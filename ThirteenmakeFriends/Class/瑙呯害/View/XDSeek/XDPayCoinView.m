//
//  XDPayCoinView.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/8/31.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDPayCoinView.h"
#import "UIView+Extension.h"
#import "NSString+Extension.h"
#import "XDSeekHelpController.h"
#import "XDIntroduceModel.h"
#import "XDNavigationController.h"

@interface XDPayCoinView ()

/** 需支付心动币 */
@property (nonatomic ,strong) UILabel *needpayText;
/** 分割线 */
@property (nonatomic ,strong) UIView *underLine;
/** 支付按钮 */
@property (nonatomic ,strong) UIButton *entryPay;
/** 底部白色视图 */
@property (nonatomic ,strong) UIView *payView;
/** 价格 */
@property (nonatomic ,strong) UILabel *des;
/** 价格描述 */
@property (nonatomic ,strong) UILabel *priceDes;
/** 心动币图片 */
@property (nonatomic ,strong) UIImageView *coinView;
/** 帮助 */
@property (nonatomic ,strong) UIButton *useMethod;

@end

@implementation XDPayCoinView

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

- (UIButton *)useMethod {
    if (!_useMethod) {
        _useMethod = [[UIButton alloc]init];
        _useMethod.hidden = YES;
        [_useMethod addTarget:self action:@selector(p_ClickTODetail:) forControlEvents:UIControlEventTouchUpInside];
        [_useMethod setImage:[UIImage imageNamed:@"seek_question"] forState:UIControlStateNormal];
    }
    return _useMethod;
}

- (void)setNoticeType:(XDSeekPayType)noticeType {
    _noticeType = noticeType;
    
    _useMethod.hidden = NO;
    XD_WeakSelf
    [self.useMethod mas_updateConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.right.mas_equalTo(-18);
        make.top.mas_equalTo(self.payView.mas_top).offset(9);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
}

- (UIView *)payView {
    if (_payView == nil) {
        _payView = [[UIView alloc] init];
    }
    return _payView;
}

- (UIView *)underLine {
    if (_underLine == nil) {
        _underLine = [[UIView alloc]init];
        _underLine.backgroundColor = RGB(230, 230, 230);
    }
    return _underLine;
}

- (UILabel *)needpayText {
    if (_needpayText == nil) {
        _needpayText = [[UILabel alloc]init];
        _needpayText.textColor = RGB(119, 119, 119);
        _needpayText.font = kPingFangBoldFont(14);
        _needpayText.text = [NSString stringWithFormat:@"需支付%@:",coin_name];
    }
    return _needpayText;
}

- (UIButton *)entryPay {
    if (_entryPay == nil) {
        _entryPay = [[UIButton alloc] init];
        [_entryPay addTarget:self action:@selector(entryBuy) forControlEvents:UIControlEventTouchUpInside];
        
        [_entryPay setBackgroundImage:[UIImage imageNamed:@"btn_gradient"] forState:UIControlStateNormal];
        _entryPay.layer.cornerRadius = 20;
        _entryPay.layer.shadowRadius = 3;
        _entryPay.layer.shadowOffset = CGSizeMake(0, 1);
        _entryPay.layer.shadowOpacity = 0.8;
        _entryPay.layer.shadowColor = ThemeColor7.CGColor;
        
        _entryPay.titleLabel.font = kPingFangBoldFont(14);
        [_entryPay setTitle:@"确认支付" forState:UIControlStateNormal];
        [_entryPay setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_entryPay setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    }
    return _entryPay;
}

#pragma mark - 添加
- (UIImageView *)coinView {
    if (_coinView == nil) {
        _coinView = [[UIImageView alloc]init];
        _coinView.image = [UIImage imageNamed:@"jinbi"];
    }
    return _coinView;
}

- (UILabel *)des {
    if (_des == nil) {
        _des = [[UILabel alloc]init];
        _des.textColor = RGB(65, 65, 65);
        _des.font = kPingFangBoldFont(18);
    }
    return _des;
}

- (UILabel *)priceDes {
    if (_priceDes == nil) {
        _priceDes = [[UILabel alloc]init];
        _priceDes.textColor = RGB(119, 119, 119);
        _priceDes.font = kPingFangRegularFont(12);
    }
    return _priceDes;
}

- (void)startAnim {
    [UIView animateWithDuration:0.4f animations:^{
        self.payView.transform = CGAffineTransformIdentity;
    }];
}

- (void)endAnim {
    [UIView animateWithDuration:0.4f animations:^{
        self.payView.transform = CGAffineTransformMakeTranslation(0, 300);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)setupSubViews {
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    [self addSubview:self.payView];
    self.payView.backgroundColor = [UIColor whiteColor];
    
    [self.payView addSubview:self.needpayText];
    [self.payView addSubview:self.underLine];
    [self.payView addSubview:self.entryPay];
    
    [self.payView addSubview:self.coinView];
    [self.payView addSubview:self.des];
    [self.payView addSubview:self.priceDes];
    [self.payView addSubview:self.useMethod];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endAnim)];
    [self addGestureRecognizer:tap];
    
    XD_WeakSelf
    [self.payView mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(self.width, 300));
        make.bottom.mas_equalTo(0);
    }];
    
    [self.needpayText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(19);
        make.top.mas_equalTo(9);
    }];
    
    [self.underLine mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.top.mas_equalTo(self.needpayText.mas_bottom).offset(7);
        make.height.mas_equalTo(1);
    }];
    
    [self.coinView mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.left.mas_equalTo(self.centerX - 42);
        make.top.mas_equalTo(103);
        make.size.mas_equalTo(CGSizeMake(39, 39));
    }];
    
    [self.des mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.left.mas_equalTo(self.coinView.mas_right).offset(10);
        make.centerY.mas_equalTo(self.coinView);
    }];
    
    [self.priceDes mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.top.mas_equalTo(self.coinView.mas_bottom).offset(38);
        make.centerX.mas_equalTo(self);
    }];
    
    [self.entryPay mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.top.mas_equalTo(self.priceDes.mas_bottom).offset(35);
        make.centerX.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(188, 40));
    }];
}

