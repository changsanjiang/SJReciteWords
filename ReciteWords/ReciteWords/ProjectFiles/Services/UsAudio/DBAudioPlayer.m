//
//  DBAudioPlayer.m
//  dancebaby
//
//  Created by BlueDancer on 2017/5/14.
//  Copyright © 2017年 hunter. All rights reserved.
//

#import "DBAudioPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import "NSObject+Extension.h"
#import <objc/message.h>
#import "YYTimer.h"

#define DBugLog

/**
 *  0.00 - 1.00
 *  If it's 1.00, play after download.
 */
#define DBAudioWhenToStartPlaying   (0.025)

/*!
 *  网路环境差 导致的停止播放 延迟多少秒继续播放
 */
#define DBAudioDelayTime (2)

NSString *const DBAudioPlayerDownloadAudioIdentifier = @"com.dancebaby.lanwuzhe.audioCacheSession";

@interface DBAudioPlayer (NSURLSessionDownloadDelegateMethos) <NSURLSessionDownloadDelegate>

/*!
 *  到达播放点
 */
@property (nonatomic, assign, readwrite) BOOL isStartPlaying;

@end



@interface DBAudioPlayer (AVAudioPlayerDelegateMethods) <AVAudioPlayerDelegate>
@end


static NSMutableDictionary<NSString *, void (^)()> *_completionHandlerDictionary;

@interface DBAudioPlayer ()

@property (nonatomic, strong, readwrite) AVAudioPlayer *audioPlayer;

@property (nonatomic, strong, readonly)  NSURLSession *audioCacheSession;

@property (nonatomic, strong, readonly) YYTimer *checkAudioTimeTimer;

@property (nonatomic, strong, readonly) YYTimer *checkAudioIsPlayingTimer;

@property (nonatomic, assign, readwrite) BOOL userClickedPause;

@property (nonatomic, strong, readonly) NSOperationQueue *oprationQueue;

@property (nonatomic, strong, readwrite) NSString *currentPlayingURLStr;

@property (nonatomic, strong, readwrite) NSURLSessionDownloadTask *currentTask;

/*!
 *  /var/ya/.....
 */
@property (nonatomic, strong, readwrite) NSString *currentItemTmpPath;

@property (nonatomic, assign, readwrite) CGFloat currentItemDownloadProgress;

@end





@implementation DBAudioPlayer

@synthesize audioCacheSession = _audioCacheSession;
@synthesize checkAudioTimeTimer = _checkAudioTimeTimer;
@synthesize oprationQueue = _oprationQueue;
@synthesize checkAudioIsPlayingTimer = _checkAudioIsPlayingTimer;

// MARK: Init

- (instancetype)init {
    self = [super init];
    if ( !self ) return nil;
    [self _DBAudioPlayerInitialize];
    [self _DBAddObservers];
    return self;
}

- (void)dealloc {
    [self _DBRemoveObservers];
    [self _DBClearTimer];
}

// MARK: Public

/**
 *  播放状态
 */
- (BOOL)playStatus {
    return self.audioPlayer.isPlaying;
}


/**
 *  初始化
 */
+ (instancetype)player {
    return [self new];
}

/**
 *  播放
 */
- (void)playAudioWithPlayURL:(NSString *)playURL {
    if ( nil == playURL ) return;
    dispatch_async(dispatch_get_main_queue(), ^{
        if ( [self.delegate respondsToSelector:@selector(audioPlayer:currentTime:reachableTime:totalTime:)] ) [self.delegate audioPlayer:self currentTime:0 reachableTime:0 totalTime:0];
    });

    [self stop];
    
    self.userClickedPause = NO;

    self.currentPlayingURLStr = playURL;
    
    self.isStartPlaying = NO;

    if ( _DBCacheExistsWithURLStr(playURL) || [playURL hasPrefix:@"file"]  ) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.currentItemDownloadProgress = 1;
            if ( ![self.delegate respondsToSelector:@selector(audioPlayer:audioDownloadProgress:)] ) return;
            [self.delegate audioPlayer:self audioDownloadProgress:1];
        });
         [self _DBPlayLocalCacheWithURLStr:playURL];
    }
    else [self _DBStartDownloadWithURLStr:playURL];
}

