//
//  UserProfileManager.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 16/9/23.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserCacheInfo : NSObject
//! 环信ID
@property(nonatomic,copy)NSString* Id;
//! 环信昵称
@property(nonatomic,copy)NSString* NickName;
//! 环信头像
@property(nonatomic,copy)NSString* AvatarUrl;
@end

@interface UserProfileManager : NSObject

+ (instancetype) shareInstance;

//! 获取当前用户在服务器上的好友数据（头像、昵称），储存到内存中或者本地沙盒中
- (void)loadUserProfileInBackgroundWithBuddy:(NSArray*)buddyList;

/*
 *保存用户信息（如果已存在，则更新）
 *userId: 用户环信ID
 *imgUrl：用户头像链接（完整路径）
 *nickName: 用户昵称
 */
+(void)saveInfo:(NSString *)userId
         imgUrl:(NSString*)imgUrl
       nickName:(NSString*)nickName;

/*
 *保存用户信息
 */
+(void)saveDict:(NSDictionary *)userinfo;

/*
 *一次保存多个用户信息
 */
+(void)saveAllDicts:(NSArray *)userinfos;

/*
 *根据环信ID获取用户信息
 *userId 用户的环信ID
 */
+(UserCacheInfo *)getById:(NSString *)userid;

/*
 * 根据环信ID获取昵称
 * userId:环信用户id
 */
+(NSString*)getNickById:(NSString*)userId;

/*
 * 获取当前环信用户信息
 */
+(UserCacheInfo *)getCurrUser;

@end
