//
//  SJBaseTableView.m
//  ReciteWords
//
//  Created by BlueDancer on 2017/8/14.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import "SJBaseTableView.h"

@implementation SJBaseTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if ( !self ) return nil;
    self.estimatedRowHeight = 150;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.backgroundColor = [UIColor whiteColor];
    self.showsVerticalScrollIndicator = YES;
    self.showsHorizontalScrollIndicator = NO;
    return self;
}

@end
