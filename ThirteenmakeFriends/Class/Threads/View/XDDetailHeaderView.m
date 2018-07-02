//
//  XDDetailHeaderView.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 17/3/29.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDDetailHeaderView.h"
#import "XDPostFrameModel.h"
#import "XDPostModel.h"
#import "XDPostPhotoView.h"
#import "XDPostsTopicView.h"
#import "XDPostPraiseView.h"
#import "XDPhotoBrowser.h"
//#import "XDOtherViewController.h"
#import "UILabel+XDCopy.h"

#define margin 10

@implementation XDDetailHeaderView
{
    UIImageView *_iconView;
    UILabel *_nameLable;
    UILabel *_addressLabel;
    UIImageView *_addressView;
    UILabel *_contentLabel;
    UIImageView *_attentionView;
    XDPostPhotoView *_picView;
    XDPostsTopicView *_topicView;
    XDPostPraiseView *_praiseView;
    UILabel *_timeLabel;
    UIImageView *_timeView;
    UIButton *_praiseButton;
    UIButton *_commentButton;
    UIButton *_otherButton;
    UIImageView *_sexView;
    UIImageView *_vipView;
    UIImageView *_is_topView;
    UIView *_lineView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    _iconView = [UIImageView new];
    _iconView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headIconBtnClicked:)];
    [_iconView addGestureRecognizer:tap];
    [self addSubview:_iconView];
    
    _nameLable = [UILabel new];
    _nameLable.font = k13Font;
    _nameLable.textColor = RGB(65, 65, 65);
    [self addSubview:_nameLable];
    
    _attentionView = [[UIImageView alloc] init];
    _attentionView.userInteractionEnabled = YES;
    [self addSubview:_attentionView];

    UITapGestureRecognizer *attentionTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(attentionViewClicked:)];
    [_attentionView addGestureRecognizer:attentionTap];
    
    _sexView = [UIImageView new];
    [self addSubview:_sexView];
    
    _vipView = [UIImageView new];
    [self addSubview:_vipView];
    
    _is_topView = [UIImageView new];
    [self addSubview:_is_topView];
    
    _addressLabel = [[UILabel alloc] init];
    _addressLabel.font = [UIFont systemFontOfSize:10];
    _addressLabel.textColor = RGB(119, 119, 119);
    [self addSubview:_addressLabel];
    
    _addressView = [UIImageView new];
    _addressView.image = [UIImage imageNamed:@"send_location"];
    [self addSubview:_addressView];
    
    _contentLabel = [UILabel new];
    _contentLabel.isCopyable = YES;
    _contentLabel.font = [UIFont systemFontOfSize:14];
    _contentLabel.textColor = RGB(65, 65, 65);
    _contentLabel.numberOfLines = 0;
    [self addSubview:_contentLabel];
    
    _picView = [[XDPostPhotoView alloc] init];
    [self addSubview:_picView];
    
    _topicView = [[XDPostsTopicView alloc] init];
    [self addSubview:_topicView];
    
    _praiseView = [[XDPostPraiseView alloc] init];
    [self addSubview:_praiseView];
    
    _praiseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_praiseButton setImage:[UIImage imageNamed:@"post_unlike"] forState:UIControlStateNormal];
    [_praiseButton setImage:[UIImage imageNamed:@"post_like"] forState:UIControlStateSelected];
    [_praiseButton addTarget:self action:@selector(praiseButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_praiseButton];
    
    _commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_commentButton setImage:[UIImage imageNamed:@"thread_comment"] forState:UIControlStateNormal];
    [_commentButton setTitle:@"评论" forState:UIControlStateNormal];
    [_commentButton setTitleColor:RGB(190, 190, 190) forState:UIControlStateNormal];
    [_commentButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [_commentButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [_commentButton setBackgroundImage:[UIImage resizedImage:@"timeline_card_bottom_background_highlighted"] forState:UIControlStateHighlighted];
    [_commentButton addTarget:self action:@selector(commentButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    _commentButton.layer.cornerRadius = 2.0f;
    _commentButton.layer.borderWidth = 0.5;
    _commentButton.layer.borderColor = RGB(190, 190, 190).CGColor;
    _commentButton.layer.masksToBounds = YES;
    [self addSubview:_commentButton];
    
    _otherButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_otherButton setImage:[UIImage imageNamed:@"thread_more"] forState:UIControlStateNormal];
    [_otherButton addTarget:self action:@selector(otherButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_otherButton];
    
    _timeLabel = [UILabel new];
    _timeLabel.textColor = RGB(119, 119, 119);
    _timeLabel.font = [UIFont systemFontOfSize:10];
    [self addSubview:_timeLabel];
    
    _timeView = [UIImageView new];
    _timeView.image = [UIImage imageNamed:@"time_thread"];
    [self addSubview:_timeView];
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = RGB(230, 230, 230);
    [self addSubview:_lineView];
}

- (void)setModel:(XDPostModel *)model {
    _model = model;
    
    CGFloat iconViewWH = 40;
    CGFloat iconViewX = margin;
    CGFloat iconViewY = margin;
    _iconView.frame = CGRectMake(iconViewX, iconViewY, iconViewWH, iconViewWH);
    
    CGFloat nameLabelX = nameLabelX = CGRectGetMaxX(_iconView.frame) + margin;
    CGFloat nameLabelY = iconViewY + 4;
    CGSize nameLabelSize = [model.nickname sizeWithFont:k13Font andMaxSize:CGSizeMake(150, 16)];
    _nameLable.frame = (CGRect){{nameLabelX,nameLabelY},nameLabelSize};
    
    CGFloat sexViewX = CGRectGetMaxX(_nameLable.frame) + 5;
    CGFloat sexViewY = nameLabelY;
    CGFloat sexViewWH = 16;
    
    if (model.sex == 1 || model.sex == 0) {
        _sexView.frame = CGRectMake(sexViewX, sexViewY, sexViewWH, sexViewWH);
    } else {
        _sexView.frame = CGRectMake(sexViewX, sexViewY, 0, 0);
    }
    
    if (model.sex == 1) {
        if (model.is_renzheng == 1) {
            CGFloat vipViewX = CGRectGetMaxX(_sexView.frame) + 5;
            CGFloat vipViewY = sexViewY;
            CGFloat vipViewH = 16;
            CGFloat vipViewW = 52;
            _vipView.frame = CGRectMake(vipViewX, vipViewY, vipViewW, vipViewH);
        } else {
            _vipView.frame = CGRectMake(CGRectGetMaxX(_sexView.frame), sexViewY, 0, 0);
        }
    } else {
        if (model.groupid > 1) {// 会员等级判断
            CGFloat vipViewX = CGRectGetMaxX(_sexView.frame) + 5;
            CGFloat vipViewY = sexViewY;
            CGFloat vipViewWH = 16;
            _vipView.frame = CGRectMake(vipViewX, vipViewY, vipViewWH, vipViewWH);
        } else {
            _vipView.frame = CGRectMake(CGRectGetMaxX(_sexView.frame), sexViewY, 0, 0);
        }
    }
    
    CGFloat topViewW = 33;
    CGFloat topViewH = 14;
    CGFloat topViewX = CGRectGetMaxX(_vipView.frame) + 5;
    CGFloat topViewY = sexViewY + 2;
    _is_topView.frame = CGRectMake(topViewX, topViewY, topViewW, topViewH);
    
    if (model.address.length > 0) {
        CGFloat addressViewX = nameLabelX - 2;
        CGFloat addressViewY = CGRectGetMaxY(_nameLable.frame) + 5;
        CGFloat addressViewWH = 14;
        _addressView.frame = CGRectMake(addressViewX, addressViewY, addressViewWH, addressViewWH);
        
        CGSize addressLabelSize = [model.address sizeWithFont:[UIFont systemFontOfSize:10]];
        CGFloat addressLabelX = CGRectGetMaxX(_addressView.frame);
        CGFloat addressLabelY = addressViewY + 2;
        _addressLabel.frame = (CGRect){{addressLabelX,addressLabelY},addressLabelSize};
        
        CGFloat timeViewWH = 10;
        CGFloat timeViewX = CGRectGetMaxX(_addressLabel.frame) + 8;
        CGFloat timeViewY = addressLabelY + 1.5;
        _timeView.frame = CGRectMake(timeViewX, timeViewY, timeViewWH, timeViewWH);
        
        CGFloat timeLabelY = addressLabelY;
        CGSize timeLabelSize = [model.created_at sizeWithFont:[UIFont systemFontOfSize:10.0f]];
        CGFloat timeLabelX = CGRectGetMaxX(_timeView.frame) + 2;
        _timeLabel.frame = (CGRect){{timeLabelX,timeLabelY},timeLabelSize};
    } else {
        CGFloat addressViewX = nameLabelX - 2;
        CGFloat addressViewY = CGRectGetMaxY(_nameLable.frame) + 5;
        CGSize addressViewSize = CGSizeMake(0, 0);
        _addressView.frame = (CGRect){{addressViewX,addressViewY},addressViewSize};
        
        CGFloat addressLabelX = CGRectGetMaxX(_addressView.frame);
        CGFloat addressLabelY = addressViewY + 3;
        CGSize addressLabelSize = CGSizeMake(0, 0);
        _addressLabel.frame = (CGRect){{addressLabelX,addressLabelY},addressLabelSize};
        
        CGFloat timeViewWH = 10;
        CGFloat timeViewX = nameLabelX - 2;
        CGFloat timeViewY = addressLabelY + 1.5;
        _timeView.frame = CGRectMake(timeViewX, timeViewY, timeViewWH, timeViewWH);
        
        CGFloat timeLabelY = addressLabelY;
        CGSize timeLabelSize = [model.created_at sizeWithFont:[UIFont systemFontOfSize:10.0f]];
        CGFloat timeLabelX = CGRectGetMaxX(_timeView.frame) + 2;
        _timeLabel.frame = (CGRect){{timeLabelX,timeLabelY},timeLabelSize};
    }
    
//    CGFloat otherBtnY = CGRectGetMaxY(_nameLable.frame);
    CGFloat otherBtnY = nameLabelY;
    CGFloat otherBtnW = 30;
    CGFloat otherBtnH = 20;
    CGFloat otherBtnX = SCREEN_WIDTH - otherBtnW - margin;
    _otherButton.frame = CGRectMake(otherBtnX, otherBtnY, otherBtnW, otherBtnH);
    
    CGFloat attentionViewW = 0;
    CGFloat attentionViewH = 0;
    if (!model.follow) {
        attentionViewW = 54;
        attentionViewH = 20;
    }
    CGFloat attentionViewX = otherBtnX - attentionViewW - 5;
    _attentionView.frame = CGRectMake(attentionViewX, otherBtnY, attentionViewW, attentionViewH);
    
    // 文字内容
    CGFloat contentLabelY = model.content.length == 0 ? CGRectGetMaxY(_iconView.frame) : CGRectGetMaxY(_iconView.frame) + 10;
    CGFloat contentLabelX = margin;
    CGSize contentLabelSize = CGSizeZero;
    contentLabelSize = [model.content sizeWithFont:k14Font maxW:SCREEN_WIDTH - postCellBorder * 2];
    _contentLabel.frame = (CGRect){{contentLabelX,contentLabelY},contentLabelSize};
    
    CGFloat picViewX = margin;
    CGFloat picViewY = model.imgItemsArray.count == 0 ? CGRectGetMaxY(_contentLabel.frame) : CGRectGetMaxY(_contentLabel.frame) + 10;
    CGSize picSize = [XDPostPhotoView sizeWithPhotos:model.imgItemsArray];
    _picView.frame = (CGRect){{picViewX,picViewY},picSize};
    
    CGFloat topicViewW = SCREEN_WIDTH;
    CGFloat topicViewH = 44;
    CGFloat topicViewX = 0;
    CGFloat topicViewY = 0;
    if (model.tag.length > 0) {
        topicViewH = 44;
        topicViewY = CGRectGetMaxY(_picView.frame);
    } else {
        topicViewH = 0;
        topicViewY = CGRectGetMaxY(_picView.frame) + 10;
    }
    _topicView.frame = CGRectMake(topicViewX, topicViewY, topicViewW, topicViewH);
    
    CGFloat commentBtnW = 56;
    CGFloat commentBtnH = 29;
    CGFloat commentBtnX = SCREEN_WIDTH - margin - commentBtnW;
    CGFloat commentBtnY = CGRectGetMaxY(_topicView.frame) + margin;
    _commentButton.frame = CGRectMake(commentBtnX, commentBtnY, commentBtnW, commentBtnH);
    
    CGFloat praiseButtonX = CGRectGetMinX(_commentButton.frame) - margin - commentBtnW;
    CGFloat praiseButtonY = commentBtnY;
    _praiseButton.frame = CGRectMake(praiseButtonX, praiseButtonY, commentBtnW, commentBtnH);
    
    CGFloat praiseViewW = praiseButtonX;
    CGFloat praiseViewH = 0;
    CGFloat praiseViewX = 0;
    CGFloat praiseViewY = praiseButtonY;
    if (model.likeCount > 0) {
        praiseViewH = 36;
    }
    _praiseView.frame = CGRectMake(praiseViewX, praiseViewY, praiseViewW, praiseViewH);
    
    _headerHeight = CGRectGetMaxY(_praiseButton.frame) + 10;
    
    _lineView.frame = CGRectMake(0, _headerHeight - 0.5, SCREEN_WIDTH, 0.5);
    
    // **************************** 赋值 ****************************
    [_iconView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    _nameLable.text = model.nickname;
    
    _attentionView.image = model.follow ? nil : [UIImage imageNamed:@"post_attention"];
    if (model.sex == 1) {
        _sexView.image = [UIImage imageNamed:@"post_woman"];
    } else {
        _sexView.image = [UIImage imageNamed:@"post_man"];
    }
    if (model.sex == 1) {
        if (model.is_renzheng == 1) {
            _vipView.image = [UIImage imageNamed:@"girl_yirenzheng"];
        } else {
            _vipView.image = nil;
        }
    } else {
        if (model.groupid > 0) {// 会员等级判断
            _vipView.image = [UIImage imageNamed:@"square_vips"];
        } else {
            _vipView.image = nil;
        }
    }
    
    if (model.is_top) {
        _is_topView.image = [UIImage imageNamed:@"is_top"];
    } else {
        _is_topView.image = nil;
    }
    _addressLabel.text = model.address;
    _contentLabel.text = model.content;
    _picView.pic_urls = model.imgItemsArray;
    _topicView.topicStiing = model.tag;
    
    _praiseView.hidden = !model.likeCount;
    _praiseView.model = model;
    
    _praiseButton.selected = model.liked;
    [self setupBtn:_commentButton originalTitle:@"评论" count:(int)model.commentCount];
    
    _topicView.hidden = model.tag.length == 0;
    _timeLabel.text = model.created_at;
    _iconView.layer.cornerRadius = _iconView.width / 2.0;
    _iconView.layer.masksToBounds = YES;
}

/**
 *  设置按钮的显示标题
 *
 *  @param btn           哪个按钮
 *  @param originalTitle 原始标题
 *  @param count         显示数字
 */
- (void)setupBtn:(UIButton *)btn originalTitle:(NSString *)originalTitle count:(int)count {
    if (count) {
        NSString * title = nil;
        if (count < 10000) {
            title = [NSString stringWithFormat:@"%d",count];
        } else {
            double countDouble = count / 10000.0;
            title = [NSString stringWithFormat:@"%.1f万",countDouble];
            title = [title stringByReplacingOccurrencesOfString:@".0" withString:@""];
        }
        [btn setTitle:title forState:UIControlStateNormal];
    }else {
        [btn setTitle:originalTitle forState:UIControlStateNormal];
    }
}

/**
 *  头像点击
 */
- (void)headIconBtnClicked:(UITapGestureRecognizer *)recognizer {
    
    UITabBarController *tabBar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav = tabBar.selectedViewController;
    
//    XDOtherViewController *personVC = [[XDOtherViewController alloc] init];
//    personVC.user_id = self.model.user_id;
//    [nav pushViewController:personVC animated:YES];
}

/**
 *  评论
 */
- (void)commentButtonClicked {
    if (self.commentButtonClickedOperation) {
        self.commentButtonClickedOperation();
    }
}

/**
 *  点赞
 */
- (void)praiseButtonClicked {
    if (self.likeButtonClickedOperation) {
        self.likeButtonClickedOperation();
    }
}

/**
 *  更多
 */
- (void)otherButtonClicked {
    
    if (self.otherButtonClickedBlock) {
        self.otherButtonClickedBlock();
    }
}

- (void)attentionViewClicked:(UITapGestureRecognizer *)recognizer {
    
    if (self.attentionViewClickedBlock) {
        self.attentionViewClickedBlock((UIImageView *)recognizer.view);
    }
}

- (void)setAttentionVIewisHiddden:(BOOL)hidden {
    _attentionView.hidden = hidden;
}

@end
