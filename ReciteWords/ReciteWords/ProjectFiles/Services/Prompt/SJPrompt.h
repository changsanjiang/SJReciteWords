//
//  SJPrompt.h
//  ReciteWords
//
//  Created by BlueDancer on 2017/8/31.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SJPrompt : NSObject

+ (void)showInfoTitle:(NSString *)infoTitle;

+ (void)showSuccessTitle:(NSString *)title;

+ (void)showErrorTitle:(NSString *)title;

+ (void)show;

+ (void)dismiss;

@end
