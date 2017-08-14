//
//  SJWordsListViewController.m
//  ReciteWords
//
//  Created by BlueDancer on 2017/8/13.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import "SJWordsListViewController.h"

#import "SJBaseTableView.h"



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
    
}

- (SJBaseTableView *)tableView {
    if ( _tableView ) return _tableView;
    _tableView = [SJBaseTableView new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 118 * SJ_Rate;
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
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#CellID#>];
    
    [cell setValue:model forKey:@"model"];
    
    return cell;
}

@end
