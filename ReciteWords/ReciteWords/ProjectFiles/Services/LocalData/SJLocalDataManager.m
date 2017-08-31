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


NSErrorDomain const SJNotifyUserErrorDomain = @"SJNotifyUserErrorDomain";

NSErrorDomain const SJWaringErrorDomain = @"SJWaringErrorDomain";


typedef NSString * SJWordListDefaultName;


static SJWordListDefaultName const SJSearchHistoryList = @"搜索历史";


static inline void sjExeBoolBlock(void(^ targetBlock)(BOOL r, NSError *error), BOOL parm, NSError *error) {
    if ( targetBlock ) targetBlock(parm, error);
}

static inline void sjExeObjBlock(void(^ targetBlock)(id obj, NSError *error), id obj, NSError *error) {
    if ( targetBlock ) targetBlock(obj, error);
}

static inline void sjExeSingleObjBlock(void(^ targetBlock)(id obj), id obj) {
    if ( targetBlock ) targetBlock(obj);
}

@interface SJLocalDataManager ()

/*!
 *  if this value is Null, you should call getSearchList: method get it.
 *  warning: You can't create it.
 */
@property (nonatomic, strong, nullable) SJWordList *searchWordList;

@property (nonatomic, strong, readwrite) NSMutableArray<SJWordList *> *locLists;

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

- (NSError *)_sjNotifyUserError:(NSString * __nullable)errorStr {
    if ( 0 == errorStr.length ) return nil;
    return [NSError errorWithDomain:SJNotifyUserErrorDomain code:0 userInfo:@{@"error":errorStr}];
}

- (NSError *)_sjWarningError:(NSString *__nullable)errorStr {
    if ( 0 == errorStr.length ) return nil;
    return [NSError errorWithDomain:SJWaringErrorDomain code:0 userInfo:@{@"error":errorStr}];
}

@end



#import "UIViewController+Extension.h"


@implementation SJLocalDataManager (Factotum)

- (void)createListAtController:(UIViewController *)vc callBlock:(void (^)(SJWordList * _Nullable, NSError *error))block {
    [vc alertWithTitle:@"创建一个词单" textFieldPlaceholder:@"请输入新的词单名.." action:^(NSString * _Nonnull inputText) {
        
        __block BOOL insertBol = YES;
        [self.locLists enumerateObjectsUsingBlock:^(SJWordList * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ( ![obj.title isEqualToString:inputText] ) return ;
            insertBol = NO;
            *stop = YES;
        }];
        
        if ( !insertBol ) { sjExeObjBlock(block, nil, [self _sjNotifyUserError:@"词单已存在, 请勿重复创建."]); return;}
        
        [LocalManager createListWithTitle:inputText callBlock:^(SJWordList * _Nullable list, NSError * _Nullable error) {
            sjExeObjBlock(block, list, error);
        }];
    }];
}

