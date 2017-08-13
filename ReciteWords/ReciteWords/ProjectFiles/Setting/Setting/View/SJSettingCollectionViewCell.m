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
}

// MARK: UI

- (void)_SJSettingCollectionViewCellSetupUI {
    
    // 调试---------------------⬇️
    self.settingLabel.backgroundColor = [UIColor colorWithRed:1.0 * (arc4random() % 256 / 255.0)
                                                        green:1.0 * (arc4random() % 256 / 255.0)
                                                         blue:1.0 * (arc4random() % 256 / 255.0)
                                                        alpha:1];
    // 调试---------------------⬆️

    [self.contentView addSubview:self.settingLabel];
    [_settingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(4, 4, 4, 4));
    }];
}

- (UILabel *)settingLabel {
    if ( _settingLabel ) return _settingLabel;
    _settingLabel = [UILabel labelWithFontSize:17 textColor:[UIColor whiteColor] alignment:NSTextAlignmentCenter];
    return _settingLabel;
}

@end
