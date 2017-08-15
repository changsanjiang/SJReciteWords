//
//  SJListManageViewController.m
//  ReciteWords
//
//  Created by BlueDancer on 2017/8/13.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import "SJListManageViewController.h"

#import "SJBaseTableView.h"

#import "SJWordList.h"

#import "SJWordInfo.h"

#import "SJWordsListViewController.h"

static CellID const SJListManageTableCellID = @"SJListManageTableCell";


@interface SJListManageViewController (UITableViewDelegateMethods)<UITableViewDelegate> @end
@interface SJListManageViewController (UITableViewDataSourceMethods)<UITableViewDataSource> @end



@interface SJListManageViewController ()

@property (nonatomic, strong, readonly) SJBaseTableView *tableView;
@property (nonatomic, strong, readonly) NSArray<SJWordList *> *lists;

@end

@implementation SJListManageViewController

@synthesize tableView = _tableView;

@synthesize lists = _lists;


- (void)viewDidLoad {
    [super viewDidLoad];
    [self _SJListManageViewControllerSetupUI];
}

// MARK: UI

- (void)_SJListManageViewControllerSetupUI {
    
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
}

- (SJBaseTableView *)tableView {
    if ( _tableView ) return _tableView;
    _tableView = [SJBaseTableView new];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = ceil(64 * SJ_Rate);
    [_tableView registerClass:NSClassFromString(SJListManageTableCellID) forCellReuseIdentifier:SJListManageTableCellID];
    return _tableView;
}

// MARK: Lazy

- (NSArray<SJWordList *> *)lists {
    if ( _lists ) return _lists;
    NSMutableArray *listsM = [NSMutableArray new];
    for ( int i = 0 ; i < 99 ; i ++ ) {
        [listsM addObject:[self getTestRandomList]];
    }
    _lists = listsM.copy;
    return _lists;
}

- (SJWordList *)getTestRandomList {
    SJWordList *list = [SJWordList new];
    list.title = [NSString stringWithFormat:@"测试 %zd", arc4random() % 100];
    return list;
}

@end


#import "SJWordList.h"

@implementation SJListManageViewController (UITableViewDelegateMethods)

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    SJWordsListViewController *vc = [SJWordsListViewController new];
    vc.title = [(SJWordList *)[cell valueForKey:@"list"] title];
    [self.navigationController pushViewController:vc animated:YES];
}

@end

@implementation SJListManageViewController (UITableViewDataSourceMethods)

// MARK: Table View Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.lists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SJListManageTableCellID];
    [cell setValue:self.lists[indexPath.row] forKey:@"list"];
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
