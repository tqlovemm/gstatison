//
//  XDAddFriendApplyController.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 16/12/14.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import "BaseViewController.h"

@interface XDAddFriendApplyController : BaseViewController

@property (copy, nonatomic) NSString * username;


/**
 是否处理过 0:未处理 1:接受 2:拒绝
 */
@property (copy, nonatomic) NSString * is_dealed;
@end
