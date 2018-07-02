//
//  XDUpgradeBottomView.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/7/17.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XDCardModel;

@interface XDUpgradeBottomView : UIView

/** 会员过期时间 */
@property (nonatomic, copy) NSString *vip_deadline;

@property (strong, nonatomic) XDCardModel * cardModel;

/**
 咨询客服
 */
@property (copy, nonatomic) void (^serviceButtonClicked)(UIButton *btn);

/**
 会员升级
 */
@property (copy, nonatomic) void (^upgradeButtonClicked)(UIButton *btn);

@end
