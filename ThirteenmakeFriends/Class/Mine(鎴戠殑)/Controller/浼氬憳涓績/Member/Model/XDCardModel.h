//
//  XDCardModel.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/7/11.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XDMemberShipModel;

@interface XDCardModel : NSObject

/** 升级类型 0.续费 1。升级 */
@property (assign, nonatomic) NSInteger pay_money_type;
/** member_id */
@property (assign, nonatomic) NSInteger member_id;
/** 会员等级 */
@property (assign, nonatomic) NSInteger groupid;
/** 原本会员价格 */
@property (assign, nonatomic) NSInteger orgPrice;
/** 原本赠送心动币 */
@property (assign, nonatomic) NSInteger giveaway;
/** 原本半年会员价格 */
@property (assign, nonatomic) NSInteger semiAnnualPrice;
/** 原本半年赠送心动币 */
@property (assign, nonatomic) NSInteger semiAnnualGiveaway;
/** 实际全年价格 */
@property (assign, nonatomic) NSInteger allPrice;
/** 实际半年价格 */
@property (assign, nonatomic) NSInteger halfPrice;
/** 会员名称 */
@property (copy, nonatomic) NSString * member_name;
/** 会员描述 */
@property (copy, nonatomic) NSString * member_introduce;
/** 会员图标 */
@property (copy, nonatomic) NSString * vipIcon;

/** 会员权益数量 */
@property (assign, nonatomic) NSInteger auth_count;
/** 会员权益 */
@property (nonatomic, strong) NSMutableArray<XDMemberShipModel *> *memberShip;

@end

@interface XDMemberShipModel : NSObject
/** 标题 */
@property (nonatomic, copy) NSString *authName;
/** 描述 */
@property (nonatomic, copy) NSString *authContent;
/** 图片 */
@property (nonatomic, copy) NSString *rightsIcon;
/** 无权益图片 */
@property (nonatomic, copy) NSString *noRightsIcon;
/** 私人权益标识图片 */
@property (nonatomic, copy) NSString *privateIcon;
/** 是否拥有该权益 */
@property (assign, nonatomic) NSInteger is_have;
/** 是否是私人权益 */
@property (assign, nonatomic) NSInteger is_private;

@end

@interface XDVipIconModel : NSObject
/** 选中图标 */
@property (nonatomic, copy) NSString *big_vipIcon;
/** 非选中图标 */
@property (nonatomic, copy) NSString *small_vipIcon;

@end
