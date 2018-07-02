//
//  XDSignInModel.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/11/20.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XDSignInModel : NSObject

/** 登录赠送 */
@property (nonatomic, assign) NSInteger login_giveaway;
/** 认证奖励 */
@property (nonatomic, assign) NSInteger auth_giveaway;
/** 连续登录天数 */
@property (nonatomic, assign) NSInteger con_days;
/** 认证类型 3为微信认证 */
@property (nonatomic, assign) NSInteger auth_type;

@end