/**
 *  从指定的进度播放
 */
- (void)setPlayProgress:(float)progress {
    if ( !self.audioPlayer ) return;
    
    NSTimeInterval reachableTime = 0;
    if ( self.currentTask ) reachableTime = self.audioPlayer.duration * self.currentItemDownloadProgress;
    else reachableTime = self.audioPlayer.duration;

    if ( self.audioPlayer.duration * progress <= reachableTime ) self.audioPlayer.currentTime = self.audioPlayer.duration * progress;
    
    [self _DBEnableTimer];
}

/**
 *  暂停
 */
- (void)pause {
    
    self.userClickedPause = YES;
    
    [self.audioPlayer pause];
    
    [self _DBClearTimer];
}

/**
 *  恢复播放
 */
- (void)resume {
    
    self.userClickedPause = NO;
    
    if ( self.audioPlayer.isPlaying ) return;
    
    if ( nil == self.audioPlayer ) {
        [self playAudioWithPlayURL:self.currentPlayingURLStr];
    }
    else {
        if ( ![self.audioPlayer prepareToPlay] ) return;
        [self.audioPlayer play];
    }
    [self _DBEnableTimer];
}

/**
 *  停止播放, 停止缓存
 */
- (void)stop {
    
    self.userClickedPause = YES;
    
    if ( !self.audioPlayer ) return;
    
    [self _DBClearMemoryCache];
    
    [_audioPlayer stop];
    _audioPlayer = nil;

    [self _DBClearTimer];
}

/**
 *  清除本地缓存
 */
- (void)clearDiskAudioCache {
    if ( self.audioPlayer ) [self stop];
    
    if ( _DBCacheFolderPath() )
        [_DBCacheItemPaths() enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [[NSFileManager defaultManager] removeItemAtPath:obj error:nil];
        }];
}

/**
 *  已缓存的大小
 */
- (NSInteger)diskAudioCacheSize {
    
    __block NSInteger size = 0;
    if ( _DBCacheFolderPath() ) {
        [_DBCacheItemPaths() enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary<NSFileAttributeKey, id> *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:obj error:nil];
            size += [dict[NSFileSize] integerValue] / 1000 / 1000;
        }];
    }
    return size;
}

/*!
 *  查看音乐是否已缓存
 */
- (BOOL)checkMusicHasBeenCachedWithPlayURL:(NSString *)playURL {
    return _DBCacheExistsWithURLStr(playURL);
}

// MARK: Observers

- (void)_DBAddObservers {
    [self addObserver:self forKeyPath:@"rate" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)_DBRemoveObservers {
    [self removeObserver:self forKeyPath:@"rate"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ( object != self ) { return;}
    
    if ( [keyPath isEqualToString:@"rate"] ) self.audioPlayer.rate = self.rate;
}

// MARK: Private

- (void)_DBClearTimer {
    [_checkAudioTimeTimer invalidate];
    _checkAudioTimeTimer = nil;
    [_checkAudioIsPlayingTimer invalidate];
    _checkAudioIsPlayingTimer = nil;
}

- (void)_DBEnableTimer {
    [self checkAudioTimeTimer];
    [self checkAudioIsPlayingTimer];
}

- (void)_DBAudioPlayerInitialize {

    if ( !_DBFolderExists() ) _DBCreateFolder();
    
    self.rate = 1;
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];

}

/**
 *  定时器事件
 */
- (void)_DBCheckAudioTime {
    if ( !_audioPlayer.isPlaying ) return;
    NSTimeInterval currentTime = _audioPlayer.currentTime;
    NSTimeInterval totalTime = _audioPlayer.duration;
    NSTimeInterval reachableTime = _audioPlayer.duration * _currentItemDownloadProgress;
    if ( ![_delegate respondsToSelector:@selector(audioPlayer:currentTime:reachableTime:totalTime:)] ) return;
    dispatch_async(dispatch_get_main_queue(), ^{
        [_delegate audioPlayer:self currentTime:currentTime reachableTime:reachableTime totalTime:totalTime];
    });
}

// MARK: 因为网络环境差 而导致的暂停播放 处理

- (void)_DBCheckAudioIsPlayingTimer {
    if ( nil == self.audioPlayer ) return;
    if ( self.userClickedPause ) return;
    if ( self.audioPlayer.isPlaying ) return;
    
    // 如果暂停,  ? 秒后 再次初始化
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DBAudioDelayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ( self.userClickedPause ) return;
        if ( self.audioPlayer.isPlaying ) return;
        /*!
         *  再次初始化
         */
        NSString *itemTmpPath = self.currentItemTmpPath;
        NSURL *filePathURL = nil;
        
        if ( itemTmpPath ) filePathURL = [NSURL fileURLWithPath:itemTmpPath];

        if ( filePathURL ) [self _DBPlayWithFileURL:filePathURL];
    });
}

