//
//  DBNetworkingServer.h
//  lanwuzhe
//
//  Created by BlueDancer on 2017/5/3.
//  Copyright © 2017年 dancebaby. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>


#define NetworkingServer [DBNetworkingServer sharedManager]

NS_ASSUME_NONNULL_BEGIN

/**
 *  网络状态
 */
typedef NS_ENUM(NSUInteger, DBNetworkState) {
    
    /**
     *  未知 网络
     */
    DBNetworkState_Unknown = 0,
    
    /**
     *  没有 网络
     */
    DBNetworkState_NotReachable,
    
    /**
     *  手机 3G/4G 网络
     */
    DBNetworkState_ReachableViaWWAN,
    
    
    /**
     *  WiFi 网络
     */
    DBNetworkState_ReachableViaWiFi,
    
};


typedef NS_ENUM(NSUInteger, DBHttpRequestType) {
    
    /**
     *  get请求
     */
    DBHttpRequestType_Get = 0,
    
    /**
     *  post请求
     */
    DBHttpRequestType_Post,
};


@protocol DBDownloadProtocol;


@interface DBNetworkingServer : AFHTTPSessionManager

+ (instancetype)sharedManager;

/**
 *  当前网络状态
 */
@property (nonatomic, assign, readonly) DBNetworkState netWorkState;


/**
 *  网络请求方法
 */
- (void)requestWithType:(DBHttpRequestType)type
              urlString:(NSString *)urlStr
             parameters:(NSDictionary *_Nullable)parameters
               complete:(void(^)(id __nullable response, NSError *__nullable error))completeBlock;


/**
 *  上传文件
 */
- (void)uploadFileWithURLStr:(NSString *)URLStr filePath:(NSString *)filePath uploadProgress:(void (^)(CGFloat progress))uploadProgressBlock complete:(void(^)(id __nullable response, NSError *__nullable error))completeBlock;


/**
 *  取消所有 Http 请求
 */
- (void)cancelAllRequest;


/**
 *  取消指定 URL 的 Http 请求
 */
- (void)cancelRequestWithUrlStr:(NSString *)urlStr;

@end














// MARK: 下载协议


@protocol DBDownloadProtocol <NSObject>

@required

/*!
 *  下载
 */
- (void)downLoadFileWithURLStr:(NSString *)urlStr
                      complete:(void(^ _Nullable)(NSString * _Nullable filePath, NSError * _Nullable error))completeBlock
                      progress:(void(^ _Nullable)(float progress))progressBlock;

/*!
 *  暂停下载
 */
- (void)suspendDownloadWithURLStr:(NSString *)urlStr
                         complete:(void(^ _Nullable)(void))completeBlock;

/// 暂停所有下载
- (void)suspendAllDownloads;

/// 恢复所有下载
- (void)restoreAllDownloads;

/// 取消下载
- (void)cancelDownloadWithURLStr:(NSString *)urlStr
                        complete:(void(^ _Nullable)(void))completeBlock;

/// 是否正在下载
- (BOOL)isDownloadingWithURLStr:(NSString *)urlStr;

/// 是否已完成下载
- (BOOL)isCompleteDownloadWithURLStr:(NSString *)urlStr;

/// 下载的进度
- (float)downloadProgressWithURLStr:(NSString *)urlStr;

@end

NS_ASSUME_NONNULL_END
