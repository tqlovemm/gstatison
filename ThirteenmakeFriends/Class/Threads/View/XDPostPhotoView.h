//
//  XDPostPhotoView.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 17/3/23.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDPostPhotoView : UIView

/**
 *  图片数据（里面都是图片模型）
 */
@property (nonatomic, strong) NSArray *pic_urls;

/**
 *  根据图片个数计算相册的最终尺寸
 */
+ (CGSize)sizeWithPhotos:(NSArray *)photos;

@end
