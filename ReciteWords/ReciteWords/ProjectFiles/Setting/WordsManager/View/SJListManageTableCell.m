//
//  SJListManageTableCell.m
//  ReciteWords
//
//  Created by BlueDancer on 2017/8/14.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import "SJListManageTableCell.h"

#import <SJBorderlineView.h>

#import "SJWordList.h"

@interface SJListManageTableCell ()

@property (nonatomic, strong, readonly) UILabel *countLabel;

@end

@implementation SJListManageTableCell

@synthesize countLabel = _countLabel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( !self ) return nil;
    [self _SJListManageTableCellSetupUI];
    return self;
}

// MARK: Setter

- (void)setList:(SJWordList *)list {
    _list = list;
    self.textLabel.text = list.title;
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    _countLabel.text = [NSString stringWithFormat:@"%zd 个", list.words.count];
}


// MARK: UI

- (void)_SJListManageTableCellSetupUI {
    [self.contentView addSubview:self.borderView];
    [self.borderView addSubview:self.countLabel];
    
    [self.borderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    self.borderView.lineWidth = 0.4;
    self.borderView.side = SJBorderlineSideTop | SJBorderlineSideBottom;
    [self.borderView setStartMargin:8 endMargin:8];
    self.borderView.lineColor = SJ_Theme_C;
    [self.borderView update];
    
    
    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.offset(-8);
        make.bottom.offset(-4);
    }];
}

- (UILabel *)countLabel {
    if ( _countLabel ) return _countLabel;
    _countLabel = [UILabel labelWithFontSize:8 textColor:[UIColor lightGrayColor]];
    return _countLabel;
}

@end
