//
//  UIImage+Extension.m
//  黑马微博
//
//  Created by apple on 14-7-3.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)
+ (UIImage *)imageWithName:(NSString *)name
{
    UIImage *image = nil;
//    if (iOS7) { // 处理iOS7的情况
//        NSString *newName = [name stringByAppendingString:@"_os7"];
//        image = [UIImage imageNamed:newName];
//    }
    
    if (image == nil) {
        image = [UIImage imageNamed:name];
    }
    return image;
}

+ (UIImage *)resizedImage:(NSString *)name
{
    return [self resizedImageWithName:name left:0.5 top:0.5];
}

+ (UIImage *)resizedImageWithName:(NSString *)name left:(CGFloat)left top:(CGFloat)top
{
    UIImage *image = [UIImage imageWithName:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width * left topCapHeight:image.size.height * top];
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    return [self imageWithColor:color size:CGSizeMake(1, 1)];
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect=CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

- (NSData *)wxImageSize:(UIImage *)image
{
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    
    CGFloat boundary = 1280;
    
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    
    // width, height <= 1280, Size remains the same
    if (imageWidth <= boundary && imageHeight <= boundary) {
        UIImage* reImage = [self resizedImage:imageWidth withHeight:imageHeight withImage:image];
        data = UIImageJPEGRepresentation(reImage, 0.5);
        return data;
    }
    
    // aspect ratio
    CGFloat s = MAX(imageWidth, imageHeight) / MIN(imageWidth, imageHeight);
    
    if (s <= 2) {
        // Set the larger value to the boundary, the smaller the value of the compression
        CGFloat x = MAX(imageWidth, imageHeight) / boundary;
        if (imageWidth > imageHeight) {
            imageWidth = boundary ;
            imageHeight = imageHeight / x;
        }else{
            imageHeight = boundary;
            imageWidth = imageWidth / x;
        }
    }else{
        if (MIN(imageWidth, imageHeight) >= boundary) {
            //- parameter type: session image boundary is 800, timeline is 1280
            // boundary = type == .session ? 800 : 1280
            CGFloat x = MIN(imageWidth, imageHeight) / boundary;
            if (imageWidth < imageHeight) {
                imageWidth = boundary;
                imageHeight = imageHeight / x;
            } else {
                imageHeight = boundary;
                imageWidth = imageWidth / x;
            }
        }
    }
    UIImage* reImage = [self resizedImage:imageWidth withHeight:imageHeight withImage:image];
    data = UIImageJPEGRepresentation(reImage, 0.5);
    return data;
}

- (UIImage *)resizedImage:(CGFloat)imageWidth withHeight:(CGFloat)imageHeight withImage:(UIImage *)image
{
    CGRect newRect = CGRectMake(0, 0, imageWidth, imageHeight);
    UIImage *newImage;
    UIGraphicsBeginImageContext(newRect.size);
    newImage = [UIImage imageWithCGImage:image.CGImage scale:1 orientation:image.imageOrientation];
    [newImage drawInRect:newRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


/**
 给图片设置圆角
 */
- (UIImage*)imageAddCornerWithRadius:(CGFloat)radius andSize:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius, radius)];
    CGContextAddPath(ctx,path.CGPath);
    CGContextClip(ctx);
    [self drawInRect:rect];
    CGContextDrawPath(ctx, kCGPathFillStroke);
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
