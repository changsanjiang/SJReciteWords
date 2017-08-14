//
//  SJReciteWordsViewController.m
//  ReciteWords
//
//  Created by BlueDancer on 2017/7/31.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import "SJReciteWordsViewController.h"
#import "SJWordInfo.h"
#import "SJReciteWordCollectionViewCell.h"
static CellID const SJReciteWordCollectionViewCellID = @"SJReciteWordCollectionViewCell";


@interface SJReciteWordsViewController (UICollectionViewDelegateMethods)<UICollectionViewDelegate>
@end

@interface SJReciteWordsViewController (UICollectionViewDataSourceMethods)<UICollectionViewDataSource>
@end


@interface SJReciteWordsViewController ()

@property (nonatomic, strong, readonly) UICollectionView *collectionView;
@property (nonatomic, strong, readonly) NSMutableArray<SJWordInfo *> *words;

@end

@implementation SJReciteWordsViewController

@synthesize collectionView = _collectionView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

// MARK: UI

- (void)setupUI {
    [super setupUI];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}

- (UICollectionView *)collectionView {
    if ( _collectionView ) return _collectionView;

    _collectionView = [UICollectionView collectionViewWithItemSize:CGSizeMake(SJ_W, SJ_H - SJ_Nav_H - SJ_Tab_H) backgroundColor:[UIColor whiteColor] scrollDirection:UICollectionViewScrollDirectionHorizontal];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.bounces = NO;
    _collectionView.pagingEnabled = YES;
    [_collectionView registerClass:[SJReciteWordCollectionViewCell class] forCellWithReuseIdentifier:SJReciteWordCollectionViewCellID];
    return _collectionView;
}
@end


@implementation SJReciteWordsViewController (UICollectionViewDelegateMethods)

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"clicked item");
}

@end

@implementation SJReciteWordsViewController (UICollectionViewDataSourceMethods)

// MARK: UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SJReciteWordCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:SJReciteWordCollectionViewCellID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:1.0 * (arc4random() % 256 / 255.0)
                                           green:1.0 * (arc4random() % 256 / 255.0)
                                            blue:1.0 * (arc4random() % 256 / 255.0)
                                           alpha:1];
    return cell;
    
}

@end
