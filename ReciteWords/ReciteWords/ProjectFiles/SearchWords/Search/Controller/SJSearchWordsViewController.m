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


#define SJWordInfoTop   (SJ_H * 0.06)


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
@property (nonatomic, strong, readonly) UIScrollView *scrollView;

@property (nonatomic, strong, readonly) UIButton *navRightItem;
@property (nonatomic, strong, readonly) SJTransitionAnimator *animator;

@end

@implementation SJSearchWordsViewController

@synthesize searchBar = _searchBar;
@synthesize wordInfoView = _wordInfoView;
@synthesize navRightItem = _navRightItem;
@synthesize animator = _animator;
@synthesize scrollView = _scrollView;

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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.25 animations:^{
        _searchBar.alpha = 1;
    }];
}

// MARK: Show Right Item

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
        [SJPrompt show];
        [LocalManager addWordsToList:list word:self.wordInfoView.wordInfo callBlock:^(BOOL result, NSError * _Nullable error) {
            if ( result ) {
                // Proper dela
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SJPrompt showSuccessTitle:@"添加成功"];
                    [weakVC dismissViewControllerAnimated:YES completion:nil];
                });
                return ;
            }
            [SJPrompt showErrorTitle:error.userInfo[@"error"]];
        }];
    };
    
    [self presentViewController:vc animated:YES completion:nil];
}

// MARK: UI

- (void)_SJSearchWordsViewControllerSetupUI {
    
    self.navigationItem.rightBarButtonItem = nil;
    self.title = @"单词搜索";
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.wordInfoView];
    [self.view addSubview:self.searchBar];
    
    _searchBar.delegate = self;
    
    [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.trailing.offset(0);
        make.height.offset(44);
    }];
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.offset(0);
        make.bottom.equalTo(_searchBar.mas_top).offset(-8);
    }];
    
    _wordInfoView.frame = CGRectMake(8, SJWordInfoTop, SJ_W - 16, SJ_H);
    
    // hidden this view because it not has data.
    _wordInfoView.hidden = YES;
    
    // use keybord.
    [_searchBar becomeFirstResponder];
    _searchBar.alpha = 0.001;
}

- (void)resetWordInfoViewLocation {
    [UIView animateWithDuration:0.25 animations:^{
       _wordInfoView.csj_y = SJWordInfoTop;
    }];
}

- (SJSearchWordsBar *)searchBar {
    if ( _searchBar ) return _searchBar;
    _searchBar = [SJSearchWordsBar new];
    _searchBar.keyboardType = UIKeyboardTypeASCIICapable;
    return _searchBar;
}

- (SJWordInfoView *)wordInfoView {
    if ( _wordInfoView ) return _wordInfoView;
    _wordInfoView = [SJWordInfoView new];
    _wordInfoView.clipsToBounds = YES;
    return _wordInfoView;
}

- (UIScrollView *)scrollView {
    if ( _scrollView ) return _scrollView;
    _scrollView = [UIScrollView new];
    _scrollView.backgroundColor = SJ_Theme_C;
    return _scrollView;
}

- (UIButton *)navRightItem {
    if ( _navRightItem ) return _navRightItem;
    _navRightItem = [UIButton buttonWithImageName:@"sj_word_addToList" tag:0 target:self sel:@selector(clickedBarItem:)];
    [_navRightItem sizeToFit];
    return _navRightItem;
}

// MARK: Lazy

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
}

- (void)_SJSearchWordsViewControllerRemoveNotifications {
    NotificationRemoveObserver(self);
}

- (void)keyboardWillChangeFrameNotification:(NSNotification *)notification {
    
    NSDictionary *userInfo = notification.userInfo;
    
    NSValue *userInfoFrameValue = userInfo[UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrame = userInfoFrameValue.CGRectValue;
    
    CGFloat subs = SJ_H;
    if ( [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight ||
        [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft ) {
        subs = SJ_W;
    }
    [self.searchBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(keyboardFrame.origin.y - subs);
    }];
    
    NSNumber *userInfoDurationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDutation = userInfoDurationValue.doubleValue;
    [UIView animateWithDuration:animationDutation animations:^{
        [self.view layoutIfNeeded];
    }];
}

@end



@implementation SJSearchWordsViewController (SJSearchWordsBarDelegateMethods)

- (void)finishedInputWithSearchWordsBar:(SJSearchWordsBar *)bar content:(NSString *)content {
    bar.enableSearchBtn = NO;
    __weak typeof(self) _self = self;
    [DataServices searchWordWithContent:content callBlock:^(SJWordInfo *wordInfo) {
        [bar clearInputtedText];
        bar.enableSearchBtn = YES;
        __strong typeof(_self) self = _self;
        if ( !self ) return;
        if ( 0 == wordInfo.content.length ) return;
        self.wordInfoView.wordInfo = wordInfo;
        self.wordInfoView.hidden = NO;
        [self resetWordInfoViewLocation];
        [UIView animateWithDuration:0.25 animations:^{
            self.wordInfoView.csj_h = wordInfo.height;
        }];
        self.scrollView.contentSize = CGSizeMake(SJ_W, wordInfo.height + SJWordInfoTop);
        [Player playWithURLStr:wordInfo.us_audio];
        [self showRightItem];
        [LocalManager searchListAddWord:wordInfo callBlock:nil];
    }];
}

@end
