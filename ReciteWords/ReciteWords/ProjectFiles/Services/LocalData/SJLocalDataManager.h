//
//  SJLocalDataManager.h
//  ReciteWords
//
//  Created by BlueDancer on 2017/8/1.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import <Foundation/Foundation.h>


#define LocalManager    [SJLocalDataManager sharedManager]


NS_ASSUME_NONNULL_BEGIN


@class SJWordList, SJWordInfo;

@interface SJLocalDataManager : NSObject

+ (instancetype)sharedManager;

@end






@interface SJLocalDataManager (Factotum)

- (void)createListAtController:(UIViewController *)vc callBlock:(void(^)(SJWordList * __nullable list, NSString *errorStr))block;

- (BOOL)existsAtList:(SJWordList *)list word:(SJWordInfo *)word;

@end



@interface SJLocalDataManager (InsertOrUpdate)

/*!
 *  创建一个词单
 */
- (void)createListWithTitle:(NSString *)Title callBlock:(void(^ __nullable)(SJWordList * __nullable list))block;

/*!
 *  添加单词到词单
 */
- (void)addedWordsToList:(SJWordList *)list words:(NSArray<SJWordInfo *> *)words callBlock:(void(^ __nullable)(BOOL result))block;

/*!
 *  更新单词
 */
- (void)updatedWord:(SJWordInfo *)word property:(NSArray<NSString *> *)property callBlock:(void(^ __nullable)(BOOL result))block;

/*!
 *  更新词单
 */
- (void)updatedList:(SJWordList *)list property:(NSArray<NSString *> *)property callBlock:(void(^ __nullable)(BOOL result))block;

@end



@interface SJLocalDataManager (Delete)

/*!
 *  从词单删除单词
 */
- (void)removedWordFromList:(SJWordList *)list word:(SJWordInfo *)word callBlock:(void (^ __nullable)(BOOL))block;

/*!
 *  删除一个词单
 */
- (void)removeList:(SJWordList *)list callBlock:(void(^ __nullable)(BOOL result))block;

@end



@interface SJLocalDataManager (Query)

/*!
 *  获取所有词单
 */
- (void)queryLocalLists:(void(^)(NSArray<SJWordList *> * __nullable lists))block;

/*!
 *  获取所有单词
 */
- (void)queryAllWords:(void(^)(NSArray<SJWordInfo *> * __nullable words))block;

@end



@interface SJLocalDataManager (SearchList)

- (void)getSearchHistory:(void(^)(SJWordList *searchList))block;

- (void)searchListAddWord:(SJWordInfo *)word callBlock:(void(^ __nullable)(BOOL result))block;

@end


NS_ASSUME_NONNULL_END
