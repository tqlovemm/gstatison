//
//  FansCell.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 16/1/18.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import "FansCell.h"
#import "AttitudeAndFansFrame.h"
#import "ShiSanUser.h"
#import "UIImageView+WebCache.h"
//#import "XDOtherViewController.h"

@interface FansCell ()

//! 头像
@property (nonatomic, weak) UIImageView *iconView;
//! 昵称
@property (nonatomic, weak) UILabel *nameLabel;
//! 自我介绍
@property (nonatomic, weak) UILabel *selfIntroLabel;

@end

@implementation FansCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        // 头像
        UIImageView *iconView = [[UIImageView alloc]init];
        [self addSubview:iconView];
        iconView.userInteractionEnabled = YES;
        self.iconView = iconView;
        // 头像点击
        UITapGestureRecognizer *tapHeader = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headIconClicked)];
        [self.iconView addGestureRecognizer:tapHeader];
        
        // 昵称
        UILabel *nameLabel = [[UILabel alloc]init];
        nameLabel.font = postNameFont;
        nameLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        // 自我介绍
        UILabel *selfIntroLabel = [[UILabel alloc]init];
        selfIntroLabel.font = postContentFont;
        selfIntroLabel.backgroundColor = [UIColor clearColor];
        selfIntroLabel.numberOfLines = 0;
        [self addSubview:selfIntroLabel];
        self.selfIntroLabel = selfIntroLabel;
        
        // 关注按钮
        UIButton *attention = [[UIButton alloc]init];
        //        [attention setBackgroundImage:[UIImage imageNamed:@"follow8"] forState:UIControlStateNormal];
        [self addSubview:attention];
        [attention addTarget:self action:@selector(attentionClicked) forControlEvents:UIControlEventTouchUpInside];
        self.attitudeBtn = attention;
    }
    return self;
}

- (void)setAttitudeFrame:(AttitudeAndFansFrame *)attitudeFrame {
    _attitudeFrame = attitudeFrame;
    
    ShiSanUser *user = attitudeFrame.user;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    self.iconView.frame = self.attitudeFrame.iconViewF;
    
    self.nameLabel.text = user.nickname;
    self.nameLabel.frame = self.attitudeFrame.nameLabelF;
    
    self.selfIntroLabel.text = user.signature;
    self.selfIntroLabel.frame = self.attitudeFrame.selfIntroLabelF;
    
    if ([user.each isEqualToNumber:[NSNumber numberWithInt:1]]) {
        [self.attitudeBtn setBackgroundImage:[UIImage imageNamed:@"follow9"] forState:UIControlStateNormal];
    } else {
        [self.attitudeBtn setBackgroundImage:[UIImage imageNamed:@"follow8"] forState:UIControlStateNormal];
    }
    
    self.attitudeBtn.frame = self.attitudeFrame.isAttitudeF;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)attentionClicked {
    
    if ([self.delegate respondsToSelector:@selector(fansCell:ClickedBtnWithAttitudeAndFansFrame:)]) {
        [self.delegate fansCell:self ClickedBtnWithAttitudeAndFansFrame:self.attitudeFrame];
    }
}

- (void)headIconClicked {
    NSLog(@"关注与粉丝的头像被点击");
    UITabBarController *tabBar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav = tabBar.selectedViewController;
        
//    XDOtherViewController *personVC = [[XDOtherViewController alloc] init];
//    personVC.user_id = self.attitudeFrame.user.user_id;
//    [nav pushViewController:personVC animated:YES];
}

@end
