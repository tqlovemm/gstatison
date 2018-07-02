//
//  XDSurePayView.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/7/19.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDSurePayView : UIView


/**
 支付金额
 */
@property (assign, nonatomic) NSInteger price;

/**
 分享
 */
@property (copy, nonatomic) void (^payButtonClicked)(UIButton *btn);

@end
