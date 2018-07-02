//
//  XDTableViewCellDate.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 16/12/12.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XDTableViewCellDate : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *subTitle;

@property (nonatomic) UIImage *icon;

- (instancetype)initWithTitle:(NSString *)title iconName:(NSString *)iconName;

- (instancetype)initWithTitle:(NSString *)title subTitle:(NSString *)subTitle iconName:(NSString *)iconName;

@end
