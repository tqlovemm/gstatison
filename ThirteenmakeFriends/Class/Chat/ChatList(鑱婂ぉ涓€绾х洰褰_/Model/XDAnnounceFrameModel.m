//
//  XDAnnounceFrameModel.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/7/25.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDAnnounceFrameModel.h"
#import "PushModel.h"

@implementation XDAnnounceFrameModel

- (void)setNotice:(PushModel *)notice {
    _notice = notice;
    
    // 头像
    CGFloat iconViewWH = 50;
    CGFloat iconViewX = postCellBorder;
    CGFloat iconViewY = 15;
    _iconViewF = CGRectMake(iconViewX, iconViewY, iconViewWH, iconViewWH);
    
    // 标题
    CGFloat titleLabelX = CGRectGetMaxX(_iconViewF) + postCellBorder;
    CGFloat titleLabelY = iconViewY;
    CGSize titleLabelSize = [notice.push_title sizeWithFont:kPingFangBoldFont(14) maxW:SCREEN_WIDTH - titleLabelX - 50];
    _titleLabelF = CGRectMake(titleLabelX, titleLabelY, titleLabelSize.width, 18);
    // 内容
    CGFloat contentLabelX = titleLabelX;
    CGFloat contentLabelY = CGRectGetMaxY(_titleLabelF) + 5;
    CGSize contentLabelSize = [notice.push_content sizeWithFont:kPingFangRegularFont(13) andMaxSize:CGSizeMake(SCREEN_WIDTH - titleLabelX - 30, 40)];
    _contentLabelF = (CGRect){{contentLabelX,contentLabelY},contentLabelSize};
    
    // 是否已读
    CGFloat readViewY = CGRectGetMaxY(_titleLabelF) + postCellBorder * 0.5;
    CGSize readViewSize = CGSizeMake(10, 10);
    CGFloat readViewX = SCREEN_WIDTH - readViewSize.width - postCellBorder;
    _isReadViewF = (CGRect){{readViewX,readViewY},readViewSize};
    
    // 创建时间
    CGFloat timeLabelX = contentLabelX;
    CGFloat timeLabelY = CGRectGetMaxY(_contentLabelF) + 5;
    CGSize timeLabelSize = [[notice getCreateTime] sizeWithFont:kPingFangRegularFont(12)];
    _timeLabelF = (CGRect){{timeLabelX,timeLabelY},timeLabelSize};
    
    _cellHeight = MAX(CGRectGetMaxY(_iconViewF), CGRectGetMaxY(_timeLabelF)) + postCellBorder;
}

@end
