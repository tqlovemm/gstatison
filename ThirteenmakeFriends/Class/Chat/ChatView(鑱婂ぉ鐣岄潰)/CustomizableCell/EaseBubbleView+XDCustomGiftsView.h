//
//  EaseBubbleView+XDCustomGiftsView.h
//  ThirteenmakeFriends
//
//  Created by 空谷凌虚 on 2018/5/22.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import "EaseBubbleView.h"

@interface EaseBubbleView (XDCustomGiftsView)

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
/**
 *  分隔线
 */
@property (strong, nonatomic) UIView  *line;
/**
 *  提示字 “送礼给TA”
 */
@property (strong, nonatomic) UILabel *tipsLabel;
@property (strong, nonatomic) UIImageView *rightImageView;

- (void)setupBusinessGiftBubbleView;

- (void)updateBusinessGiftMargin:(UIEdgeInsets)margin;

- (void)_setupGiftConstraintsXX;

@end
