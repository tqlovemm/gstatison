//
//  XDCustomGiftCell.m
//  ThirteenmakeFriends
//
//  Created by 空谷凌虚 on 2018/5/22.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import "XDCustomGiftCell.h"

#import "UIImageView+EMWebCache.h"
#import "EaseBubbleView+XDCustomGiftsView.h"
#import "XDGiftItemModel.h"
#import "IConversationModel.h"
static const CGFloat kCellHeight = 116.0f;

@implementation XDCustomGiftCell

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
    [_bubbleView setupBusinessGiftBubbleView];
    
    _bubbleView.imageView.image = [UIImage imageNamed:@"imageDownloadFail"];
}

- (void)updateCustomBubbleViewMargin:(UIEdgeInsets)bubbleMargin model:(id<IMessageModel>)model
{
    [_bubbleView updateBusinessGiftMargin:bubbleMargin];
    _bubbleView.translatesAutoresizingMaskIntoConstraints = YES;
    
    CGFloat bubbleViewHeight = 90;// 气泡背景图高度
    CGFloat nameLabelHeight = 15;// 昵称label的高度
    
    if (model.isSender) {
        _bubbleView.frame =
        CGRectMake([UIScreen mainScreen].bounds.size.width - 273.5, nameLabelHeight, 213, bubbleViewHeight);
    }else{
        _bubbleView.frame = CGRectMake(55, nameLabelHeight, 213, bubbleViewHeight);
        
    }
    // 这里强制调用内部私有方法
    [_bubbleView _setupGiftConstraintsXX];
    
}

+ (NSString *)cellIdentifierWithModel:(id<IMessageModel>)model
{
    return model.isSender ? @"XDCustomGiftCellSendIdentifier" : @"XDCustomGiftCellReceiveIdentifier";
}

+ (CGFloat)cellHeightWithModel:(id<IMessageModel>)model
{
    return kCellHeight;
}

- (void)setModel:(id<IMessageModel>)model
{
    [super setModel:model];
    
    NSDictionary *dict = model.message.ext;
    if (model.isSender) {
            self.bubbleView.userNameLabel.text = [NSString stringWithFormat:@"送%@ %@",model.message.to,dict[@"name"]];
    }else{
            self.bubbleView.userNameLabel.text = [NSString stringWithFormat:@"送你 %@",dict[@"name"]];
    }

    self.bubbleView.userDesLabel.text  = [NSString stringWithFormat:@"%@%@",dict[@"price"],diamonds_name];
    [self.bubbleView.userHeaderImageView sd_setImageWithURL:[NSURL URLWithString:dict[@"imgurl"]] placeholderImage:[UIImage imageNamed:@"square_image_placeholder"]];
//    if (self.model.isSender) {
//        self.bubbleView.userNameLabel.text = [NSString stringWithFormat:@"送给%@",dict[@"name"]];
//        self.bubbleView.userDesLabel.text  = [NSString stringWithFormat:@"%@",dict[@"price"]];
//    }
    _hasRead.hidden = YES;//名片消息不显示已读
    //    _nameLabel = nil;// 不显示姓名
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSString *imageName = self.model.isSender ? @"custom_chat_sender_bg_white" : @"custom_chat_receiver_bg";
    
    UIImage *image = self.model.isSender ? [[UIImage imageNamed:imageName] stretchableImageWithLeftCapWidth:30 topCapHeight:30] :
    [[UIImage imageNamed:imageName] stretchableImageWithLeftCapWidth:20 topCapHeight:35];
    self.bubbleView.backgroundImageView.image = image;
}

@end
