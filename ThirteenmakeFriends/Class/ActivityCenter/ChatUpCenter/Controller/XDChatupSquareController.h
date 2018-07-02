//
//  XDChatupSquareController.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2018/1/11.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import "BaseViewController.h"
@class XDAreaModel;

@interface XDChatupSquareController : BaseViewController

@property (nonatomic, copy) NSString *startAge;
@property (nonatomic, copy) NSString *endAge;

@property (nonatomic, copy) NSString *sex;
@property (nonatomic, strong) XDAreaModel *areaModel;
@property (nonatomic, copy) NSString *is_vip;

- (void)retryNewData;

@end
