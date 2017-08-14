//
//  SJWordList.h
//  ReciteWords
//
//  Created by BlueDancer on 2017/8/14.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SJWordInfo;

@interface SJWordList : NSObject

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSArray<SJWordInfo *> *words;

@end
