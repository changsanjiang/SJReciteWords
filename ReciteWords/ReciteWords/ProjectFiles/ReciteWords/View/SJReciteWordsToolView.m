//
//  SJReciteWordsToolView.m
//  ReciteWords
//
//  Created by BlueDancer on 2017/9/1.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import "SJReciteWordsToolView.h"

#import "UIView+Extension.h"


static CellID UICollectionViewCellID = @"UICollectionViewCell";

@interface SJReciteWordsToolView (UICollectionViewDelegateMethods)<UICollectionViewDelegate>
@end

@interface SJReciteWordsToolView (UICollectionViewDataSourceMethods)<UICollectionViewDataSource>
@end



@interface SJReciteWordsToolView ()

@property (nonatomic, strong, readonly) UICollectionView *collectionView;
@property (nonatomic, strong, readwrite) NSArray<NSString *> *itemImageNames;

@end

@implementation SJReciteWordsToolView

@synthesize collectionView = _collectionView;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if ( !self ) return nil;
    [self _SJReciteWordsToolViewSetupUI];
    return self;
}

// MARK: UI

- (void)_SJReciteWordsToolViewSetupUI {
    self.itemImageNames = @[@"sj_word_list", @"sj_list_list"];
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
}

- (UICollectionView *)collectionView {
    if ( _collectionView ) return _collectionView;
    _collectionView = [UICollectionView collectionViewWithItemSize:CGSizeMake(SJ_W / self.itemImageNames.count, 44) backgroundColor:[UIColor clearColor] scrollDirection:UICollectionViewScrollDirectionHorizontal];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:NSClassFromString(UICollectionViewCellID) forCellWithReuseIdentifier:UICollectionViewCellID];
    return _collectionView;
}

@end



@implementation SJReciteWordsToolView (UICollectionViewDelegateMethods)

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end

@implementation SJReciteWordsToolView (UICollectionViewDataSourceMethods)

// MARK: UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.itemImageNames.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:UICollectionViewCellID forIndexPath:indexPath];
    UIImageView *imageView = cell.contentView.subviews.lastObject;
    if ( nil == imageView ) {
        imageView = [UIImageView imageViewWithImageStr:self.itemImageNames[indexPath.row] viewMode:UIViewContentModeScaleAspectFit];
        [cell.contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.offset(0);
        }];
        return cell;
    }
    imageView.image = [UIImage imageNamed:self.itemImageNames[indexPath.row]];
    return cell;
}

@end
