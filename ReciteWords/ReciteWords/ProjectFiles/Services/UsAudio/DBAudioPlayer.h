//
//  DBAudioPlayer.h
//  dancebaby
//
//  Created by BlueDancer on 2017/5/14.
//  Copyright © 2017年 hunter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DBAudioPlayerPlayProtocol;

@protocol DBAudioPlayerDelegate;

@interface DBAudioPlayer : NSObject

@property (nonatomic, weak,   readwrite) id<DBAudioPlayerDelegate> delegate;

@property (nonatomic, assign, readwrite) CGFloat rate;

@property (nonatomic, strong, readonly) NSString *currentPlayingURLStr;

@property (nonatomic, assign, readonly) BOOL playStatus;

/*!
 *  初始化
 */
+ (instancetype)player;

/*!
 *  播放
 */
- (void)playAudioWithPlayURL:(NSString *)playURL;

/*!
 *  从指定的进度播放
 */
- (void)setPlayProgress:(float)progress;

/*!
 *  暂停
 */
- (void)pause;

/*!
 *  恢复播放
 */
- (void)resume;

/*!
 *  停止播放, 停止缓存
 */
- (void)stop;

/*!
 *  清除本地缓存
 */
- (void)clearDiskAudioCache;

/*!
 *  已缓存的audios的大小
 */
- (NSInteger)diskAudioCacheSize;

/*!
 *  查看音乐是否已缓存
 */
- (BOOL)checkMusicHasBeenCachedWithPlayURL:(NSString *)playURL;

@end


@protocol DBAudioPlayerPlayProtocol <NSObject>

@required

@property (nonatomic, strong) NSString *playUrl;

@end


@protocol DBAudioPlayerDelegate <NSObject>

@optional

- (void)audioPlayer:(DBAudioPlayer *)player audioDownloadProgress:(CGFloat)progress;

- (void)audioPlayer:(DBAudioPlayer *)player currentTime:(NSTimeInterval)currentTime reachableTime:(NSTimeInterval)reachableTime totalTime:(NSTimeInterval)totalTime;

- (void)audioPlayerDidFinishPlaying:(DBAudioPlayer *)player;

@end

NS_ASSUME_NONNULL_END
