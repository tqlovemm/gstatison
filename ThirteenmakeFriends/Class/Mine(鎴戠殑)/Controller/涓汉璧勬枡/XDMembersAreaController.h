//
//  XDMembersAreaController.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/7/31.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "BaseViewController.h"
#import "HMCommonViewController.h"

@interface XDMembersAreaController : HMCommonViewController

/**
 地区选择完成
 */
@property (copy, nonatomic) void (^areaSelectViewClickedBlock)(NSString *areaStr, NSString *areaID);

@end
