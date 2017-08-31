//
//  SJReciteWordsCollectionCell.m
//  ReciteWords
//
//  Created by BlueDancer on 2017/8/17.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import "SJReciteWordsCollectionCell.h"

#import "SJWordInfoView.h"

#import "SJWordList.h"

#import "SJWordInfo.h"

@interface SJReciteWordsCollectionCell ()

@property (nonatomic, strong, readonly) SJWordInfoView *wordInfoView;

@end

@implementation SJReciteWordsCollectionCell

@synthesize wordInfoView = _wordInfoView;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if ( !self ) return nil;
    [self _SJReciteWordsCollectionCellSetupUI];
    return self;
}

// MARK: UI

- (void)_SJReciteWordsCollectionCellSetupUI {
    
}

- (SJWordInfoView *)wordInfoView {
    if ( _wordInfoView ) return _wordInfoView;
    _wordInfoView = [SJWordInfoView new];
    return _wordInfoView;
}

@end
