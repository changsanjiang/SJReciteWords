//
//  SJWordInfo.h
//  ReciteWords
//
//  Created by BlueDancer on 2017/7/31.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <SJDBMapUseProtocol.h>

@class SJWordPronunciations;

@interface SJWordInfo : NSObject<SJDBMapUseProtocol>

@property (nonatomic, assign) NSInteger object_id;

@property (nonatomic, strong) NSString *definition;

@property (nonatomic, strong) NSString *content;

@property (nonatomic, strong) NSString *us_audio;

@property (nonatomic, strong) NSString *uk_audio;

@property (nonatomic, strong) SJWordPronunciations *pronunciations;

+ (instancetype)wordInfoWithDictionary:(NSDictionary *)dict;

// MARK: SJAdd
@property (nonatomic, assign) CGFloat height;
// MARK: SJEnd

@property (nonatomic, strong) NSString *tips;
@property (nonatomic, assign) CGFloat tipsHeight;


@end
