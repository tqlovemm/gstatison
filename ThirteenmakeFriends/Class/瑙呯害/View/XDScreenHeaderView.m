//
//  XDScreenHeaderView.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/9/5.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDScreenHeaderView.h"

@interface XDScreenHeaderView ()

@property (nonatomic, strong) UILabel *tipLabel;

@end

@implementation XDScreenHeaderView

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
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.textColor = RGB(65, 65, 65);
    tipLabel.font = kPingFangRegularFont(24);
    tipLabel.text = @"您喜欢的类型？";
    [self addSubview:tipLabel];
    
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(20);
    }];
}

@end
