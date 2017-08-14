//
//  SJWordsListViewController.m
//  ReciteWords
//
//  Created by BlueDancer on 2017/8/13.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import "SJWordsListViewController.h"

#import "SJBaseTableView.h"


static CellID const SJWordsListTableCellID = @"SJWordsListTableCell";

@interface SJWordsListViewController (UITableViewDelegateMethods)<UITableViewDelegate> @end
@interface SJWordsListViewController (UITableViewDataSourceMethods)<UITableViewDataSource> @end



@interface SJWordsListViewController ()

@property (nonatomic, strong, readonly) SJBaseTableView *tableView;

@end

@implementation SJWordsListViewController

@synthesize tableView = _tableView;

// MARK: UI

- (void)setupUI {
    [super setupUI];
    
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
}

- (SJBaseTableView *)tableView {
    if ( _tableView ) return _tableView;
    _tableView = [SJBaseTableView new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 150 * SJ_Rate;
    [_tableView registerClass:NSClassFromString(SJWordsListTableCellID) forCellReuseIdentifier:SJWordsListTableCellID];
    return _tableView;
}

@end




@implementation SJWordsListViewController (UITableViewDelegateMethods)

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
}

@end

@implementation SJWordsListViewController (UITableViewDataSourceMethods)

// MARK: Table View Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 99;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SJWordsListTableCellID];
    
//    [cell setValue:model forKey:@"model"];
    
    return cell;
}

// MARK: Edit

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"delete" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"delete");
    }];
    if ( action ) return @[action];
    return nil;
}

@end
