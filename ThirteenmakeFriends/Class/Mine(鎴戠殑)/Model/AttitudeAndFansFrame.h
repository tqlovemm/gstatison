//
//  AttitudeAndFansFrame.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 15/12/31.
//  Copyright © 2015年 ThirtyOneDay. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ShiSanUser;

@interface AttitudeAndFansFrame : NSObject

@property (strong, nonatomic) ShiSanUser * user;

/**
 *  头像
 */
@property (nonatomic, assign, readonly) CGRect iconViewF;

/**
 *  昵称
 */
@property (nonatomic, assign, readonly) CGRect nameLabelF;

/**
 *  自我介绍
 */
@property (nonatomic, assign, readonly) CGRect selfIntroLabelF;

/**
 *  关注按钮
 */
@property (nonatomic, assign, readonly) CGRect isAttitudeF;

/**
 *  cell高度
 */
@property (nonatomic, assign, readonly) CGFloat cellHeight;

@end
