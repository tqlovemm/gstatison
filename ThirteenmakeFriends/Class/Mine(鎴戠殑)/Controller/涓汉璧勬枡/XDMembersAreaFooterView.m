//
//  XDMembersAreaFooterView.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/7/31.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDMembersAreaFooterView.h"

@interface XDMembersAreaFooterView ()

/** 我的关注 */
@property (weak, nonatomic) UILabel *joinsIntro;

@end

@implementation XDMembersAreaFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self setupSubviews];
    }
    return self;
}


- (void)setupSubviews {
    
    self.backgroundColor = [UIColor whiteColor];
    
    UILabel *desTitlelab = [[UILabel alloc] init];
    desTitlelab.text = @"地区的意义";
    desTitlelab.textColor = RGB(170, 170, 170);
    desTitlelab.font = kPingFangBoldFont(13);
    [self addSubview:desTitlelab];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = RGB(230, 230, 230);
    [self addSubview:lineView];
    
    UILabel *desLab = [[UILabel alloc] init];
    desLab.text = @"您的入会地区将直接决定您在平台可约会对象的所在地区，每位会员最多可拥有三个不同地区。";
    desLab.textColor = RGB(170, 170, 170);
    desLab.numberOfLines = 0;
    desLab.font = kPingFangRegularFont(12);
    [self addSubview:desLab];
    
    UILabel *joinsIntro = [[UILabel alloc] init];
    joinsIntro.text = @"PS：地区修改或添加，请联系客服";
    joinsIntro.font = kPingFangRegularFont(12);
    joinsIntro.textColor = ThemeColor1;
    [self addSubview:joinsIntro];
    
    WEAKSELF
    [desTitlelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(10);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(desTitlelab);
        make.top.mas_equalTo(desTitlelab.mas_bottom).offset(10);
        make.right.mas_equalTo(weakSelf);
        make.height.mas_equalTo(0.5);
    }];
    
    [desLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(lineView);
        make.top.mas_equalTo(lineView.mas_bottom).offset(15);
        make.width.mas_lessThanOrEqualTo(weakSelf.width - 30);
    }];
    
    [joinsIntro mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(desLab);
        make.top.mas_equalTo(desLab.mas_bottom).offset(10);
    }];
}

@end
