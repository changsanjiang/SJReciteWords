//
//  SJPrompt.m
//  ReciteWords
//
//  Created by BlueDancer on 2017/8/31.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import "SJPrompt.h"

#import <SVProgressHUD.h>

@implementation SJPrompt

+ (void)showInfoTitle:(NSString *)infoTitle {
    [SVProgressHUD showInfoWithStatus:infoTitle];
}

+ (void)showSuccessTitle:(NSString *)title {
    [SVProgressHUD showSuccessWithStatus:title];
}

+ (void)showErrorTitle:(NSString *)title {
    [SVProgressHUD showErrorWithStatus:title];
}

+ (void)show {
    [SVProgressHUD show];
}

+ (void)dismiss {
    [SVProgressHUD dismiss];
}

@end
