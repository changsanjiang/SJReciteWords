//
//  SJWordInfoView.m
//  ReciteWords
//
//  Created by BlueDancer on 2017/7/31.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import "SJWordInfoView.h"
#import "SJWordInfo.h"

@interface SJWordInfoView ()

@property (nonatomic, strong, readonly) UILabel *contentLabel;
/*!
 *  发音
 */
@property (nonatomic, strong, readonly) UILabel *pronunciationLabel;
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
@synthesize pronunciationLabel = _pronunciationLabel;
@synthesize definitionLabel = _definitionLabel;
@synthesize us_audioBtn = _us_audioBtn;
@synthesize uk_audioBtn = _uk_audioBtn;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if ( !self ) return nil;
    [self _SJWordInfoViewSetupUI];
    return self;
}

// MARK: Actions

- (void)clickedBtn:(UIButton *)btn {
    NSLog(@"clicked btn");
    switch (btn.tag) {
        case 0: {
            if ( ![self.delegate respondsToSelector:@selector(clickedUSPlayBtnOnWordInfoView:)] ) return;
            [self.delegate clickedUSPlayBtnOnWordInfoView:self];
        }
            break;
        case 1: {
            if ( ![self.delegate respondsToSelector:@selector(clickedUKPlayBtnOnWordInfoView:)] ) return;
            [self.delegate clickedUKPlayBtnOnWordInfoView:self];
        }
            break;
    }
}


// MARK: Setter

- (void)setWordInfo:(SJWordInfo *)wordInfo {
    _wordInfo = wordInfo;
    _contentLabel.text = wordInfo.content;
    _pronunciationLabel.text = [NSString stringWithFormat:@"[ %@ ]", wordInfo.pronunciation];
    _definitionLabel.text = wordInfo.definition;
}

// MARK: UI

- (void)_SJWordInfoViewSetupUI {
    [self addSubview:self.contentLabel];
    [self addSubview:self.definitionLabel];
    [self addSubview:self.pronunciationLabel];
    [self addSubview:self.us_audioBtn];
    [self addSubview:self.uk_audioBtn];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(20);
        make.leading.trailing.offset(0);
    }];
    
    [_pronunciationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_contentLabel);
        make.top.equalTo(_contentLabel.mas_bottom).offset(20);
        make.leading.trailing.offset(0);
    }];
    
    [_definitionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_pronunciationLabel.mas_bottom).offset(20);
        make.leading.offset(12);
        make.trailing.offset(12);
    }];
    
    [_us_audioBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_definitionLabel.mas_bottom).offset(20);
        make.centerX.equalTo(_contentLabel).multipliedBy(0.5);
    }];
    
    [_uk_audioBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_us_audioBtn);
        make.centerX.equalTo(_contentLabel).multipliedBy(1.5);
    }];
}

- (UILabel *)contentLabel {
    if ( _contentLabel ) return _contentLabel;
    _contentLabel = [UILabel labelWithFontSize:16 textColor:[UIColor blackColor] alignment:NSTextAlignmentCenter];
    _contentLabel.font = [UIFont boldSystemFontOfSize:16];
    return _contentLabel;
}

- (UILabel *)pronunciationLabel {
    if ( _pronunciationLabel ) return _pronunciationLabel;
    _pronunciationLabel = [UILabel labelWithFontSize:12 textColor:[UIColor blackColor] alignment:NSTextAlignmentCenter];
    return _pronunciationLabel;
}

- (UILabel *)definitionLabel {
    if ( _definitionLabel ) return _definitionLabel;
    _definitionLabel = [UILabel labelWithFontSize:14 textColor:[UIColor blackColor]];
    _definitionLabel.numberOfLines = 0;
    return _definitionLabel;
}

- (UIButton *)us_audioBtn {
    if ( _us_audioBtn ) return _us_audioBtn;
    _us_audioBtn = [UIButton buttonWithImageName:@"sj_word_audio" title:@"美音" titleColor:[UIColor blackColor] backgroundColor:[UIColor clearColor] tag:0 target:self sel:@selector(clickedBtn:)];
    return _us_audioBtn;
}

- (UIButton *)uk_audioBtn {
    if ( _uk_audioBtn ) return _uk_audioBtn;
    _uk_audioBtn = [UIButton buttonWithImageName:@"sj_word_audio" title:@"英音" titleColor:[UIColor blackColor] backgroundColor:[UIColor clearColor] tag:1 target:self sel:@selector(clickedBtn:)];
    return _uk_audioBtn;
}
@end
