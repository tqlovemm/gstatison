//
//  XDMatchCommentController.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/12/20.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "BaseViewController.h"
@class XDMatchRecordModel;

@interface XDMatchCommentController : BaseViewController

@property (nonatomic, strong) XDMatchRecordModel *user;

/**
 评价成功
 */
@property (copy, nonatomic) void (^hasevaluated)(NSString *str);

@end
