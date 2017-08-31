//
//  SJWordInfoView.m
//  ReciteWords
//
//  Created by BlueDancer on 2017/7/31.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import "SJWordInfoView.h"

#import "SJWordInfo.h"

#import "SJWordPronunciations.h"

#import <objc/message.h>



@interface SJWordInfoTipsView : UIView

@property (nonatomic, strong, readwrite) NSString *tips;

@end



@interface SJWordInfoView ()

@property (nonatomic, strong, readonly) UILabel *contentLabel;
/*!
 *  发音
 */
@property (nonatomic, strong, readonly) UILabel *pUSLabel;
/*!
 *  发音
 */
@property (nonatomic, strong, readonly) UILabel *pUKLabel;
/*!
 *  定义
 */
@property (nonatomic, strong, readonly) UILabel *definitionLabel;
/*!
 *  美音
 */
@property (nonatomic, strong, readonly) UIButton *us_audioBtn;
/*!
 *  英音
 */
@property (nonatomic, strong, readonly) UIButton *uk_audioBtn;

/*!
 *  Tips View
 */
@property (nonatomic, strong, readonly) SJWordInfoTipsView *tipsView;

@end

@implementation SJWordInfoView

@synthesize contentLabel = _contentLabel;
@synthesize pUSLabel = _pUSLabel;
@synthesize pUKLabel = _pUKLabel;
@synthesize definitionLabel = _definitionLabel;
@synthesize us_audioBtn = _us_audioBtn;
@synthesize uk_audioBtn = _uk_audioBtn;
@synthesize tipsView = _tipsView;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if ( !self ) return nil;
    [self _SJWordInfoViewSetupView];
    return self;
}

// MARK: Actions

- (void)clickedBtn:(UIButton *)btn {
    NSLog(@"clicked btn");
    switch (btn.tag) {
        case 0: {
            [Player playWithURLStr:_wordInfo.us_audio];
        }
            break;
        case 1: {
            [Player playWithURLStr:_wordInfo.uk_audio];
        }
            break;
    }
}


// MARK: Setter

- (void)setWordInfo:(SJWordInfo *)wordInfo {
    _wordInfo = wordInfo;
    _contentLabel.text = wordInfo.content;
    _pUSLabel.text = [NSString stringWithFormat:@"美 [ %@ ]", wordInfo.pronunciations.us];
    _pUKLabel.text = [NSString stringWithFormat:@"英 [ %@ ]", wordInfo.pronunciations.uk];
    _definitionLabel.text = wordInfo.definition;
    
    if ( self.enableTipsView ) {
//        wordInfo.tips = @"It shows how to prepare a CV, and gives tips on applying for jobs.它说明了如何准备简历，并就如何申请职位提了些建议。";
        self.tipsView.tips = wordInfo.tips;
        [self.tipsView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(wordInfo.tipsHeight);
        }];
        
        [self layoutIfNeeded];
    }
}

// MARK: UI

- (void)_SJWordInfoViewSetupView {
    
    [self addSubview:self.contentLabel];
    [self addSubview:self.definitionLabel];
    [self addSubview:self.pUSLabel];
    [self addSubview:self.pUKLabel];
    [self addSubview:self.us_audioBtn];
    [self addSubview:self.uk_audioBtn];
    
    CGFloat margin = ceil(20 * SJ_Rate);
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(margin);
        make.leading.trailing.offset(0);
    }];
    
    [_contentLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
    
    [_pUSLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_contentLabel);
        make.top.equalTo(_contentLabel.mas_bottom).offset(margin);
        make.leading.trailing.offset(0);
    }];
    
    [_pUKLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_contentLabel);
        make.top.equalTo(_pUSLabel.mas_bottom).offset(margin);
        make.leading.trailing.offset(0);
    }];
    
    [_definitionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_pUKLabel.mas_bottom).offset(margin);
        make.leading.trailing.offset(0);
    }];

    [_us_audioBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_definitionLabel.mas_bottom).offset(margin);
        make.trailing.equalTo(_contentLabel.mas_centerX);
        make.leading.offset(0);
    }];

    [_uk_audioBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_us_audioBtn);
        make.leading.equalTo(_contentLabel.mas_centerX);
        make.trailing.offset(0);
    }];
}

