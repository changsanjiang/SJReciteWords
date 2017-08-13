//
//  DBNetworkingServer.m
//  lanwuzhe
//
//  Created by BlueDancer on 2017/5/3.
//  Copyright © 2017年 dancebaby. All rights reserved.
//

#import "DBNetworkingServer.h"
#import <objc/message.h>

#import <AFNetworkReachabilityManager.h>
#import <AFNetworkActivityIndicatorManager.h>


#define DB_NetworkingRequestLog     NSLog(@"******************** 请求参数 ***************************"); \
                                    NSLog(@"\n请求头: %@\n请求方式: %@\n请求URL: %@\n请求param: %@\n\n",self.requestSerializer.HTTPRequestHeaders, requestType, urlStr, parameters); \
                                    NSLog(@"******************************************************");


@interface DBNetworkingServer ()

@property (nonatomic, assign) DBNetworkState netWorkState;

@property (nonatomic, strong) NSMutableDictionary<NSString *, NSURLSessionTask *> *tasksDictM;

@end

@implementation DBNetworkingServer

@synthesize netWorkState = _netWorkState;

+ (instancetype)sharedManager {
    static id _instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [self new];
    });
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        /**
         *  requestTime
         *  设置请求超时时间
         */
        self.requestSerializer.timeoutInterval = 20;
        
        /**
         *  tips
         *  打开状态栏的等待菊花
         */
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
        
        /**
         *  Cache
         *  设置相应的缓存策略：此处选择不用加载也可以使用自动缓存
         *  [注：只有get方法才能用此缓存策略，NSURLRequestReturnCacheDataDontLoad]
         */
        self.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        
        /**
         *  request
         *  设置请求服务器数类型式为 json
         */
        AFJSONRequestSerializer *_request = [AFJSONRequestSerializer serializer];
//        AFHTTPRequestSerializer *_request = [AFHTTPRequestSerializer serializer];
        self.requestSerializer = _request;
        
        /**
         *  response
         *  设置返回数据类型为 json, 分别设置请求以及相应的序列化器
         */
        AFJSONResponseSerializer *_response = [AFJSONResponseSerializer serializer];
//        AFHTTPResponseSerializer *_response = [AFHTTPResponseSerializer serializer];
        /**
         *  Types
         *  设置响应数据的基本类型
         */
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"application/xml", @"application/hal+json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/xml",@"text/plain", @"application/javascript", @"image/*", nil];
        
        /**
         *  Null
         *  这里是去掉了键值对里 空对象的键值
         */
        _response.removesKeysWithNullValues = YES;
        self.responseSerializer = _response;
        
        /**
         *  https
         */
        AFSecurityPolicy *_securityPolicy = [AFSecurityPolicy defaultPolicy];
        _securityPolicy.allowInvalidCertificates = YES;
        _securityPolicy.validatesDomainName = NO;
        self.securityPolicy = _securityPolicy;
        
        /**
         *  开启网络监控
         */
        [self _dbNetWorkMonitoring];
        
    }
    return self;
}

/**
 *  网络请求方法
 */
- (void)requestWithType:(DBHttpRequestType)type
                            urlString:(NSString *)urlStr
                           parameters:(NSDictionary *_Nullable)parameters
                             complete:(void(^)(id response, NSError *error))completeBlock {
    
    if ( nil == urlStr || 0 == urlStr.length ) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:-1 userInfo:@{@"msg":@"传入URL地址无效"}];
        completeBlock(nil, error);
        return;
    }
    
    NSURLSessionTask *sessionTask = nil;
    
    __weak typeof(self) _self = self;
    void(^networkingSuccessBlock)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) = ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (completeBlock) {
            completeBlock(responseObject, nil);
        }
        
        [[_self tasksDictM] removeObjectForKey:urlStr];
    };
    
    void(^networkingFailureBlock)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (completeBlock) {
            completeBlock(nil, error);
        }
        
        [[_self tasksDictM] removeObjectForKey:urlStr];
    };
 
    
    NSString *requestType;
    switch (type) {
        case DBHttpRequestType_Get:
        {
            requestType = @"Get";
            sessionTask = [_self GET:urlStr parameters:parameters progress:nil success:networkingSuccessBlock failure:networkingFailureBlock];

        }
            break;
        case DBHttpRequestType_Post:
        {
            requestType = @"Post";
            sessionTask = [_self POST:urlStr parameters:parameters progress:nil success:networkingSuccessBlock failure:networkingFailureBlock];
        }
            break;
        default:
            NSLog(@"请求类型不支持 %s - %zd", __FILE__, __LINE__);
            break;
    }
    
DB_NetworkingRequestLog
    
    [[_self tasksDictM] setValue:sessionTask forKey:urlStr];
    
}

#define kBoundary @"xxxxx"

/**
 *  上传文件
 */
