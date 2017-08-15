//
//  SJLocalDataManager.m
//  ReciteWords
//
//  Created by BlueDancer on 2017/8/1.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import "SJLocalDataManager.h"

#import "SJWordInfo.h"

#import "SJWordList.h"

#import <SJDBMap.h>

#import <objc/message.h>

typedef NSString * SJWordListDefaultName;

static SJWordListDefaultName const SJSearchHistoryList = @"SJ_Search_History_List";


static inline void sjExeBoolBlock(void(^ targetBlock)(BOOL), BOOL parm) {
    if ( targetBlock ) targetBlock(parm);
}

static inline void sjExeObjBlock(void(^ targetBlock)(id obj), id obj) {
    if ( targetBlock ) targetBlock(obj);
}



@interface SJLocalDataManager ()

@end

@implementation SJLocalDataManager

+ (instancetype)sharedManager {
    static id _instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [self new];
    });
    return _instance;
}

- (instancetype)init {
    self = [super init];
    if ( !self ) return nil;
    return self;
}

@end






@interface SJLocalDataManager (Factotum)


- (BOOL)havaAWordWithList:(SJWordList *)list word:(SJWordInfo *)word;

@end


@implementation SJLocalDataManager (Factotum)

- (BOOL)havaAWordWithList:(SJWordList *)list word:(SJWordInfo *)word {
    __block BOOL exists = NO;
    [list.words enumerateObjectsUsingBlock:^(SJWordInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ( obj.object_id != word.object_id ) return;
        exists = YES;
        *stop = YES;
    }];
    return exists;
}

@end










@implementation SJLocalDataManager (InsertOrUpdate)

/*!
 *  创建一个词单
 */
- (void)createListWithTitle:(NSString *)Title callBlock:(void(^)(SJWordList *list))block {
    SJWordList *list = [SJWordList listWithTitle:Title];
    [[SJDatabaseMap sharedServer] insertOrUpdateDataWithModel:list callBlock:^(BOOL result) {
        sjExeObjBlock(block, result ? list : nil);
    }];
}

/*!
 *  添加单词到词单
 */
- (void)addedWordsToList:(SJWordList *)list words:(NSArray<SJWordInfo *> *)words callBlock:(void(^)(BOOL result))block {
    [[SJDatabaseMap sharedServer] update:list insertedOrUpdatedValues:@{@"words":words} callBlock:^(BOOL r) {
        sjExeBoolBlock(block, r);
    }];
}

/*!
 *  更新单词
 */
- (void)updatedWord:(SJWordInfo *)word property:(NSArray<NSString *> *)property callBlock:(void(^)(BOOL result))block {
    [[SJDatabaseMap sharedServer] update:word property:property callBlock:^(BOOL result) {
        sjExeBoolBlock(block, result);
    }];
}

/*!
 *  更新词单
 */
- (void)updateList:(SJWordList *)list property:(NSArray<NSString *> *)property callBlock:(void(^)(BOOL result))block {
    [[SJDatabaseMap sharedServer] update:list property:property callBlock:^(BOOL result) {
        sjExeBoolBlock(block, result);
    }];
}

@end



@implementation SJLocalDataManager (Delete)

/*!
 *  从词单删除单词
 */
- (void)removeWordsFromList:(SJWordList *)list words:(NSArray<SJWordInfo *> *)words callBlock:(void(^)(BOOL result))block {
    [[SJDatabaseMap sharedServer] deleteDataWithModels:@[list] callBlock:^(BOOL result) {
        sjExeBoolBlock(block, result);
    }];
}

@end



@implementation SJLocalDataManager (Query)

/*!
 *  获取所有词单
 */
- (void)queryLocalLists:(void(^)(NSArray<SJWordList *> *lists))block {
    
}

@end




@implementation SJLocalDataManager (SearchList)

- (void)getSearchHistory:(void(^)(SJWordList *searchList))block {
    SJWordList *list = self.searchWordList;
    if ( list )
        sjExeObjBlock(block, list);
    else
        [self _SJGetStorageSearchHistoryList:^(SJWordList *list) {
            self.searchWordList = list;
            sjExeObjBlock(block, list);
        }];
}

- (void)searchListAddWord:(SJWordInfo *)word callBlock:(void(^)(BOOL result))block {
    if ( nil == word ) { sjExeBoolBlock(block, NO); return; }
    if ( self.searchWordList )
        [self _sjAddWord:word callBlock:block];
    else
        [self _SJGetStorageSearchHistoryList:^(SJWordList *list) {
            if ( nil == list ) { sjExeBoolBlock(block, NO); return ; }
            self.searchWordList = list;
            [self _sjAddWord:word callBlock:block];
        }];
}

- (void)_sjAddWord:(SJWordInfo *)word callBlock:(void(^)(BOOL result))block {
    [self.searchWordList.words insertObject:word atIndex:0];
    [self addedWordsToList:self.searchWordList words:@[word] callBlock:^(BOOL result) {
        if ( !result ) { [self.searchWordList.words removeObjectAtIndex:0]; }
        sjExeBoolBlock(block, result);
    }];
}

- (void)_SJGetStorageSearchHistoryList:(void(^)(SJWordList * list))block {
    [[SJDatabaseMap sharedServer] queryDataWithClass:[SJWordList class] queryDict:@{@"title":SJSearchHistoryList} completeCallBlock:^(NSArray<id<SJDBMapUseProtocol>> * _Nullable data) {
        if ( 0 != data.count ) {
            sjExeObjBlock(block, data.firstObject);
        }
        else {
            SJWordList *historyList = [SJWordList listWithTitle:SJSearchHistoryList];
            [[SJDatabaseMap sharedServer] insertOrUpdateDataWithModel:historyList callBlock:^(BOOL result) {
                sjExeObjBlock(block, result ? historyList : nil);
            }];
        }
    }];
}

- (void)setSearchWordList:(SJWordList *)searchWordList {
    objc_setAssociatedObject(self, @selector(searchWordList), searchWordList, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (SJWordList *)searchWordList {
    return objc_getAssociatedObject(self, _cmd);
}
@end
