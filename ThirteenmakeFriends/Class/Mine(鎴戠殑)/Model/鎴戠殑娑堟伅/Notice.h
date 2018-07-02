//
//  Notice.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 16/4/21.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//  我的消息模型

#import <Foundation/Foundation.h>
@class PushModel;

@interface Notice : NSObject
/** 消息推送id */
@property (nonatomic, assign) NSInteger push_id;
/** 消息推送模型 */
@property (nonatomic, strong) PushModel *extras;

@property (nonatomic, assign) NSInteger status;
/** 消息推送标题 */
@property (nonatomic, copy) NSString *title;
/** 消息内容 */
@property (nonatomic, copy) NSString *msg;

@property (nonatomic, copy) NSString *response;
/** 客户端id */
@property (nonatomic, copy) NSString *cid;
/** 是否已读 (默认为1,未读) */
@property (nonatomic, assign) NSInteger is_read;

@property (nonatomic, assign) NSInteger updated_at;
/** 图标 */
@property (nonatomic, copy) NSString *icon;
/** 通知时间 */
@property (nonatomic, assign) NSInteger created_at;

- (NSString *)getCreateTime;

@end
