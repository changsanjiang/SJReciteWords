//
//  SJWordsListTableCell.m
//  ReciteWords
//
//  Created by BlueDancer on 2017/8/15.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import "SJWordsListTableCell.h"

#import "UIView+Extension.h"

#import <SJBorderlineView.h>

static short const SJUS_AudioBtnTag = 0;
static short const SJUK_AudioBtnTag = 1;
static short const SJPlayBtnTag = 2;

@interface SJWordsListTableCell ()

@property (nonatomic, strong, readonly) UILabel *contentLabel;
/*!
 *  美音
 */
@property (nonatomic, strong, readonly) UIButton *us_audioBtn;
/*!
 *  英音
 */
@property (nonatomic, strong, readonly) UIButton *uk_audioBtn;

/*!
 *  定义
 */
@property (nonatomic, strong, readonly) UILabel *definitionLabel;

/*!
 *  播放
 */
@property (nonatomic, strong, readonly) UIButton *playBtn;

@end

@implementation SJWordsListTableCell

@synthesize contentLabel = _contentLabel;
@synthesize us_audioBtn = _us_audioBtn;
@synthesize uk_audioBtn = _uk_audioBtn;
@synthesize definitionLabel = _definitionLabel;
@synthesize playBtn = _playBtn;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _SJWordsListTableCellSetupUI];
    }
    return self;
}

// MARK: Actions

- (void)clickedBtn:(UIButton *)btn {
    NSLog(@"clicked btn");
}

// MARK: UI

- (void)_SJWordsListTableCellSetupUI {
    
    // 调试---------------------⬇️
    self.contentLabel.text = @"Color";
    self.definitionLabel.text = @"1  n. 颜色; 脸色; 肤色; 颜料\n 2  vt. 给...涂颜色; 粉饰; 歪曲\n 3  vi. 变色; 获得颜色";
    // 调试---------------------⬆️

    
    
    [self.contentView addSubview:self.borderView];
    self.borderView.lineColor = SJ_Theme_C;
    self.borderView.lineWidth = 1;
    self.borderView.side = SJBorderlineSideTop | SJBorderlineSideBottom;
    [self.borderView update];
    
    [self.borderView addSubview:self.contentLabel];
    [self.borderView addSubview:self.us_audioBtn];
    [self.borderView addSubview:self.uk_audioBtn];
    [self.borderView addSubview:self.definitionLabel];
    [self.borderView addSubview:self.playBtn];
    
    [self.borderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    
    [_us_audioBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_us_audioBtn.superview).multipliedBy(1.5);
        make.centerY.equalTo(_contentLabel.mas_centerY).multipliedBy(0.5);
    }];
    
    [_uk_audioBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_us_audioBtn);
        make.centerY.equalTo(_contentLabel.mas_centerY).multipliedBy(1.5);
    }];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_contentLabel.superview).multipliedBy(0.5);
        make.top.offset(0);
        make.height.offset(64 * SJ_Rate);
    }];
    
    [_playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.offset(8);
        make.bottom.offset(-8);
        make.size.mas_offset(CGSizeMake(20, 20));
    }];
    
    [_definitionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_playBtn.mas_trailing).offset(8);
        make.bottom.equalTo(_playBtn);
        make.top.equalTo(_contentLabel.mas_bottom).offset(8);
        make.trailing.offset(-8);
    }];
}

- (UILabel *)contentLabel {
    if ( _contentLabel ) return _contentLabel;
    _contentLabel = [UILabel labelWithFontSize:17 textColor:[UIColor blackColor] alignment:NSTextAlignmentCenter];
    return _contentLabel;
}

- (UIButton *)us_audioBtn {
    if ( _us_audioBtn ) return _us_audioBtn;
    _us_audioBtn = [UIButton buttonWithTitle:@"英音 [ 'kçl¢ ]" titleColor:[UIColor blackColor] backgroundColor:[UIColor clearColor] tag:SJUS_AudioBtnTag target:self sel:@selector(clickedBtn:) fontSize:12];
    return _us_audioBtn;
}

- (UIButton *)uk_audioBtn {
    if ( _uk_audioBtn ) return _uk_audioBtn;
    _uk_audioBtn = [UIButton buttonWithTitle:@"美音 [ 'kçl¢ ]" titleColor:[UIColor blackColor] backgroundColor:[UIColor clearColor] tag:SJUK_AudioBtnTag target:self sel:@selector(clickedBtn:) fontSize:12];
    return _uk_audioBtn;
}

- (UILabel *)definitionLabel {
    if ( _definitionLabel ) return _definitionLabel;
    _definitionLabel = [UILabel labelWithFontSize:12 textColor:[UIColor blackColor] alignment:NSTextAlignmentCenter];
    _definitionLabel.numberOfLines = 0;
    return _definitionLabel;
}

- (UIButton *)playBtn {
    if ( _playBtn ) return _playBtn;
    _playBtn = [UIButton buttonWithImageName:@"sj_audio" tag:SJPlayBtnTag target:self sel:@selector(clickedBtn:)];
    return _playBtn;
}
@end
