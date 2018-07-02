//
//  NoticeMessageCell.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 16/4/21.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import "NoticeMessageCell.h"
#import "UIImageView+WebCache.h"
#import "PushModel.h"

@interface NoticeMessageCell ()

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

@implementation NoticeMessageCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    // 创建cell
    static NSString *ID = @"NoticeMessageCell";
    NoticeMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if(cell == nil)
    {
        cell = [[NoticeMessageCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        // 取消cell选中背景
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // 创建cell内部子控件
        [self setupSubViews];
        
        UILongPressGestureRecognizer *longPressGR = [[ UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        longPressGR.minimumPressDuration = 0.7;
        [self addGestureRecognizer:longPressGR];
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
    titleLabel.font = postNameFont;
    titleLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:titleLabel];
    self.pushtitleLabel = titleLabel;
    
    // 内容
    UILabel *contentLabel = [[UILabel alloc]init];
    contentLabel.font = postContentFont;
    contentLabel.textColor = RGB(135, 135, 135);
    contentLabel.backgroundColor = [UIColor clearColor];
    contentLabel.numberOfLines = 0;
    [self.contentView addSubview:contentLabel];
    self.contentLabel = contentLabel;
    
    // 时间
    UILabel *timeLabel = [[UILabel alloc]init];
    timeLabel.font = postContentFont;
    timeLabel.textColor = RGB(39, 39, 39);
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.numberOfLines = 0;
    timeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    // 是否阅读
    UIImageView *isReadView = [[UIImageView alloc]init];
    [self.contentView addSubview:isReadView];
    self.isReadView = isReadView;
    
}

- (void)setNoticeFrame:(NoticeFrame *)noticeFrame {
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

-(BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if(action == @selector(delete:))
    {
        return YES;
    }
    else
    {
        return [super canPerformAction:action withSender:sender];  
    }  
}

- (void)delete:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(deleteRow:)]) {
        [self.delegate deleteRow:self];
    }
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)recognizer
{
    if([self isHighlighted])
    {
        if ([self.delegate respondsToSelector:@selector(showMenu:)]) {
            [self.delegate showMenu:self];
        }
    }
    
}

@end