- (void)uploadFileWithURLStr:(NSString *)URLStr filePath:(NSString *)filePath uploadProgress:(void (^)(CGFloat progress))uploadProgressBlock complete:(void(^)(id __nullable response, NSError *__nullable error))completeBlock {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLStr]];
    request.HTTPMethod = @"POST";
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", kBoundary] forHTTPHeaderField:@"Content-Type"];
    
    [[self uploadTaskWithRequest:request fromData:[self getBodyDataWithPath:filePath] progress:^(NSProgress * _Nonnull uploadProgress) {
        if ( 0 == uploadProgress.totalUnitCount ) return ;
        if ( uploadProgressBlock ) uploadProgressBlock(uploadProgress.completedUnitCount * 1.0 / uploadProgress.totalUnitCount);
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if ( error ) {
            NSLog(@"%@", error);
            return ;
        }
        if ( completeBlock ) completeBlock(responseObject, error);
       
    }] resume]; /** 同样需要resume */
    
}

- (NSData *)getBodyDataWithPath:(NSString *)filePath {
    
    /**
     *
     ------WebKitFormBoundarytgRKq09crvuzGEDu
     Content-Disposition: form-data; name="userfile"; filename=""
     Content-Type: application/octet-stream
     ------WebKitFormBoundarytgRKq09crvuzGEDu--
     */
//    NSString *fileName = [filePath lastPathComponent];
    
    NSMutableData *bodyDataM = [NSMutableData data];
    NSMutableString *bodyStrM = [NSMutableString stringWithFormat:@"--%@\r\n", kBoundary];
    [bodyStrM appendFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"png\"\r\n"];
    [bodyStrM appendFormat:@"Content-Type: application/octet-stream\r\n"];
    [bodyStrM appendFormat:@"\r\n"];
    [bodyDataM appendData:[bodyStrM dataUsingEncoding:NSUTF8StringEncoding]];
    
    // 照片
    [bodyDataM appendData:[NSData dataWithContentsOfFile:filePath]];
    
    NSString *endStr = [NSString stringWithFormat:@"\r\n--%@--", kBoundary];
    
    [bodyDataM appendData:[endStr dataUsingEncoding:NSUTF8StringEncoding]];
    return bodyDataM;
}


- (NSMutableDictionary<NSString *, NSURLSessionTask *> *)tasksDictM {
    
    if ( _tasksDictM ) return _tasksDictM;
    
    _tasksDictM = [NSMutableDictionary new];
    return _tasksDictM;
}


/**
 *  取消所有 Http 请求
 */
- (void)cancelAllRequest {
    // 锁操作
    @synchronized(self) {
        [[self tasksDictM] enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSURLSessionTask * _Nonnull obj, BOOL * _Nonnull stop) {
            [obj cancel];
            [[self tasksDictM] removeObjectForKey:key];
        }];
    }
}


/**
 *  取消指定 URL 的 Http 请求
 */
- (void)cancelRequestWithUrlStr:(NSString *)urlStr {
    if ( nil == urlStr || 0 == urlStr.length ) {
        return;
    }
    @synchronized (self) {
        [[self tasksDictM] removeObjectForKey:urlStr];
    }
}


// MARK: Private


/**
 *  网络状态监测
 */
- (void)_dbNetWorkMonitoring {
    
    // 获得网络监控的管理者
    AFNetworkReachabilityManager *_manager = [AFNetworkReachabilityManager sharedManager];
    
    __weak typeof(self) _self = self;
    
    // 设置网络状态改变后的处理
    [_manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        __strong typeof(_self) self = _self;
        
        if ( self ) {
            
            switch (status)
            {
                case AFNetworkReachabilityStatusUnknown:
                {
                    NSLog(@"未知网络");
                    NetworkingServer.netWorkState = DBNetworkState_Unknown;
                }
                    break;
                case AFNetworkReachabilityStatusNotReachable:
                {
                    NSLog(@"没有网络");
                    NetworkingServer.netWorkState = DBNetworkState_NotReachable;
                }
                    break;
                case AFNetworkReachabilityStatusReachableViaWWAN:
                {
                    NSLog(@"手机自带网络");
                    NetworkingServer.netWorkState = DBNetworkState_ReachableViaWWAN;
                }
                    break;
                case AFNetworkReachabilityStatusReachableViaWiFi:
                {
                    NSLog(@"wifi 网络");
                    NetworkingServer.netWorkState = DBNetworkState_ReachableViaWiFi;
                }
                    break;
            }
        }
        
    }];
    // Monitoring  开启监控
    [_manager startMonitoring];
}


/**
 *  过滤请求的URL(未使用)
 */
- (NSString *)_dbLeachWithURLString:(NSString *)str {
    return [NSURL URLWithString:str] ? str : [self _dbStrUTF8Encoding:str];
}

- (NSString *)_dbStrUTF8Encoding:(NSString *)str {
    if ( [[UIDevice currentDevice] systemVersion].floatValue >= 9.0 ) {
        return [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
    }
    else {
        return [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
}

@end

