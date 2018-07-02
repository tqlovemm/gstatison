//
//  NoticeFrame.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 16/4/21.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import "NoticeFrame.h"
#import "PushModel.h"

@implementation NoticeFrame

- (void)setNotice:(PushModel *)notice {
    _notice = notice;
    
    // 头像
    CGFloat iconViewWH = 45;
    CGFloat iconViewX = postCellBorder;
    CGFloat iconViewY = postCellBorder;
    _iconViewF = CGRectMake(iconViewX, iconViewY, iconViewWH, iconViewWH);
    
    // 标题
    CGFloat titleLabelX = CGRectGetMaxX(_iconViewF) + postCellBorder;
    CGFloat titleLabelY = iconViewY;
//    CGSize titleLabelSize = [notice.extras.push_title sizeWithFont:postNameFont];
    CGSize titleLabelSize = [notice.push_title sizeWithFont:postNameFont maxW:SCREEN_WIDTH - titleLabelX - 50 - 60];
//    _titleLabelF = (CGRect){{titleLabelX,titleLabelY},titleLabelSize};
    _titleLabelF = CGRectMake(titleLabelX, titleLabelY, titleLabelSize.width, 18);
    // 内容
    CGFloat contentLabelX = titleLabelX;
    CGFloat contentLabelY = CGRectGetMaxY(_titleLabelF) + postCellBorder * 0.5;
    CGSize contentLabelSize = [notice.push_content sizeWithFont:postContentFont maxW:SCREEN_WIDTH - titleLabelX - 30];
    _contentLabelF = (CGRect){{contentLabelX,contentLabelY},contentLabelSize};
    
    // 创建时间
    CGFloat timeLabelY = titleLabelY;
    CGSize timeLabelSize = [[notice getCreateTime] sizeWithFont:postContentFont];
    CGFloat timeLabelX = SCREEN_WIDTH - timeLabelSize.width - postCellBorder;
    _timeLabelF = (CGRect){{timeLabelX,timeLabelY},timeLabelSize};
    
    // 是否已读
    CGFloat readViewY = CGRectGetMaxY(_titleLabelF) + postCellBorder * 0.5;
    CGSize readViewSize = CGSizeMake(10, 10);
    CGFloat readViewX = SCREEN_WIDTH - readViewSize.width - postCellBorder;
    _isReadViewF = (CGRect){{readViewX,readViewY},readViewSize};
    
    _cellHeight = MAX(CGRectGetMaxY(_iconViewF), CGRectGetMaxY(_contentLabelF)) + postCellBorder;
}
@end
