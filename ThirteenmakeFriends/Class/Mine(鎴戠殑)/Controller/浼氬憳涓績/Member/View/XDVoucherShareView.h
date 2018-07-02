//
//  XDVoucherShareView.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/7/19.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDVoucherShareView : UIView

/**
 分享
 */
@property (copy, nonatomic) void (^shareButtonClicked)(UIButton *btn);

@end
