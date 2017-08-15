//
//  NSString+Extension.m
//  CSJQQMusic
//
//  Created by ya on 12/19/16.
//  Copyright © 2016 ya. All rights reserved.
//

#import "NSString+Extension.h"
#import <CommonCrypto/CommonCrypto.h>


@implementation NSString (Extension)

- (char)charValue {
    return self.UTF8String[0] - '0';
}

// MARK: -  处理时间
+ (NSString *)csj_processTimeWithCreateDate:(NSString *)createDateStr nowDate:(NSString *)nowDateStr {
    
    double value = nowDateStr.longLongValue * 0.001 - createDateStr.longLongValue * 0.001;
    
    if ( value < 0 ) {
        return @"火星时间";
    }
    
    NSInteger year  = value / 31104000;
    NSInteger month = value / 2592000;
    NSInteger week  = value / 604800;
    NSInteger day   = value / 86400;
    NSInteger hour  = value / 3600;
    NSInteger min   = value / 60;
    
    if ( year > 0 ) {
        return [NSString stringWithFormat:@"%zd年前", year];
    }
    else if ( month > 0 ) {
        return [NSString stringWithFormat:@"%zd月前", month];
    }
    else if ( week > 0 ) {
        return [NSString stringWithFormat:@"%zd周前", week];
    }
    else if ( day > 0 ) {
        return [NSString stringWithFormat:@"%zd天前", day];
    }
    else if ( hour > 0 ) {
        return [NSString stringWithFormat:@"%zd小时前", hour];
    }
    else if ( min > 0 ) {
        return [NSString stringWithFormat:@"%zd分钟前", min];
    }
    else {
        return @"刚刚";
    }
    return @"";
}

+ (NSString *)csj_processTimeWithCreateDateI:(NSInteger)createDate nowDateI:(NSInteger)nowDate {
    double value = nowDate * 0.001 - createDate * 0.001;
    
    if ( value < 0 ) {
        return @"火星时间";
    }
    
    NSInteger year  = value / 31104000;
    NSInteger month = value / 2592000;
    NSInteger week  = value / 604800;
    NSInteger day   = value / 86400;
    NSInteger hour  = value / 3600;
    NSInteger min   = value / 60;
    
    if ( year > 0 ) {
        return [NSString stringWithFormat:@"%zd年前", year];
    }
    else if ( month > 0 ) {
        return [NSString stringWithFormat:@"%zd月前", month];
    }
    else if ( week > 0 ) {
        return [NSString stringWithFormat:@"%zd周前", week];
    }
    else if ( day > 0 ) {
        return [NSString stringWithFormat:@"%zd天前", day];
    }
    else if ( hour > 0 ) {
        return [NSString stringWithFormat:@"%zd小时前", hour];
    }
    else if ( min > 0 ) {
        return [NSString stringWithFormat:@"%zd分钟前", min];
    }
    else {
        return @"刚刚";
    }
    return @"";
}

- (NSString *)fileName {
    return [self lastPathComponent];
}

/// 从文件读取字符串
+ (NSString *)csj_contenOfFile:(NSString *)path {

    NSError *error = nil;
    NSString *lrcFileContent = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    if (error != nil) {
        NSLog(@"%@", error);
        return nil;
    }

    return lrcFileContent;
}

/// 字符串转URL
- (NSURL *)csj_url {
    NSURL *url = [NSURL URLWithString:self];
    return url;
}

