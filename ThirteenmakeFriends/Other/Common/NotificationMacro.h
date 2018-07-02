//
//  NotificationMacro.h
//  ThirteenmakeFriends
//
//  Created by iOS on 21/4/17.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#ifndef NotificationMacro_h
#define NotificationMacro_h

// 是否打开了密码   YES   NO
#define OpenedGesPWD [NSString stringWithFormat:@"%@CanOpenGesPWD",User_ID]

// touchid        YES  NO
#define TouchID [NSString stringWithFormat:@"%@TouchID",User_ID]

// 九宫格密码    加密后的密码
#define CombinationLock  [NSString stringWithFormat:@"%@CombinationLock",User_ID]


static NSString *const FireFightRedPoint = @"FireFightNewMessage";//关注粉丝

// 救我通知 set YES
#define SetFireFightWithRedPoint    [UserDefaults setObject:@"YES" forKey:FireFightRedPoint];
// 救我通知 set NO
#define SetFireFightWithOutRedPoint [UserDefaults setObject:@"NO" forKey:FireFightRedPoint];

#pragma mark -帖子通知
// 评论通知
#define XDPostCommentNotification @"XDPostCommentNotification"
// 点赞通知
#define XDPostLikeNotification @"XDPostLikeNotification"

#pragma mark - 出现匹配结果通知
#define XDMatchResultSuccessNotification @"XDMatchResultSuccessNotification"
#define XDMatchResultFailedNotification @"XDMatchResultFailedNotification"
#define XDMatchResultMatchingNotification @"XDMatchResultMatchingNotification"

#endif /* NotificationMacro_h */
