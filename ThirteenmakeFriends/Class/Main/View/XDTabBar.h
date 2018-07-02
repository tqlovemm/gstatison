//
//  XDTabBar.h
//  Miai13
//
//  Created by Xudongdong on 16/7/11.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XDTabBar;

@protocol XDTabBarDelegate <NSObject>

@optional
- (void)tabBarDidClickedPlusButton:(XDTabBar *)tabBar;

@end

@interface XDTabBar : UITabBar
@property (nonatomic, weak) id<XDTabBarDelegate> tabBarDelegate;

@end
