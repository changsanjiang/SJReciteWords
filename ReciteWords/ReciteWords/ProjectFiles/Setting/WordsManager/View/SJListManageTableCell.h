//
//  SJListManageTableCell.h
//  ReciteWords
//
//  Created by BlueDancer on 2017/8/14.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import "SJBaseTableViewCell.h"

@class SJWordList;

@interface SJListManageTableCell : SJBaseTableViewCell

@property (nonatomic, strong) SJWordList *list;

@end
