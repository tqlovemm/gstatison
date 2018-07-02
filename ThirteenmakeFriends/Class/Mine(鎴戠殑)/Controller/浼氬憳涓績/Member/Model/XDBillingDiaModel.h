//
//  XDBillingDiaModel.h
//  ThirteenmakeFriends
//
//  Created by 空谷凌虚 on 2018/5/21.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XDBillingDiaModel : NSObject


@property (copy, nonatomic) NSString *diamonds;
@property (copy, nonatomic) NSString *created_at;
/** 消费或收入说明 */
@property (copy, nonatomic) NSString * subject;
/** 余额 */
@property (assign, nonatomic) NSInteger balance;

@end
