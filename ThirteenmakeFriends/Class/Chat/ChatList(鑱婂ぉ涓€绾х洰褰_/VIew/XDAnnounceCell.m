//
//  XDAnnounceCell.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/7/25.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDAnnounceCell.h"
#import "UIImageView+WebCache.h"
#import "XDAnnounceFrameModel.h"
#import "PushModel.h"

@interface XDAnnounceCell ()

//! 图标
@property (nonatomic, weak) UIImageView * iconView;

//! 标题
@property (nonatomic, weak) UILabel *pushtitleLabel;
//! 内容
@property (nonatomic, weak) UILabel *contentLabel;
//! 是否已读
@property (nonatomic, weak) UIImageView *isReadView;

//! 创建时间
@property (nonatomic, weak) UILabel *timeLabel;

@end

@implementation XDAnnounceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        // 取消cell选中背景
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // 创建cell内部子控件
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    // 头像
    UIImageView *iconView = [[UIImageView alloc]init];
    [self.contentView addSubview:iconView];
    self.iconView = iconView;
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = kPingFangBoldFont(14);
    titleLabel.textColor = RGB(65, 65, 65);
    titleLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:titleLabel];
    self.pushtitleLabel = titleLabel;
    
    // 内容
    UILabel *contentLabel = [[UILabel alloc]init];
    contentLabel.font = kPingFangRegularFont(13);
    contentLabel.textColor = RGB(159, 159, 159);
    contentLabel.backgroundColor = [UIColor clearColor];
    contentLabel.numberOfLines = 0;
    [self.contentView addSubview:contentLabel];
    self.contentLabel = contentLabel;
    
    // 时间
    UILabel *timeLabel = [[UILabel alloc]init];
    timeLabel.font = kPingFangRegularFont(12);
    timeLabel.textColor = RGB(159, 159, 159);
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    // 是否阅读
    UIImageView *isReadView = [[UIImageView alloc]init];
    [self.contentView addSubview:isReadView];
    self.isReadView = isReadView;
    
}

- (void)setNoticeFrame:(XDAnnounceFrameModel *)noticeFrame {
    _noticeFrame = noticeFrame;
    
    PushModel *notice = noticeFrame.notice;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:notice.icon] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    self.iconView.frame = noticeFrame.iconViewF;
    self.iconView.layer.cornerRadius = self.iconView.width/2.0;
    self.iconView.layer.masksToBounds = YES;
    
    self.pushtitleLabel.text = notice.push_title;
    self.pushtitleLabel.frame = noticeFrame.titleLabelF;
    
    self.contentLabel.text = notice.push_content;
    self.contentLabel.frame = noticeFrame.contentLabelF;
    
    if(notice.is_read == 0) {
        self.isReadView.hidden = NO;
        self.isReadView.frame = noticeFrame.isReadViewF;
        self.isReadView.image = [UIImage imageNamed:@"MyCard_Reddot"];
        
    } else {
        self.isReadView.hidden = YES;
    }
    
    self.timeLabel.text = [notice getCreateTime];
    self.timeLabel.frame = noticeFrame.timeLabelF;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    // 创建cell
    static NSString *ID = @"XDAnnounceCellID";
    XDAnnounceCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if(cell == nil)
    {
        cell = [[XDAnnounceCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

@end
