//
//  SJAddWordToListViewController.m
//  ReciteWords
//
//  Created by BlueDancer on 2017/8/15.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import "SJAddWordToListViewController.h"

#import "SJBaseTableView.h"

#import "SJListManageTableCell.h"

#import "SJWordList.h"

#import <SJBorderlineView.h>

static CellID const SJListManageTableCellID = @"SJListManageTableCell";



@interface SJAddWordToListViewController (UITableViewDelegateMethods)<UITableViewDelegate> @end
@interface SJAddWordToListViewController (UITableViewDataSourceMethods)<UITableViewDataSource> @end


@interface SJAddWordToListViewController ()

@property (nonatomic, strong, readonly) UIButton *createListBtn;
@property (nonatomic, strong, readonly) SJBaseTableView *tableView;
@property (nonatomic, strong, readwrite) NSMutableArray<SJWordList *> *listsM;

@end

@implementation SJAddWordToListViewController

@synthesize createListBtn = _createListBtn;
@synthesize tableView = _tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _SJAddWordToListViewControllerSetupUI];
    
    [self _SJAddWordToListViewControllerGetLocalLists];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIView animateWithDuration:0.25 animations:^{
        _createListBtn.csj_y = _createListBtn.csj_y - _createListBtn.csj_h;
        _tableView.alpha = 1;
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIView animateWithDuration:0.25 animations:^{
        _tableView.alpha = 0.001;
        _tableView.transform = CGAffineTransformMakeScale(1.2, 1.2);
        _createListBtn.csj_y = SJ_H;
    }];
}

- (void)_SJAddWordToListViewControllerGetLocalLists {
    __weak typeof(self) _self = self;
    [LocalManager queryLocalLists:^(NSArray<SJWordList *> * _Nullable lists) {
        __strong typeof(_self) self = _self;
        if ( !self ) return;
        self.listsM = lists.mutableCopy;
        
        [self updateTableViewHeight];
        
        [self.tableView reloadData];
    }];
}

- (void)updateTableViewHeight {
    CGFloat height = self.listsM.count * 44 * SJ_Rate;
    height += 44 * SJ_Rate;
    if ( height < SJ_H * 0.48) {
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(height);
        }];
        [UIView animateWithDuration:0.25 animations:^{
            [self.tableView layoutIfNeeded];
        }];
    }
}

// MARK: Actions

- (void)clickedBtn:(UIButton *)btn {
    NSLog(@"clicked Btn");
    __weak typeof(self) _self = self;
    [LocalManager createListAtController:self callBlock:^(SJWordList * _Nullable list, NSError * _Nullable error) {
        __strong typeof(_self) self = _self;
        if ( !self ) return;
        if ( nil == list ) { [SJPrompt showErrorTitle:error.userInfo[@"error"]]; return; }
        [SJPrompt showSuccessTitle:@"创建成功"];
        [self.listsM addObject:list];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.listsM.count - 1 inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self updateTableViewHeight];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        });
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:YES completion:nil];
}


// MARK: UI

- (void)_SJAddWordToListViewControllerSetupUI {
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.createListBtn];
    
    self.tableView.layer.cornerRadius = 4;
    self.tableView.clipsToBounds = YES;
    
    _tableView.backgroundColor = SJ_Theme_C;
    
    CGFloat margin = ceil(60 * SJ_Rate);
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.offset(margin);
        make.trailing.offset(-margin);
        make.center.offset(0);
        make.height.offset(SJ_H * 0.48);
    }];
    _createListBtn.frame = CGRectMake(0, SJ_H, SJ_W, 44);
}

- (UIButton *)createListBtn {
    if ( _createListBtn ) return _createListBtn;
    _createListBtn = [UIButton buttonWithTitle:@"新建词单" titleColor:[UIColor blackColor] backgroundColor:SJ_Theme_C tag:0 target:self sel:@selector(clickedBtn:) fontSize:14];
    return _createListBtn;
}

- (SJBaseTableView *)tableView {
    if ( _tableView ) return _tableView;
    _tableView = [SJBaseTableView new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 44 * SJ_Rate;
    [_tableView registerClass:NSClassFromString(SJListManageTableCellID) forCellReuseIdentifier:SJListManageTableCellID];
    _tableView.sectionHeaderHeight = 44 * SJ_Rate;
    _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(44 * SJ_Rate, 0, 0, 0);
    return _tableView;
}

@end




@implementation SJAddWordToListViewController (UITableViewDelegateMethods)

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SJListManageTableCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ( _selectedListCallBlock ) _selectedListCallBlock(cell.list);
}

@end

@implementation SJAddWordToListViewController (UITableViewDataSourceMethods)

// MARK: Table View Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _listsM.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SJListManageTableCell *cell = [tableView dequeueReusableCellWithIdentifier:SJListManageTableCellID];
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.textLabel.textColor = SJ_Font_C;
    cell.list = _listsM[indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *headerLabel = [UILabel labelWithFontSize:16 textColor:[UIColor blackColor] alignment:NSTextAlignmentCenter];
    headerLabel.text = @"添加到词单";
    headerLabel.backgroundColor = SJ_Theme_C;
    return headerLabel;
}

@end
