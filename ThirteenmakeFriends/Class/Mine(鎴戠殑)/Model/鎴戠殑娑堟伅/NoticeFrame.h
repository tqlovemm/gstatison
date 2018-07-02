//
//  NoticeFrame.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 16/4/21.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Notice.h"

@interface NoticeFrame : NSObject

@property (strong, nonatomic) PushModel * notice;

/**
 *  头像
 */
@property (nonatomic, assign, readonly) CGRect iconViewF;
/**
 *  标题
 */
@property (nonatomic, assign, readonly) CGRect titleLabelF;
/**
 *  内容
 */
@property (nonatomic, assign, readonly) CGRect contentLabelF;

/**
 *  创建时间
 */
@property (nonatomic, assign, readonly) CGRect timeLabelF;

/**
 *  正文
 */
@property (nonatomic, assign, readonly) CGRect isReadViewF;

/**
 *  cell的高度
 */
@property (nonatomic, assign, readonly) CGFloat cellHeight;

@end
