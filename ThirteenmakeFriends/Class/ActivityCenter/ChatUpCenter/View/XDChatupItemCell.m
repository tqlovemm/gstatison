//
//  XDChatupItemCell.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2018/1/11.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import "XDChatupItemCell.h"
#import "XDSquareUserModel.h"

@interface XDChatupItemCell ()

/** 头像 */
@property (nonatomic, weak) UIImageView *iconView;
/** vipView */
@property (nonatomic, weak) UIImageView *vipView;
/** 蒙版 */
@property (nonatomic, weak) UIImageView *backView;
/** 昵称 */
@property (nonatomic, weak) UILabel *nickenameLabel;
/** 图片张数 */
@property (nonatomic, strong) UIButton *countBtn;

/** 年龄 */
@property (nonatomic, weak) UILabel *ageLabel;
/** 地区 */
@property (nonatomic, weak) UILabel *areaLabel;
/** 性别 */
@property (nonatomic, weak) UIImageView *sexView;

@end

@implementation XDChatupItemCell

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    self.backgroundColor = RGB(29, 28, 27);
    self.contentView.layer.cornerRadius = 2;
    self.contentView.clipsToBounds = YES;
    
    UIImageView *iconView = [[UIImageView alloc] init];
    [self.contentView addSubview:iconView];
    self.iconView = iconView;
    
    UIImageView *vipView = [[UIImageView alloc] init];
    [self.contentView addSubview:vipView];
    self.vipView = vipView;
    
    UIImageView *backView = [[UIImageView alloc] init];
    backView.image = [UIImage imageNamed:@"chatup_square_backImage"];
    [self.contentView addSubview:backView];
    self.backView = backView;
    
    UILabel *nickenameLabel = [[UILabel alloc] init];
    nickenameLabel.textColor = RGB(240, 239, 245);
    nickenameLabel.font = kPingFangRegularFont(10);
    [self.contentView addSubview:nickenameLabel];
    self.nickenameLabel = nickenameLabel;
    
    self.countBtn = [[UIButton alloc] init];
    self.countBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.countBtn.imageEdgeInsets = UIEdgeInsetsMake(2.5, 0, 2.5, 0);
    [self.countBtn setImage:[UIImage imageNamed:@"seek_photo"] forState:UIControlStateNormal];
    [self.countBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.countBtn setBackgroundColor:RGBA(68, 63, 77, 0.65)];
    [self.countBtn.titleLabel setFont:kPingFangRegularFont(6)];
    [self addSubview:self.countBtn];
    self.countBtn.layer.cornerRadius = 6;
    
    UILabel *ageLabel = [[UILabel alloc] init];
    ageLabel.textColor = RGB(240, 239, 245);
    ageLabel.font = kPingFangRegularFont(10);
    [self.contentView addSubview:ageLabel];
    self.ageLabel = ageLabel;
    
    UILabel *areaLabel = [[UILabel alloc] init];
    areaLabel.textColor = RGB(240, 239, 245);
    areaLabel.font = kPingFangRegularFont(10);
    [self.contentView addSubview:areaLabel];
    self.areaLabel = areaLabel;
    
    UIImageView *sexView = [[UIImageView alloc] init];
    [self.contentView addSubview:sexView];
    self.sexView = sexView;
    
    XD_WeakSelf
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.width.mas_equalTo(self.contentView);
        make.height.mas_equalTo(self.iconView.mas_width);
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
    }];
    
    [self.vipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(52, 16));
        make.top.mas_equalTo(4);
        make.left.mas_equalTo(4);
    }];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.top.bottom.left.right.mas_equalTo(self.iconView);
    }];
    
    [self.nickenameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.bottom.mas_equalTo(self.iconView.mas_bottom);
        make.left.mas_equalTo(self.iconView.mas_left);
        make.right.lessThanOrEqualTo(self.countBtn.mas_left).offset(-2);
    }];
    
    [self.countBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(27, 12));
        make.bottom.mas_equalTo(self.nickenameLabel).offset(-3);
        make.right.mas_equalTo(-2);
    }];
    
    [self.sexView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-4);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-2);
        make.size.mas_equalTo(CGSizeMake(12, 12));
    }];
    
    [self.ageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.centerY.mas_equalTo(self.sexView.mas_centerY);
        make.left.mas_equalTo(self.nickenameLabel);
    }];
    
    [self.areaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.centerY.mas_equalTo(self.sexView.mas_centerY);
        make.left.mas_equalTo(self.ageLabel.mas_right).offset(5);
        make.right.lessThanOrEqualTo(self.sexView).offset(-2);
    }];
    
    // 设置优先级 (照片张数优先级高于昵称)
    [self.countBtn setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.nickenameLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    
    // 设置优先级 (地区优先级低)
    [self.sexView setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.areaLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.ageLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
}

- (void)setUser:(XDSquareUserModel *)user {
    _user = user;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"square_image_placeholder"]];
    self.nickenameLabel.text = user.nickname;
    self.ageLabel.text = [NSString stringWithFormat:@"%ld岁",user.age];
    self.areaLabel.text = user.area;
    self.sexView.image = [UIImage imageNamed:user.sex != 0 ? @"activity_square_woman" : @"activity_square_man"];
    if (user.sex) {
        self.vipView.image = [UIImage imageNamed:user.vip ? @"girl_yirenzheng" : nil];
    } else {
        self.vipView.image = [UIImage imageNamed:user.vip ? @"longImg_vips" : nil];
    }
    [self.countBtn setTitle:[NSString stringWithFormat:@"%ld",user.photo_count] forState:UIControlStateNormal];
}

@end
