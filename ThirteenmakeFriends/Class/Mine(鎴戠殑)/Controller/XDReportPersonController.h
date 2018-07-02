//
//  XDReportPersonController.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 16/7/8.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import "HMCommonViewController.h"
#import "ShiSanUser.h"

@interface XDReportPersonController : HMCommonViewController

@property (strong, nonatomic) ShiSanUser * user;
/**
 *  编号举报
 */
@property (copy, nonatomic) NSString * number;

@end
