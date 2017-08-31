//
//  SJWordInfoView.h
//  ReciteWords
//
//  Created by BlueDancer on 2017/7/31.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import "SJBaseView.h"

@class SJWordInfo;

@interface SJWordInfoView : SJBaseView

@property (nonatomic, strong, readwrite) SJWordInfo *wordInfo;

@end



@interface SJWordInfoView (Tips)

/*!
 *  default is NO.
 */
@property (nonatomic, assign) BOOL enableTipsView;

@end
