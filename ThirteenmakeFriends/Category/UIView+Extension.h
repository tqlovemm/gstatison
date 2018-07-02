//
//  UIView+Extension.h
//  01-黑酷
//
//  Created by apple on 14-6-27.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGFloat right;
@property (nonatomic, assign) CGFloat bottom;

/**
 *  获取当前控制器所在控制器
 */
- (UIViewController*)viewController;

/**
 *  获取当前控制器所在导航控制器
 */
- (UINavigationController*)navigationController;

/**
 *  获取当前控制器所在控制器
 */
- (UITableViewController *)tableViewController;


/**
 吐司提示

 @param message 消息内容
 */
- (void)showToastMessage:(NSString *)message;
@end
