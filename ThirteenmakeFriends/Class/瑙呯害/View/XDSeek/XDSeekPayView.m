//
//  XDSeekPayView.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/8/31.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDSeekPayView.h"


@interface XDSeekPayView ()

/** 倒计时 */
@property (nonatomic, strong) UILabel *timeLabel;
/** 支付价格 */
@property (nonatomic, strong) UILabel *priceLabel;

/** 支付按钮 */
@property (nonatomic, strong) UIButton *payBtn;

@end

@implementation XDSeekPayView

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
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.textColor = RGB(226, 99, 142);
    timeLabel.font = kPingFangRegularFont(14);
    [self addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    UILabel *priceLabel = [[UILabel alloc] init];
    priceLabel.textColor = RGB(119, 119, 119);
    priceLabel.font = kPingFangRegularFont(12);
    [self addSubview:priceLabel];
    self.priceLabel = priceLabel;
    
    UIButton *payBtn = [[UIButton alloc] init];
    [payBtn setImage:[UIImage imageNamed:@"seek_recommended"] forState:UIControlStateNormal];
    [payBtn setImage:[UIImage imageNamed:@"seek_full"] forState:UIControlStateDisabled];
    [self addSubview:payBtn];
    [payBtn addTarget:self action:@selector(payButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.payBtn = payBtn;
    
    // 给按钮设置阴影
    self.payBtn.layer.cornerRadius = 20;
    self.payBtn.layer.shadowRadius = 3;
    self.payBtn.layer.shadowOffset = CGSizeMake(0, 1);
    self.payBtn.layer.shadowOpacity = 0.8;
    self.payBtn.layer.shadowColor = ThemeColor7.CGColor;
    
    XD_WeakSelf
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.top.mas_equalTo(40);
        make.centerX.mas_equalTo(self);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.top.mas_equalTo(self.timeLabel.mas_bottom).offset(21);
        make.centerX.mas_equalTo(self);
    }];
    
    [self.payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.top.mas_equalTo(self.priceLabel.mas_bottom).offset(35);
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(self).offset(-35);
    }];
}

- (void)setPrice:(NSInteger)price {
    _price = price;
    
    self.priceLabel.text = [NSString stringWithFormat:@"所需%@：%ld",coin_name,price];
}

- (void)setTimeIntervel:(NSInteger)timeIntervel {
    _timeIntervel = timeIntervel;
    self.timeLabel.text = [NSString stringWithFormat:@"还剩%ld",timeIntervel];
}

- (void)setPayType:(NSInteger)payType {
    _payType = payType;
    if (payType == 2) {
        [self.payBtn setImage:[UIImage imageNamed:@"saveme_signup"] forState:UIControlStateNormal];
    } else if (payType == 1) {
        [self.payBtn setImage:[UIImage imageNamed:@"seek_recommended"] forState:UIControlStateNormal];
    } else {
        [self.payBtn setImage:[UIImage imageNamed:@"seek_recommended"] forState:UIControlStateNormal];
    }
}

- (void)setIs_limited:(BOOL)is_limited {
    _is_limited = is_limited;
    
    self.payBtn.enabled = !is_limited;
    
    if (self.payBtn.enabled) {
        self.payBtn.layer.shadowColor = ThemeColor7.CGColor;
    } else {
        self.payBtn.layer.shadowColor = RGB(170, 170, 170).CGColor;
    }
}

- (void)payButtonClicked:(UIButton *)payBtn {
    if (self.payButtonClicked) {
        self.payButtonClicked(payBtn);
    }
}

@end
