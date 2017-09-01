//
//  SJWordsListViewController.m
//  ReciteWords
//
//  Created by BlueDancer on 2017/8/13.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import "SJWordsListViewController.h"

#import "SJBaseTableView.h"

#import "SJWordList.h"

#import "SJWordInfo.h"

#import "UIViewController+Extension.h"


static CellID const SJWordsListTableCellID = @"SJWordsListTableCell";



@interface SJWordsListViewController (UITableViewDelegateMethods)<UITableViewDelegate> @end
@interface SJWordsListViewController (UITableViewDataSourceMethods)<UITableViewDataSource> @end



@interface SJWordsListViewController ()

@end

@implementation SJWordsListViewController

@synthesize tableView = _tableView;


// MARK: 生命周期

- (instancetype)initWithList:(SJWordList *)list {
    self = [super init];
    if ( !self ) return nil;
    self.list = list;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _SJWordsListViewControllerSetupUI];
}

// MARK: Setter

- (void)setList:(SJWordList *)list {
    _list = list;
    if ( _tableView ) [_tableView reloadData];
    self.title = list.title;
}


// MARK: UI

- (void)_SJWordsListViewControllerSetupUI {
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
    return _list.words.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SJWordsListTableCellID];
    [cell setValue:_list.words[indexPath.row] forKey:@"model"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SJWordInfo *word = _list.words[indexPath.row];
    return word.height + word.tipsHeight;
}

// MARK: Edit

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"delete" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        SJWordInfo *word = [cell valueForKey:@"model"];
        [self alertWithType:AlertType_DeleteAndCancel title:word.content msg:@"确定删除?" action:^{
            NSInteger index = [self.list.words indexOfObject:word];
            [self.list.words removeObjectAtIndex:index];
            [LocalManager removedWordFromList:self.list word:word callBlock:^(BOOL result, NSError * _Nullable error) {
                if ( !result ) {
                    [self.list.words insertObject:word atIndex:index];
                    [SJPrompt showErrorTitle:error.userInfo[@"error"]];
                }
                else
                    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }];
        }];
    }];
    if ( action ) return @[action];
    return nil;
}

@end
