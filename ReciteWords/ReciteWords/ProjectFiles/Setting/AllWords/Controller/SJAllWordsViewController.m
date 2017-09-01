//
//  SJAllWordsViewController.m
//  ReciteWords
//
//  Created by BlueDancer on 2017/8/16.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import "SJAllWordsViewController.h"

#import "SJWordInfo.h"

#import "SJBaseTableView.h"

#import "SJWordList.h"

@interface SJAllWordsViewController ()

@end

@implementation SJAllWordsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _SJAllWordsViewControllerGetAllWords];
    
    // Do any additional setup after loading the view.
}

- (void)_SJAllWordsViewControllerGetAllWords {
    [SJPrompt show];
    __weak typeof(self) _self = self;
    [LocalManager queryAllWords:^(NSArray<SJWordInfo *> * _Nullable words) {
        [SJPrompt dismiss];
        __strong typeof(_self) self = _self;
        if ( !self ) return;
        SJWordList *list = [SJWordList listWithTitle:@"全部单词"];
        list.words = words.mutableCopy;
        self.list = list;
        [self.tableView reloadData];
    }];
}

// MARK: Tableview Edit

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

@end
