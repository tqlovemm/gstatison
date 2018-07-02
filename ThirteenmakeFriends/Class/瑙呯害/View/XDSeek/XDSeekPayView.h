//
//  XDSeekPayView.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/8/31.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDSeekPayView : UIView

/**
 支付
 */
@property (copy, nonatomic) void (^payButtonClicked)(UIButton *btn);

@property (nonatomic, assign) NSInteger price;

@property (nonatomic, assign) NSInteger timeIntervel;

/** 支付类型(2.救我 1.专属 0.觅约) */
@property (nonatomic, assign) NSInteger payType;

@property (nonatomic, assign) BOOL is_limited;
@end