- (void)_DBPlayLocalCacheWithURLStr:(NSString *)URLStr {
    __weak typeof(self) _self = self;
    [self.oprationQueue addOperationWithBlock:^{
        __strong typeof(_self) self = _self;
        if ( !self ) return;
        NSURL *contentsURL = nil;
        if ( [URLStr hasPrefix:@"file"] )
             contentsURL = [NSURL URLWithString:URLStr];
        else contentsURL = [NSURL fileURLWithPath:_DBCachePathWithURLStr(URLStr)];
        [self _DBPlayWithFileURL:contentsURL];
    }];
}

// MARK:  播放缓存音乐

- (void)_DBPlayWithFileURL:(NSURL *)fileURL {

    @synchronized (self) {
        
        NSError *error = nil;
        
        NSTimeInterval currentTime = self.audioPlayer.currentTime;
        
        AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL fileTypeHint:AVFileTypeMPEGLayer3 error:&error];
        
        if ( error ) {
            NSLog(@"\n-播放器初始化失败-%@-%@ \n", error, fileURL);
            NSString *fileURLStr = fileURL.absoluteString;
            if ( [fileURLStr hasPrefix:@"file://"] ) fileURLStr = [fileURLStr substringFromIndex:7];
            if ( _DBCacheExistsWithFileURLStr(fileURLStr) ) {
                NSLog(@"\n-删除下载文件-%@ \n", fileURLStr);
                [[NSFileManager defaultManager] removeItemAtPath:fileURLStr error:nil];
            }
            return;
        }
        
        if ( !audioPlayer ) return;
        
        audioPlayer.enableRate = YES;
        
        if ( ![audioPlayer prepareToPlay] ) return;
        
//        if ( audioPlayer.duration < 5 ) return;
        
        audioPlayer.delegate = self;
#ifdef DBugLog
        NSLog(@"\n-开始播放\n-持续时间: %f 秒\n-播放地址为: %@ ",
              audioPlayer.duration,
              fileURL);
        NSLog(@"\n-线程: %@", [NSThread currentThread]);
        if ( [[UIDevice currentDevice].systemVersion integerValue] >= 10 ) {
            NSLog(@"\n-格式%@", audioPlayer.format);
        }
#endif
        [audioPlayer play];
        
        if ( 0 != currentTime ) audioPlayer.currentTime = currentTime;
        
        audioPlayer.rate = self.rate;
        
        self.audioPlayer = audioPlayer;
        
        self.isStartPlaying = YES;
        
        [self _DBEnableTimer];
    }
}

// MARK: 下载任务初始化

