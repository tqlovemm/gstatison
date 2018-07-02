//
//  XDSaveMesController.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2018/1/3.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import "BaseViewController.h"
#import "XDAreaModel.h"
@interface XDSaveMesController : BaseViewController

/**
 *  地区ID
 */
//@property (copy, nonatomic) NSString * areaID;
/**
 *  地区名
 */
//@property (copy, nonatomic) NSString * areaName;
/**
 *  性别
 */
@property (copy, nonatomic) NSString * sex;
/**
 *  是否本人
 */
@property (nonatomic, copy) NSString *isself;

@property (strong, nonatomic) XDAreaModel * areaModel;

- (void)retryNewData;

@end
