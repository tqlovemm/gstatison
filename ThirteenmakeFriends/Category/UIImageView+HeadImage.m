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


#import "UIImageView+HeadImage.h"

#import "UserProfileManager.h"
#import "UIImageView+EMWebCache.h"
// 头像昵称
//#import "UserCacheManager.h"

@implementation UIImageView (HeadImage)

/**
 *  根据用户名设置头像
 */
- (void)imageWithUsername:(NSString *)username placeholderImage:(UIImage*)placeholderImage
{
    if (placeholderImage == nil) {
        placeholderImage = [UIImage imageNamed:@"chatListCellHead"];
    }
//    UserProfileEntity *profileEntity = [[UserProfileManager sharedInstance] getUserProfileByUsername:username];
    // 头像昵称
    UserCacheInfo *profileEntity = [UserProfileManager getById:username];
    if (profileEntity) {
        if ([username isEqualToString:kServiceName]) {
//            [self sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/uploads/user/avatar/364916437561466532.png",DomainUrl2]] placeholderImage:placeholderImage];
            self.image = [UIImage imageNamed:@"app_icon"];
        } else {
            [self sd_setImageWithURL:[NSURL URLWithString:profileEntity.AvatarUrl] placeholderImage:placeholderImage];
        }
        
    } else {
//#warning 客服
        // 判断是否是客服，是则设置客服图片
        if ([username isEqualToString:kServiceName]) {
//            [self sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/uploads/user/avatar/364916437561466532.png",DomainUrl2]] placeholderImage:placeholderImage];
            self.image = [UIImage imageNamed:@"app_icon"];
        } else {
            [self sd_setImageWithURL:nil placeholderImage:placeholderImage];
        }
        
    }
}

@end

@implementation UILabel (Prase)

/**
 *  根据用户名设置昵称
 */
- (void)setTextWithUsername:(NSString *)username
{
//    UserProfileEntity *profileEntity = [[UserProfileManager sharedInstance] getUserProfileByUsername:username];
//    if (profileEntity) {
//        if (profileEntity.nickname && profileEntity.nickname.length > 0) {
//            [self setText:profileEntity.nickname];
//            [self setNeedsLayout];
//        } else {
//            [self setText:username];
//        }
//    } else {
//        [self setText:username];
//    }
    // 头像昵称
    UserCacheInfo *profileEntity = [UserProfileManager getById:username];
    if (profileEntity) {
        if (profileEntity.NickName && profileEntity.NickName.length > 0) {
            [self setText:profileEntity.NickName];
            [self setNeedsLayout];
        } else {
            [self setText:username];
        }
    } else {
        [self setText:username];
    }
    
}

@end