- (void)_DBStartDownloadWithURLStr:(NSString *)URLStr {
    
    if ( !URLStr ) return;
    
    NSURL *URL = [NSURL URLWithString:URLStr];
    
    if ( !URL ) return;
    
    NSURLSessionDownloadTask *task = nil;
    
    task = [self.audioCacheSession downloadTaskWithRequest:[NSURLRequest requestWithURL:URL]];
    
    if ( !task ) return;
        
    [task resume];
    
#ifdef DBugLog
    NSLog(@"\n准备下载: %@ \n" , URLStr);
#endif
    
    self.currentTask = task;
    self.currentItemDownloadProgress = 0;
    _DBDownloadingItemPath(^(NSString *itemTmpPath) {
        self.currentItemTmpPath = itemTmpPath;
    });
}

// MARK: Task 相关操作

/*!
 *  获取当前的下载路径
 */
- (NSString *)_DBAudioPlayerCurrentTmpItemPath {
    return objc_getAssociatedObject(self.currentTask, [NSString stringWithFormat:@"%zd", self.currentTask.taskIdentifier].UTF8String);
}

- (void)_DBClearMemoryCache {
    [_currentTask cancel];
    _currentTask = nil;
    _currentItemDownloadProgress = 0;
    _currentItemTmpPath = nil;
    _currentPlayingURLStr = nil;
}

// MARK: Getter

- (NSURLSession *)audioCacheSession {
    if ( nil == _audioCacheSession ) {
        NSURLSessionConfiguration *cofig = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:DBAudioPlayerDownloadAudioIdentifier];
        _audioCacheSession = [NSURLSession sessionWithConfiguration:cofig delegate:self delegateQueue:self.oprationQueue];
    }
    return _audioCacheSession;
}

- (NSOperationQueue *)oprationQueue {
    if ( nil == _oprationQueue ) {
        _oprationQueue = [NSOperationQueue new];
        _oprationQueue.maxConcurrentOperationCount = 1;
        _oprationQueue.name = @"com.dancebaby.lanwuzhe.audioCacheSessionOprationQueue";
    }
    return _oprationQueue;
}

+ (NSMutableDictionary<NSString *,void (^)()> *)completionHandlerDictionary {
    if ( nil == _completionHandlerDictionary ) {
        _completionHandlerDictionary = [NSMutableDictionary new];
    }
    return _completionHandlerDictionary;
}

- (YYTimer *)checkAudioTimeTimer {
    if ( nil == _checkAudioTimeTimer) {
        _checkAudioTimeTimer = [YYTimer timerWithTimeInterval:0.1 target:self selector:@selector(_DBCheckAudioTime) repeats:YES];
        [_checkAudioTimeTimer fire];
    }
    return _checkAudioTimeTimer;
}

- (YYTimer *)checkAudioIsPlayingTimer {
    if ( _checkAudioIsPlayingTimer ) return _checkAudioIsPlayingTimer;
    _checkAudioIsPlayingTimer = [YYTimer timerWithTimeInterval:DBAudioDelayTime target:self selector:@selector(_DBCheckAudioIsPlayingTimer) repeats:YES];
    [_checkAudioIsPlayingTimer fire];
    return _checkAudioIsPlayingTimer;
}

// MARK: File Path

static BOOL _DBFolderExists() { return [[NSFileManager defaultManager] fileExistsAtPath:_DBFolderPath()];}

static BOOL _DBCacheExistsWithURLStr(NSString *URLStr) { return [[NSFileManager defaultManager] fileExistsAtPath:_DBCachePathWithURLStr(URLStr)];}

static BOOL _DBCacheExistsWithFileURLStr(NSString *fileURLStr) {
    if ( [fileURLStr hasPrefix:@"file://"] ) fileURLStr = [fileURLStr substringFromIndex:7];
    NSString *dataName = fileURLStr.lastPathComponent;
    if ( !dataName ) return NO;
    return [[NSFileManager defaultManager] fileExistsAtPath:[_DBCacheFolderPath() stringByAppendingPathComponent:dataName]];
}

/**
 *  ../com.dancebaby.lanwuzhe.audioCacheFolder/
 */

