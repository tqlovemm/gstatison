//
//  XDMatchUserModel.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/12/26.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDMatchUserModel.h"
#import "MJExtension.h"

@implementation XDMatchUserModel

- (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"user_id" : @"id"};

}

@end
