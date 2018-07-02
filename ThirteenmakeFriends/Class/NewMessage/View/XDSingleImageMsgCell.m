//
//  XDSingleImageMsgCell.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2018/1/26.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import "XDSingleImageMsgCell.h"
#import "XDMsgCategoryModel.h"
#import "XDPhotoBrowser.h"

#define kMaxChatImageViewWidth 200.f
#define kMaxChatImageViewHeight 300.f
#define kMaxLabelWidth (SCREEN_WIDTH - 85)

@interface XDSingleImageMsgCell ()<MLEmojiLabelDelegate>

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, weak) UIImageView *iconImageView;
@property (nonatomic, weak) UIView *container;
@property (nonatomic, weak) MLEmojiLabel *label;
@property (nonatomic, weak) UIImageView *messageImageView;
@property (nonatomic, weak) UIImageView *containerBackgroundImageView;
@property (nonatomic, strong) UIImageView *maskImageView;

@end

@implementation XDSingleImageMsgCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    // 创建cell
    static NSString *ID = @"XDSingleImageMsgCellID";
    XDSingleImageMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if(cell == nil)
    {
        cell = [[XDSingleImageMsgCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self xdd_setupView];
    }
    return self;
}

- (void)xdd_setupView
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    
    self.timeLabel = [UILabel new];
    self.timeLabel.font = kPingFangRegularFont(12);
    self.timeLabel.textColor = RGB(170, 170, 170);
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.timeLabel];
    
    UIImageView *iconImageView = [UIImageView new];
    [self.contentView addSubview:iconImageView];
    self.iconImageView = iconImageView;
    
    UIView *container = [UIView new];
    [self.contentView addSubview:container];
    self.container = container;
    
    MLEmojiLabel *label = [MLEmojiLabel new];
    label.delegate = self;
    label.font = [UIFont systemFontOfSize:16.0f];
    label.numberOfLines = 0;
    label.textInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.container addSubview:label];
    self.label = label;
    
    UIImageView *messageImageView = [UIImageView new];
    messageImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.container addSubview:messageImageView];
    self.messageImageView = messageImageView;
    
    UIImageView *containerBackgroundImageView = [UIImageView new];
    containerBackgroundImageView.image = [[UIImage imageNamed:@"custom_chat_receiver_bg"] stretchableImageWithLeftCapWidth:20 topCapHeight:35];
    [self.container insertSubview:containerBackgroundImageView atIndex:0];
    self.containerBackgroundImageView = containerBackgroundImageView;
    
    self.maskImageView = [UIImageView new];
    self.maskImageView.image = self.containerBackgroundImageView.image;
    
    [self.containerBackgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(self.container);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.contentView).offset(10);
        make.width.lessThanOrEqualTo(@(300));
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(35, 35));
//        make.left.top.mas_equalTo(10);
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(self.timeLabel.mas_bottom).offset(10);
    }];
    
    [self.container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconImageView);
        make.left.mas_equalTo(self.iconImageView.mas_right).offset(10);
        make.bottom.mas_equalTo(self.contentView).offset(-10);
    }];
    
    self.messageImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageviewTapped:)];
    [self.messageImageView addGestureRecognizer:tap];
}

- (void)setModel:(XDNewMessageModel *)model
{
    _model = model;
    
    self.timeLabel.text = [model getMessageTimeWithCreate_at:model.created_at];
    
    self.label.text = model.msg_description;
//    self.iconImageView.image = [UIImage imageNamed:@"syytem_notice"];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.from_user_url] placeholderImage:[UIImage imageNamed:@"square_image_placeholder"]];
    
    if (model.template_id == 21) { // 有图片的先看下设置图片自动布局
        
        self.messageImageView.hidden = NO;
        
        [self.messageImageView sd_setImageWithURL:[NSURL URLWithString:model.imageModel.img_url] placeholderImage:[UIImage imageNamed:@"square_image_placeholder"]];
        
        // 根据图片的宽高尺寸设置图片约束
        CGFloat standardWidthHeightRatio = kMaxChatImageViewWidth / kMaxChatImageViewHeight;
        CGFloat widthHeightRatio = 0;
        CGFloat h = model.imageModel.height;
        CGFloat w = model.imageModel.width;
        
        if (w > kMaxChatImageViewWidth || w > kMaxChatImageViewHeight) {
            
            widthHeightRatio = w / h;
            
            if (widthHeightRatio > standardWidthHeightRatio) {
                w = kMaxChatImageViewWidth;
                h = w * (model.imageModel.height / model.imageModel.width);
            } else {
                h = kMaxChatImageViewHeight;
                w = h * widthHeightRatio;
            }
        }
        
        self.messageImageView.size = CGSizeMake(w, h);
        
        [self.container mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.iconImageView);
            make.left.mas_equalTo(self.iconImageView.mas_right).offset(10);
            make.bottom.mas_equalTo(self.contentView).offset(-10);
            make.width.mas_equalTo(w).priority(999);
            make.height.mas_equalTo(h).priority(999);
        }];
        
        [self.containerBackgroundImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.mas_equalTo(self.container);
        }];
        
        self.maskImageView.size = self.messageImageView.size;
        // container按照containerBackgroundImageView裁剪
//        self.container.layer.mask = self.containerBackgroundImageView.layer;
        // container按照maskImageView裁剪
        self.container.layer.mask = self.maskImageView.layer;
    }
    else if (model.template_id == 11 || model.template_id == 12) { // 没有图片有文字情况下设置文字自动布局
        
        // 清除展示图片时候用到的mask
        [self.container.layer.mask removeFromSuperlayer];
        self.container.layer.mask = nil;
        self.maskImageView.frame = CGRectZero;
        self.messageImageView.hidden = YES;
        
        [self.label mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.container).offset(15);
            make.top.mas_equalTo(self.container).offset(8);
            make.width.lessThanOrEqualTo(@(kMaxLabelWidth));
        }];
        
        [self.container mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.iconImageView);
            make.left.mas_equalTo(self.iconImageView.mas_right).offset(10);
            make.bottom.mas_equalTo(self.contentView).offset(-10);
//            make.width.mas_equalTo(self.label.mas_width).offset(25);
//            make.height.mas_equalTo(self.label.mas_height).offset(18);
            make.right.mas_equalTo(self.label.mas_right).offset(10);
            make.bottom.mas_equalTo(self.label).offset(10);
        }];
        
        [self.containerBackgroundImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.mas_equalTo(self.container);
        }];
    }
}

#pragma mark - MLEmojiLabelDelegate

- (void)mlEmojiLabel:(MLEmojiLabel *)emojiLabel didSelectLink:(NSString *)link withType:(MLEmojiLabelLinkType)type
{
    if (self.didSelectLinkTextOperationBlock) {
        self.didSelectLinkTextOperationBlock(link, type);
    }
}

- (void)imageviewTapped:(UITapGestureRecognizer *)tap {
    [[XDPhotoBrowser defaultManager] showBrowserWithImages:@[self.model.imageModel.img_url] andCurrentIndex:0 fromImageContainer:tap.view];
}

@end