- (void)setPrice:(NSString *)price {
    _price = price;
    
    self.des.text = [NSString stringWithFormat:@"%@",price];
    self.priceDes.text = [NSString stringWithFormat:@"所需%@：%@",coin_name,price];
}

/**
 *  支付
 */
- (void)entryBuy {
    if ([self.delegate respondsToSelector:@selector(entryPay)]) {
        [self.delegate entryPay];
    }
    
    if (_cellIndex) {
        if ([self.delegate respondsToSelector:@selector(entryPayWithIndexPath:)]) {
            [self.delegate entryPayWithIndexPath:_cellIndex];
        }
    }
    [self endAnim];
    NSLog(@"恭喜您支付了%@元",self.price);
}

- (void)p_ClickTODetail:(UIButton *)sender {
    
    UITabBarController *tabBar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    
    XDSeekHelpController *helpVC = [[XDSeekHelpController alloc] init];
    XDIntroduceModel *coin = [[XDIntroduceModel alloc] init];
    coin.title = [NSString stringWithFormat:@"%@使用 ",coin_name];
    if ([User_Sex integerValue] == 1) { // 女性心动币使用
        coin.des = [NSString stringWithFormat:@"·每日签到可获得%@\n·%@用于约会 救我 翻牌的报名使用\n·没有报名成功，%@将原数返还",coin_name,coin_name,coin_name];
    } else { // 男心动币使用
        coin.des = [NSString stringWithFormat:@"·会员才能使用%@，在我的%@充值\n·%@用于约会 救我 专属的报名使用\n·没有报名成功，%@将原数返还",coin_name,coin_name,coin_name,coin_name];
    }
    helpVC.dataArray = @[coin];
    XDNavigationController *nav = [[XDNavigationController alloc] initWithRootViewController:helpVC];
    [tabBar presentViewController:nav animated:YES completion:nil];
}

@end
