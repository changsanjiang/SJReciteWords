//
//  SJWordPronunciations.h
//  ReciteWords
//
//  Created by BlueDancer on 2017/8/15.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <SJDBMapUseProtocol.h>

@interface SJWordPronunciations : NSObject<SJDBMapUseProtocol>

@property (nonatomic, assign) NSInteger psId;
@property (nonatomic, strong) NSString *uk;
@property (nonatomic, strong) NSString *us;

+ (instancetype)pronunciationsWithUk:(NSString *)uk us:(NSString *)us;

@end
