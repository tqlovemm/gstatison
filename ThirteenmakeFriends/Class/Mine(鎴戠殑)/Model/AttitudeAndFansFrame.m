//
//  AttitudeAndFansFrame.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 15/12/31.
//  Copyright © 2015年 ThirtyOneDay. All rights reserved.
//

#import "AttitudeAndFansFrame.h"
#import "ShiSanUser.h"

@implementation AttitudeAndFansFrame

- (void)setUser:(ShiSanUser *)user {
    _user = user;
    
    // 1.头像
    CGFloat iconViewWH = 45;
    CGFloat iconViewX = postCellBorder;
    CGFloat iconViewY = postCellBorder;
    _iconViewF = CGRectMake(iconViewX, iconViewY, iconViewWH, iconViewWH);
    
    // 2.关注按钮
    CGFloat postBtnW = 57;
    CGFloat postBtnX = SCREEN_WIDTH - postBtnW - postCellBorder;
    CGFloat postBtnY = postCellBorder;
    CGFloat postBtnH = 23;
    _isAttitudeF = CGRectMake(postBtnX, postBtnY, postBtnW, postBtnH);
    
    // 3.昵称
    CGFloat nameLabelX = CGRectGetMaxX(_iconViewF) + postCellBorder;
    CGFloat nameLabelY = iconViewY;
    CGSize nameLabelSize = [user.nickname sizeWithFont:postNameFont maxW:SCREEN_WIDTH - CGRectGetMaxX(_iconViewF) - postBtnW - postCellBorder];
    _nameLabelF = (CGRect){{nameLabelX,nameLabelY},nameLabelSize};
    
    // 4.自我介绍
    CGFloat introX = nameLabelX;
    CGFloat introY = CGRectGetMaxY(_nameLabelF) + postCellBorder * 0.5;
    CGSize introSize = [user.signature sizeWithFont:postContentFont andMaxSize:CGSizeMake(SCREEN_WIDTH - CGRectGetMaxX(_iconViewF) - postCellBorder, MAXFLOAT)];
    _selfIntroLabelF = (CGRect){{introX,introY},introSize};
    
    _cellHeight = MAX(CGRectGetMaxY(_selfIntroLabelF), CGRectGetMaxY(_iconViewF)) + postCellBorder;
}

@end
