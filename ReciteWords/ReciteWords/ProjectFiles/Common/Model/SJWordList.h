//
//  SJWordList.h
//  ReciteWords
//
//  Created by BlueDancer on 2017/8/14.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <SJDBMapUseProtocol.h>

@class SJWordInfo;

@interface SJWordList : NSObject<SJDBMapUseProtocol>

@property (nonatomic, assign) NSInteger listId;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSMutableArray<SJWordInfo *> *words;

+ (instancetype)listWithTitle:(NSString *)title;

@end
