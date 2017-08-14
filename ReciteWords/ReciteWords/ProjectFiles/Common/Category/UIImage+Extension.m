//
//  UIImage+Extension.m
//  AXFEightGroup
//
//  Created by ya on 12/26/16.
//  Copyright © 2016 ya. All rights reserved.
//

#import "UIImage+Extension.h"
#import <JavaScriptCore/JavaScriptCore.h>

@implementation UIImage (Extension)

- (CGFloat)csj_w {
    return self.size.width;
}

- (CGFloat)csj_h {
    return self.size.height;
}

+ (UIImage *)csj_originImage:(NSString *)imageName {
    return [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

/// 将Color转为UIImage
+ (UIImage *)csj_imageWithColor:(UIColor *)color size:(CGSize)size {

    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

/// 异步. 根据大小, 将图片切圆.
- (void)csj_cornerImageWithSize:(CGSize)size
                      fillColor:(UIColor *)color
                       complete:(void(^)(UIImage *image))block {

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIGraphicsBeginImageContextWithOptions(size, YES, 0);
        [color setFill];
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        UIRectFill(rect);

        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithOvalInRect:rect];
        [bezierPath addClip];
        [self drawInRect:rect];

        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        dispatch_sync(dispatch_get_main_queue(), ^{
            block(image);
        });
    });
}

/// 将图片 切片 中间部分放大
/// 根据图片上下左右4边的像素进行自动扩充。
- (void)testWithImage:(UIImage *)image {
    /**
     *  图片的切片
     */
    // 第一中方法
    image = [image resizableImageWithCapInsets:
             UIEdgeInsetsMake(image.size.height * 0.8,
                              image.size.width * 0.5,
                              image.size.height * 0.2,
                              image.size.width * 0.5)
                                  resizingMode:UIImageResizingModeTile];
    // 第二中方法
        image = [image stretchableImageWithLeftCapWidth:image.size.width * 0.5
                                           topCapHeight:image.size.height * 0.8];
}

- (UIImage *)csj_resizableImage {
    return [self resizableImageWithCapInsets:
             UIEdgeInsetsMake(self.csj_h * 0.5,
                              self.csj_w * 0.5,
                              self.csj_h * 0.5,
                              self.csj_w * 0.5)
                                resizingMode:UIImageResizingModeTile];

}

/// 图片写入文件
- (BOOL)csj_writeToFile:(NSString *)filePath {
    NSData *data = UIImagePNGRepresentation(self);
    if (data == nil) {
        data = UIImageJPEGRepresentation(self, 1);
    }
    return [data writeToFile:filePath atomically:YES];
}

@end
