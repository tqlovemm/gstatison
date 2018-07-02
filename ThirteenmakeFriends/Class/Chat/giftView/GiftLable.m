//
//  GiftLable.m
//  ThirteenmakeFriends
//
//  Created by jie.huang on 2018/4/13.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import "GiftLable.h"

@implementation GiftLable

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
    
        self.font = [UIFont systemFontOfSize:10];
        self.textAlignment = NSTextAlignmentCenter;
        self.textColor = RGB(104, 103, 103);
        self.backgroundColor = RGB(31, 29, 29);
    }
    return self;
}


@end
