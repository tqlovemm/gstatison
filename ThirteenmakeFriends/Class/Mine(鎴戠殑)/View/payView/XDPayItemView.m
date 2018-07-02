//
//  XDPayItemView.m
//  MeiziIntro
//
//  Created by Xudongdong on 16/7/27.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import "XDPayItemView.h"
#import "XDPay.h"

#import "UIView+Extension.h"
#import "NSString+Extension.h"

@interface XDPayItemView ()
@property (nonatomic ,strong) UIImageView *payIcon;

@property (nonatomic ,strong) UILabel *payTitle;

@property (nonatomic ,strong) UILabel *payDes;

@property (nonatomic ,strong) UIImageView *underLine;

@property (nonatomic ,strong) UIButton *checkBox;

@end

@implementation XDPayItemView

- (UIImageView *)payIcon {
    if (_payIcon == nil) {
        _payIcon = [[UIImageView alloc]init];
        _payIcon.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _payIcon;
}

- (UIImageView *)underLine {
    if (_underLine == nil) {
        _underLine = [[UIImageView alloc]init];
        _underLine.image = [UIImage imageNamed:@"underLine"];
    }
    return _underLine;
}

- (UILabel *)payTitle {
    if (_payTitle == nil) {
        _payTitle = [[UILabel alloc]init];
        _payTitle.textColor = [UIColor blackColor];
        _payTitle.font = [UIFont systemFontOfSize:14.0f];
    }
    return _payTitle;
}

- (UILabel *)payDes {
    if (_payDes == nil) {
        _payDes = [[UILabel alloc]init];
        _payDes.textColor = [UIColor lightGrayColor];
        _payDes.font = [UIFont systemFontOfSize:14.0f];
    }
    return _payDes;
}

- (UIButton *)checkBox {
    if (_checkBox == nil) {
        _checkBox = [[UIButton alloc] init];
        [_checkBox setImage:[UIImage imageNamed:@"f_adressUnSel_18x18"] forState:UIControlStateNormal];
        [_checkBox setImage:[UIImage imageNamed:@"f_adressSel_17x17"] forState:UIControlStateSelected];
        _checkBox.userInteractionEnabled = false;
        
    }
    return _checkBox;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    [self addSubview:self.payIcon];
    [self addSubview:self.payTitle];
    [self addSubview:self.payDes];
    [self addSubview:self.underLine];
    [self addSubview:self.checkBox];
}

- (void)setPayInfo:(XDPay *)payInfo {
    _payInfo = payInfo;
    
    self.payIcon.image = payInfo.icon;
    self.payIcon.frame = CGRectMake(10, 10, 40, 40);
    CGSize titleSize = [payInfo.title sizeWithFont:[UIFont systemFontOfSize:14.0f]];
    self.payTitle.text = payInfo.title;
    self.payTitle.frame = CGRectMake(CGRectGetMaxX(self.payIcon.frame) + 15, CGRectGetMinY(self.payIcon.frame), titleSize.width, titleSize.height);
    CGSize desSize = [payInfo.des sizeWithFont:[UIFont systemFontOfSize:14.0f]];
    self.payDes.text = payInfo.des;
    self.payDes.frame = CGRectMake(CGRectGetMinX(self.payTitle.frame), CGRectGetMaxY(self.payIcon.frame) - desSize.height, desSize.width, desSize.height);
    self.underLine.frame = CGRectMake(0, self.height - 1, self.width, 1);
    self.checkBox.frame = CGRectMake(self.width - 18 - 15, self.height / 2.0 - 9, 18, 18);
}

- (void)setSelected:(BOOL)selected{
    _selected = selected;
    
    self.checkBox.selected = selected;
}

@end
