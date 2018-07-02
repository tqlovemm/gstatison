//
//  XDPostPraiseFrameModel.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 17/5/15.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XDPostPraiseModel;

@interface XDPostPraiseFrameModel : NSObject

@property (strong, nonatomic) XDPostPraiseModel * praiseModel;

/**
 *  头像
 */
@property (nonatomic, assign, readonly) CGRect iconViewF;
/**
 *  昵称
 */
@property (nonatomic, assign, readonly) CGRect nameLabelF;
/**
 *  年龄
 */
@property (nonatomic, assign, readonly) CGRect ageLabelF;
/**
 *  正文
 */
@property (nonatomic, assign, readonly) CGRect contentLabelF;

//! 行高
@property (assign, nonatomic) CGFloat cellHeight;

@end