/// 从区间取子字符串
- (NSString*)csj_subStringWithinBoundsLeft:(NSString*)strLeft
                                     right:(NSString*)strRight
{
    NSRange rangeSub;
    NSString *strSub;

    NSRange range;
    range = [self rangeOfString:strLeft options:0];

    if (range.location == NSNotFound) {
        return nil;
    }

    rangeSub.location = range.location + range.length;

    range.location = rangeSub.location;
    range.length = [self length] - range.location;
    range = [self rangeOfString:strRight options:0 range:range];

    if (range.location == NSNotFound) {
        return nil;
    }

    rangeSub.length = range.location - rangeSub.location;
    strSub = [[self substringWithRange:rangeSub] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    return strSub;
}

/// 返回标志之前的字符串
- (NSString *)csj_beforeString:(NSString *)flag {
    /// flag 位置
    NSRange range = [self rangeOfString:flag];

    if (range.location == NSNotFound) {
        return nil;
    }

    /// 取 flag 之前的字符串
    return [self substringToIndex:range.location];
}

/// 返回标志之后的字符串
- (NSString *)csj_afterString:(NSString *)flag {
    /// flag 位置
    NSRange range = [self rangeOfString:flag];

    if (range.location == NSNotFound) {
        return nil;
    }

    /// 取 flag 之后的字符串
    return [self substringFromIndex:range.length + range.location];

}


/// 删除空格
- (NSString *)csj_deletePrefixWhitespace {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

/// 连接字符串
- (NSString *(^)(id))link {

    __block NSString *linked = self;

    return ^NSString *(id obj) {
        if (self == nil) {
            NSLog(@"link的参数为空!");
            return [NSString new];
        }
        linked = [self stringByAppendingFormat:@"%@", obj];
        return linked;
    };
}

/// 加后缀
- (NSString *(^)(NSString *))suffix {
    NSString *str = self;
    if ( ![str hasSuffix:@"."] ) {
        str = [str stringByAppendingString:@"."];
    }
    return [str link];
}


#pragma mark - 将NSString转换成UTF8编码的NSString

/**
 *  在使用网络地址时, 一般要先将url进行encode成UTF8格式的编码.
 *  否则在使用时可能报告网址不存在的错误, 这时就需要进行转换.
 */
- (NSString *)csj_encodeUTF8WithString:(NSString *)string {

    /**
     *  方法1
     */
    NSString *utf8Str = string;
    NSString *unicodeStr = [NSString stringWithCString:[utf8Str UTF8String] encoding:NSUnicodeStringEncoding];
    
    
    
    
    return unicodeStr;

    /**
     *  方法2
     */
    //    NSString *urlString= [NSString stringWithFormat:@"%@", string];
    //    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)urlString, NULL, NULL,  kCFStringEncodingUTF8 ));
    //    NSURL *url = [NSURL URLWithString:encodedString];
    //    NSLog(@"%@", url);
}


#pragma mark - 乱码问题
- (NSString *)csj_messyString{

    NSString *transString = [NSString stringWithString:[self stringByRemovingPercentEncoding]];

    /**
     *  以前的方法
     */
    //    NSString *transString = [NSString stringWithString:[string stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    return transString;
}

/// 判断字符串 纯数字
- (BOOL)csj_isPureIntWithString {
    NSScanner *scan = [NSScanner scannerWithString:self];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

// MARK: 计算文本尺寸
- (void)csj_textContentSizeMaxWidth:(CGFloat)width callBlock:(void(^)(CGSize size))block {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        CGSize size = [self csj_textSizeWithMaxWidth:width fontSize:13];
        if (block) block(size);
    });
}

// MARK: 计算文本尺寸
- (CGSize)csj_textSizeWithMaxWidth:(CGFloat)width {
    return [self csj_textSizeWithMaxWidth:width fontSize:14];
}

// MARK: 计算文本尺寸 fontSize: 字体大小
- (CGSize)csj_textSizeWithMaxWidth:(CGFloat)width fontSize:(CGFloat)fontSize {
    NSDictionary *attribute = @{NSFontAttributeName : [UIFont systemFontOfSize:fontSize]};
    CGSize size = [self boundingRectWithSize:CGSizeMake(width, 0.0f)
                                     options:
                   NSStringDrawingTruncatesLastVisibleLine  |
                   NSStringDrawingUsesLineFragmentOrigin    |
                   NSStringDrawingUsesFontLeading
                                  attributes:attribute
                                     context:nil].size;
    return size;
}

- (CGSize)csj_textSizeWithRowSpacing:(CGFloat)rowSpacing kern:(CGFloat)kern fontSize:(CGFloat)fontSize maxWidth:(CGFloat)maxWidth {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = rowSpacing;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{
                          NSFontAttributeName:[UIFont systemFontOfSize:fontSize],
                          NSParagraphStyleAttributeName:paraStyle,
                          NSKernAttributeName:@(kern),
                          };
    CGSize size = [self boundingRectWithSize:CGSizeMake(maxWidth, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size;
}
 // MARK:- 追加路径
/// 给当前文件追加文档路径
- (NSString *)csj_appendDocumentDir {
    NSString *dir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;

    return [dir stringByAppendingPathComponent:self.lastPathComponent];
}

/// 给当前文件追加缓存路径
- (NSString *)csj_appendCacheDir {
    NSString *dir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;

    return [dir stringByAppendingPathComponent:self.lastPathComponent];
}

/// 给当前文件追加临时路径
- (NSString *)csj_appendTempDir {
    NSString *dir = NSTemporaryDirectory();

    return [dir stringByAppendingPathComponent:self.lastPathComponent];
}



#pragma mark -
#pragma mark - Base64 转码
 /// base64编码
+ (NSString *)csj_base64EncodeString:(NSString *)string {
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}

#pragma mark -
#pragma mark - Base64 解码
 /// base64解码
+ (NSString *)csj_base64DecodeString:(NSString *)string {
    NSData *data = [[NSData alloc] initWithBase64EncodedString:string options:0];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}



#pragma mark - 散列函数
- (NSString *)csj_md5String {
    const char *str = self.UTF8String;
    uint8_t buffer[CC_MD5_DIGEST_LENGTH];

    CC_MD5(str, (CC_LONG)strlen(str), buffer);

    return [self stringFromBytes:buffer length:CC_MD5_DIGEST_LENGTH];
}

- (NSString *)csj_sha1String {
    const char *str = self.UTF8String;
    uint8_t buffer[CC_SHA1_DIGEST_LENGTH];

    CC_SHA1(str, (CC_LONG)strlen(str), buffer);

    return [self stringFromBytes:buffer length:CC_SHA1_DIGEST_LENGTH];
}

- (NSString *)csj_sha224String {
    const char *str = self.UTF8String;
    uint8_t buffer[CC_SHA224_DIGEST_LENGTH];

    CC_SHA224(str, (CC_LONG)strlen(str), buffer);

    return [self stringFromBytes:buffer length:CC_SHA224_DIGEST_LENGTH];
}

- (NSString *)csj_sha256String {
    const char *str = self.UTF8String;
    uint8_t buffer[CC_SHA256_DIGEST_LENGTH];

    CC_SHA256(str, (CC_LONG)strlen(str), buffer);

    return [self stringFromBytes:buffer length:CC_SHA256_DIGEST_LENGTH];
}

- (NSString *)csj_sha384String {
    const char *str = self.UTF8String;
    uint8_t buffer[CC_SHA384_DIGEST_LENGTH];

    CC_SHA384(str, (CC_LONG)strlen(str), buffer);

    return [self stringFromBytes:buffer length:CC_SHA384_DIGEST_LENGTH];
}

- (NSString *)csj_sha512String {
    const char *str = self.UTF8String;
    uint8_t buffer[CC_SHA512_DIGEST_LENGTH];

    CC_SHA512(str, (CC_LONG)strlen(str), buffer);

    return [self stringFromBytes:buffer length:CC_SHA512_DIGEST_LENGTH];
}

#pragma mark - HMAC 散列函数
- (NSString *)csj_hmacMD5StringWithKey:(NSString *)key {
    const char *keyData = key.UTF8String;
    const char *strData = self.UTF8String;
    uint8_t buffer[CC_MD5_DIGEST_LENGTH];

    CCHmac(kCCHmacAlgMD5, keyData, strlen(keyData), strData, strlen(strData), buffer);

    return [self stringFromBytes:buffer length:CC_MD5_DIGEST_LENGTH];
}

- (NSString *)csj_hmacSHA1StringWithKey:(NSString *)key {
    const char *keyData = key.UTF8String;
    const char *strData = self.UTF8String;
    uint8_t buffer[CC_SHA1_DIGEST_LENGTH];

    CCHmac(kCCHmacAlgSHA1, keyData, strlen(keyData), strData, strlen(strData), buffer);

    return [self stringFromBytes:buffer length:CC_SHA1_DIGEST_LENGTH];
}

- (NSString *)csj_hmacSHA256StringWithKey:(NSString *)key {
    const char *keyData = key.UTF8String;
    const char *strData = self.UTF8String;
    uint8_t buffer[CC_SHA256_DIGEST_LENGTH];

    CCHmac(kCCHmacAlgSHA256, keyData, strlen(keyData), strData, strlen(strData), buffer);

    return [self stringFromBytes:buffer length:CC_SHA256_DIGEST_LENGTH];
}

- (NSString *)csj_hmacSHA512StringWithKey:(NSString *)key {
    const char *keyData = key.UTF8String;
    const char *strData = self.UTF8String;
    uint8_t buffer[CC_SHA512_DIGEST_LENGTH];

    CCHmac(kCCHmacAlgSHA512, keyData, strlen(keyData), strData, strlen(strData), buffer);

    return [self stringFromBytes:buffer length:CC_SHA512_DIGEST_LENGTH];
}

#pragma mark - 文件散列函数

#define FileHashDefaultChunkSizeForReadingData 4096

- (NSString *)csj_fileMD5Hash {
    NSFileHandle *fp = [NSFileHandle fileHandleForReadingAtPath:self];
    if (fp == nil) {
        return nil;
    }

    CC_MD5_CTX hashCtx;
    CC_MD5_Init(&hashCtx);

    while (YES) {
        @autoreleasepool {
            NSData *data = [fp readDataOfLength:FileHashDefaultChunkSizeForReadingData];

            CC_MD5_Update(&hashCtx, data.bytes, (CC_LONG)data.length);

            if (data.length == 0) {
                break;
            }
        }
    }
    [fp closeFile];

    uint8_t buffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(buffer, &hashCtx);

    return [self stringFromBytes:buffer length:CC_MD5_DIGEST_LENGTH];
}

- (NSString *)csj_fileSHA1Hash {
    NSFileHandle *fp = [NSFileHandle fileHandleForReadingAtPath:self];
    if (fp == nil) {
        return nil;
    }

    CC_SHA1_CTX hashCtx;
    CC_SHA1_Init(&hashCtx);

    while (YES) {
        @autoreleasepool {
            NSData *data = [fp readDataOfLength:FileHashDefaultChunkSizeForReadingData];

            CC_SHA1_Update(&hashCtx, data.bytes, (CC_LONG)data.length);

            if (data.length == 0) {
                break;
            }
        }
    }
    [fp closeFile];

    uint8_t buffer[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1_Final(buffer, &hashCtx);

    return [self stringFromBytes:buffer length:CC_SHA1_DIGEST_LENGTH];
}

- (NSString *)csj_fileSHA256Hash {
    NSFileHandle *fp = [NSFileHandle fileHandleForReadingAtPath:self];
    if (fp == nil) {
        return nil;
    }

    CC_SHA256_CTX hashCtx;
    CC_SHA256_Init(&hashCtx);

    while (YES) {
        @autoreleasepool {
            NSData *data = [fp readDataOfLength:FileHashDefaultChunkSizeForReadingData];

            CC_SHA256_Update(&hashCtx, data.bytes, (CC_LONG)data.length);

            if (data.length == 0) {
                break;
            }
        }
    }
    [fp closeFile];

    uint8_t buffer[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256_Final(buffer, &hashCtx);

    return [self stringFromBytes:buffer length:CC_SHA256_DIGEST_LENGTH];
}

- (NSString *)csj_fileSHA512Hash {
    NSFileHandle *fp = [NSFileHandle fileHandleForReadingAtPath:self];
    if (fp == nil) {
        return nil;
    }

    CC_SHA512_CTX hashCtx;
    CC_SHA512_Init(&hashCtx);

    while (YES) {
        @autoreleasepool {
            NSData *data = [fp readDataOfLength:FileHashDefaultChunkSizeForReadingData];

            CC_SHA512_Update(&hashCtx, data.bytes, (CC_LONG)data.length);

            if (data.length == 0) {
                break;
            }
        }
    }
    [fp closeFile];

    uint8_t buffer[CC_SHA512_DIGEST_LENGTH];
    CC_SHA512_Final(buffer, &hashCtx);

    return [self stringFromBytes:buffer length:CC_SHA512_DIGEST_LENGTH];
}

#pragma mark - 助手方法
/**
 *  返回二进制 Bytes 流的字符串表示形式
 *
 *  @param bytes  二进制 Bytes 数组
 *  @param length 数组长度
 *
 *  @return 字符串表示形式
 */
- (NSString *)stringFromBytes:(uint8_t *)bytes length:(int)length {
    NSMutableString *strM = [NSMutableString string];

    for (int i = 0; i < length; i++) {
        [strM appendFormat:@"%02x", bytes[i]];
    }

    return strM.copy;
}

#pragma mark - 时间转化
+ (NSString *)timeIntervalToMMSSFormat:(NSTimeInterval)interval {
    NSInteger ti = (NSInteger)interval;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    return [NSString stringWithFormat:@"%02ld:%02ld", (long)minutes, (long)seconds];
}

@end
