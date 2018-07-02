//
//  XDGetCouponView.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/7/25.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDGetCouponView : UIView

/**
 优惠券按钮
 */
@property (copy, nonatomic) void (^couponButtonClicked)(UIButton *btn);

/**
 显示超级喜欢
 
 @param animated 是否动画展示
 */
- (void)show:(BOOL)animated;

/**
 隐藏超级喜欢
 
 @param animated 是否动画展示
 */
- (void)hide:(BOOL)animated;

@end
