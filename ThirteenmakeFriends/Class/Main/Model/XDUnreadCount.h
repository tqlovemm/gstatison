//
//  XDUnreadCount.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 16/10/13.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XDUnreadCount : NSObject
///** 未读帖子消息数 */
//@property (nonatomic, assign) int unread_thread_count;
///** 救我消息数 */
//@property (assign, nonatomic) int unread_saveme_count;
///** 其他 */
//@property (nonatomic, assign) int unread_other_msg_count;
///** 系统公告未读数 */
//@property (nonatomic, assign) int unread_system_count;
///** 未读消息总数 */
//@property (nonatomic, assign) int unread_msg_total;

/** 帖子未读消息数 */
@property (nonatomic, assign) int thread_count;
/** 系统消息数 */
@property (nonatomic, assign) int system_total_count;
/** 未读消息总数 */
@property (nonatomic, assign) int msg_total;

+ (instancetype)sharedInstance;

@end
