//
//  XDSaveMeModel.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2018/1/3.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XDSignUpModel;

@interface XDSaveMeModel : NSObject

/** 用户的id */
@property (nonatomic, assign) NSInteger user_id;
/** 救我id */
@property (nonatomic, assign) NSInteger info_id;
/** 头像 */
@property (nonatomic, copy) NSString *avatar;
/** 昵称 */
@property (nonatomic, copy) NSString *nickname;
/** 性别 */
@property (nonatomic, assign) NSInteger sex;
/** 活动名称 */
@property (nonatomic, copy) NSString *activity_type;
/** 地点 */
@property (nonatomic, copy) NSString *area_one;
/** 截止时间 */
@property (nonatomic, copy) NSString *endTimeaddTransactionObserver;
/** 文字内容 */
@property (nonatomic, copy) NSString *hope_require;
/** 配图 */
@property (nonatomic, strong) NSArray *photos;
/** 活动开始时间 */
@property (nonatomic, assign) NSInteger created_at;
/** 活动结束时间 */
@property (nonatomic, assign) NSInteger end_time;
/** 报名所需心动币 */
@property (nonatomic, assign) NSInteger need_coin;
/** 报名需要等级 */
@property (nonatomic, assign) NSInteger need_vip;
/** 是否是自己发布的 */
@property (nonatomic, assign) NSInteger is_self;
/** 报名人数 */
@property (nonatomic, assign) NSInteger signupCount;
/** 最多可报名人数 */
@property (nonatomic, assign) NSInteger limit_count;

/** 男生为是否是会员，女生为是否认证 1.是 ，0不是 */
@property (nonatomic, assign) NSInteger vip;
/** 发布来源   0 会员自己发布，1官方发布 */
@property (nonatomic, assign) NSInteger type;
/** 是否置顶，0不置顶，1置顶 */
@property (nonatomic, assign) NSInteger is_top;

/** 报名人数 */
@property (nonatomic, strong) NSArray <XDSignUpModel *> *signup;

- (NSString *)stringDatewithInterval:(NSInteger)timestamp;

/**
 返回截止时间
 */
- (NSString *)stringDatewithEndInterval:(NSInteger)timestamp;

@end

@interface XDSignUpModel : NSObject
//! 昵称
@property (nonatomic, copy) NSString *nickname;
//! 昵称
@property (nonatomic, copy) NSString *username;
//! 头像
@property (nonatomic, copy) NSString *avatar;
/** 用户的id */
@property (nonatomic, assign) NSInteger user_id;
/** 是否为好友 */
@property (nonatomic, assign) BOOL is_friend;
/** 活动开始时间 */
@property (nonatomic, assign) NSInteger created_at;

- (NSString *)stringDatewithInterval:(NSInteger)timestamp;

@end
