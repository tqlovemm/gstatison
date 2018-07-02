//
//  XDBasicDataController.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 16/8/24.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//  资料详情

#import "HMCommonViewController.h"


@protocol XDBasicDataControllerDelegate <NSObject>

- (void)basicInfoChanged;

@end

@interface XDBasicDataController : HMCommonViewController

@property (weak, nonatomic) id<XDBasicDataControllerDelegate> delegate;

@end
