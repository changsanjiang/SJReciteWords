//
//  SJSettingOperation.h
//  ReciteWords
//
//  Created by BlueDancer on 2017/8/13.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SJSettingOperation : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, copy)  void(^operation)();

- (instancetype)initWithTitle:(NSString *)title imageName:(NSString *)imageName operation:(void(^)())block;

@end
