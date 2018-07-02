//
//  XDScreenExclusiveController.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/9/6.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "BaseViewController.h"

@interface XDScreenExclusiveController : BaseViewController

@property (copy, nonatomic) NSString * areaModel;

/** 完成 */
@property (copy, nonatomic) void (^downButtonClicked)(NSString * areaModel);

@end
