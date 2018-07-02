//
//  ThirteenWithVideoCellTableViewCell.m
//  ThirteenmakeFriends
//
//  Created by iOS on 15/5/17.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "ThirteenWithVideoCellTableViewCell.h"
#import<QuartzCore/QuartzCore.h>
@implementation ThirteenWithVideoCellTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)didPressedToPrise:(UIButton *)sender {
    if (_didPressedEvent) {
        _didPressedEvent(Praise,self);
    }
}
- (IBAction)didPressedToCollect:(UIButton *)sender {
    if (_didPressedEvent) {
        _didPressedEvent(Collection,self);
    }
}

- (IBAction)didPressedToShare:(UIButton *)sender {
    if (_didPressedEvent) {
        _didPressedEvent(Share,self);
    }
}

/*
 code:200 有数据
 Title：标题
 Wimg:描述图片
 Content:内容
 Wclick：点击数
 Wdianzan：点赞数
 Hot：1 火贴  2 不是火帖
 Wtype：分类
 Nickname：发布人
 Level：发布人会员等级
 Avatar：发布人头像
 Sex：发布人性别
 created_at：发布时间
 */
- (void)setModel:(ThirteenSayArticlesModel *)model {
    if (model) {
        _model = model;
        self.avatarView.urlAvatar = F(@"%@",model.avatar);
        self.avatarView.isNeedCut = YES;
        
        self.lblName.text    = model.nickname;
        self.lblTitle.text   = model.title;
        self.lblTime.text    = model.created_at;
        self.lblMessage.text = model.miaoshu;
        
        [self.imgType sd_setImageWithURL:[NSURL URLWithString:model.labelthumb]];
        [self.imgVideo sd_setImageWithURL:URL(F(@"%@", model.wimg)) placeholderImage:nil];
        self.lblPraise.text  = F(@"%@", model.wdianzan);
        [self.btnReply setTitle:F(@"%@", model.comment_count) forState:UIControlStateNormal];
        if ([F(@"%@", model.labelname) isEqualToString:@"视频"]) {
            self.imgPlay.hidden = NO;
        }
        else {
            self.imgPlay.hidden = YES;
        }
        if ([model.iscollection integerValue] == 1) {
            self.imgCollect.image = ImageViewName(@"ThirteenSay_liked");
        }
        if ([model.islike integerValue] == 1) {
            self.imgPraise.image  = ImageViewName(@"praise_select");
            [self.lblPraise setTextColor:RGB(216, 63, 113)];
        }
        
        if ([F(@"%@", model.yuanchuang) isEqualToString:@"1"]) {
            self.lblOriginal.hidden = NO;
        }
        else {
            self.lblOriginal.hidden = YES;
        }
        [self setNeedsLayout];
    }
}

- (void)layoutSubviews {
    _constraintTitle.constant            = _model.titleHeight;
    self.lblOriginal.layer.borderColor   = RGB(170, 170, 170).CGColor;
    self.lblOriginal.layer.borderWidth   = 0.5;
    self.lblOriginal.layer.masksToBounds = YES;
    self.lblOriginal.layer.cornerRadius  = 8;
}


/**
 点赞动画
 */
- (void)didPressedToStartPriseAnimationIncreasePraiseNum:(BOOL)increase {
    [self p_animation:self.imgPraise SelectPic:ImageViewName(@"praise_select")];
    [self.lblPraise setTextColor:RGB(216, 63, 113)];
    if (increase) {
        self.lblPraise.text  = F(@"%ld", [_model.wdianzan integerValue] + 1);
    }
    
}

/**
 收藏动画
 */
- (void)didPressedToStartCollectionAnimation {
    if ([self.model.iscollection integerValue] == 1) {
        return;
    }
    [self p_animation:self.imgCollect SelectPic:ImageViewName(@"ThirteenSay_liked")];
}

- (void)p_animation:(UIImageView *)imgView SelectPic:(UIImage *)img {
    CAKeyframeAnimation * animation;
    animation                     = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration            = 0.5;
    animation.removedOnCompletion = YES;
    animation.fillMode            = kCAFillModeForwards;
    NSMutableArray *values        = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values              = values;
    [imgView.layer addAnimation:animation forKey:nil];
    [imgView setImage:img];
}
@end
