//
//  SJDataServer.m
//  ReciteWords
//
//  Created by BlueDancer on 2017/7/31.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import "SJDataServer.h"
#import "DBNetworkingServer.h"
#import <SVProgressHUD.h>

#define BaseURL                 @"https://api.shanbay.com/"

@implementation SJDataServer

+ (instancetype)sharedManager {
    static id _instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [self new];
    });
    return _instance;
}

- (void)_SJGETWithPathStr:(NSString *)pathStr parameters:(NSDictionary *)parameters callBlock:(void(^)(id response))block {
    [self _SJRequestWithType:DBHttpRequestType_Get pathStr:pathStr parameters:parameters callBlock:block];
}

- (void)_SJPOSTWithPathStr:(NSString *)pathStr parameters:(NSDictionary *)parameters callBlock:(void(^)(id response))block {
    [self _SJRequestWithType:DBHttpRequestType_Post pathStr:pathStr parameters:parameters callBlock:block];
}

- (void)_SJRequestWithType:(DBHttpRequestType)type pathStr:(NSString *)pathStr parameters:(NSDictionary *)parameters callBlock:(void(^)(id response))block {
    if ( !pathStr ) { NSLog(@"%zd - %s", __LINE__, __func__); return; }
    [NetworkingServer requestWithType:type urlString:[NSString stringWithFormat:@"%@%@", BaseURL, pathStr] parameters:parameters complete:^(id  _Nullable response, NSError * _Nullable error) {
        if ( error ) {
            NSLog(@"%zd - %s networkingError: %@", __LINE__, __func__, error);
//            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", error.userInfo]];
            if ( block ) block(nil);
            return;
        }
        if ( block ) block(response);
    }];
}

@end


// MARK: 搜索

#import "SJWordInfo.h"

@implementation SJDataServer (Search)

/*!
 *  搜索单个单词
 */
- (void)searchWordWithContent:(NSString *)content callBlock:(void(^)(SJWordInfo *wordInfo))block {
    NSString *pathStr = @"bdc/search";
    NSDictionary *parameters = @{
                                 @"word":content,
                                 };
    [self _SJGETWithPathStr:pathStr parameters:parameters callBlock:^(id response) {
        SJWordInfo *info = [SJWordInfo wordInfoWithDictionary:response[@"data"]];
        if ( block ) block(info);
    }];
}

@end
