//
//  SJBaseTableViewCell.m
//  ReciteWords
//
//  Created by BlueDancer on 2017/8/14.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import "SJBaseTableViewCell.h"

#import <SJBorderlineView.h>

@interface SJBaseTableViewCell ()

@end

@implementation SJBaseTableViewCell

@synthesize borderView = _borderView;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( !self ) return nil;
    [self _SJBaseTableViewCellSetupUI];
    return self;
}

// MARK: UI

- (void)_SJBaseTableViewCellSetupUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (SJBorderlineView *)borderView {
    if ( _borderView ) return _borderView;
    _borderView = [SJBorderlineView new];
    _borderView.backgroundColor = [UIColor whiteColor];
    return _borderView;
}

@end
