//
//  XDSurePayView.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/7/19.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDSurePayView.h"

@interface XDSurePayView ()

/** 支付 */
@property (nonatomic, weak) UILabel *desLabel;
/** 支付金额 */
@property (nonatomic, weak) UILabel *priceLabel;
/** 支付按钮 */
@property (nonatomic, weak) UIButton *payBtn;

@end

@implementation XDSurePayView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 创建cell内部子控件
        [self setupSubViews];
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        // 创建cell内部子控件
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    self.backgroundColor = [UIColor whiteColor];

    UILabel* desLabel = [[UILabel alloc] init];
    desLabel.text = @"支付：";
    desLabel.font = kPingFangRegularFont(14);
    desLabel.textColor = RGB(68, 63, 77);
    [self addSubview:desLabel];
    self.desLabel = desLabel;
    
    UILabel* priceLabel = [[UILabel alloc] init];
    priceLabel.font = kPingFangBoldFont(18);
    priceLabel.textColor = ThemeColor1;
    [self addSubview:priceLabel];
    self.priceLabel = priceLabel;
    
    UIButton *payBtn = [[UIButton alloc] init];
    [payBtn setImage:[UIImage imageNamed:@"sure_pay_money"] forState:UIControlStateNormal];
    [self addSubview:payBtn];
    self.payBtn = payBtn;
    [payBtn addTarget:self action:@selector(payBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    WEAKSELF
    [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf);
        make.left.mas_equalTo(12);
    }];
    
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(desLabel.mas_right).offset(0);
        make.centerY.mas_equalTo(weakSelf);
    }];
    
    [payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf);
        make.size.mas_equalTo(CGSizeMake(145, 38));
        make.right.mas_equalTo(-12);
    }];
}

- (void)payBtnClicked:(UIButton *)btn {
    WEAKSELF
    if (weakSelf.payButtonClicked) {
        weakSelf.payButtonClicked(btn);
    }
}

- (void)setPrice:(NSInteger)price {
    _price = price;
    
    self.priceLabel.text = [NSString stringWithFormat:@"￥%ld",price];
}

@end
