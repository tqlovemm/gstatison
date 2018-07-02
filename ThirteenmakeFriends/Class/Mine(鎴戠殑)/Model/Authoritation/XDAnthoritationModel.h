//
//  XDAnthoritationModel.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/11/10.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XDAnthoritationModel : NSObject

/** 标题 */
@property (nonatomic, copy) NSString* title;

/** 描述 */
@property (nonatomic, copy) NSString* des;

/** 认证状态 0 未认证，1 审核中，2 认证失败，3 认证成功 */
@property (nonatomic, assign) NSInteger is_auth;

/** 标题配图 */
@property (nonatomic, copy) NSString* imgName;

/** 背景图 */
@property (nonatomic, copy) NSString* backImgNaem;

/** 视频认证内容 */
@property (nonatomic, copy) NSString* content;

/** 微信客服二维码 */
@property (nonatomic, copy) NSString* customer_qrc;

@end
