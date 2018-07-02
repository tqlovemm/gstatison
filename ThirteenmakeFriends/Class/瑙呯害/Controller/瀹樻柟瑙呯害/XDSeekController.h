//
//  XDSeekController.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/9/1.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "BaseViewController.h"
@class XDAreaModel;

@interface XDSeekController : BaseViewController

/**
 *  地区
 */
@property (strong, nonatomic) XDAreaModel * areaModel;

- (void)retryNewData;

@end
