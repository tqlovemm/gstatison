//
//  UIImage+Extension.h
//  黑马微博
//
//  Created by apple on 14-7-3.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)
/**
 *  根据图片名自动加载适配iOS6\7的图片
 */
+ (UIImage *)imageWithName:(NSString *)name;

/**
 *  根据图片名返回一张能够自由拉伸的图片
 */
+ (UIImage *)resizedImage:(NSString *)name;

/**
 *  根据图片名返回一张能够从哪个位置开始自由拉伸的图片
 */
+ (UIImage *)resizedImageWithName:(NSString *)name left:(CGFloat)left top:(CGFloat)top;

/**
 *  根据颜色返回一张图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 *  根据颜色返回指定尺寸的图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;



/**
 图片压缩算法
 */
- (NSData *)wxImageSize:(UIImage *)image;

/**
 *  根据原图返回一个指定大小的图片
 */
- (UIImage *)resizedImage:(CGFloat)imageWidth withHeight:(CGFloat)imageHeight withImage:(UIImage *)image;

/**
 给图片设置圆角
 */
- (UIImage*)imageAddCornerWithRadius:(CGFloat)radius andSize:(CGSize)size;
@end
