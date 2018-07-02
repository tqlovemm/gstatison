//
//  XDThirdRegStep2Controller.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/12/1.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "BaseViewController.h"
@class ShiSanUser;

@interface XDThirdRegStep2Controller : BaseViewController

@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *birthdate;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, strong) ShiSanUser *user;

@end
