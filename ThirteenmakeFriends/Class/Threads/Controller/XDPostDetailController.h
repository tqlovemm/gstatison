//
//  XDPostDetailController.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 17/3/29.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDBaseUMShareController.h"
@class XDPostModel;

@interface XDPostDetailController : XDBaseUMShareController

@property (copy, nonatomic) NSString * thread_id;

/**
 删除帖子按钮点击
 */
@property (copy, nonatomic) void (^deleteButtonClicked)(void);

/**
 帖子关注按钮点击 code==200：取消关注  202：关注
 */
@property (copy, nonatomic) void (^attentionViewClickedBlock)(NSInteger code);

@end
