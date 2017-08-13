//
//  UIColor+Extension.m
//  CSJExample
//
//  Created by ya on 12/5/16.
//  Copyright © 2016 ya. All rights reserved.
//

#import "UIColor+Extension.h"

@implementation UIColor (Extension)

+ (instancetype)csj_randomColor {
    return [UIColor colorWithRed:(float)(arc4random() % 256) / 255.0
                           green:(float)(arc4random() % 256) / 255.0
                            blue:(float)(arc4random() % 256) / 255.0
                           alpha:1];
}

+ (instancetype)csj_colorWithHexStr:(NSString *)hexStr {
    if ( hexStr.length < 6) return nil;
    NSString *str = [hexStr substringWithRange:NSMakeRange(hexStr.length - 6, 6)];
    
    NSInteger location = 0;
    NSRange range = NSMakeRange(location, 2);
    NSString *rStr = [str substringWithRange:range];
    
    location = 2;
    range = NSMakeRange(location, 2);
    NSString *gStr = [str substringWithRange:range];
    
    location = 4;
    range = NSMakeRange(location, 2);
    NSString *bStr = [str substringWithRange:range];
    
    unsigned int red   = 0;
    unsigned int green = 0;
    unsigned int blue  = 0;
    
    [[NSScanner scannerWithString:rStr] scanHexInt:&red];
    [[NSScanner scannerWithString:gStr] scanHexInt:&green];
    [[NSScanner scannerWithString:bStr] scanHexInt:&blue];
    
    return [UIColor colorWithRed:red / 255.0f green:green / 255.0f blue:blue / 255.0f alpha:1];
}

/// UIColor 获取 RGB 值
- (CGFloat)csj_redValue {
    return (CGColorGetComponents(self.CGColor)[0] * 255);
}

- (CGFloat)csj_greenValue {
    return (CGColorGetComponents(self.CGColor)[1] * 255);
}

- (CGFloat)csj_blueValue {
    return (CGColorGetComponents(self.CGColor)[2] * 255);
}

- (CGFloat)csj_alpha {
    return CGColorGetComponents(self.CGColor)[3];
}


@end
