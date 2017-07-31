//
//  SJWordInfoView.h
//  ReciteWords
//
//  Created by BlueDancer on 2017/7/31.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import "SJBaseView.h"

@class SJWordInfo;

@protocol SJWordInfoViewDelegate;

@interface SJWordInfoView : SJBaseView

@property (nonatomic, strong, readwrite) SJWordInfo *wordInfo;

@property (nonatomic, weak) id <SJWordInfoViewDelegate> delegate;

@end


@protocol SJWordInfoViewDelegate <NSObject>

- (void)clickedUKPlayBtnOnWordInfoView:(SJWordInfoView *)view;

- (void)clickedUSPlayBtnOnWordInfoView:(SJWordInfoView *)view;

@end
