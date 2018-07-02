//
//  XDExclusiveRecordModel.h
//  ThirteenmakeFriends
//
//  Created by iOS on 18/5/17.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MZInfo;

@interface XDExclusiveRecordModel : NSObject

/** 妹子编号 */
@property (nonatomic, copy) NSString *zid;

@property (nonatomic, copy) NSString *sid;

@property (nonatomic, strong) MZInfo *info;

@property (nonatomic, copy) NSString *user_id;

@property (nonatomic, copy) NSString *created_at;

//! 三种状态 10.觅约等待中 11.觅约成功 12.觅约失败
@property (nonatomic, copy) NSString *status;

@end

@interface MZInfo : NSObject
/** 妹子编号 */
@property (nonatomic, copy) NSString *zid;

@property (nonatomic, copy) NSString *updated_at;

@property (nonatomic, copy) NSString *limit_count;

@property (nonatomic, copy) NSString *sign_up_count;

@property (nonatomic, copy) NSString *limit_vip;

@property (nonatomic, copy) NSString *introduce;


//! 报名需要心动币数量
@property (nonatomic, copy) NSString *coin;

//! 妹子头像
@property (nonatomic, copy) NSString *avatar;

//! 妹子地址
@property (nonatomic, copy) NSString *address;

//! 妹子地址
@property (nonatomic, copy) NSString *address_detail;

//! 妹子标签
@property (copy, nonatomic) NSArray<NSString *> *p_info;

//! 交友要求
@property (copy, nonatomic) NSArray<NSString *> *h_info;


@end
