//
//  XDPayItemView.h
//  MeiziIntro
//
//  Created by Xudongdong on 16/7/27.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XDPay;

@interface XDPayItemView : UIView

@property (strong, nonatomic) XDPay * payInfo;

@property (assign, nonatomic) BOOL selected;

@end
