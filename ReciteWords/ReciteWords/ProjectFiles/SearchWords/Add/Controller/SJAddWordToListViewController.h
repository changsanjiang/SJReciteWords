//
//  SJAddWordToListViewController.h
//  ReciteWords
//
//  Created by BlueDancer on 2017/8/15.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import "SJBaseViewController.h"

@interface SJAddWordToListViewController : SJBaseViewController

@property (nonatomic, copy) void(^selectedListCallBlock)(SJWordList *list);

@end
