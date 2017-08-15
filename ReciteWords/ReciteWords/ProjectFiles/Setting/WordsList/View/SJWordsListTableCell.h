//
//  SJWordsListTableCell.h
//  ReciteWords
//
//  Created by BlueDancer on 2017/8/15.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import "SJBaseTableViewCell.h"

@class SJWordInfo;

@interface SJWordsListTableCell : SJBaseTableViewCell

@property (nonatomic, strong) SJWordInfo *model;

@end
