//
//  NoticeForGirlModel.h
//  ThirteenmakeFriends
//
//  Created by iOS on 26/4/17.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoticeForGirlModel : NSObject
@property (nonatomic, copy) NSString *apply_uid;  // 申请人id
@property (nonatomic, copy) NSString *apply_id;  // 帖子id
@property (nonatomic, copy) NSString *created_at; // 时间
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
@property (nonatomic, copy) NSString *level;  //! 权限等级（0为最高级）1非会员，2初级会员，3，高端会员，4至尊会员，5，私人至尊
@end
