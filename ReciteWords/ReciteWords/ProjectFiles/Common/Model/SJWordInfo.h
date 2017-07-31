//
//  SJWordInfo.h
//  ReciteWords
//
//  Created by BlueDancer on 2017/7/31.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SJWordInfo : NSObject

@property (nonatomic, strong) NSString *definition;

@property (nonatomic, strong) NSString *content;

@property (nonatomic, strong) NSString *pronunciation;

@property (nonatomic, strong) NSString *us_audio;

@property (nonatomic, strong) NSString *uk_audio;

+ (instancetype)wordInfoWithDictionary:(NSDictionary *)dict;

@end
