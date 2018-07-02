//
//  Seek.h
//  觅约-seek-
//
//  Created by Xudongdong on 16/3/18.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FlopPhoto;

@interface Seek : NSObject<NSCoding>
//! 觅约id
@property (copy, nonatomic) NSString * dating_id;

//! 妹子编号
@property (copy, nonatomic) NSString * girlNum;

//! 妹子头像
@property (copy, nonatomic) NSString * girlHeadIcon;

//! 妹子标签
@property (copy, nonatomic) NSArray<NSString *> *girlLabel;

//! 交友要求
@property (copy, nonatomic) NSArray<NSString *> *datingRequire;

/** 更新日期_时间戳 */
@property (copy, nonatomic) NSString * updated_at;

//! 发布日期_时间戳
@property (copy, nonatomic) NSString * created_at;

//! 结束时间_时间戳
@property (copy, nonatomic) NSString * end_time;

/** 主地区 */
@property (copy, nonatomic) NSString * area;
/** 地区2 */
@property (copy, nonatomic) NSString * area_two;
/** 地区3 */
@property (copy, nonatomic) NSString * area_three;

//! 觅约配图
@property (copy, nonatomic) NSArray<FlopPhoto *> *seekPicture;

//! 状态
@property (copy, nonatomic) NSString * status;

//! 觅约价格
@property (copy, nonatomic) NSString * worth;

//! 高端会员过期时间
@property (copy, nonatomic) NSString * expire;

//! 用户名
@property (copy, nonatomic) NSString * username;

//! 昵称
@property (copy, nonatomic) NSString * nickname;

//! 简介
@property (copy, nonatomic) NSString * introduction;

//! 觅约配图
@property (copy, nonatomic) NSArray<FlopPhoto *> *chatImg;

//! hot
@property (copy, nonatomic) NSString * tag_type;

//! 认证
@property (copy, nonatomic) NSString * authenticate;

//! 微信
@property (copy, nonatomic) NSString * contact_model;

@end
