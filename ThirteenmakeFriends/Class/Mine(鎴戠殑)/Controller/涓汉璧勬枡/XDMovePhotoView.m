//
//  XDMovePhotoView.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 16/8/24.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import "XDMovePhotoView.h"

@implementation XDMovePhotoView

-(instancetype)init
{
    if(self == [super init])
    {
        self.userInteractionEnabled = YES;
        self.clipsToBounds = YES;
        self.contentMode = UIViewContentModeScaleAspectFill;
    }
    return self;
}

@end
