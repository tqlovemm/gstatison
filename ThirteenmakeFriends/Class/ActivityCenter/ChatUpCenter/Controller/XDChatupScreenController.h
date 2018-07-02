//
//  XDChatupScreenController.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2018/1/12.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import "BaseViewController.h"
@class XDAreaModel;

@interface XDChatupScreenController : BaseViewController

@property (nonatomic, copy) NSString *startAge;
@property (nonatomic, copy) NSString *endAge;

@property (nonatomic, copy) NSString *sex;
@property (nonatomic, strong) XDAreaModel *areaModel;
@property (nonatomic, copy) NSString *is_vip;

/** 完成 */
@property (copy, nonatomic) void (^downButtonClicked)(XDAreaModel * areaModel, NSString *startAge, NSString *endAge, NSString *sex, NSString *is_vip);

@end
