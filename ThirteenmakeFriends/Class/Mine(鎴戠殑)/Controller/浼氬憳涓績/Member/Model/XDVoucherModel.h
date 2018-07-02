//
//  XDVoucherModel.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/7/18.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XDVoucherModel : NSObject

/** 原本会员价格 */
@property (assign, nonatomic) NSInteger price;
/** 是否使用 */
@property (assign, nonatomic) BOOL is_use;
/** 卡券描述 */
@property (copy, nonatomic) NSString *des;
/** 卡券类型 */
@property (assign, nonatomic) NSInteger voucherType;
/** 过期时间 */
@property (assign, nonatomic) NSInteger overdueTime;

@end
