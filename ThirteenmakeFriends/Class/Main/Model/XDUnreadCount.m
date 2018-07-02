//
//  XDUnreadCount.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 16/10/13.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import "XDUnreadCount.h"

@implementation XDUnreadCount

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static XDUnreadCount *instance;
    
    // dispatch_once是线程安全的，onceToken默认为0
    static dispatch_once_t onceToken;
    // dispatch_once宏可以保证块代码中的指令只会被执行一次
    dispatch_once(&onceToken, ^{
        // 永远只执行一次，instance只会被实例化一次
        instance = [super allocWithZone:zone];
    });
    
    return instance;
}

+ (instancetype)sharedInstance {
    return [[self alloc]init];
}

@end
