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
    
    [self _SJSearchHistoryViewControllerSetupUI];
    
    [self _SJSearchHistoryViewControllerGetSearchHistory];
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

// MARK: UI

- (void)_SJSearchHistoryViewControllerSetupUI {
    
}

@end
