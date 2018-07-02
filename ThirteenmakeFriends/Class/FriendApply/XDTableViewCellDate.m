//
//  XDTableViewCellDate.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 16/12/12.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import "XDTableViewCellDate.h"

@implementation XDTableViewCellDate

- (instancetype)initWithTitle:(NSString *)title iconName:(NSString *)iconName {
    return [self initWithTitle:title subTitle:nil iconName:iconName];
}

- (instancetype)initWithTitle:(NSString *)title subTitle:(NSString *)subTitle iconName:(NSString *)iconName {
    self = [super init];
    if (self) {
        self.title = title;
        self.icon = [UIImage imageNamed:iconName];
        self.subTitle = subTitle;
    }
    
    return self;
}

@end
