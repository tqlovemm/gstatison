/************************************************************
 *  * EaseMob CONFIDENTIAL
 * __________________
 * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of EaseMob Technologies.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from EaseMob Technologies.
 */


#import <UIKit/UIKit.h>

@interface UIImageView (HeadImage)

/**
 *  根据用户名设置头像
 */
- (void)imageWithUsername:(NSString*)username placeholderImage:(UIImage*)placeholderImage;

@end

@interface UILabel (Prase)

/**
 *  根据用户名设置昵称
 */
- (void)setTextWithUsername:(NSString *)username;

@end
