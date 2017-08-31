//
//  SJSettingOperation.m
//  ReciteWords
//
//  Created by BlueDancer on 2017/8/13.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import "SJSettingOperation.h"

@implementation SJSettingOperation

- (instancetype)initWithTitle:(NSString *)title imageName:(NSString *)imageName operation:(void(^)())block {
    self = [super init];
    if ( !self ) return nil;
    self.title = title;
    self.imageName = imageName;
    self.operation = block;
    return self;
}

@end
