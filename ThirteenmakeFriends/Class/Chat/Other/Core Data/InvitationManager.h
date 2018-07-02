/************************************************************
 *  * EaseMob CONFIDENTIAL
 * __________________
 * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of EaseMob Technologies.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from EaseMob Technologies.
 */


//  用来处理UIDemo上的数据，您使用时请自己处理相关部分db

#import <Foundation/Foundation.h>

@class ApplyEntity;
@interface InvitationManager : NSObject

+ (instancetype)sharedInstance;

// 申请与通知
-(void)updateInvitation:(ApplyEntity *)applyEntity loginUser:(NSString *)username;

-(void)addInvitation:(ApplyEntity *)applyEntity loginUser:(NSString *)username;

-(void)removeInvitation:(ApplyEntity *)applyEntity loginUser:(NSString *)username;

-(NSArray *)applyEmtitiesWithloginUser:(NSString *)username;

@end

@interface ApplyEntity : NSObject 
/** 申请人用户名 */
@property (nonatomic, strong) NSString * applicantUsername;
/** 申请人昵称 */
@property (nonatomic, strong) NSString * applicantNick;
/** 申请人头像 */
@property (nonatomic, strong) NSString * applicantAvatar;
/** 原因 */
@property (nonatomic, strong) NSString * reason;
/** 接收者用户名 */
@property (nonatomic, strong) NSString * receiverUsername;
/** 接收者昵称 */
@property (nonatomic, strong) NSString * receiverNick;
/** 申请类型 */
@property (nonatomic, strong) NSNumber * style;
/** 申请群id */
@property (nonatomic, strong) NSString * groupId;
/** 申请群组的主题 */
@property (nonatomic, strong) NSString * groupSubject;

//！申请与通知（是否处理过）0:未处理 1：已接受 2：已拒绝
@property (nonatomic, strong) NSString * is_dealed;

@end
