//
//  XDSeekRecord.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 16/6/30.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XDSeekRecord : NSObject

/** 觅约记录id */
@property (nonatomic, assign) NSInteger signup_id;

/** 妹子图片 */
@property (nonatomic, copy) NSString *avatar;

/** 妹子编号 */
@property (nonatomic, copy) NSString *number;

/** 妹子标签 */
@property (nonatomic, copy) NSString *mark;

/** 交友要求 */
@property (nonatomic, copy) NSString *require;

/** 地址 */
@property (nonatomic, copy) NSString *address;

/** 报名平台 0.微信 1.ios 2.andriod */
@property (nonatomic, assign) NSInteger platform;

/** 觅约价格 */
@property (nonatomic, assign) NSInteger coin;

/** 觅约状态 10:等待中，冻结心动币，11:成功，扣除心动币，12:失败，返回心动币 */
@property (nonatomic, assign) NSInteger status;

@end

