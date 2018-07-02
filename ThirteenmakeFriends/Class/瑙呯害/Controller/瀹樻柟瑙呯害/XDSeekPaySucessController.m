//
//  XDSeekPaySucessController.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/9/1.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDSeekPaySucessController.h"
//#import "ManDateHistoryViewController.h"
//#import "XDWomanSeekRecodController.h"

@interface XDSeekPaySucessController ()

@property (nonatomic, weak) UILabel *payCoinLabel;

@end

@implementation XDSeekPaySucessController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"支付成功";
    [self setupNavbar];
    
    [self setupSubviews];
}

- (void)setupNavbar {
    
    UIBarButtonItem *leftNegativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
    // leftNegativeSpacer为占位符
    leftNegativeSpacer.width = -10;
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    [rightBtn setTitleColor:NormalNavBtnColor forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [rightBtn addTarget:self action:@selector(saveBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItems = @[leftNegativeSpacer, rightItem];
}

- (void)saveBtnClicked:(UIButton *)btn {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setupSubviews {
    UIView *backView = [[UIView alloc] init];
    [self.view addSubview:backView];
    
    UIImageView *successView = [[UIImageView alloc] init];
    successView.image = [UIImage imageNamed:@"seek_ certified"];
    [backView addSubview:successView];
    
    UILabel *successLabel = [[UILabel alloc] init];
    successLabel.text = @"支付成功！";
    successLabel.font = [UIFont systemFontOfSize:18];
    successLabel.textColor = RGB(65, 65, 65);
    [backView addSubview:successLabel];
    
    UILabel *payWay = [[UILabel alloc] init];
    payWay.font = kPingFangRegularFont(14);
    payWay.textColor = RGB(119, 119, 119);
    [backView addSubview:payWay];
    
    UILabel *payCoinLabel = [[UILabel alloc] init];
    payCoinLabel.font = kPingFangRegularFont(14);
    payCoinLabel.textColor = RGB(119, 119, 119);
    [backView addSubview:payCoinLabel];
    self.payCoinLabel = payCoinLabel;
    
    UIButton *checkProceesBtn = [[UIButton alloc] init];
    [checkProceesBtn addTarget:self action:@selector(checkProceesBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [checkProceesBtn setBackgroundImage:[UIImage imageNamed:@"btn_gradient"] forState:UIControlStateNormal];
    [checkProceesBtn setBackgroundImage:[UIImage imageNamed:@"btn_gradient"] forState:UIControlStateHighlighted];
    checkProceesBtn.layer.cornerRadius = 20;
    checkProceesBtn.layer.shadowRadius = 3;
    checkProceesBtn.layer.shadowOffset = CGSizeMake(0, 1);
    checkProceesBtn.layer.shadowOpacity = 0.8;
    checkProceesBtn.layer.shadowColor = ThemeColor7.CGColor;
    checkProceesBtn.titleLabel.font = kPingFangBoldFont(14);
    [checkProceesBtn setTitle:@"查看约会进程" forState:UIControlStateNormal];
    [checkProceesBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [checkProceesBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [backView addSubview:checkProceesBtn];
    
    
    UIButton *continueBtn = [[UIButton alloc] init];
    [continueBtn addTarget:self action:@selector(continueBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [continueBtn setBackgroundColor:[UIColor whiteColor]];
    continueBtn.layer.cornerRadius = 20;
    continueBtn.layer.shadowRadius = 3;
    continueBtn.layer.shadowOffset = CGSizeMake(0, 1);
    continueBtn.layer.shadowOpacity = 0.8;
    continueBtn.layer.shadowColor = RGBA(175, 175, 175, 0.5).CGColor;
    continueBtn.titleLabel.font = kPingFangBoldFont(14);
    [continueBtn setTitle:@"继续浏览" forState:UIControlStateNormal];
    [continueBtn setTitleColor:ThemeColor1 forState:UIControlStateNormal];
    [continueBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [backView addSubview:continueBtn];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@""];
    [string appendAttributedString:[[NSAttributedString alloc] initWithString:@"支付方式："]];
    NSAttributedString *givingStr = [[NSAttributedString alloc] initWithString:coin_name attributes:@{NSForegroundColorAttributeName:RGB(31, 31, 31)                                                                           }];
    [string appendAttributedString:givingStr];
    [payWay setAttributedText:string];
    
    NSMutableAttributedString *payCoinStr = [[NSMutableAttributedString alloc] initWithString:@""];
    [payCoinStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"支付金额："]];
    NSAttributedString *coinStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld",self.payMoney] attributes:@{NSForegroundColorAttributeName:RGB(31, 31, 31)                                                                           }];
    [payCoinStr appendAttributedString:coinStr];
    [self.payCoinLabel setAttributedText:payCoinStr];
    
    XD_WeakSelf
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.left.right.centerX.centerY.mas_equalTo(self);
    }];
    
    [successView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(backView);
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.centerX.mas_equalTo(backView.centerX);
    }];
    
    [successLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(successView.mas_bottom).offset(16);
        make.centerX.mas_equalTo(successView.centerX);
    }];
    
    [payWay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(successLabel.mas_bottom).offset(36);
        make.centerX.mas_equalTo(successLabel.centerX);
    }];
    
    [payCoinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(payWay.mas_bottom).offset(14);
        make.left.mas_equalTo(payWay.mas_left);
    }];
    
    [checkProceesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(payCoinLabel.mas_bottom).offset(46);
        make.centerX.mas_equalTo(payWay.centerX);
        make.size.mas_equalTo(CGSizeMake(188, 40));
    }];
    
    [continueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(checkProceesBtn.mas_bottom).offset(24);
        make.centerX.mas_equalTo(checkProceesBtn.centerX);
        make.size.mas_equalTo(CGSizeMake(188, 40));
        make.bottom.mas_equalTo(backView);
    }];
}

- (void)checkProceesBtnClicked {
    [self dismissViewControllerAnimated:NO completion:^{
        if ([User_Sex isEqualToString:@"1"]) {
//            XDWomanSeekRecodController *vc = [[XDWomanSeekRecodController alloc]init];
//            MainViewController *mainVC = (MainViewController *)[[[UIApplication sharedApplication] keyWindow] rootViewController];
//            UINavigationController *nav = mainVC.selectedViewController;
//            [nav pushViewController:vc animated:YES];
        } else {
//            ManDateHistoryViewController *vc = [[ManDateHistoryViewController alloc]init];
//            MainViewController *mainVC = (MainViewController *)[[[UIApplication sharedApplication] keyWindow] rootViewController];
//            UINavigationController *nav = mainVC.selectedViewController;
//            [nav pushViewController:vc animated:YES];
        }
    }];
}

- (void)continueBtnClicked {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
