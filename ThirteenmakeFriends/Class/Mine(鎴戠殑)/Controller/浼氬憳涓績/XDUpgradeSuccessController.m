//
//  XDUpgradeSuccessController.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 17/4/14.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//  会员升级成功

#import "XDUpgradeSuccessController.h"
#import "Masonry.h"
#import "MBProgressHUD+MJ.h"

@interface XDUpgradeSuccessController ()<UITextFieldDelegate>

@property (weak, nonatomic) UITextField *style1Field;

@property (weak, nonatomic) UITextField *style2Field;

@end

@implementation XDUpgradeSuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"升级成功";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNavBar];
    [self setupSubViews];
    [self requestData];
    // 关闭键盘
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    // 升级成功通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"upgradeToPaySucess" object:nil];
}
-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    [self.view endEditing:YES];
}
/**
 *  设置导航条内容
 */
- (void)setupNavBar
{
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -12;
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"gray_back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer, backItem];
    UIButton *saveButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [saveButton setTitle:@"提交" forState:UIControlStateNormal];
    [saveButton setTitleColor:NormalNavBtnColor forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithCustomView:saveButton];
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, saveItem];
}
- (void)requestData {
    [FKL_DataService requestURL:[NSString url_getWechatService] parameters:nil withType:@"GET" format:@"JSON" complete:^(id result) {
        if ([result[@"code"] integerValue] == 200) {
            NSMutableAttributedString *searchStr = [[NSMutableAttributedString alloc] initWithString:result[@"data"]];
            NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"添加微信客服" attributes:@{NSForegroundColorAttributeName:RGB(65, 65, 65),
                                                                                                        NSFontAttributeName:[UIFont boldSystemFontOfSize:17]                                                                             }];
            [searchStr insertAttributedString:str atIndex:0];
            self.style1Field.attributedText = searchStr;
        } else {
            [self.view makeToast:result[@"message"] duration:2.0 position:CSToastPositionCenter];
        }
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        [self.view makeToast:error.localizedDescription duration:2.0 position:CSToastPositionCenter];
    }];
}
- (void)setupSubViews {
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.image = [UIImage imageNamed:@"upgrade_congratulation"];
    [self.view addSubview:imgView];
    UILabel *successLabel = [[UILabel alloc]init];
    successLabel.font = kPingFangBoldFont(20);
    successLabel.textColor = RGB(65, 65, 65);
    successLabel.text = @"升级成功!";
    [self.view addSubview:successLabel];
    UILabel *successDesLabel = [[UILabel alloc]init];
    successDesLabel.font = kPingFangBoldFont(12);
    successDesLabel.textColor = RGB(65, 65, 65);
    successDesLabel.numberOfLines = 0;
    successDesLabel.text = @"您已成为会员,为了全方位体验会员服务,请同时添加微信客服。";
    [self.view addSubview:successDesLabel];
    UIImageView *wxView = [[UIImageView alloc] init];
    wxView.image = [UIImage imageNamed:@"upgrade_weixin"];
    [self.view addSubview:wxView];
    UILabel *wxDesLabel = [[UILabel alloc]init];
    wxDesLabel.font = kPingFangBoldFont(12);
    wxDesLabel.textColor = RGB(65, 65, 65);
    wxDesLabel.text = @"微信私人客服在等你哦~";
    [self.view addSubview:wxDesLabel];
    UIImageView *style1View = [[UIImageView alloc] init];
    style1View.image = [UIImage imageNamed:@"upgrade_style1"];
    [self.view addSubview:style1View];
    UITextField *style1Field = [[UITextField alloc] init];
    style1Field.borderStyle = UITextBorderStyleRoundedRect;
    style1Field.textColor = RGB(226, 99, 142);
    style1Field.font = kPingFangBoldFont(17);
    style1Field.userInteractionEnabled = NO;
    style1Field.textAlignment = NSTextAlignmentCenter;
    NSMutableAttributedString *searchStr = [[NSMutableAttributedString alloc] initWithString:@"shisan-10"];
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"添加微信客服" attributes:@{NSForegroundColorAttributeName:RGB(65, 65, 65),
                     NSFontAttributeName:[UIFont boldSystemFontOfSize:17]                                                                             }];
    [searchStr insertAttributedString:str atIndex:0];
    style1Field.attributedText = searchStr;
    style1Field.layer.borderColor = RGB(65, 65, 65).CGColor;
    style1Field.layer.borderWidth = 2;
    style1Field.layer.cornerRadius = 10;
    style1Field.layer.masksToBounds = YES;
    [self.view addSubview:style1Field];
    self.style1Field = style1Field;
    UIImageView *style2View = [[UIImageView alloc] init];
    style2View.image = [UIImage imageNamed:@"upgrade_style2"];
    [self.view addSubview:style2View];
    UITextField *style2Field = [[UITextField alloc] init];
    style2Field.borderStyle = UITextBorderStyleRoundedRect;
    style2Field.textColor = RGB(65, 65, 65);
    style2Field.font = kPingFangBoldFont(17);
    style2Field.placeholder = @"输入微信号，等待客服加好友";
    style2Field.textAlignment = NSTextAlignmentCenter;
    style2Field.delegate = self;
    style2Field.returnKeyType = UIReturnKeyDone;
    style2Field.layer.borderColor = RGB(65, 65, 65).CGColor;
    style2Field.layer.borderWidth = 2;
    style2Field.layer.cornerRadius = 10;
    style2Field.layer.masksToBounds = YES;
    [self.view addSubview:style2Field];
    self.style2Field = style2Field;
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(49);
        make.size.mas_equalTo(CGSizeMake(86, 86));
        make.centerX.mas_equalTo(self.view);
    }];
    [successLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(imgView.mas_bottom).offset(8);
        make.centerX.mas_equalTo(imgView.mas_centerX);
    }];
    [successDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(successLabel.mas_bottom).offset(8);
        make.centerX.mas_equalTo(imgView.mas_centerX);
        make.width.mas_equalTo(SCREEN_WIDTH - 20);
    }];
    [wxDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(successDesLabel.mas_bottom).offset(11);
        make.centerX.mas_equalTo(imgView.mas_centerX).offset(12);
    }];
    [wxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(wxDesLabel.mas_centerY);
        make.trailing.mas_equalTo(wxDesLabel.mas_leading).offset(-3);
        make.size.mas_equalTo(CGSizeMake(23, 20));
    }];
    [style1View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(wxDesLabel.mas_bottom).offset(42);
        make.centerX.mas_equalTo(imgView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(44, 17));
    }];
    [style1Field mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(style1View.mas_bottom).offset(6);
        make.centerX.mas_equalTo(imgView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 48, 40));
    }];
    [style2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(style1Field.mas_bottom).offset(34);
        make.centerX.mas_equalTo(imgView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(44, 17));
    }];
    [style2Field mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(style2View.mas_bottom).offset(6);
        make.centerX.mas_equalTo(imgView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 48, 40));
    }];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    NSLog(@"textField被点击---%@",textField.text);
    if (textField.text.length == 0) {
        [self.view makeToast:@"输入内容不能为空" duration:2.0 position:CSToastPositionCenter];
        return NO;
    }
    [self uploadInfois_load:YES];
    return NO;
}
- (void)back {
    [self.view endEditing:YES];
    [self uploadInfois_load:NO];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)save {
    [self.view endEditing:YES];
    if (self.style2Field.text.length == 0) {
        [self.view makeToast:@"输入内容不能为空" duration:2.0 position:CSToastPositionCenter];
        return;
    }
    [self uploadInfois_load:YES];
}
- (void)uploadInfois_load:(BOOL)load {
    if (load) {
        [self showHudInView:self.view hint:@"上传中..."];
    }
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"user_id"] = User_ID;
    paras[@"recharge_id"] = self.recharge_id;
    paras[@"wechat"] = self.style2Field.text;
    
    // 公钥加密
    NSString *encryWithPublicKeyStr = [RSAUtil encryptString:[NSString stringWithFormat:@"%@",User_ID] publicKey:kRSA_Public_key];
    [FKL_DataService requestURL:[NSString url_UpgradeSuccessSubmit] parameters:paras headerKey:@"sign" headerValue:encryWithPublicKeyStr withType:@"POST" format:@"JSON" complete:^(id result) {
        [self hideHud];
        if ([result[@"code"] integerValue] == 200) {
            if (load) {
                [MBProgressHUD showSuccess:@"提交成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }
        } else {
           [self.view makeToast:result[@"message"] duration:2 position:CSToastPositionCenter];
        }
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        if (load) {
            [self hideHud];
        }
        [self.view makeToast:error.localizedDescription duration:2 position:CSToastPositionCenter];
    }];
}

@end
