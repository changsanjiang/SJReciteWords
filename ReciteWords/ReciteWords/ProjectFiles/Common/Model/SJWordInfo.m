//
//  SJWordInfo.m
//  ReciteWords
//
//  Created by BlueDancer on 2017/7/31.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import "SJWordInfo.h"

#import "SJWordPronunciations.h"

#import "NSString+Extension.h"

#import "NSObject+Extension.h"

@implementation SJWordInfo

+ (NSString *)primaryKey {
    return @"object_id";
}

+ (NSDictionary<NSString *,NSString *> *)correspondingKeys {
    return @{@"pronunciations":@"psId"};
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {

}

+ (instancetype)wordInfoWithDictionary:(NSDictionary *)dict {
    SJWordInfo *info = [SJWordInfo new];
    NSMutableDictionary *dictM = dict.mutableCopy;
    NSDictionary *value = dictM[@"pronunciations"];
    SJWordPronunciations *ps = [SJWordPronunciations pronunciationsWithUk:value[@"uk"] us:value[@"us"]];
    dictM[@"pronunciations"] = ps;
    [info setValuesForKeysWithDictionary:dictM];
    return info;
}

- (NSString *)description {
    return [NSString stringWithFormat:@" {\n\t object_id:%zd,\n\t definition:%@,\n\t content:%@,\n\t pronunciation:%@,\n\t us_audio:%@,\n\t}", self.object_id, self.definition, self.content, self.pronunciations.us, self.us_audio];
}

- (CGFloat)height {
    if ( 0 != _height ) return _height;
    // top
    CGFloat margin = ceil(20 * SJ_Rate);
    _height += margin;
    
    // content
    _height += [_content csj_textSizeWithMaxWidth:SJ_W fontSize:30].height;
    
    _height += margin * 2; // us and  uk
    
    // us and  uk
    _height += [_pronunciations.us csj_textSizeWithMaxWidth:SJ_W fontSize:12].height * 2;
    
    _height += margin;
    
    // definition
    _height += [_definition csj_textSizeWithMaxWidth:SJ_W fontSize:14].height;
    
    _height += margin;
    
    // playBtn
    _height += 14;
    
    _height += margin;
    
    return _height;
}

- (NSString *)tips {
    if ( _tips ) return _tips;
    return @"未编辑";
}

- (CGFloat)tipsHeight {
    if ( 0 == _tips.length ) return 1;
    if ( 0 != _tipsHeight ) return _tipsHeight;
    
    CGFloat margin = ceil(20 * SJ_Rate);
    _tipsHeight += margin;

    // headerLabel
    _tipsHeight += sjFontH(14);
    
    // margin
    _tipsHeight += 8;
    
    // textView
    _tipsHeight += [_tips csj_textSizeWithMaxWidth:SJ_W * 0.5 fontSize:12].height;
    
    _tipsHeight += margin;
    return _tipsHeight;
}

@end
