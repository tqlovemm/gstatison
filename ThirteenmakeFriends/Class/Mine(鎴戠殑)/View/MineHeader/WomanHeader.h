//
//  WomanHeader.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 16/6/29.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileUser.h"
@class MyModuleView;

@interface WomanHeader : UIView

//! 头像
@property (weak, nonatomic) UIImageView *headIcon;
//! 用户名
@property (weak, nonatomic) UILabel *userName;
//! 昵称
@property (weak, nonatomic) UILabel *nickName;
//! 性别
@property (weak, nonatomic) UIImageView *sexView;
//! 视频认证
@property (weak, nonatomic) UIImageView *autheView;
//! 我的关注
@property (weak, nonatomic) UILabel *attributeCount;
//! 我的粉丝
@property (weak, nonatomic) UILabel *fansCount;
//! 我的发帖
@property (weak, nonatomic) UILabel *sendPostCount;


@property (strong, nonatomic) ProfileUser *user;

//! 心动币
@property (weak, nonatomic) MyModuleView *coinView;
//! 魅力值
@property (weak, nonatomic) MyModuleView *charmView;

//! 会员等级
@property (weak, nonatomic) MyModuleView *vipLevelView;

//! 约会记录
@property (weak, nonatomic) MyModuleView *seekRecordView;

@end