static NSString *_DBFolderPath() {
    NSString *sCachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
    NSString *folderPath = [sCachePath stringByAppendingPathComponent:@"com.dancebaby.lanwuzhe.audioCacheFolder"];
    return folderPath;
}

static NSString *_DBCacheFolderPath() { return [_DBFolderPath() stringByAppendingPathComponent:@"cache"];}

static NSString *_DBResumeDataFolderPath() { return [_DBFolderPath() stringByAppendingPathComponent:@"resumeData"];}

/**
 *  Root Cache + cache + resumeData
 */
static void _DBCreateFolder() {
    [[NSFileManager defaultManager] createDirectoryAtPath:_DBCacheFolderPath() withIntermediateDirectories:YES attributes:nil error:nil];
    [[NSFileManager defaultManager] createDirectoryAtPath:_DBResumeDataFolderPath() withIntermediateDirectories:YES attributes:nil error:nil];
}

/**
 *  /var/../com.dancebaby.lanwuzhe.audioCacheFolder/cache/StrHash
 */
static NSString *_DBCachePathWithURLStr(NSString *URLStr) {
    NSString *cacheName = [_DBHashStr(URLStr) stringByAppendingString:@".mp3"];
    NSString *cachePath = [_DBCacheFolderPath() stringByAppendingPathComponent:cacheName];
    if ( cachePath ) return cachePath;
    return @"";
}

/**
 *  Apple Tmp Folder Path
 *  ../Library/Caches/com.apple.nsurlsessiond/Downloads/com.dancebaby.DBAudioPlayer/CFNetworkDownload_Pwvolm.tmp
 */
static NSString *_NSURLSessionTmpFolderPath() {
    NSString *bundleId = [[NSBundle mainBundle] bundleIdentifier];
    NSString *pathComponent = [NSString stringWithFormat:@"com.apple.nsurlsessiond/Downloads/%@", bundleId];
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:pathComponent];
}

static void _DBDownloadingItemPath(void(^block)(NSString *itemTmpPath)) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *tmpFolder = _NSURLSessionTmpFolderPath();
        __block NSArray<NSString *> *items = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:tmpFolder error:nil];
        if ( 0 == items.count ) return;
        
        items = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:tmpFolder error:nil];
        
        __block NSString *newItemPath = [tmpFolder stringByAppendingPathComponent:items.firstObject];
        if ( 1 == items.count ) {if (block) block(newItemPath); return;}
        NSDictionary<NSFileAttributeKey, id> *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:[tmpFolder stringByAppendingPathComponent:items.firstObject] error:nil];
        __block NSDate *newItemDate = dict[NSFileCreationDate];
        [items enumerateObjectsUsingBlock:^(NSString * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
            if ( 0 != idx ) {
                NSString *itemPath = [tmpFolder stringByAppendingPathComponent:item];
                NSDictionary<NSFileAttributeKey, id> *attrDict = [[NSFileManager defaultManager] attributesOfItemAtPath:itemPath error:nil];
                NSDate *itemDate = attrDict[NSFileCreationDate];
                NSComparisonResult result = [newItemDate compare:itemDate];
                if ( result == NSOrderedAscending ) {
                    newItemDate = itemDate;
                    newItemPath = itemPath;
                }
            }
        }];
        if ( block ) block(newItemPath);
    });
}

static NSArray<NSString *> *_DBCacheItemPaths() { return _DBContentsOfPath(_DBCacheFolderPath());}

static NSArray<NSString *> *_DBContentsOfPath(NSString *path) {
    NSArray *paths = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    NSMutableArray<NSString *> *itemPaths = [NSMutableArray new];
    [paths enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [itemPaths addObject:[path stringByAppendingPathComponent:obj]];
    }];
    return itemPaths;
}

static NSString *_DBHashStr(NSString *URLStr) {
    if ( !URLStr ) return nil;
    return [NSString stringWithFormat:@"%zd", [URLStr hash]];
}

@end



// MARK: Session Delegate
/* 保持只有一个任务在下载 */
@implementation DBAudioPlayer (NSURLSessionDownloadDelegateMethos)

