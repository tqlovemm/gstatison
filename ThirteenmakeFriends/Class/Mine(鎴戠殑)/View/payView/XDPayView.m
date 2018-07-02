//
//  XDPayView.m
//  MeiziIntro
//
//  Created by Xudongdong on 16/7/27.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import "XDPayView.h"
#import "XDPayItemView.h"
#import "XDPay.h"

#import "UIView+Extension.h"
#import "NSString+Extension.h"

@interface XDPayView ()

@property (nonatomic ,strong) UILabel *needpayText;

@property (nonatomic ,strong) UILabel *priceLabel;

@property (nonatomic ,strong) UIImageView *underLine;

@property (nonatomic ,strong) UIButton *entryPay;

@property (nonatomic ,strong) UIView *payView;

@property (nonatomic ,strong) XDPayItemView *selectedPayItem;

@end

@implementation XDPayView

- (UIView *)payView {
    if (_payView == nil) {
        _payView = [[UIView alloc] init];
        
    }
    return _payView;
}

- (UIImageView *)underLine {
    if (_underLine == nil) {
        _underLine = [[UIImageView alloc]init];
        _underLine.image = [UIImage imageNamed:@"underLine"];
    }
    return _underLine;
}

- (UILabel *)needpayText {
    if (_needpayText == nil) {
        _needpayText = [[UILabel alloc]init];
        _needpayText.textColor = [UIColor blackColor];
        _needpayText.font = [UIFont systemFontOfSize:13.0f];
        _needpayText.text = @"需支付:";
    }
    return _needpayText;
}

- (UILabel *)priceLabel {
    if (_priceLabel == nil) {
        _priceLabel = [[UILabel alloc]init];
        _priceLabel.textColor = [UIColor orangeColor];
        _priceLabel.font = [UIFont systemFontOfSize:13.0f];
    }
    return _priceLabel;
}

- (UIButton *)entryPay {
    if (_entryPay == nil) {
        _entryPay = [[UIButton alloc] init];
        [_entryPay setImage:[UIImage imageNamed:@"f_okPay_278x39"] forState:UIControlStateNormal];
        [_entryPay addTarget:self action:@selector(entryBuy) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _entryPay;
}

- (void)startAnim {
    [UIView animateWithDuration:0.4f animations:^{
        self.payView.transform = CGAffineTransformIdentity;
    }];
}

- (void)endAnim {
    
    [UIView animateWithDuration:0.4f animations:^{
        self.payView.transform = CGAffineTransformMakeTranslation(0, 350);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    [self addSubview:self.payView];
    self.payView.backgroundColor = [UIColor whiteColor];
    
    [self.payView addSubview:self.needpayText];
    [self.payView addSubview:self.priceLabel];
    [self.payView addSubview:self.underLine];
    [self.payView addSubview:self.entryPay];
    
    self.payView.frame = CGRectMake(0, self.height - 350, self.width, 350);
    CGSize needpayTextSize = [self.needpayText.text sizeWithFont:[UIFont systemFontOfSize:13.0f]];
    self.needpayText.frame = CGRectMake(20, 15, needpayTextSize.width, needpayTextSize.height);
    
    self.priceLabel.frame = CGRectMake(CGRectGetMaxX(self.needpayText.frame) + 15, 15, 0, 0);
    self.underLine.frame = CGRectMake(CGRectGetMinX(self.needpayText.frame), CGRectGetMaxY(self.needpayText.frame) + 5, self.width - 20, 1);
    XD_WeakSelf
    [self.entryPay mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.centerX.mas_equalTo(self.payView);
        make.height.mas_equalTo(39);
        make.width.mas_equalTo(278);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.mas_safeAreaLayoutGuideBottom).offset(-20);
        } else {
            make.bottom.mas_equalTo(-20);
        }
    }];
    
    self.payView.transform = CGAffineTransformMakeTranslation(0, 350);
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endAnim)];
    [self addGestureRecognizer:tap];
}

- (void)setTotalPrice:(NSInteger)totalPrice {
    _totalPrice = totalPrice;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%ld",(long)totalPrice];
    CGSize priceSize = [self.priceLabel.text sizeWithFont:[UIFont systemFontOfSize:13.0f]];
    self.priceLabel.size = CGSizeMake(priceSize.width, priceSize.height);
}

- (void)selectPayItem:(UITapGestureRecognizer *)tap {
    self.selectedPayItem = (XDPayItemView *)tap.view;
}

@end
