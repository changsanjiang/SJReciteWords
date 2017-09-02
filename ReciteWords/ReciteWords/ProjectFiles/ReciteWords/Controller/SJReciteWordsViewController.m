//
//  SJReciteWordsViewController.m
//  ReciteWords
//
//  Created by BlueDancer on 2017/7/31.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import "SJReciteWordsViewController.h"

#import "SJWordInfo.h"

#import "SJWordList.h"

#import "SJBaseTableView.h"

#import "SJListManageTableCell.h"

#import "SJReciteWordsCollectionCell.h"

#import "SJReciteWordsToolView.h"

static CellID const SJListManageTableCellID = @"SJListManageTableCell";
static CellID const SJReciteWordsCollectionCellID = @"SJReciteWordsCollectionCell";

@interface SJReciteWordsViewController (UITableViewDelegateMethods)<UITableViewDelegate> @end
@interface SJReciteWordsViewController (UITableViewDataSourceMethods)<UITableViewDataSource> @end

@interface SJReciteWordsViewController (UICollectionViewDelegateMethods)<UICollectionViewDelegate> @end

@interface SJReciteWordsViewController (UICollectionViewDataSourceMethods)<UICollectionViewDataSource> @end



@interface SJReciteWordsViewController ()

// use it to display lists.
@property (nonatomic, strong, readonly) SJBaseTableView *tableView;
@property (nonatomic, strong, readwrite) NSArray<SJWordList *> *lists;


// use it to display words.
@property (nonatomic, strong, readonly) UICollectionView *collectionView;
@property (nonatomic, strong, readwrite) SJWordList *selectedList;

@property (nonatomic, strong, readonly) SJReciteWordsToolView *toolView;

@end

@implementation SJReciteWordsViewController

@synthesize tableView = _tableView;
@synthesize collectionView = _collectionView;
@synthesize toolView = _toolView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _SJReciteWordsViewControllerSetupUI];
    
    [self _SJAddWordToListViewControllerGetLocalLists];
    
    // Do any additional setup after loading the view.
}

// MARK: Parameters

- (void)_SJAddWordToListViewControllerGetLocalLists {
    __weak typeof(self) _self = self;
    [LocalManager queryLocalLists:^(NSArray<SJWordList *> * _Nullable lists) {
        __strong typeof(_self) self = _self;
        if ( !self ) return;
        self.lists = lists;
        
        [self updateTableViewHeight];
        
        [self.tableView reloadData];
    }];
}

- (void)updateTableViewHeight {
    CGFloat height = self.lists.count * 44 * SJ_Rate;
    height += 44 * SJ_Rate;
    CGFloat maxH = floor(SJ_H * 0.48);
    if ( self.tableView.csj_h == maxH ) return;
    if ( height < maxH ) {
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(height);
        }];
    }
    else if ( self.tableView.csj_h != maxH ) {
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(maxH);
        }];
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}


// MARK: UI

- (void)_SJReciteWordsViewControllerSetupUI {
    
    [self.view addSubview:self.collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self.view addSubview:self.tableView];
    
    CGFloat margin = ceil(60 * SJ_Rate);
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.offset(margin);
        make.trailing.offset(-margin);
        make.center.offset(0);
        make.height.offset(SJ_H * 0.48);
    }];
    
    
    [self.view addSubview:self.toolView];
    [_toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.offset(0);
        make.bottom.offset(-20);
        make.height.offset(44);
    }];
    
    _toolView.alpha = 0.001;
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
    _tableView.layer.cornerRadius = 4;
    _tableView.clipsToBounds = YES;
    _tableView.backgroundColor = SJ_Theme_C;
    return _tableView;
}

- (UICollectionView *)collectionView {
    if ( _collectionView ) return _collectionView;
    _collectionView = [UICollectionView collectionViewWithItemSize:CGSizeMake(SJ_W, SJ_H - SJ_Nav_H - SJ_Tab_H) backgroundColor:SJ_Theme_C scrollDirection:UICollectionViewScrollDirectionHorizontal];
    _collectionView.dataSource = self;
    [_collectionView registerClass:NSClassFromString(SJReciteWordsCollectionCellID) forCellWithReuseIdentifier:SJReciteWordsCollectionCellID];
    _collectionView.pagingEnabled = YES;
    return _collectionView;
}

- (SJReciteWordsToolView *)toolView {
    if ( _toolView ) return _toolView;
    _toolView = [SJReciteWordsToolView new];
    return _toolView;
}
@end



@implementation SJReciteWordsViewController (UITableViewDelegateMethods)

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SJListManageTableCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ( 0 == cell.list.words.count ) {
        [SJPrompt showErrorTitle:@"词单没有单词"];
        return;
    }
    [cell scaleAnimation];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5 animations:^{
            tableView.alpha = 0.001;
            tableView.transform = CGAffineTransformMakeScale(1.2, 1.2);
            self.view.backgroundColor = SJ_Theme_C;
            self.toolView.alpha = 1;
        } completion:^(BOOL finished) {
            [tableView removeFromSuperview];
            self.selectedList = cell.list;
            [self.collectionView reloadData];
        }];
    });
}

@end

@implementation SJReciteWordsViewController (UITableViewDataSourceMethods)

// MARK: Table View Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _lists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SJListManageTableCell *cell = [tableView dequeueReusableCellWithIdentifier:SJListManageTableCellID];
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.textLabel.textColor = SJ_Font_C;
    cell.list = _lists[indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *headerLabel = [UILabel labelWithFontSize:16 textColor:[UIColor blackColor] alignment:NSTextAlignmentCenter];
    headerLabel.text = @"选择一个词单";
    headerLabel.backgroundColor = SJ_Theme_C;
    return headerLabel;
}

@end


@implementation SJReciteWordsViewController (UICollectionViewDelegateMethods)

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end

@implementation SJReciteWordsViewController (UICollectionViewDataSourceMethods)

// MARK: UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.selectedList.words.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SJReciteWordsCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SJReciteWordsCollectionCellID forIndexPath:indexPath];
    cell.wordInfo = self.selectedList.words[indexPath.row];
    return cell;
}

@end
