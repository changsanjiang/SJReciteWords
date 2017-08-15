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

@end

@implementation SJWordInfoView

@synthesize contentLabel = _contentLabel;
@synthesize pUSLabel = _pUSLabel;
@synthesize pUKLabel = _pUKLabel;
@synthesize definitionLabel = _definitionLabel;
@synthesize us_audioBtn = _us_audioBtn;
@synthesize uk_audioBtn = _uk_audioBtn;

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
//            if ( ![self.delegate respondsToSelector:@selector(clickedUSPlayBtnOnWordInfoView:)] ) return;
//            [self.delegate clickedUSPlayBtnOnWordInfoView:self];
            [Player playWithURLStr:_wordInfo.us_audio];
        }
            break;
        case 1: {
//            if ( ![self.delegate respondsToSelector:@selector(clickedUKPlayBtnOnWordInfoView:)] ) return;
//            [self.delegate clickedUKPlayBtnOnWordInfoView:self];
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
        make.bottom.offset(-20);
    }];
    
    [_uk_audioBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_us_audioBtn);
        make.leading.equalTo(_contentLabel.mas_centerX);
        make.trailing.offset(0);
        make.bottom.offset(-20);
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
@end
