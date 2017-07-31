//
//  SJReciteWordsViewController.m
//  ReciteWords
//
//  Created by BlueDancer on 2017/7/31.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import "SJReciteWordsViewController.h"
#import "SJWordInfo.h"

static CellID const SJReciteWordsCollectionViewCellID = @"SJReciteWordsCollectionViewCell";


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
}

- (UICollectionView *)collectionView {
    if ( _collectionView ) return _collectionView;
    _collectionView = [UICollectionView collectionViewWithItemSize:CGSizeMake(SJ_W, SJ_H) backgroundColor:[UIColor whiteColor] scrollDirection:UICollectionViewScrollDirectionVertical];
    [_collectionView registerClass:NSClassFromString(SJReciteWordsCollectionViewCellID) forCellWithReuseIdentifier:SJReciteWordsCollectionViewCellID];
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
    return self.words.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SJReciteWordsCollectionViewCellID forIndexPath:indexPath];
    [cell setValue:self.words[indexPath.row] forKey:@"wordInfo"];
    return cell;
}

@end
