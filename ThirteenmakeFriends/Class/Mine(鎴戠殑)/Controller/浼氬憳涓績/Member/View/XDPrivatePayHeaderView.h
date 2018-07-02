//
//  XDPrivatePayHeaderView.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/7/21.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDPrivatePayHeaderView : UIView

@property (nonatomic, assign) NSInteger minPrice;
/**
 咨询客服
 */
@property (copy, nonatomic) void (^serviceButtonClicked)(UIButton *btn);

@end
