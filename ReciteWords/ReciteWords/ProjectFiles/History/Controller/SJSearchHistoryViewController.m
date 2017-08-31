//
//  SJSearchHistoryViewController.m
//  ReciteWords
//
//  Created by BlueDancer on 2017/8/13.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import "SJSearchHistoryViewController.h"

#import "SJWordInfo.h"

#import "SJWordList.h"

#import "SJBaseTableView.h"

@interface SJSearchHistoryViewController ()

@end

@implementation SJSearchHistoryViewController


- (instancetype)init {
    self = [super init];
    if ( !self ) return nil;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _SJSearchHistoryViewControllerGetSearchHistory];
}

- (void)setList:(SJWordList *)list {
    [list.words enumerateObjectsUsingBlock:^(SJWordInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.tips = @"It shows how to prepare a CV, and gives tips on applying for jobs.它说明了如何准备简历，并就如何申请职位提了些建议。";
    }];
    [super setList:list];
    self.title = @"搜索历史";
}

- (void)_SJSearchHistoryViewControllerGetSearchHistory {
    [LocalManager getSearchHistory:^(SJWordList * _Nonnull searchList) {
        self.list = searchList;
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

@end
