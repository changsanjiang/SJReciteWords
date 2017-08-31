//
//  SJSettingCollectionViewCell.m
//  ReciteWords
//
//  Created by BlueDancer on 2017/8/13.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import "SJSettingCollectionViewCell.h"

#import "UIView+Extension.h"

#import "SJSettingOperation.h"

#import "NSAttributedString+ZFBAdditon.h"

@interface SJSettingCollectionViewCell ()

@property (nonatomic, strong, readonly) UILabel *settingLabel;

@end

@implementation SJSettingCollectionViewCell

@synthesize settingLabel = _settingLabel;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if ( !self ) return nil;
    [self _SJSettingCollectionViewCellSetupUI];
    return self;
}

- (void)setOperation:(SJSettingOperation *)operation {
    _operation = operation;
    _settingLabel.text = operation.title;
    _settingLabel.attributedText = [NSAttributedString mh_imageTextWithImage:[UIImage imageNamed:operation.imageName] imageW:20 imageH:20 title:operation.title fontSize:12 titleColor:SJ_Font_C spacing:8];
}

// MARK: UI

- (void)_SJSettingCollectionViewCellSetupUI {

    [self.contentView addSubview:self.settingLabel];
    [_settingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(4, 4, 4, 4));
    }];
    
    self.settingLabel.layer.cornerRadius = 6;
    self.settingLabel.clipsToBounds = YES;
//    self.settingLabel.layer.shadowOffset = CGSizeMake(2, 2);
    self.settingLabel.layer.shadowColor = SJ_Words_D_C.CGColor;
}

- (UILabel *)settingLabel {
    if ( _settingLabel ) return _settingLabel;
    _settingLabel = [UILabel labelWithFontSize:12 textColor:SJ_Font_C alignment:NSTextAlignmentCenter];
    _settingLabel.backgroundColor = [UIColor whiteColor];
    _settingLabel.numberOfLines = 0;
    return _settingLabel;
}

@end
