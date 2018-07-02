//
//  XDWomanSeekScreenController.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/11/17.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "HMCommonViewController.h"
@class XDAreaModel;

@interface XDWomanSeekScreenController : HMCommonViewController

/** 完成 */
@property (copy, nonatomic) void (^downButtonClicked)(XDAreaModel * areaModel);

@property (strong, nonatomic) XDAreaModel *areaModel;

@end
