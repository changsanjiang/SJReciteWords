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

@end

@implementation SJListManageTableCell

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
}


// MARK: UI

- (void)_SJListManageTableCellSetupUI {
    [self.contentView addSubview:self.borderView];
    [self.borderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    self.borderView.lineWidth = 2;
    self.borderView.side = SJBorderlineSideTop | SJBorderlineSideBottom;
    self.borderView.lineColor = SJ_Theme_C;
    [self.borderView update];
}

@end
