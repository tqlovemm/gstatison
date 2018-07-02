//
//  XDAreaModel.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/8/8.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDAreaModel.h"

@implementation XDAreaModel

- (NSDictionary*)objectClassInArray {
    
    return @{@"children":[XDAreaChildrenModel class]};
}

@end

@implementation XDAreaChildrenModel

@end
