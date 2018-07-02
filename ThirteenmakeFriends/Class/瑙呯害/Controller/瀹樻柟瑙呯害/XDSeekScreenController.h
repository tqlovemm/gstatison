//
//  XDSeekScreenController.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/9/5.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "BaseViewController.h"
@class XDAreaModel;

@interface XDSeekScreenController : BaseViewController

@property (strong, nonatomic) XDAreaModel * areaModel;

/** 完成 */
@property (copy, nonatomic) void (^downButtonClicked)(XDAreaModel * areaModel);

@end
