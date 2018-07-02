//
//  UIButton+XDTimeInterval.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/6/22.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (XDTimeInterval)

/* 防止button重复点击，设置间隔 */
@property (nonatomic, assign) NSTimeInterval mm_acceptEventInterval;

@end
