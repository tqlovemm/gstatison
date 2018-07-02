//
//  XDMatchEvaluationController.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 17/1/10.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "BaseViewController.h"
@class ShiSanUser;

@interface XDMatchEvaluationController : BaseViewController

@property (copy, nonatomic) NSString * user_id;   //被评论人id
@property (copy, nonatomic) NSString * saveme_id; //救火id

/**
 评价成功
 */
@property (copy, nonatomic) void (^hasevaluated)(NSInteger );

@end
