//
//  NoticeForBoyModel.h
//  ThirteenmakeFriends
//
//  Created by iOS on 26/4/17.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoticeForBoyModel : NSObject
@property (nonatomic, copy) NSString *apply_uid;  // 申请人id
@property (nonatomic, copy) NSString *apply_id;  // 

@property (nonatomic, copy) NSString *created_at; // 时间
@property (nonatomic, copy) NSString *created_id; // 男生通知的被评论人id
@property (nonatomic, copy) NSString *saveme_id;  // 救火id
@property (nonatomic, assign) NSInteger status;     // 0.待接受，1.待沟通，2。未评价，3，已评价，4.已过期
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *updated_at;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *sex;
//@property (nonatomic, copy) NSString *is_overdue;  // 1 表示已过期  2 表示没过期
@end