- (UILabel *)contentLabel {
    if ( _contentLabel ) return _contentLabel;
    _contentLabel = [UILabel labelWithFontSize:30 textColor:[UIColor blackColor] alignment:NSTextAlignmentCenter];
    _contentLabel.font = [UIFont boldSystemFontOfSize:30];
    return _contentLabel;
}

- (UILabel *)pUSLabel {
    if ( _pUSLabel ) return _pUSLabel;
    _pUSLabel = [UILabel labelWithFontSize:12 textColor:[UIColor blackColor] alignment:NSTextAlignmentCenter];
    return _pUSLabel;
}

- (UILabel *)pUKLabel {
    if ( _pUKLabel ) return _pUKLabel;
    _pUKLabel = [UILabel labelWithFontSize:12 textColor:[UIColor blackColor] alignment:NSTextAlignmentCenter];
    return _pUKLabel;
}

- (UILabel *)definitionLabel {
    if ( _definitionLabel ) return _definitionLabel;
    _definitionLabel = [UILabel labelWithFontSize:14 textColor:[UIColor blackColor] alignment:NSTextAlignmentCenter];
    _definitionLabel.numberOfLines = 0;
    return _definitionLabel;
}

- (UIButton *)us_audioBtn {
    if ( _us_audioBtn ) return _us_audioBtn;
    _us_audioBtn = [UIButton buttonWithImageName:@"sj_audio" title:@" 美音" titleColor:[UIColor blackColor] backgroundColor:[UIColor clearColor] tag:0 target:self sel:@selector(clickedBtn:)];
    return _us_audioBtn;
}

- (UIButton *)uk_audioBtn {
    if ( _uk_audioBtn ) return _uk_audioBtn;
    _uk_audioBtn = [UIButton buttonWithImageName:@"sj_audio" title:@" 英音" titleColor:[UIColor blackColor] backgroundColor:[UIColor clearColor] tag:1 target:self sel:@selector(clickedBtn:)];
    return _uk_audioBtn;
}

- (SJWordInfoTipsView *)tipsView {
    if ( _tipsView ) return _tipsView;
    _tipsView = [SJWordInfoTipsView new];
    _tipsView.backgroundColor = self.backgroundColor;
    [self addSubview:self.tipsView];
    CGFloat margin = ceil(20 * SJ_Rate);
    [_tipsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_uk_audioBtn.mas_bottom).offset(margin);
        make.leading.trailing.offset(0);
    }];
    return _tipsView;
}

@end




@implementation SJWordInfoView (Tips)

- (void)setEnableTipsView:(BOOL)enableTipsView {
    if ( enableTipsView == self.enableTipsView ) return;
    objc_setAssociatedObject(self, @selector(enableTipsView), @(enableTipsView), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.tipsView.hidden = !enableTipsView;
}

- (BOOL)enableTipsView {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

@end




@interface SJWordInfoTipsView ()

@property (nonatomic, strong, readonly) UILabel *headerLabel;
@property (nonatomic, strong, readonly) UITextView *textView;

@end

@implementation SJWordInfoTipsView

@synthesize headerLabel = _headerLabel;
@synthesize textView = _textView;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if ( !self ) return nil;
    [self _SJWordInfoTipsViewSetupUI];
    return self;
}

- (void)setTips:(NSString *)tips {
    _tips = tips;
    _textView.text = tips;
}

// MARK: UI

- (void)_SJWordInfoTipsViewSetupUI {
    [self addSubview:self.headerLabel];
    [self addSubview:self.textView];
    
    [_headerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.centerX.equalTo(_headerLabel.superview);
    }];
    
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headerLabel.mas_bottom).offset(8);
        make.leading.trailing.offset(0);
        make.bottom.offset(0).priority(MASLayoutPriorityRequired);
    }];
}

- (UITextView *)textView {
    if ( _textView ) return _textView;
    _textView = [UITextView new];
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.font = [UIFont systemFontOfSize:12];
    _textView.textColor = [UIColor blackColor];
    _textView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _textView.textAlignment = NSTextAlignmentCenter;
    return _textView;
}

- (UILabel *)headerLabel {
    if ( _headerLabel ) return _headerLabel;
    _headerLabel = [UILabel labelWithFontSize:14 textColor:[UIColor blackColor] alignment:NSTextAlignmentCenter];
    _headerLabel.text = @"tips";
    return _headerLabel;
}

@end
