//
//  XDUnreadPostFrame.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 17/3/31.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XDPostModel;

@interface XDUnreadPostFrame : NSObject

@property (strong, nonatomic) XDPostModel * model;

/**
 *  头像
 */
@property (nonatomic, assign, readonly) CGRect iconViewF;
/**
 *  昵称
 */
@property (nonatomic, assign, readonly) CGRect nameLabelF;
/**
 *  配图
 */
@property (nonatomic, assign, readonly) CGRect picViewF;
/**
 *  时间
 */
@property (nonatomic, assign, readonly) CGRect timeLabelF;
/**
 *  评论内容
 */
@property (nonatomic, assign, readonly) CGRect contentLabelF;
/**
 *  帖子内容
 */
@property (nonatomic, assign, readonly) CGRect postContentLabelF;
/**
 *  点赞
 */
@property (nonatomic, assign, readonly) CGRect likeViewF;

//! 行高
@property (assign, nonatomic) CGFloat cellHeight;

@end
