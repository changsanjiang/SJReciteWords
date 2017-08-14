//
//  SJRecitrWordCollectionViewCell.h
//  ReciteWords
//
//  Created by summer的Dad on 2017/8/13.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SJWordInfo;
@protocol SJReciteWordCollectionViewCellDalegate;
@interface SJReciteWordCollectionViewCell : UICollectionViewCell
//dalegate
@property (nonatomic,weak)id<SJReciteWordCollectionViewCellDalegate>   dalegate;

@property (nonatomic,strong)SJWordInfo*                 model;
@end

@protocol SJReciteWordCollectionViewCellDalegate <NSObject>

/**
 点击播放按钮

 @param reciteWordCollectionViewCell self
 @param clickRecite 点击按钮
 */
- (void)reciteWordCollectionViewCell:(SJReciteWordCollectionViewCell*)reciteWordCollectionViewCell clickReciteBtn:(UIButton*)clickRecite;

@end
