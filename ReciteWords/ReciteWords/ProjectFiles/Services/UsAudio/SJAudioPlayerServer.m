//
//  SJAudioPlayerServer.m
//  ReciteWords
//
//  Created by BlueDancer on 2017/7/31.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import "SJAudioPlayerServer.h"
#import "DBAudioPlayer.h"

@interface SJAudioPlayerServer ()

@property (nonatomic, strong, readwrite) DBAudioPlayer *player;

@end

@implementation SJAudioPlayerServer

+ (instancetype)sharedManager {
    static id _instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [self new];
    });
    return _instance;
}

- (instancetype)init {
    self = [super init];
    if ( !self ) return nil;
    self.player = [DBAudioPlayer player];
    return self;
}

- (void)playWithURLStr:(NSString *)playURLStr {
    [self.player playAudioWithPlayURL:playURLStr];
}

@end
