//
//  SJAudioPlayerServer.h
//  ReciteWords
//
//  Created by BlueDancer on 2017/7/31.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import <Foundation/Foundation.h>

#define Player      [SJAudioPlayerServer sharedManager]

@interface SJAudioPlayerServer : NSObject

+ (instancetype)sharedManager;

- (void)playWithURLStr:(NSString *)playURLStr;

@end
