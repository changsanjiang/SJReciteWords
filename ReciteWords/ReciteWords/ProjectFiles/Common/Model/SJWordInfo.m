//
//  SJWordInfo.m
//  ReciteWords
//
//  Created by BlueDancer on 2017/7/31.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import "SJWordInfo.h"

@implementation SJWordInfo

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

+ (instancetype)wordInfoWithDictionary:(NSDictionary *)dict {
    SJWordInfo *info = [SJWordInfo new];
    [info setValuesForKeysWithDictionary:dict];
    return info;
}

- (NSString *)description {
    return [NSString stringWithFormat:@" {\n\t definition:%@,\n\t content:%@,\n\t pronunciation:%@,\n\t us_audio:%@,\n\t}", self.definition, self.content, self.pronunciation, self.us_audio];
}

@end
