//
//  SJSearchWordsBar.m
//  ReciteWords
//
//  Created by BlueDancer on 2017/7/31.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import "SJSearchWordsBar.h"
#import "SJBorderlineView.h"

@interface SJSearchWordsBar (UITextFieldDelegateMethods)<UITextFieldDelegate> @end

@interface SJSearchWordsBar ()

@property (nonatomic, strong, readonly) UITextField *inputView;
@property (nonatomic, strong, readonly) SJBorderlineView *borderView;
@property (nonatomic, strong, readonly) UIButton *searchBtn;

@end

@implementation SJSearchWordsBar

@synthesize inputView = _inputView;
@synthesize borderView = _borderView;
@synthesize searchBtn = _searchBtn;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if ( !self ) return nil;
    [self _SJSearchWordsBarSetupUI];
    return self;
}

// MARK: Public

- (void)becomeFirstResponder {
    if ( !_inputView.isFirstResponder ) [_inputView becomeFirstResponder];
}

- (void)resignFirstResponder {
    if ( _inputView.isFirstResponder ) [_inputView resignFirstResponder];
}

- (void)clearInputtedText {
    _inputView.text = nil;
}

// MARK: Setter

- (void)setEnableSearchBtn:(BOOL)enableSearchBtn {
    _enableSearchBtn = enableSearchBtn;
    _searchBtn.enabled = enableSearchBtn;
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType {
    _keyboardType = keyboardType;
    self.inputView.keyboardType = keyboardType;
}

// MARK: Actions

- (void)clickedBtn:(UIButton *)btn {
    NSLog(@"clicked search btn.");
    if ( 0 == _inputView.text.length ) return;
    if ( ![self.delegate respondsToSelector:@selector(finishedInputWithSearchWordsBar:content:)] ) return;
    [self.delegate finishedInputWithSearchWordsBar:self content:_inputView.text];
}


// MARK: UI

- (void)_SJSearchWordsBarSetupUI {
    [self addSubview:self.borderView];
    [_borderView addSubview:self.inputView];
    [_borderView addSubview:self.searchBtn];
    
    [_borderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    
    [_inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(6);
        make.bottom.offset(-6);
        make.leading.offset(8);
        make.trailing.equalTo(_searchBtn.mas_leading).offset(-8);
    }];
    
    [_searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.trailing.bottom.offset(0);
        make.width.equalTo(_searchBtn.superview).multipliedBy(0.2);
    }];
}

- (UITextField *)inputView {
    if ( _inputView ) return _inputView;
    _inputView = [[UITextField alloc] init];
    _inputView.backgroundColor = [UIColor whiteColor];
    _inputView.layer.cornerRadius = 4;
    _inputView.clipsToBounds = YES;
    _inputView.delegate = self;
    _inputView.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
    _inputView.leftViewMode = UITextFieldViewModeAlways;
    _inputView.clearButtonMode = UITextFieldViewModeAlways;
    _inputView.returnKeyType = UIReturnKeyDone;
    return _inputView;
}

- (SJBorderlineView *)borderView {
    if ( _borderView ) return _borderView;
    _borderView = [SJBorderlineView borderlineViewWithSide:SJBorderlineSideTop startMargin:0 endMargin:0 lineColor:[UIColor colorWithWhite:0.9 alpha:1] backgroundColor:SJ_Theme_C];
    return _borderView;
}

- (UIButton *)searchBtn {
    if ( _searchBtn ) return _searchBtn;
    _searchBtn = [UIButton buttonWithTitle:@"搜索"
                                titleColor:[UIColor blackColor]
                           backgroundColor:[UIColor clearColor]
                                       tag:0
                                    target:self
                                       sel:@selector(clickedBtn:)
                                  fontSize:14];
    return _searchBtn;
}
@end


@implementation SJSearchWordsBar (UITextFieldDelegateMethods)

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ( 0 == _inputView.text.length ) return YES;
    if ( ![self.delegate respondsToSelector:@selector(finishedInputWithSearchWordsBar:content:)] ) return YES;
    [self.delegate finishedInputWithSearchWordsBar:self content:textField.text];
    return YES;
}

@end
