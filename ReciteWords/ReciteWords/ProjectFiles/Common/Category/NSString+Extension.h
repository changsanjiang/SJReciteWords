//
//  NSString+Extension.h
//  CSJQQMusic
//
//  Created by ya on 12/19/16.
//  Copyright © 2016 ya. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Extension)

 // MARK: -  处理时间 createDateStr 毫秒 nowDateStr 毫秒
/**
 *  处理时间 createDateStr 毫秒 nowDateStr 毫秒
 */
+ (NSString *)csj_processTimeWithCreateDate:(NSString *)createDateStr nowDate:(NSString *)nowDateStr;

+ (NSString *)csj_processTimeWithCreateDateI:(NSInteger)createDate nowDateI:(NSInteger)nowDate;


 // MARK: -  删除空格
@property (nonatomic, strong, readonly) NSString *csj_deletePrefixWhitespace;

 // MARK: -  字符串转URL
@property (nonatomic, strong, readonly) NSURL *csj_url;

 // MARK: -  从文件读取字符串
+ (NSString *)csj_contenOfFile:(NSString *)path;

 // MARK: -  从区间取子字符串
- (NSString *)csj_subStringWithinBoundsLeft:(NSString *)strLeft right:(NSString *)strRight;

 // MARK: -  返回标志之前的字符串
/// 返回标志之前的字符串
- (NSString *)csj_beforeString:(NSString *)flag;

 // MARK: -  返回标志之后的字符串
/// 返回标志之后的字符串
- (NSString *)csj_afterString:(NSString *)flag;

 // MARK: -  连接字符串
- (NSString *(^)(id))link;

 // MARK: -  加后缀
- (NSString *(^)(NSString *))suffix;

 // MARK: -  目前没用到任何地方
- (NSString *)csj_messyString;

 // MARK: -  判断字符串 纯数字
- (BOOL)csj_isPureIntWithString;

// MARK: 计算文本尺寸 fontSize: 13
- (void)csj_textContentSizeMaxWidth:(CGFloat)width callBlock:(void(^)(CGSize size))block;

// MARK: 计算文本尺寸 fontSize: 14
- (CGSize)csj_textSizeWithMaxWidth:(CGFloat)width;

// MARK: 计算文本尺寸 fontSize: 字体大小
- (CGSize)csj_textSizeWithMaxWidth:(CGFloat)width fontSize:(CGFloat)fontSize;

// MARK: 计算文本尺寸 rowSpacing  行间距。kern 字间距
- (CGSize)csj_textSizeWithRowSpacing:(CGFloat)rowSpacing kern:(CGFloat)kern fontSize:(CGFloat)fontSize maxWidth:(CGFloat)maxWidth;

 //  MARK:- 路径相关
 // MARK: -  /private/var/mobile/Containers/Data/Application/1CE3FCEA-7828-4678-A68E-4012E2471FF0/tmp/testAHNBKJKK
 // MARK: -  给当前文件追加文档路径
@property (nonatomic, strong, readonly) NSString *csj_appendDocumentDir;

 // MARK: -  给当前文件追加缓存路径
@property (nonatomic, strong, readonly) NSString *csj_appendCacheDir;

 // MARK: -  给当前文件追加临时路径
@property (nonatomic, strong, readonly) NSString *csj_appendTempDir;















 // MARK: -  base64编码/解码
+ (NSString *)csj_base64EncodeString:(NSString *)string;
+ (NSString *)csj_base64DecodeString:(NSString *)string;















#pragma mark - 散列函数
/**
 *  计算MD5散列结果
 *
 *  终端测试命令：
 *  @code
 *  md5 -s "string"
 *  @endcode
 *
 *  <p>提示：随着 MD5 碰撞生成器的出现，MD5 算法不应被用于任何软件完整性检查或代码签名的用途。<p>
 *
 *  @return 32个字符的MD5散列字符串
 */
- (NSString *)csj_md5String;

/**
 *  计算SHA1散列结果
 *
 *  终端测试命令：
 *  @code
 *  echo -n "string" | openssl sha -sha1
 *  @endcode
 *
 *  @return 40个字符的SHA1散列字符串
 */
