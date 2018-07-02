//
//  XDNewSavemeScreenController.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2018/1/10.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import "HMCommonViewController.h"
//@class XDAreaModel;

@interface XDNewSavemeScreenController : HMCommonViewController

@property (copy, nonatomic) NSString * areaID;
@property (copy, nonatomic) NSString * areaName;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, assign) BOOL is_self;

/** 完成 */
@property (copy, nonatomic) void (^downButtonClicked)(NSString * areaID, NSString * areaName, NSString * sex, BOOL is_self);

@end
