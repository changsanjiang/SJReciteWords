//
//  SJSettingViewController.m
//  ReciteWords
//
//  Created by BlueDancer on 2017/8/13.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import "SJSettingViewController.h"

#import "UIView+Extension.h"

#import "SJSettingCollectionViewCell.h"

#import "SJListManageViewController.h"

#import "SJSettingOperation.h"

#import "SJAllWordsViewController.h"

static NSString * const SJSettingCollectionViewCellID = @"SJSettingCollectionViewCell";

static short const item_h = 90;

@interface SJSettingViewController (UICollectionViewDelegateMethods)<UICollectionViewDelegate>
@end

@interface SJSettingViewController (UICollectionViewDataSourceMethods)<UICollectionViewDataSource>
@end


@interface SJSettingViewController ()

@property (nonatomic, strong, readonly) UICollectionView *collectionView;
@property (nonatomic, strong, readonly) NSArray<SJSettingOperation *> *operations;

@end

@implementation SJSettingViewController

@synthesize collectionView = _collectionView;
@synthesize operations = _operations;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _SJSettingViewControllerSetupUI];
}

// MARK: UI

- (void)_SJSettingViewControllerSetupUI {
    [self.view addSubview:self.collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.offset(ceil(32 * SJ_Rate));
        make.width.offset(ceil(item_h * 2 * SJ_Rate));
        make.bottom.offset(0);
    }];
}

- (UICollectionView *)collectionView {
    if ( _collectionView ) return _collectionView;
    _collectionView = [UICollectionView collectionViewWithItemSize:CGSizeMake(floor(item_h * SJ_Rate), floor(item_h * SJ_Rate)) backgroundColor:SJ_Theme_C scrollDirection:UICollectionViewScrollDirectionVertical];
    [_collectionView registerClass:NSClassFromString(SJSettingCollectionViewCellID) forCellWithReuseIdentifier:SJSettingCollectionViewCellID];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    return _collectionView;
}

// MARK: Lazy

- (NSArray<SJSettingOperation *> *)operations {
    if ( _operations ) return _operations;
    __weak typeof(self) _self = self;
    _operations =
    @[
      [[SJSettingOperation alloc] initWithTitle:@"全部单词" imageName:@"sj_word_list" operation:^ {
          SJAllWordsViewController *vc = [SJAllWordsViewController new];
          [self.navigationController pushViewController:vc animated:YES];
      }],
      [[SJSettingOperation alloc] initWithTitle:@"词单" imageName:@"sj_list_list" operation:^ {
          __strong typeof(_self) self = _self;
          if ( !self ) return;
          SJListManageViewController *vc = [SJListManageViewController new];
          vc.title = @"词单";
          [self.navigationController pushViewController:vc animated:YES];
      }],
//      [[SJSettingOperation alloc] initWithTitle:@"最近添加的单词" operation:nil],
//      [[SJSettingOperation alloc] initWithTitle:@"最近添加的词单" operation:nil],
     ];
    
    return _operations;
}
@end


@implementation SJSettingViewController (UICollectionViewDelegateMethods)

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"clicked Item");
    SJSettingOperation *operation = [[collectionView cellForItemAtIndexPath:indexPath] valueForKey:@"operation"];
    if ( operation.operation ) operation.operation();
}

@end

@implementation SJSettingViewController (UICollectionViewDataSourceMethods)

// MARK: UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.operations.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SJSettingCollectionViewCellID forIndexPath:indexPath];
    [cell setValue:_operations[indexPath.row] forKey:@"operation"];
    return cell;
}

@end
