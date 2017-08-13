//
//  UIColor+Extension.h
//  CSJExample
//
//  Created by ya on 12/5/16.
//  Copyright © 2016 ya. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Extension)

/// 获取 RGB 值
@property (nonatomic, assign, readonly) CGFloat csj_redValue;
@property (nonatomic, assign, readonly) CGFloat csj_greenValue;
@property (nonatomic, assign, readonly) CGFloat csj_blueValue;
@property (nonatomic, assign, readonly) CGFloat csj_alpha;
@property (nonatomic, strong, class, readonly) UIColor *csj_randomColor;

+ (instancetype)csj_colorWithHexStr:(NSString *)hexStr;

@end

NS_ASSUME_NONNULL_END
