//
//  XDPostsController.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 17/3/23.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDBaseUMShareController.h"

@interface XDPostsController : XDBaseUMShareController

/** 话题 */
@property (copy, nonatomic) NSString * topic;

- (void)reloadUnreadMessageCount;

@end
