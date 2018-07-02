//
//  XDBillingModel.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/8/28.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XDBillingModel : NSObject

/** 增加或消费多少 */
@property (copy, nonatomic) NSString *coin;
/** 时间 */
@property (copy, nonatomic) NSString *created_at;
/** type：消费还是收入 正数：充值，负数：消费 */
@property (assign, nonatomic) NSInteger type;
/** 消费或收入说明 */
@property (copy, nonatomic) NSString * subject;
/** 余额 */
@property (assign, nonatomic) NSInteger balance;

@end
