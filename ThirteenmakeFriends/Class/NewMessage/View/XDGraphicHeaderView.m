//
//  XDGraphicHeaderView.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2018/1/30.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import "XDGraphicHeaderView.h"
#import "XDMsgCategoryModel.h"

@interface XDGraphicHeaderView ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIView *maskView;

@end

@implementation XDGraphicHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self xdd_setupSubViews];
    }
    return self;
}

- (void)xdd_setupSubViews
{
    self.iconImageView = [UIImageView new];
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.iconImageView.clipsToBounds = YES;
    [self addSubview:self.iconImageView];
    
    self.maskView = [[UIView alloc] init];
    self.maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self addSubview:self.maskView];
    
    self.label = [UILabel new];
    self.label.font = kPingFangRegularFont(18);
    self.label.textColor = [UIColor whiteColor];
    self.label.numberOfLines = 2;
    [self addSubview:self.label];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self);
        make.height.mas_equalTo(196);
        make.bottom.mas_equalTo(self);
    }];
    
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.iconImageView.mas_bottom).offset(-15);
        make.left.mas_equalTo(self.iconImageView.mas_left).offset(20);
        make.right.mas_equalTo(self.iconImageView.mas_right).offset(-20);
    }];
    
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.iconImageView.mas_bottom);
        make.left.mas_equalTo(self.iconImageView.mas_left);
        make.right.mas_equalTo(self.iconImageView.mas_right);
        make.height.mas_equalTo(self.label.mas_height).offset(20);
    }];
    
}

- (void)setModel:(XDNewMessageGraphicModel *)model {
    _model = model;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.img_url] placeholderImage:[UIImage imageNamed:@"square_image_placeholder"]];
    self.label.text = model.title;
}

@end
