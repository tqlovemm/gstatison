//
//  XDMatchRecordModel.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/12/19.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XDMatchRecordModel : NSObject

/** 自己的user_id */
@property (nonatomic, assign) NSInteger cuser_id;
/** 匹配人的user_id */
@property (nonatomic, assign) NSInteger puser_id;
/** 1.已评价 0.未评价 */
@property (nonatomic, assign) NSInteger is_comment;
/** 匹配时间 */
@property (nonatomic, copy) NSString *created_at;
/** 性别 */
@property (nonatomic, assign) NSInteger sex;
/** 地区 */
@property (nonatomic, copy) NSString *area;
/** 年龄 */
@property (nonatomic, assign) NSInteger age;
/** 身高 */
@property (nonatomic, assign) NSInteger height;
/** 体重 */
@property (nonatomic, assign) NSInteger weight;
/** 头像 */
@property (nonatomic, copy) NSString *avatar;
/** 昵称 */
@property (nonatomic, copy) NSString *nickname;
/** 评价描述 */
@property (nonatomic, copy) NSString *comment_level;

@end
