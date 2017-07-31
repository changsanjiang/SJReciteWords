//
//  SJDataServer.h
//  ReciteWords
//
//  Created by BlueDancer on 2017/7/31.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DataServices    [SJDataServer sharedManager]

@class SJWordInfo;

@interface SJDataServer : NSObject

+ (instancetype)sharedManager;

@end


// MARK: 搜索

@interface SJDataServer (Search)

/*!
 *  搜索单个单词
 */
- (void)searchWordWithContent:(NSString *)content callBlock:(void(^)(SJWordInfo *wordInfo))block;

@end
