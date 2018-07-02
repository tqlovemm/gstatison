//
//  XDUnreadPostFrame.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 17/3/31.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDUnreadPostFrame.h"
#import "XDPostModel.h"

@implementation XDUnreadPostFrame

- (void)setModel:(XDPostModel *)model {
    _model = model;
    
    // 1.头像
    CGFloat iconViewWH = 50;
    CGFloat iconViewX = postCellBorder;
    CGFloat iconViewY = postCellBorder;
    _iconViewF = CGRectMake(iconViewX, iconViewY, iconViewWH, iconViewWH);
    
    // 3.配图
    CGFloat picViewWH = 75;
    CGFloat picViewX = SCREEN_WIDTH - picViewWH - postCellBorder * 0.5;
    CGFloat picViewY = postCellBorder * 0.5;
    _picViewF = CGRectMake(picViewX, picViewY, picViewWH, picViewWH);
    _postContentLabelF = CGRectMake(picViewX, picViewY, picViewWH, picViewWH);
    
    
    // 2.昵称
    CGFloat nameLabelX = CGRectGetMaxX(_iconViewF) + postCellBorder;
    CGFloat nameLabelY = iconViewY + postCellBorder * 0.5;
    //    CGSize nameLabelSize = [model.nickname sizeWithFont:[UIFont boldSystemFontOfSize:14]];
    CGFloat nameLabelMaxW = SCREEN_WIDTH - 2 * postCellBorder - CGRectGetMaxX(_iconViewF) - picViewWH;
    CGSize nameLabelSize = [model.nickname sizeWithFont:[UIFont boldSystemFontOfSize:14] andMaxSize:CGSizeMake(nameLabelMaxW, 20)];
    _nameLabelF = (CGRect){{nameLabelX,nameLabelY},nameLabelSize};
    
    // 4.帖子的正文内容
    CGFloat contentLabelX = nameLabelX;
    CGFloat contentLabelY = CGRectGetMaxY(_nameLabelF) + 8;
    CGFloat contentLabelMaxW = SCREEN_WIDTH - 2 * postCellBorder - CGRectGetMaxX(_iconViewF) - picViewWH;
    CGSize contentLabelSize = [model.content sizeWithFont:k13Font andMaxSize:CGSizeMake(contentLabelMaxW, 20)];
    _contentLabelF = (CGRect){{contentLabelX,contentLabelY},contentLabelSize};
    
    // 4.喜欢的view
    CGFloat likeViewWH = 15;
    CGFloat likeViewX = nameLabelX;
    CGFloat likeViewY = CGRectGetMaxY(_nameLabelF) + 8;
    _likeViewF = CGRectMake(likeViewX, likeViewY, likeViewWH, likeViewWH);
    
    // 5.时间
    CGFloat timeLabelX = contentLabelX;
    CGFloat timeLabelY = 0;
    if (model.content) {
        timeLabelY = CGRectGetMaxY(_contentLabelF) + postCellBorder * 0.5;
    } else {
        timeLabelY = CGRectGetMaxY(_likeViewF) + postCellBorder * 0.5;
    }
    CGSize timeLabelSize = [model.created_at sizeWithFont:k13Font];
    _timeLabelF = (CGRect){{timeLabelX,timeLabelY},timeLabelSize};
    
    _cellHeight = MAX(CGRectGetMaxY(_picViewF), CGRectGetMaxY(_timeLabelF)) + postCellBorder * 0.5;
}

@end