- (BOOL)existsAtList:(SJWordList *)list word:(SJWordInfo *)word {
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
- (void)createListWithTitle:(NSString *)Title callBlock:(void (^ _Nullable)(SJWordList * _Nullable, NSError * _Nullable))block {
    SJWordList *list = [SJWordList listWithTitle:Title];
    [[SJDatabaseMap sharedServer] insertOrUpdateDataWithModel:list callBlock:^(BOOL result) {
        NSError *error = nil;
        if ( result && self.locLists )
            [self.locLists addObject:list];
        else
            error = [self _sjNotifyUserError:@"词单创建失败."];
        sjExeObjBlock(block, result ? list : nil, error);
    }];
}

/*!
 *  添加单词到词单
 */
- (void)addWordsToList:(SJWordList *)list word:(SJWordInfo *)word callBlock:(void (^ _Nullable)(BOOL, NSError * _Nullable))block {
    if ( 0 == word.content.length ) {
        sjExeBoolBlock(block, NO, [self _sjNotifyUserError:@"单词内容为空, 无法添加"]);
        return;
    }
    
    if ( [self existsAtList:list word:word] ) {
        sjExeBoolBlock(block, NO, [self _sjNotifyUserError:@"该单词已存在"]);
        return;
    }

    [list.words addObject:word];
    [[SJDatabaseMap sharedServer] update:list insertedOrUpdatedValues:@{@"words":@[word]} callBlock:^(BOOL r) {
        NSError *error = r ? nil : [self _sjNotifyUserError:@"添加失败"];
        if ( !r ) {[list.words removeLastObject];}
        sjExeBoolBlock(block, r, error);
    }];
}

/*!
 *  更新单词
 */
- (void)updatedWord:(SJWordInfo *)word property:(NSArray<NSString *> *)property callBlock:(void (^ _Nullable)(BOOL, NSError * _Nullable))block {
    [[SJDatabaseMap sharedServer] update:word property:property callBlock:^(BOOL result) {
        NSError *error = result ? nil : [self _sjNotifyUserError:@"更新失败"];
        sjExeBoolBlock(block, result, error);
    }];
}

/*!
 *  更新词单
 */
- (void)updatedList:(SJWordList *)list property:(NSArray<NSString *> *)property callBlock:(void (^ _Nullable)(BOOL, NSError * _Nullable))block {
    [[SJDatabaseMap sharedServer] update:list property:property callBlock:^(BOOL result) {
        NSError *error = result ? nil : [self _sjNotifyUserError:@"更新失败"];
        sjExeBoolBlock(block, result, error);
    }];
}

@end



@implementation SJLocalDataManager (Delete)

/*!
 *  从词单删除单词
 */
- (void)removedWordFromList:(SJWordList *)list word:(SJWordInfo *)word callBlock:(void (^ _Nullable)(BOOL, NSError * _Nullable))block {
    [[SJDatabaseMap sharedServer] updateTheDeletedValuesInTheModel:list callBlock:^(BOOL r) {
        NSError *error = r ? nil : [self _sjNotifyUserError:@"删除失败"];
        sjExeBoolBlock(block, r, error);
    }];
}

/*!
 *  删除一个词单
 */
- (void)removeList:(SJWordList *)list callBlock:(void (^ _Nullable)(BOOL, NSError * _Nullable))block {
    [[SJDatabaseMap sharedServer] deleteDataWithClass:[list class] primaryValue:list.listId callBlock:^(BOOL result) {
        if ( self.locLists ) {
            [self.locLists removeObject:list];
        }
        NSError *error = result ? nil : [self _sjNotifyUserError:@"删除失败"];
        sjExeBoolBlock(block, result, error);
    }];
}

@end



@implementation SJLocalDataManager (Query)

/*!
 *  获取所有词单
 */
- (void)queryLocalLists:(void(^)(NSArray<SJWordList *> *lists))block {
    if ( self.locLists ) { sjExeSingleObjBlock(block, self.locLists); return; }
    [[SJDatabaseMap sharedServer] queryAllDataWithClass:[SJWordList class] completeCallBlock:^(NSArray<id<SJDBMapUseProtocol>> * _Nullable data) {
        self.locLists = data.mutableCopy;
        [self.locLists removeObjectAtIndex:0];
        sjExeSingleObjBlock(block, self.locLists);
    }];
}

/*!
 *  获取所有单词
 */
- (void)queryAllWords:(void(^)(NSArray<SJWordInfo *> * __nullable words))block {
    [[SJDatabaseMap sharedServer] queryAllDataWithClass:[SJWordInfo class] completeCallBlock:^(NSArray<id<SJDBMapUseProtocol>> * _Nullable data) {
        sjExeSingleObjBlock(block, data);
    }];
}

@end




@implementation SJLocalDataManager (SearchList)

- (void)getSearchHistory:(void(^)(SJWordList *searchList))block {
    SJWordList *list = self.searchWordList;
    if ( list )
        sjExeSingleObjBlock(block, list);
    else
        [self _SJGetStorageSearchHistoryList:^(SJWordList *list) {
            self.searchWordList = list;
            sjExeSingleObjBlock(block, list);
        }];
}

- (void)searchListAddWord:(SJWordInfo *)word callBlock:(void (^ _Nullable)(BOOL, NSError * _Nullable))block {
    if ( 0 == word.content.length ) {
        sjExeBoolBlock(block, NO, [self _sjWarningError:@"空单词无法加入到搜索历史词单中."]);
        return;
    }

    if ( self.searchWordList )
        [self _sjAddWord:word callBlock:block];
    else
        [self _SJGetStorageSearchHistoryList:^(SJWordList *list) {
            if ( nil == list ) {
                sjExeBoolBlock(block, NO, [self _sjWarningError:@"数据库未查询到搜索历史词单."]);
                return;
            }
            self.searchWordList = list;
            [self _sjAddWord:word callBlock:block];
        }];
}

- (void)_sjAddWord:(SJWordInfo *)word callBlock:(void(^)(BOOL result, NSError * _Nullable))block {
    [self.searchWordList.words insertObject:word atIndex:0];
    [[SJDatabaseMap sharedServer] update:self.searchWordList insertedOrUpdatedValues:@{@"words":@[word]} callBlock:^(BOOL result) {
        NSError *error = result ? nil : [self _sjNotifyUserError:@"添加失败"];
        if ( !result ) [self.searchWordList.words removeObjectAtIndex:0];
        sjExeBoolBlock(block, result, error);
    }];
}

- (void)_SJGetStorageSearchHistoryList:(void(^)(SJWordList * list))block {
    [[SJDatabaseMap sharedServer] queryDataWithClass:[SJWordList class] queryDict:@{@"title":SJSearchHistoryList} completeCallBlock:^(NSArray<id<SJDBMapUseProtocol>> * _Nullable data) {
        if ( 0 != data.count ) {
            sjExeSingleObjBlock(block, data.firstObject);
        }
        else {
            SJWordList *historyList = [SJWordList listWithTitle:SJSearchHistoryList];
            [[SJDatabaseMap sharedServer] insertOrUpdateDataWithModel:historyList callBlock:^(BOOL result) {
                sjExeSingleObjBlock(block, result ? historyList : nil);
            }];
        }
    }];
}

@end
