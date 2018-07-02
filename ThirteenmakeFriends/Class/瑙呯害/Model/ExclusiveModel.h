//
//  ExclusiveModel.h
//  ThirteenmakeFriends
//
//  Created by iOS on 17/5/17.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FlopPhoto;

@interface ExclusiveModel : NSObject<NSCoding>

/** 觅约id */
@property (copy, nonatomic) NSString * zid;

/** 妹子编号 */
@property (copy, nonatomic) NSString * girlNum;

/** 妹子头像 */
@property (copy, nonatomic) NSString * avatar;

/** 妹子标签 */
@property (copy, nonatomic) NSArray<NSString *> *p_info;

/** 交友要求 */
@property (copy, nonatomic) NSArray<NSString *> *h_info;

/** 发布日期 */
@property (copy, nonatomic) NSString * created_at;

/** 结束时间_时间戳 */
@property (copy, nonatomic) NSString * end_time;

/** 地区 */
@property (copy, nonatomic) NSString * address;

/** 觅约配图 */
@property (copy, nonatomic) NSArray<FlopPhoto *> *photos;

/** 状态 */
@property (copy, nonatomic) NSString * status;

/** 觅约价格 */
@property (copy, nonatomic) NSString * coin;

/** 高端会员过期时间 */
@property (copy, nonatomic) NSString * expire;

/** 用户名 */
@property (copy, nonatomic) NSString * username;

/** 昵称 */
@property (copy, nonatomic) NSString * nickname;

/** 简介 */
@property (copy, nonatomic) NSString * introduction;

//! 觅约配图
//@property (copy, nonatomic) NSArray<FlopPhoto *> *chatImg;

/** hot */
@property (copy, nonatomic) NSString * tag_type;

/** 认证 */
@property (copy, nonatomic) NSString * authenticate;

/** 微信 */
@property (copy, nonatomic) NSString * contact_model;

/** 名额已满 1.已满 0.未满 */
@property (assign, nonatomic) BOOL is_limited;

@end
