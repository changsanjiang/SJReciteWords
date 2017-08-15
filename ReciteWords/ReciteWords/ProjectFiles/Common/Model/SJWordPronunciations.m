//
//  SJWordPronunciations.m
//  ReciteWords
//
//  Created by BlueDancer on 2017/8/15.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import "SJWordPronunciations.h"

@implementation SJWordPronunciations

+ (NSString *)autoincrementPrimaryKey {
    return @"psId";
}

+ (instancetype)pronunciationsWithUk:(NSString *)uk us:(NSString *)us {
    SJWordPronunciations *ps = [SJWordPronunciations new];
    ps.uk = uk;
    ps.us = us;
    return ps;
}

@end
