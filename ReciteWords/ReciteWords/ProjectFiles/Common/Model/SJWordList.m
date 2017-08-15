//
//  SJWordList.m
//  ReciteWords
//
//  Created by BlueDancer on 2017/8/14.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import "SJWordList.h"

#import "SJWordInfo.h"

@implementation SJWordList

+ (NSString *)autoincrementPrimaryKey {
    return @"listId";
}

+ (NSDictionary<NSString *,Class> *)arrayCorrespondingKeys {
    return @{@"words":[SJWordInfo class]};
}

+ (instancetype)listWithTitle:(NSString *)title {
    SJWordList *list = [self new];
    list.title = title;
    return list;
}


- (NSMutableArray<SJWordInfo *> *)words {
    if ( _words ) return _words;
    _words = [NSMutableArray new];
    return _words;
}
@end
