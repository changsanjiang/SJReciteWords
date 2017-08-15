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

#import "SJWordInfo.h"

#import "SJWordPronunciations.h"

#import "SJWordInfoView.h"

@interface SJWordsListTableCell ()

@property (nonatomic, strong) SJWordInfoView *wordInfoView;

@end

@implementation SJWordsListTableCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _SJWordsListTableCellSetupView];
    }
    return self;
}

// MARK: Setter

- (void)setModel:(SJWordInfo *)model {
    _model = model;
    _wordInfoView.wordInfo = model;
}

// MARK: UI

- (void)_SJWordsListTableCellSetupView {
    
    [self.contentView addSubview:self.borderView];
    self.borderView.lineColor = SJ_Theme_C;
    self.borderView.lineWidth = 1;
    self.borderView.side = SJBorderlineSideTop | SJBorderlineSideBottom;
    [self.borderView update];
   
    [self.borderView addSubview:self.wordInfoView];
    
    [self.borderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    
    [self.wordInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
}

- (SJWordInfoView *)wordInfoView {
    if ( _wordInfoView ) return _wordInfoView;
    _wordInfoView = [SJWordInfoView new];
    return _wordInfoView;
}
@end
