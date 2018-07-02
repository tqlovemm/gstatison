//
//  ProfileUser.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 16/1/11.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProfileUser : NSObject<NSCoding>

//! id
@property (nonatomic,copy) NSString *user_id;
/**头像图片Url*/
@property (nonatomic,strong) NSString *avatar;

@property (nonatomic,strong) NSString *avatarid;
//! 用户手机
@property (nonatomic,copy) NSString* cellphone;
//! 用户注册时间
@property (nonatomic,copy) NSString* created_at;

@property (nonatomic,copy) NSString* empirical_value;
//! 阅读数
@property (nonatomic,copy) NSString* feed_count;
/** 粉丝数 */
@property (nonatomic,copy) NSString* follower_count;
/** 关注数 */
@property (nonatomic,copy) NSString* following_count;
//! 帖子回帖数
@property (nonatomic,copy) NSString* post_count;
/** 发帖数 */
@property (nonatomic,copy) NSString* thread_count;

@property (nonatomic,copy) NSString* unread_message_count;

@property (nonatomic,copy) NSString* unread_notice_count;
//! 邮箱
@property (nonatomic,copy) NSString* email;
/** 权限等级（0=>非会员，1包月会员，2初级会员，3高端会员，4至尊会员，5私人订制) */
@property (nonatomic,copy) NSString* groupid;

@property (nonatomic,copy) NSString* identity;

@property (nonatomic,copy) NSString* invitation;
//! 生日
@property (nonatomic,copy) NSString* birthdate;
//! 身高
@property (nonatomic,copy) NSString* height;
//! 爱好
@property (nonatomic,strong) NSArray* hobby;
//! 交友请求
@property (nonatomic,strong) NSArray* make_friend;
//! 个人标签
@property (nonatomic,strong) NSArray* mark;
//! 体重
@property (nonatomic,copy) NSString* weight;
//! 性别
@property (nonatomic,copy) NSString* sex;

@property (nonatomic,copy) NSString* status;

@property (nonatomic,copy) NSString* updated_at;
//! 用户名
@property (nonatomic,copy) NSString* username;
//! 昵称
@property (nonatomic,copy) NSString* nickname;
//! 用户签名
@property (nonatomic,copy) NSString* signature;

@property (nonatomic,copy) NSString* auth_key;
//! 心动币
@property (nonatomic,assign) NSInteger jiecao_coin;
//! 冻结心动币
@property (nonatomic,copy) NSString* frozen_jiecao_coin;
//!钻石
@property (nonatomic,assign) NSInteger diamonds;

//! 魅力值
@property (nonatomic,copy) NSString* glamorous;

//! 关注（为查看关注与粉丝时提供）
@property (nonatomic,assign) NSNumber* each;
//! 登陆用户是否关注词用户（1为关注）
@property (nonatomic,assign) NSNumber *follow;

//! 档案照
@property (nonatomic,strong) NSArray* photos;

//! 情感状态 （0:单身，1:有/男女朋友，2:已婚, 3:保密）
@property (nonatomic,copy) NSString* is_marry;

//! 觅约金额
@property (nonatomic,copy) NSString* worth;

//! 觅约编号
@property (nonatomic,copy) NSString* dating_no;

//! 第三方登录标识
@property (nonatomic,copy) NSString* openId;

/** 是否认证 0 未认证，1 认证成功 */
@property (nonatomic,assign) NSInteger is_renzheng;

/** 微信号 */
@property (nonatomic,copy) NSString* wechat;
/** 微信二维码 */
@property (nonatomic,copy) NSString* weima;

//! 地址
//@property (nonatomic,copy) NSString* address;

/** 主地址 */
@property (nonatomic,copy) NSString* area_one;
/** 副地址1 */
@property (nonatomic,copy) NSString* area_two;
/** 副地址2 */
@property (nonatomic,copy) NSString* area_three;
/** 用户编号 */
@property (nonatomic,copy) NSString* thirteen_platform_number;


/** 学历 1初中及以下，2高中，3大专，4本科，5研究生，6博士及以上 */
@property (nonatomic,assign) NSInteger education;
/** 年薪 1：10万以下，2：10-20万，3：20-50万，4：50-100万，5：100-500万，6：500万以上 */
@property (nonatomic,assign) NSInteger annual_salary;
/** 职业 */
@property (nonatomic,copy) NSString* job;

+ (id)sharedUser;


/** 获取会员等级名 */
- (NSString *)getMemberName;

/** 获取最高学历 */
- (NSString *)getHighestEducation;

/** 获取收入 */
- (NSString *)getPersonIncome;

@end
