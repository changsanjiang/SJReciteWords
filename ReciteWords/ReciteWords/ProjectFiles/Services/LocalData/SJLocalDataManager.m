//
//  SJLocalDataManager.m
//  ReciteWords
//
//  Created by BlueDancer on 2017/8/1.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import "SJLocalDataManager.h"

@implementation SJLocalDataManager

+ (instancetype)sharedManager {
    static id _instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [self new];
    });
    return _instance;
}

#warning next.... 本地数据管理类

@end
