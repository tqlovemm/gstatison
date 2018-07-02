//
//  XDGraphicItemView.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2018/1/29.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import "XDGraphicItemView.h"
#import "XDMsgCategoryModel.h"

@interface XDGraphicItemView ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation XDGraphicItemView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self xdd_setupSubViews];
    }
    return self;
}

- (void)xdd_setupSubViews
{
    self.iconImageView = [UIImageView new];
    [self addSubview:self.iconImageView];
    
    self.lineView = [UIView new];
    self.lineView.backgroundColor = DefaultColor_BG_gray;
    [self addSubview:self.lineView];
    
    self.label = [UILabel new];
    self.label.font = [UIFont systemFontOfSize:16.0f];
    self.label.numberOfLines = 2;
    [self addSubview:self.label];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.right.mas_equalTo(self.mas_right).offset(-20);
        make.top.mas_equalTo(self.mas_top).offset(15);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-20);
    }];
    
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.iconImageView.mas_top);
        make.centerY.mas_equalTo(self.iconImageView.mas_centerY);
        make.left.mas_equalTo(self.mas_left).offset(20);
        make.right.mas_equalTo(self.iconImageView.mas_left).offset(-20);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.left.right.mas_equalTo(self.label);
        make.bottom.mas_equalTo(-0.5);
    }];
}

- (void)setModel:(XDNewMessageGraphicModel *)model {
    _model = model;
    
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.img_url] placeholderImage:[UIImage imageNamed:@"square_image_placeholder"]];
    self.label.text = model.title;
}

@end
