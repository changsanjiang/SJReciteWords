//
//  SJWordsListViewController.h
//  ReciteWords
//
//  Created by BlueDancer on 2017/8/13.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import "SJBaseViewController.h"

@class SJWordList, SJBaseTableView;

@interface SJWordsListViewController : SJBaseViewController

- (instancetype)initWithList:(SJWordList *)list;

@property (nonatomic, strong, readwrite) SJWordList *list;

@property (nonatomic, strong, readonly) SJBaseTableView *tableView;

@end
