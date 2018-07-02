//
//  XDUnreadPostMessageCell.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 17/3/31.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDUnreadPostMessageCell.h"
#import "XDUnreadPostFrame.h"
#import "XDPostModel.h"
#import "UIImageView+WebCache.h"
#import "XDPhotoModel.h"
#import "XDVerticalAlignmentLabel.h"

@interface XDUnreadPostMessageCell ()

/** 头像 */
@property (nonatomic, weak) UIImageView *iconView;
//! 昵称
@property (nonatomic, weak) UILabel *nameLabel;
//! 时间
@property (nonatomic, weak) UILabel *timeLabel;
//! 评论内容
@property (nonatomic, weak) UILabel *contentLabel;
//! 正文
@property (nonatomic, weak) XDVerticalAlignmentLabel *postContentLabel;
/** 配图 */
@property (nonatomic, weak) UIImageView *picView;
/** 点赞 */
@property (nonatomic, weak) UIImageView *likeView;

@end

@implementation XDUnreadPostMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupSubViews];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setupSubViews {
    // 头像
    UIImageView *iconView = [[UIImageView alloc]init];
    [self.contentView addSubview:iconView];
    self.iconView = iconView;
    
    // 昵称
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.font = [UIFont boldSystemFontOfSize:14];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = RGB(65, 65, 65);
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    // 年龄
    UILabel *timeLabel = [[UILabel alloc]init];
    timeLabel.font = k13Font;
    timeLabel.textColor = RGB(205, 205, 205);
    timeLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    // 评论
    UILabel *contentLabel = [[UILabel alloc]init];
    contentLabel.font = k13Font;
    contentLabel.textColor = RGB(65, 65, 65);
    contentLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:contentLabel];
    self.contentLabel = contentLabel;
    
    // 正文
    XDVerticalAlignmentLabel *postContentLabel = [[XDVerticalAlignmentLabel alloc]init];
    postContentLabel.font = k13Font;
    postContentLabel.textColor = RGB(65, 65, 65);
    postContentLabel.backgroundColor = [UIColor clearColor];
    postContentLabel.numberOfLines = 0;
    postContentLabel.verticalAlignment = myVerticalAlignmentTop;
    [self.contentView addSubview:postContentLabel];
    self.postContentLabel = postContentLabel;
    
    // 配图
    UIImageView *picView = [[UIImageView alloc]init];
    picView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:picView];
    self.picView = picView;
    
    // 点赞
    UIImageView *likeView = [[UIImageView alloc]init];
    [self.contentView addSubview:likeView];
    self.likeView = likeView;
}

- (void)setUnreadThread:(XDUnreadPostFrame *)unreadThread {
    _unreadThread = unreadThread;
    
    XDPostModel *model = unreadThread.model;
    
    [_iconView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    self.iconView.frame = unreadThread.iconViewF;
    self.iconView.layer.cornerRadius = self.iconView.width/2.0;
    self.iconView.layer.masksToBounds = YES;
    
    self.nameLabel.text = model.nickname;
    self.nameLabel.frame = unreadThread.nameLabelF;
    
    self.timeLabel.text = model.created_at;
    self.timeLabel.frame = unreadThread.timeLabelF;
    
    XDPhotoModel *pic = model.imgItemsArray.firstObject;
    [_picView sd_setImageWithURL:[NSURL URLWithString:pic.img_path] placeholderImage:[UIImage imageNamed:@"square_image_placeholder"]];
    self.picView.frame = unreadThread.picViewF;
    
    self.postContentLabel.text = model.unreadContent;
    self.postContentLabel.frame = unreadThread.postContentLabelF;
    
    if (model.imgItemsArray.count > 0 ) {
        self.postContentLabel.hidden = YES;
        self.picView.hidden = NO;
    } else {
        self.postContentLabel.hidden = NO;
        self.picView.hidden = YES;
    }
    
    if (model.content.length > 0) {
        self.contentLabel.text = model.content;
        self.contentLabel.frame = unreadThread.contentLabelF;
        self.likeView.hidden = YES;
        self.contentLabel.hidden = NO;
    } else {
        _likeView.image = [UIImage imageNamed:@"praise_select"];
        self.likeView.frame = unreadThread.likeViewF;
        self.likeView.hidden = NO;
        self.contentLabel.hidden = YES                                                                                   ;
    }
}

@end
