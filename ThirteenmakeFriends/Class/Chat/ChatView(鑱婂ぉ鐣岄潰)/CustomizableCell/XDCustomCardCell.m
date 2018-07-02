//
//  XDCustomCardCell.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/11/6.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDCustomCardCell.h"
#import "UIImageView+EMWebCache.h"
#import "EaseBubbleView+XDCustomCardView.h"

static const CGFloat kCellHeight = 116.0f;

@implementation XDCustomCardCell

+ (void)initialize
{
    // UIAppearance Proxy Defaults
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier model:(id<IMessageModel>)model
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier model:model];

    if (self) {
        self.hasRead.hidden = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    return self;
}

- (BOOL)isCustomBubbleView:(id<IMessageModel>)model
{
    return YES;
}

- (void)setCustomModel:(id<IMessageModel>)model
{
    UIImage *image = model.image;
    if (!image) {
        [self.bubbleView.imageView sd_setImageWithURL:[NSURL URLWithString:model.fileURLPath] placeholderImage:[UIImage imageNamed:model.failImageName]];
    } else {
        _bubbleView.imageView.image = image;
    }
    
    if (model.avatarURLPath) {
        [self.avatarView sd_setImageWithURL:[NSURL URLWithString:model.avatarURLPath] placeholderImage:model.avatarImage];
    } else {
        self.avatarView.image = model.avatarImage;
    }
}

- (void)setCustomBubbleView:(id<IMessageModel>)model
{
    [_bubbleView setupBusinessCardBubbleView];
    
    _bubbleView.imageView.image = [UIImage imageNamed:@"imageDownloadFail"];
}

- (void)updateCustomBubbleViewMargin:(UIEdgeInsets)bubbleMargin model:(id<IMessageModel>)model
{
    [_bubbleView updateBusinessCardMargin:bubbleMargin];
    _bubbleView.translatesAutoresizingMaskIntoConstraints = YES;
    
    CGFloat bubbleViewHeight = 90;// 气泡背景图高度
    CGFloat nameLabelHeight = 15;// 昵称label的高度
    
    if (model.isSender) {
        _bubbleView.frame =
        CGRectMake([UIScreen mainScreen].bounds.size.width - 273.5, nameLabelHeight, 213, bubbleViewHeight);
//        self.bubbleView.userHeaderImageView.frame = CGRectMake(13, 19, 26, 34);
//        self.bubbleView.userNameLabel.frame = CGRectMake(48, 19, 156, 15);
//        self.bubbleView.userPhoneLabel.frame = CGRectMake(48, 41, 49, 12);
//        self.bubbleView.line.frame = CGRectMake(13, 73, 200, 1);
//        self.bubbleView.tipsLabel.frame = CGRectMake(145, 73, 80, 20);
    }else{
        _bubbleView.frame = CGRectMake(55, nameLabelHeight, 213, bubbleViewHeight);
//        self.bubbleView.userHeaderImageView.frame = CGRectMake(20, 19, 26, 34);
//        self.bubbleView.userNameLabel.frame = CGRectMake(55, 19, 156, 15);
//        self.bubbleView.userPhoneLabel.frame = CGRectMake(55, 41, 49, 12);
//        self.bubbleView.line.frame = CGRectMake(20, 73, 200, 1);
//        self.bubbleView.tipsLabel.frame = CGRectMake(152, 73, 80, 20);
        
    }
    // 这里强制调用内部私有方法
    [_bubbleView _setupConstraintsXX];
    
}

+ (NSString *)cellIdentifierWithModel:(id<IMessageModel>)model
{
    return model.isSender ? @"XDCustomCardCellSendIdentifier" : @"XDCustomCardCellReceiveIdentifier";
}

+ (CGFloat)cellHeightWithModel:(id<IMessageModel>)model
{
    return kCellHeight;
}

- (void)setModel:(id<IMessageModel>)model
{
    [super setModel:model];
    
    NSDictionary *dict = model.message.ext;
    
    self.bubbleView.userNameLabel.text = dict[KEM_Custom_Message_userName];
    self.bubbleView.userDesLabel.text = dict[KEM_Custom_Message_cardUserDes];
    [self.bubbleView.userHeaderImageView sd_setImageWithURL:[NSURL URLWithString:dict[KEM_Custom_Message_cardUserPic]] placeholderImage:[UIImage imageNamed:@"square_image_placeholder"]];

    _hasRead.hidden = YES;//名片消息不显示已读
    //    _nameLabel = nil;// 不显示姓名
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSString *imageName = self.model.isSender ? @"custom_chat_sender_bg_white" : @"custom_chat_receiver_bg";
    
    UIImage *image = self.model.isSender ? [[UIImage imageNamed:imageName] stretchableImageWithLeftCapWidth:30 topCapHeight:35] :
    [[UIImage imageNamed:imageName] stretchableImageWithLeftCapWidth:20 topCapHeight:35];
    // 等待接入名片的背景图片
    self.bubbleView.backgroundImageView.image = image;
}

@end
