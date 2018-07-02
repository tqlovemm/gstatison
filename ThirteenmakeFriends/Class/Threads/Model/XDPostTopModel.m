//
//  XDPostTopModel.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/10/24.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDPostTopModel.h"

@implementation XDPostTopModel

@end

@implementation XDRecommendPersonModel

- (NSString *)username {
    if ([_username isKindOfClass:[NSNull class]]) {
        return nil;
    }
    return _username;
}

@end

@implementation XDAcitivityModel

@end