// MARK: 下载完成

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    
    NSString *URLStr = downloadTask.currentRequest.URL.absoluteString;
    
#ifdef DBugLog
    NSLog(@"\n-下载完成: %@", URLStr);
#endif
    
    NSString *cachePath = _DBCachePathWithURLStr(URLStr);
    
    if ( !cachePath ) return;
    
    BOOL copyResult = [[NSFileManager defaultManager] copyItemAtPath:location.path toPath:cachePath error:nil];
    
    if ( !copyResult ) return;
    
    if ( self.audioPlayer.isPlaying ) return;
    
    if ( self.userClickedPause ) return;
    
    NSURL *fileURL = [NSURL fileURLWithPath:cachePath];
    
    if ( !fileURL ) return;
    
    [self _DBPlayWithFileURL:fileURL];
    
}

// MARK: 下载报错

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error {
    
#ifdef DBugLog
    if ( error ) NSLog(@"\n-下载报错: %@", error);
#endif
    
//    [self _DBClearMemoryCache];
}

// MARK: 下载中

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    
    if ( 0 == totalBytesExpectedToWrite ) return;
    
    if ( downloadTask != self.currentTask ) return;
    
    CGFloat progress = totalBytesWritten * 1.0 / totalBytesExpectedToWrite;
    
    self.currentItemDownloadProgress = progress;
    
#ifdef DBugLog
    NSLog(@"\n-%@\n-写入大小: %zd - 文件大小: %zd - 下载进度: %f \n",
          downloadTask.response.URL,
          totalBytesWritten,
          totalBytesExpectedToWrite,
          progress);
#endif
    
    if ( [self.delegate respondsToSelector:@selector(audioPlayer:audioDownloadProgress:)] )
        [self.delegate audioPlayer:self audioDownloadProgress:progress];
    
    if ( self.userClickedPause ) return;
    
    if ( !self.isStartPlaying && (progress > DBAudioWhenToStartPlaying) ) {
        [self _DBReadyPlayDownloadingAudio:downloadTask];
    }
}

// MARK: 记录 到达播放点

- (BOOL)isStartPlaying {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setIsStartPlaying:(BOOL)isStartPlaying {
    objc_setAssociatedObject(self, @selector(isStartPlaying), @(isStartPlaying), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// MARK: 准备播放

- (void)_DBReadyPlayDownloadingAudio:(NSURLSessionDownloadTask *)task {
    
    if ( self.audioPlayer.isPlaying ) return;
    
    NSString *ItemPath = self.currentItemTmpPath;
    
    if ( !ItemPath ) {
        _DBDownloadingItemPath(^(NSString *itemTmpPath) {
            self.currentItemTmpPath = itemTmpPath;
        });
    }
    
    if ( !ItemPath ) return;
    
    NSURL *fileURL = [NSURL fileURLWithPath:ItemPath];
    
    if ( !fileURL ) return;
    
    NSLog(@"\n-准备完毕 开始播放 \n-%@ \n", task.response.URL);

    [self _DBPlayWithFileURL:fileURL];
}

@end

// MARK: 播放完毕

@implementation DBAudioPlayer (AVAudioPlayerDelegateMethods)

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {

    if ( [self.currentPlayingURLStr hasPrefix:@"http"] ) {
        if ( 1 > self.currentItemDownloadProgress ) return;
    }

#ifdef DBugLog
    NSLog(@"\n-播放完毕\n-播放地址:%@", player.url);
#endif
    
    [self _DBClearMemoryCache];
    
    if ( ![self.delegate respondsToSelector:@selector(audioPlayerDidFinishPlaying:)] ) return;

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegate audioPlayerDidFinishPlaying:self];
    });
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player {
    if ( self.audioPlayer.isPlaying ) [self pause];
}

-(void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags {
    
    if ( ![self.audioPlayer prepareToPlay] ) return;
    
    [self.audioPlayer play];
}

@end
