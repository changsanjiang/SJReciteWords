//
//  SJReciteWordsCollectionCell.h
//  ReciteWords
//
//  Created by BlueDancer on 2017/8/17.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import "SJBaseCollectionViewCell.h"

@class SJWordInfo;

@interface SJReciteWordsCollectionCell : SJBaseCollectionViewCell

@property (nonatomic, strong, readwrite) SJWordInfo *wordInfo;

@end
