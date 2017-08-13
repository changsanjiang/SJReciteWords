//
//  UIImage+Extension.h
//  AXFEightGroup
//
//  Created by ya on 12/26/16.
//  Copyright © 2016 ya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

@property (nonatomic, assign, readonly) CGFloat csj_w;
@property (nonatomic, assign, readonly) CGFloat csj_h;


+ (UIImage *)csj_originImage:(NSString *)imageName;

 //  MARK: -  将Color转为UIImage
+ (UIImage *)csj_imageWithColor:(UIColor *)color
                           size:(CGSize)size;

 //  MARK: -  异步. 根据大小, 将图片切圆.
- (void)csj_cornerImageWithSize:(CGSize)size
                      fillColor:(UIColor *)color
                       complete:(void(^)(UIImage *image))block;

 //  MARK: -  图片写入文件
- (BOOL)csj_writeToFile:(NSString *)filePath;

- (UIImage *)csj_resizableImage;

@end
