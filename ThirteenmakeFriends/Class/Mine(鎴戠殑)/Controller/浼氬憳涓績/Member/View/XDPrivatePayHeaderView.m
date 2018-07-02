//
//  XDPrivatePayHeaderView.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/7/21.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDPrivatePayHeaderView.h"
#import "XDPrivatePriceView.h"

@interface XDPrivatePayHeaderView ()<UITextFieldDelegate>

/** 输入金额 */
@property (nonatomic, weak) UITextField *inputView;
/** 咨询按钮 */
@property (nonatomic, weak) UIButton *serviceBtn;

@end

@implementation XDPrivatePayHeaderView

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
    self.backgroundColor = RGB(240, 239, 245);
    
    UIButton *serviceBtn = [[UIButton alloc] init];
    [serviceBtn setImage:[UIImage imageNamed:@"consulting_service"] forState:UIControlStateNormal];
    [self addSubview:serviceBtn];
    self.serviceBtn = serviceBtn;
    [serviceBtn addTarget:self action:@selector(serviceBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    XDPrivatePriceView *inputView = [[XDPrivatePriceView alloc] init];
    inputView.delegate = self;
    inputView.placeholder = @"咨询客服后填写金额(高于4998)";
    inputView.font = kPingFangRegularFont(14);
    inputView.textColor = RGB(68, 63, 77);
    inputView.backgroundColor = [UIColor whiteColor];
    inputView.keyboardType = UIKeyboardTypeNumberPad;
    [self addSubview:inputView];
    self.inputView = inputView;
    
    self.minPrice = 4998;
    
    WEAKSELF
    [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf).offset(46 + 10);
        make.height.mas_equalTo(46);
        make.left.mas_equalTo(22);
        make.right.mas_equalTo(-22);
    }];
    
    [serviceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(inputView);
        make.size.mas_equalTo(CGSizeMake(61, 28));
        make.bottom.mas_equalTo(inputView.mas_top).offset(-45);
    }];
}

- (void)serviceBtnClicked:(UIButton *)btn {
    WEAKSELF
    if (weakSelf.serviceButtonClicked) {
        weakSelf.serviceButtonClicked(btn);
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if ([textField.text integerValue] <= self.minPrice) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"私人会员价格不应低于至尊价格" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    return YES;
}

@end
