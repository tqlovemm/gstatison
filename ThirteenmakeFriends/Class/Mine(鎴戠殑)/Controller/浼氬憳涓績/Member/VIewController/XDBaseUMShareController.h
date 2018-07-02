//
//  XDBaseUMShareController.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/7/19.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "BaseViewController.h"
#import <UMSocialCore/UMSocialCore.h>

//static NSString* const UMS_Title = @"【友盟+】社会化组件U-Share";
static NSString* const UMS_Prog_Title = @"【友盟+】U-Share小程序";
static NSString* const UMS_Text = @"欢迎使用【友盟+】社会化组件U-Share，SDK包最小，集成成本最低，助力您的产品开发、运营与推广！";
static NSString* const UMS_Text_image = @"i欢迎使用【友盟+】社会化组件U-Share，SDK包最小，集成成本最低，助力您的产品开发、运营与推广！";
//static NSString* const UMS_Web_Desc = @"W欢迎使用【友盟+】社会化组件U-Share，SDK包最小，集成成本最低，助力您的产品开发、运营与推广！";
static NSString* const UMS_Music_Desc = @"M欢迎使用【友盟+】社会化组件U-Share，SDK包最小，集成成本最低，助力您的产品开发、运营与推广！";
static NSString* const UMS_Video_Desc = @"V欢迎使用【友盟+】社会化组件U-Share，SDK包最小，集成成本最低，助力您的产品开发、运营与推广！";

//static NSString* const UMS_THUMB_IMAGE = @"https://mobile.umeng.com/images/pic/home/social/img-1.png";
static NSString* const UMS_IMAGE = @"https://mobile.umeng.com/images/pic/home/social/img-1.png";

//static NSString* const UMS_WebLink = @"https://bbs.umeng.com/";

static NSString *UMS_SHARE_TBL_CELL = @"UMS_SHARE_TBL_CELL";

@interface XDBaseUMShareController : BaseViewController

/** 标题 */
@property (nonatomic, copy) NSString *UMS_Title;

/** 网页描述 */
@property (nonatomic, copy) NSString *UMS_Web_Desc;

/** 缩略图 */
@property (nonatomic, strong) UIImage *UMS_THUMB_IMAGE;

/** 分享的网页链接 */
@property (nonatomic, copy) NSString *UMS_WebLink;

/** 分享的纯文本 */
@property (nonatomic, copy) NSString *UMS_Text;

/**
 网页分享
 */
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType;

/**
 分享文本
 */
- (void)shareTextToPlatformType:(UMSocialPlatformType)platformType;


/**
 分享本地图片
 */
- (void)shareImageToPlatformType:(UMSocialPlatformType)platformType;


/**
 分享网络图片
 */
- (void)shareImageURLToPlatformType:(UMSocialPlatformType)platformType;


/**
 分享图片和文字 -- 仅支持新浪微博
 */
- (void)shareImageAndTextToPlatformType:(UMSocialPlatformType)platformType;

@end
