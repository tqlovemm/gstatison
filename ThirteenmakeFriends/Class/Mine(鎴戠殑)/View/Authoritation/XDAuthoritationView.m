//
//  XDAuthoritationView.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/11/10.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDAuthoritationView.h"
#import "XDGradientLabel.h"
#import "XDAnthoritationModel.h"

@interface XDAuthoritationView ()

/** 图片 */
@property (nonatomic, strong) UIImageView *imgView;
/** 背景图片 */
@property (nonatomic, strong) UIImageView *backImgView;
/** 标题 */
@property (nonatomic, strong) XDGradientLabel *titleLabel;
/** 描述 */
@property (nonatomic, strong) UILabel *desLabel;
/** 状态 */
@property (nonatomic, strong) XDGradientLabel *statusLabel;
/** 分割线 */
@property (nonatomic, strong) UIView *lineView;

@end

@implementation XDAuthoritationView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    self.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imgView = [[UIImageView alloc] init];
    [self addSubview:imgView];
    self.imgView = imgView;
    
    UIImageView *backImgView = [[UIImageView alloc] init];
    backImgView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:backImgView];
    self.backImgView = backImgView;
    
    NSArray *gradientColors = @[(id)RGB(232, 146, 121).CGColor, (id)RGB(232, 82, 120).CGColor];
    XDGradientLabel *titleLabel = [[XDGradientLabel alloc] init];
    titleLabel.colors = gradientColors;
//    titleLabel.textColor = RGB(65, 65, 65);
    titleLabel.font = kPingFangBoldFont(14);
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UILabel *desLabel = [[UILabel alloc] init];
    desLabel.textColor = RGB(119, 119, 119);
    desLabel.font = kPingFangBoldFont(11);
    [self addSubview:desLabel];
    self.desLabel = desLabel;
    
    XDGradientLabel *statusLabel = [[XDGradientLabel alloc] init];
    statusLabel.colors = gradientColors;
//    statusLabel.textColor = RGB(119, 119, 119);
    statusLabel.font = kPingFangRegularFont(11);
    [self addSubview:statusLabel];
    self.statusLabel = statusLabel;
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = RGB(232, 146, 21);
    [self addSubview:lineView];
    self.lineView = lineView;
}

- (void)setModel:(XDAnthoritationModel *)model {
    _model = model;

    self.titleLabel.text = model.title;
    self.desLabel.text = model.des;
    
    if (model.is_auth == 0) {
        self.statusLabel.text = @"前往认证  >>";
    } else if (model.is_auth == 1) {
        self.statusLabel.text = @"审核中";
    } else if (model.is_auth == 2) {
        self.statusLabel.text = @"认证失败  >>";
    } else if (model.is_auth == 3) {
        self.statusLabel.text = @"认证成功";
    } else {
        self.statusLabel.text = @"未知状态";
    }
    
    self.imgView.image = [UIImage imageNamed:model.imgName];
    self.backImgView.image = [UIImage imageNamed:model.backImgNaem];

    XD_WeakSelf
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(25);
        make.left.mas_equalTo(25);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    [self.backImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(150, 100));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.top.mas_equalTo(self.imgView.mas_top);
        make.left.mas_equalTo(self.imgView.mas_right).offset(15);
    }];

    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(5);
        make.left.mas_equalTo(self.titleLabel.mas_left);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.top.mas_equalTo(self.imgView.mas_bottom).offset(18);
        make.left.mas_equalTo(22);
        make.right.mas_equalTo(-22);
        make.height.mas_equalTo(0.5);
    }];


    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.top.mas_equalTo(self.lineView.mas_bottom).offset(12);
        make.left.mas_equalTo(self.lineView.mas_left).offset(3);
        make.bottom.mas_equalTo(self).offset(-13);
    }];
}

@end
