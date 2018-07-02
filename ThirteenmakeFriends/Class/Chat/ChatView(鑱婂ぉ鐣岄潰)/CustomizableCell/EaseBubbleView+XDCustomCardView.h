//
//  EaseBubbleView+XDCustomCardView.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/11/6.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "EaseBubbleView.h"

@interface EaseBubbleView (XDCustomCardView)

/**
 *  用户的头像
 */
@property (strong, nonatomic) UIImageView *userHeaderImageView;
/**
 *  用户的昵称
 */
@property (strong, nonatomic) UILabel *userNameLabel;
/**
 *  用户的描述
 */
@property (strong, nonatomic) UILabel *userDesLabel;
///**
// *  分隔线
// */
//@property (strong, nonatomic) UIView  *line;
///**
// *  提示字 “个人名片”
// */
//@property (strong, nonatomic) UILabel *tipsLabel;

- (void)setupBusinessCardBubbleView;

- (void)updateBusinessCardMargin:(UIEdgeInsets)margin;

- (void)_setupConstraintsXX;

@end
