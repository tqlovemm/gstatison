//
//  XDSquareUserModel.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2018/1/11.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XDSquareUserModel : NSObject
/** 用户的id */
@property (nonatomic, assign) NSInteger user_id;
/** 头像 */
@property (nonatomic, copy) NSString *avatar;
/** 昵称 */
@property (nonatomic, copy) NSString *nickname;
/** 性别 */
@property (nonatomic, assign) NSInteger sex;
/** 年龄 */
@property (nonatomic, assign) NSInteger age;
/** 地点 */
@property (nonatomic, copy) NSString *area;
/** 照片数 */
@property (nonatomic, assign) NSInteger photo_count;
/** 用户名 */
@property (nonatomic, copy) NSString *username;
/** vip 1.会员或已认证 0.非会员或未认证 */
@property (nonatomic, assign) NSInteger vip;

@end
