//
//  SJSearchWordsViewController.m
//  ReciteWords
//
//  Created by BlueDancer on 2017/7/31.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import "SJSearchWordsViewController.h"
#import "SJSearchWordsBar.h"
#import <objc/message.h>

// MARK: 通知处理

@interface SJSearchWordsViewController (DBNotifications)

- (void)_SJSearchWordsViewControllerInstallNotifications;

- (void)_SJSearchWordsViewControllerRemoveNotifications;

@end


@interface SJSearchWordsViewController ()

@property (nonatomic, strong, readonly) SJSearchWordsBar *searchBar;

@end

@implementation SJSearchWordsViewController

@synthesize searchBar = _searchBar;

// MARK: 生命周期

- (instancetype)init {
    self = [super init];
    if ( !self ) return nil;
    [self _SJSearchWordsViewControllerInstallNotifications];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void)dealloc {
    [self _SJSearchWordsViewControllerRemoveNotifications];
}

// MARK: UI

- (void)setupUI {
    [super setupUI];
    self.navigationItem.rightBarButtonItem = nil;
    self.title = @"单词搜索";
    
    [self.view addSubview:self.searchBar];
    
    [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.trailing.offset(0);
        make.height.offset(44);
    }];
}

- (SJSearchWordsBar *)searchBar {
    if ( _searchBar ) return _searchBar;
    _searchBar = [SJSearchWordsBar new];
    return _searchBar;
}

@end


// MARK: 通知处理

@implementation SJSearchWordsViewController (DBNotifications)

// MARK: 通知安装

- (void)_SJSearchWordsViewControllerInstallNotifications {
    NotificationCenterAddObserver(self, UIKeyboardWillChangeFrameNotification, @selector(keyboardWillChangeFrameNotification:));
    NotificationCenterAddObserver(self, UITextFieldTextDidBeginEditingNotification, @selector(textFieldTextDidBeginEditingNotification));
    NotificationCenterAddObserver(self, UITextFieldTextDidEndEditingNotification, @selector(textFieldTextDidEndEditingNotification));
}

- (void)_SJSearchWordsViewControllerRemoveNotifications {
    NotificationRemoveObserver(self);
}

- (void)keyboardWillChangeFrameNotification:(NSNotification *)notification {
    
    NSDictionary *userInfo = notification.userInfo;
    
    NSValue *userInfoFrameValue = userInfo[UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrame = userInfoFrameValue.CGRectValue;
    
    [self.searchBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(keyboardFrame.origin.y - SJ_H);
    }];
    
    NSNumber *userInfoDurationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDutation = userInfoDurationValue.doubleValue;
    [UIView animateWithDuration:animationDutation animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)textFieldTextDidBeginEditingNotification {
    [self.view addGestureRecognizer:self.tap];
}

- (void)textFieldTextDidEndEditingNotification {
    [self.view removeGestureRecognizer:self.tap];
}

- (UITapGestureRecognizer *)tap {
    UITapGestureRecognizer *tap = objc_getAssociatedObject(self, _cmd);
    if ( tap ) return tap;
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGR:)];
    objc_setAssociatedObject(self, _cmd, tap, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return tap;
}

- (void)handleTapGR:(UITapGestureRecognizer *)tap {
    [self.view endEditing:YES];
}

@end

