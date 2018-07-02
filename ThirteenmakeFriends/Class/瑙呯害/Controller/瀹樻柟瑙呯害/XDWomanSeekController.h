//
//  XDWomanSeekController.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/11/8.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "BaseViewController.h"
@class XDAreaModel;

@interface XDWomanSeekController : BaseViewController

@property (strong, nonatomic) XDAreaModel * areaModel;

- (void)retryNewData;

@end
