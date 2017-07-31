//
//  SJDataServer.m
//  ReciteWords
//
//  Created by BlueDancer on 2017/7/31.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import "SJDataServer.h"

@implementation SJDataServer

+ (instancetype)sharedManager {
    static id _instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [self new];
    });
    return _instance;
}

- (void)_SJ_GETWithPathStr:(NSString *)pathStr parameters:(NSDictionary *)parameters callBlock:(void(^)(id response))block {
    
}

- (void)_SJ_POSTWithPathStr:(NSString *)pathStr parameters:(NSDictionary *)parameters callBlock:(void(^)(id response))block {
    
}

@end


// MARK: 搜索

@implementation SJDataServer (Search)

/*!
 *  搜索单个单词
 */
- (void)searchWordWithContent:(NSString *)content callBlock:(void(^)(SJWordInfo *wordInfo))block {
#warning Next...
}

@end
