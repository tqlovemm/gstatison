//
//  UIView+XDGradientColor.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/11/30.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "UIView+XDGradientColor.h"

@implementation UIView (XDGradientColor)

/**
 *  设置渐变背景
 */
- (void)setShadowBackgroundColor {
    CAGradientLayer *colorLayer = [CAGradientLayer layer];
    colorLayer.frame    = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    colorLayer.position = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0);
    [self.layer insertSublayer:colorLayer atIndex:0];
    
#if APP_Puppet  // Puppet
    // 颜色分配
    colorLayer.colors = @[(__bridge id)[UIColor colorWithRed:232/255.0f green:63/255.0f blue:120/255.0f alpha:1].CGColor,
                          (__bridge id)[UIColor colorWithRed:233/255.0f green:174/255.0f blue:121/255.0f alpha:1].CGColor
                          ];
//    colorLayer.locations  = @[@(0.75)];
    // 起始点
    colorLayer.startPoint = CGPointMake(0, 0);
    
    // 结束点
    colorLayer.endPoint   = CGPointMake(1, 1);
#elif APP_myPuppet
    // 颜色分配
    colorLayer.colors = @[(__bridge id)[UIColor colorWithRed:91/255.0f green:56/255.0f blue:185/255.0f alpha:1].CGColor,
                          (__bridge id)[UIColor colorWithRed:156/255.0f green:88/255.0f blue:203/255.0f alpha:1].CGColor
                          ];
//    colorLayer.locations  = @[@(0.75)];
    // 起始点
    colorLayer.startPoint = CGPointMake(0.1, 0.5);
    
    // 结束点
    colorLayer.endPoint   = CGPointMake(0.8, 0);
#else // 正常
    // 颜色分配
    colorLayer.colors = @[(__bridge id)[UIColor colorWithRed:233/255.0f green:174/255.0f blue:121/255.0f alpha:1].CGColor,
                          (__bridge id)[UIColor colorWithRed:232/255.0f green:63/255.0f blue:120/255.0f alpha:1].CGColor
                          ];
//    colorLayer.locations  = @[@(0.75)];
    // 起始点
    colorLayer.startPoint = CGPointMake(0.35, -1);
    
    // 结束点
    colorLayer.endPoint   = CGPointMake(0.6, 1);
#endif
}

@end
