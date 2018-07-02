//
//  XDPostFrameModel.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 17/3/23.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XDPostModel;

@interface XDPostFrameModel : NSObject<NSCoding>

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
 *  性别
 */
@property (nonatomic, assign, readonly) CGRect sexViewF;
/**
 *  会员标识
 */
@property (nonatomic, assign, readonly) CGRect memberViewF;
/**
 *  发帖时间
 */
@property (nonatomic, assign, readonly) CGRect timeLabelF;
/**
 *  时间图标
 */
@property (nonatomic, assign, readonly) CGRect timeViewF;
/**
 *  位置信息
 */
@property (nonatomic, assign, readonly) CGRect locationLabelF;
/**
 *  位置图标
 */
@property (nonatomic, assign, readonly) CGRect locationViewF;
/**
 *  置顶
 */
@property (nonatomic, assign, readonly) CGRect isTopViewF;
/**
 *  关注图标
 */
@property (nonatomic, assign, readonly) CGRect attentionViewF;
/**
 *  配图
 */
@property (nonatomic, assign, readonly) CGRect picViewF;
/**
 *  话题
 */
@property (nonatomic, assign, readonly) CGRect topViewF;
/**
 *  赞的view
 */
@property (nonatomic, assign, readonly) CGRect praiseViewF;
/**
 *  内容
 */
@property (nonatomic, assign, readonly) CGRect contentLabelF;
/**
 *  全文按钮
 */
@property (nonatomic, assign, readonly) CGRect isMoreButtonF;
/**
 *  评论视图
 */
@property (nonatomic, assign, readonly) CGRect commentViewF;
/**
 *  查看所有评论
 */
@property (nonatomic, assign, readonly) CGRect allCommentsF;
/**
 *  赞
 */
@property (nonatomic, assign, readonly) CGRect praiseBtnF;
/**
 *  评论
 */
@property (nonatomic, assign, readonly) CGRect commentBtnF;
/**
 *  其他
 */
@property (nonatomic, assign, readonly) CGRect otherBtnF;


//! 行高
@property (assign, nonatomic) CGFloat cellHeight;

@end
