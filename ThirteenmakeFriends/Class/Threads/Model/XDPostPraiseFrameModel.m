//
//  XDPostPraiseFrameModel.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 17/5/15.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDPostPraiseFrameModel.h"
#import "XDPostPraiseModel.h"

@implementation XDPostPraiseFrameModel

- (void)setPraiseModel:(XDPostPraiseModel *)praiseModel {
    _praiseModel = praiseModel;
    
    // 1.头像
    CGFloat iconViewWH = 65;
    CGFloat iconViewX = postCellBorder;
    CGFloat iconViewY = postCellBorder;
    _iconViewF = CGRectMake(iconViewX, iconViewY, iconViewWH, iconViewWH);
    
    // 2.昵称
    CGFloat nameLabelX = CGRectGetMaxX(_iconViewF) + postCellBorder;
    CGFloat nameLabelY = iconViewY + postCellBorder * 0.5;
    CGSize nameLabelSize = [praiseModel.nickname sizeWithFont:k14Font];
    _nameLabelF = (CGRect){{nameLabelX,nameLabelY},nameLabelSize};
    
    // 3.年龄
    CGFloat ageLabelX = nameLabelX;
    CGFloat ageLabelY = CGRectGetMaxY(_nameLabelF) + 8;
    
    NSString *ageLab = praiseModel.age == 0 ? [NSString stringWithFormat:@"%@ %ldcm/%ldkg",praiseModel.address,praiseModel.height,praiseModel.weight] : [NSString stringWithFormat:@"%@ %ld岁 %ldcm/%ldkg",praiseModel.address,praiseModel.age,praiseModel.height,praiseModel.weight];
    CGSize ageLabelSize = [ageLab sizeWithFont:k13Font];
    _ageLabelF = (CGRect) {{ageLabelX,ageLabelY} ,ageLabelSize};
    
    // 4.帖子的正文内容
    CGFloat contentLabelX = nameLabelX;
    CGFloat contentLabelY = CGRectGetMaxY(_ageLabelF) + 8;
    CGFloat contentLabelMaxW = SCREEN_WIDTH - 2 * postCellBorder - CGRectGetMaxX(_iconViewF);
    NSString *contentLab = [NSString stringWithFormat:@"%ld条动态",praiseModel.thread_count];
    CGSize contentLabelSize = [contentLab sizeWithFont:postContentFont maxW:contentLabelMaxW];
    _contentLabelF = (CGRect){{contentLabelX,contentLabelY},contentLabelSize};
    
    _cellHeight = MAX(CGRectGetMaxY(_contentLabelF), CGRectGetMaxY(_iconViewF)) + postCellBorder;
}

@end
