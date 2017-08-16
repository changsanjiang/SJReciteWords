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

#import "SJWordInfo.h"

#import "SJWordList.h"

#import "SJWordInfoView.h"

#import "SJTransitionAnimator.h"

#import "SJAddWordToListViewController.h"

// MARK: 通知处理

@interface SJSearchWordsViewController (DBNotifications)

- (void)_SJSearchWordsViewControllerInstallNotifications;

- (void)_SJSearchWordsViewControllerRemoveNotifications;

@end

@interface SJSearchWordsViewController (SJSearchWordsBarDelegateMethods)<SJSearchWordsBarDelegate> @end

@interface SJSearchWordsViewController ()

@property (nonatomic, strong, readonly) SJSearchWordsBar *searchBar;
@property (nonatomic, strong, readonly) SJWordInfoView *wordInfoView;
@property (nonatomic, strong, readwrite) SJWordList *list;
@property (nonatomic, strong, readonly) UIButton *navRightItem;
@property (nonatomic, strong, readonly) UIView *editingMaskView;
@property (nonatomic, strong, readonly) SJTransitionAnimator *animator;

@end

@implementation SJSearchWordsViewController

@synthesize searchBar = _searchBar;
@synthesize wordInfoView = _wordInfoView;
@synthesize navRightItem = _navRightItem;
@synthesize editingMaskView = _editingMaskView;
@synthesize animator = _animator;

// MARK: 生命周期

- (instancetype)init {
    self = [super init];
    if ( !self ) return nil;
    [self _SJSearchWordsViewControllerInstallNotifications];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _SJSearchWordsViewControllerSetupUI];
    
    // Do any additional setup after loading the view.
}

- (void)dealloc {
    [self _SJSearchWordsViewControllerRemoveNotifications];
}

- (void)showRightItem {
    if ( self.navigationItem.rightBarButtonItem == nil ) self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.navRightItem];
    [self.navRightItem shakeAnimation];
}

// MARK: Actions

- (void)clickedBarItem:(UIBarButtonItem *)barItem {
    NSLog(@"clicked bar item");
    SJAddWordToListViewController *vc = [SJAddWordToListViewController new];
    self.animator.modalViewController = vc;
    CGFloat duration = self.animator.duration;
    __weak typeof(self) _self = self;
    
    
    // Present Animation
    [self.animator presentedAnimation:^(id<UIViewControllerContextTransitioning>  _Nonnull transitionContext) {
        UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
        UIView *containerView = [transitionContext containerView];
        [containerView addSubview:toView];
        containerView.backgroundColor = [UIColor clearColor];
        toView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        toView.alpha = 0.001;
        
        __strong typeof(_self) self = _self;
        if ( !self ) return;
        [UIView animateWithDuration:duration animations:^{
            toView.alpha = 1;
        } completion:^(BOOL finished) {
            
            // hidden search bar
            self.searchBar.alpha = 0.001;
            [transitionContext completeTransition:YES];
        }];
        
    // Dismiss Animation
    } dismissedAnimation:^(id<UIViewControllerContextTransitioning>  _Nonnull transitionContext) {
        __strong typeof(_self) self = _self;
        if ( !self ) return;
        
        // show search bar
        self.searchBar.alpha = 1;
        UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        [UIView animateWithDuration:0.25 animations:^{
            fromView.alpha = 0.001;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }];
    
    
    // Selected List Block
    __weak SJAddWordToListViewController *weakVC = vc;
    vc.selectedListCallBlock = ^(SJWordList *list) {
        __strong typeof(_self) self = _self;
        if ( !self ) return;
        if ( nil == self.wordInfoView.wordInfo ) return;
        [list.words insertObject:self.wordInfoView.wordInfo atIndex:list.words.count];
        [SVProgressHUD show];
        [LocalManager addedWordsToList:list words:@[self.wordInfoView.wordInfo] callBlock:^(BOOL result) {
            if ( result ) {
                // Proper dela
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SVProgressHUD showSuccessWithStatus:@"添加成功"];
                    [weakVC dismissViewControllerAnimated:YES completion:nil];
                });
                return ;
            }
            [list.words removeLastObject];
            [SVProgressHUD showErrorWithStatus:@"添加失败"];
        }];
    };
    
    [self presentViewController:vc animated:YES completion:nil];
}

// MARK: UI

- (void)_SJSearchWordsViewControllerSetupUI {
    
    self.navigationItem.rightBarButtonItem = nil;
    self.title = @"单词搜索";
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.view addSubview:self.wordInfoView];
    [self.view addSubview:self.searchBar];
    
    _searchBar.delegate = self;
    
    [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.trailing.offset(0);
        make.height.offset(44);
    }];
    
    [_wordInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(20);
        make.leading.trailing.offset(0);
    }];
    
    _wordInfoView.hidden = YES;
}

- (SJSearchWordsBar *)searchBar {
    if ( _searchBar ) return _searchBar;
    _searchBar = [SJSearchWordsBar new];
    return _searchBar;
}

- (SJWordInfoView *)wordInfoView {
    if ( _wordInfoView ) return _wordInfoView;
    _wordInfoView = [SJWordInfoView new];
    _wordInfoView.clipsToBounds = YES;
    return _wordInfoView;
}

- (UIButton *)navRightItem {
    if ( _navRightItem ) return _navRightItem;
    _navRightItem = [UIButton buttonWithImageName:@"sj_word_addToList" tag:0 target:self sel:@selector(clickedBarItem:)];
    [_navRightItem sizeToFit];
    return _navRightItem;
}

- (UIView *)editingMaskView {
    if ( _editingMaskView ) return _editingMaskView;
    _editingMaskView = [UIView new];
    _editingMaskView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGR:)];
    [_editingMaskView addGestureRecognizer:tap];
    return _editingMaskView;
}

- (void)handleTapGR:(UITapGestureRecognizer *)tap {
    [self.view endEditing:YES];
}

- (SJTransitionAnimator *)animator {
    if ( _animator ) return _animator;
    _animator = [SJTransitionAnimator new];
    _animator.duration = 0.25;
    return _animator;
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
    [self.view addSubview:self.editingMaskView];
    [self.editingMaskView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.offset(0);
        make.bottom.equalTo(_searchBar.mas_top).offset(-8);
    }];
}

- (void)textFieldTextDidEndEditingNotification {
    [self.editingMaskView removeFromSuperview];
}

@end



@implementation SJSearchWordsViewController (SJSearchWordsBarDelegateMethods)

- (void)finishedInputWithSearchWordsBar:(SJSearchWordsBar *)bar content:(NSString *)content {
//    [SVProgressHUD showWithStatus:@"请求中..."];
    __weak typeof(self) _self = self;
    [DataServices searchWordWithContent:content callBlock:^(SJWordInfo *wordInfo) {
//        [SVProgressHUD dismiss];
        __strong typeof(_self) self = _self;
        if ( !self ) return;
        self.wordInfoView.wordInfo = wordInfo;
        self.wordInfoView.hidden = NO;
        [self.wordInfoView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(wordInfo.height).priority(MASLayoutPriorityDefaultHigh);
        }];
        [UIView animateWithDuration:0.25 animations:^{
            [self.wordInfoView layoutIfNeeded];
        }];
        [Player playWithURLStr:wordInfo.us_audio];
        [self showRightItem];
        [LocalManager searchListAddWord:wordInfo callBlock:nil];
    }];
}

@end