- (NSString *)csj_sha1String;

/**
 *  计算SHA224散列结果
 *
 *  终端测试命令：
 *  @code
 *  echo -n "string" | openssl sha -sha224
 *  @endcode
 *
 *  @return 56个字符的SHA224散列字符串
 */
- (NSString *)csj_sha224String;

/**
 *  计算SHA256散列结果
 *
 *  终端测试命令：
 *  @code
 *  echo -n "string" | openssl sha -sha256
 *  @endcode
 *
 *  @return 64个字符的SHA256散列字符串
 */
- (NSString *)csj_sha256String;

/**
 *  计算SHA 384散列结果
 *
 *  终端测试命令：
 *  @code
 *  echo -n "string" | openssl sha -sha384
 *  @endcode
 *
 *  @return 96个字符的SHA 384散列字符串
 */
- (NSString *)csj_sha384String;

/**
 *  计算SHA 512散列结果
 *
 *  终端测试命令：
 *  @code
 *  echo -n "string" | openssl sha -sha512
 *  @endcode
 *
 *  @return 128个字符的SHA 512散列字符串
 */
- (NSString *)csj_sha512String;

#pragma mark - HMAC 散列函数
/**
 *  计算HMAC MD5散列结果
 *
 *  终端测试命令：
 *  @code
 *  echo -n "string" | openssl dgst -md5 -hmac "key"
 *  @endcode
 *
 *  @return 32个字符的HMAC MD5散列字符串
 */
- (NSString *)csj_hmacMD5StringWithKey:(NSString *)key;

/**
 *  计算HMAC SHA1散列结果
 *
 *  终端测试命令：
 *  @code
 *  echo -n "string" | openssl sha -sha1 -hmac "key"
 *  @endcode
 *
 *  @return 40个字符的HMAC SHA1散列字符串
 */
- (NSString *)csj_hmacSHA1StringWithKey:(NSString *)key;

/**
 *  计算HMAC SHA256散列结果
 *
 *  终端测试命令：
 *  @code
 *  echo -n "string" | openssl sha -sha256 -hmac "key"
 *  @endcode
 *
 *  @return 64个字符的HMAC SHA256散列字符串
 */
- (NSString *)csj_hmacSHA256StringWithKey:(NSString *)key;

/**
 *  计算HMAC SHA512散列结果
 *
 *  终端测试命令：
 *  @code
 *  echo -n "string" | openssl sha -sha512 -hmac "key"
 *  @endcode
 *
 *  @return 128个字符的HMAC SHA512散列字符串
 */
- (NSString *)csj_hmacSHA512StringWithKey:(NSString *)key;

#pragma mark - 文件散列函数

/**
 *  计算文件的MD5散列结果
 *
 *  终端测试命令：
 *  @code
 *  md5 file.dat
 *  @endcode
 *
 *  @return 32个字符的MD5散列字符串
 */
- (NSString *)csj_fileMD5Hash;

/**
 *  计算文件的SHA1散列结果
 *
 *  终端测试命令：
 *  @code
 *  openssl sha -sha1 file.dat
 *  @endcode
 *
 *  @return 40个字符的SHA1散列字符串
 */
- (NSString *)csj_fileSHA1Hash;

/**
 *  计算文件的SHA256散列结果
 *
 *  终端测试命令：
 *  @code
 *  openssl sha -sha256 file.dat
 *  @endcode
 *
 *  @return 64个字符的SHA256散列字符串
 */
- (NSString *)csj_fileSHA256Hash;

/**
 *  计算文件的SHA512散列结果
 *
 *  终端测试命令：
 *  @code
 *  openssl sha -sha512 file.dat
 *  @endcode
 *
 *  @return 128个字符的SHA512散列字符串
 */
- (NSString *)csj_fileSHA512Hash;


+ (NSString *)timeIntervalToMMSSFormat:(NSTimeInterval)interval;
@end

NS_ASSUME_NONNULL_END
