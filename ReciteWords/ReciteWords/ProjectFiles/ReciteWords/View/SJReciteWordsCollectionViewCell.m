//
//  SJReciteWordsCollectionViewCell.m
//  ReciteWords
//
//  Created by BlueDancer on 2017/8/1.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import "SJReciteWordsCollectionViewCell.h"
#import "SJWordInfoView.h"

@interface SJReciteWordsCollectionViewCell ()

@property (nonatomic, strong, readonly) SJWordInfoView *wordInfoView;

@end

@implementation SJReciteWordsCollectionViewCell

@synthesize wordInfoView = _wordInfoView;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if ( !self ) return nil;
    [self _SJReciteWordsCollectionViewCellSetupUI];
    return self;
}

// MARK: Setter

- (void)setWordInfo:(SJWordInfo *)wordInfo {
    _wordInfo = wordInfo;
    _wordInfoView.wordInfo = wordInfo;
}

// MARK: UI

- (void)_SJReciteWordsCollectionViewCellSetupUI {
    [self addSubview:self.wordInfoView];
    [self.wordInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(4, 2, 4, 2));
    }];
}

- (SJWordInfoView *)wordInfoView {
    if ( _wordInfoView ) return _wordInfoView;
    _wordInfoView = [SJWordInfoView new];
    return _wordInfoView;
}
@end
