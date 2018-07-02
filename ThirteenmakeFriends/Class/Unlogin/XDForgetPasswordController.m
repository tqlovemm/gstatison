//
//  XDForgetPasswordController.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/12/1.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDForgetPasswordController.h"
#import <SMS_SDK/SMSSDK.h>
#import "SMSSDKUIZonesViewController.h"
#import "FormatValidate.h"
#import "MBProgressHUD+MJ.h"
#import "XDLocalHtmlViewController.h"
#import "XDRegStep2Controller.h"

#import "UIView+XDGradientColor.h"

#define TextColor RGB(19, 19, 19)

@interface XDForgetPasswordController ()<UIAlertViewDelegate,UITextFieldDelegate>
{
    NSInteger _count;
}
/**  手机号 */
@property(nonatomic,strong) UITextField *cellphone;
/**  验证码 */
@property(nonatomic,weak) UITextField *verifyCode;
/**  密码 */
@property(nonatomic,weak) UITextField *password;
/**  验证码按钮 */
@property(nonatomic,weak) UIButton *codeBtn;
/**  下一步按钮 */
@property(nonatomic,weak) UIButton * submitBtn;

/** 区域码按钮 */
@property(nonatomic,weak) UILabel *areaCodeField;

@property(nonatomic,strong) UILabel *voiceCallMsgLabel;

@property(nonatomic,strong) UIButton *voiceCallButton;

//@property (nonatomic, strong) NSMutableArray* areaArray;

@property (nonatomic) SMSGetCodeMethod getCodeMethod;

@end

@implementation XDForgetPasswordController

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"忘记密码";
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:RGB(24, 22, 20)] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName:kPingFangRegularFont(18)}];
    //去除 navigationBar 底部的细线
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    [self xdd_setupSubViews];
    
    [self setupNavigationBar];
}

- (void)setupNavigationBar {
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"gray_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -12;
    self.navigationItem.leftBarButtonItems = @[negativeSpacer, backItem];
}

- (void)back {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)xdd_setupSubViews {
    
    // 背景图
    UIImageView *backgroundImage = [[UIImageView alloc]init];
    backgroundImage.image = [UIImage imageNamed:@"login_bg"];
    [self.view addSubview:backgroundImage];
    [backgroundImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    UIScrollView *contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationBar_Height)];
    contentView.bounces = NO;
    [self.view addSubview:contentView];
    
    if (@available(iOS 11.0, *)) {
        contentView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    UILabel* areaCodeField = [[UILabel alloc] init];
    areaCodeField.size = CGSizeMake(50, 46);
    areaCodeField.text = [NSString stringWithFormat:@"+86"];
    areaCodeField.textColor = [UIColor whiteColor];
    areaCodeField.textAlignment = NSTextAlignmentLeft;
    areaCodeField.font = kPingFangRegularFont(16);
    areaCodeField.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *reg = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(areaSelected)];
    [areaCodeField addGestureRecognizer:reg];
    
    _cellphone = [[UITextField alloc] init];
    _cellphone.frame = CGRectMake(30, 40, self.view.frame.size.width - 60, 45);
    _cellphone.leftView = areaCodeField;
    _cellphone.leftViewMode = UITextFieldViewModeAlways;
    _cellphone.placeholder = @"请输入手机号码";
    [_cellphone setValue:ThemeColor8 forKeyPath:@"_placeholderLabel.textColor"];
    _cellphone.textColor = [UIColor whiteColor];
    _cellphone.font = kPingFangRegularFont(16);
    _cellphone.keyboardType = UIKeyboardTypePhonePad;
    _cellphone.clearButtonMode = UITextFieldViewModeWhileEditing;
    [contentView addSubview:_cellphone];
    self.areaCodeField = areaCodeField;
    
    UIView *lineView1 = [[UIView alloc] init];
    lineView1.backgroundColor = RGB(42, 42, 42);
    lineView1.frame = CGRectMake(self.cellphone.x, CGRectGetMaxY(self.cellphone.frame), self.cellphone.width, 1);
    [contentView addSubview:lineView1];
    
    UITextField *Verifycode = [[UITextField alloc]initWithFrame:CGRectMake(self.cellphone.x,CGRectGetMaxY(_cellphone.frame) + 10,_cellphone.width,_cellphone.height)];
    Verifycode.placeholder= @"请输入验证码";
    Verifycode.textAlignment = NSTextAlignmentLeft;
    Verifycode.keyboardType = UIKeyboardTypePhonePad;
    Verifycode.font = kPingFangRegularFont(16);
    Verifycode.backgroundColor = [UIColor clearColor];
    Verifycode.textColor = [UIColor whiteColor];
    [Verifycode setValue:ThemeColor8 forKeyPath:@"_placeholderLabel.textColor"];
    [contentView addSubview:Verifycode];
    self.verifyCode = Verifycode;
    
    UIButton * codeBtn=[UIButton new];
    codeBtn.size = CGSizeMake(100, 34);
    [codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [codeBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:15.0f]];
    [codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [codeBtn setBackgroundColor:RGB(88,74,48)];
    [codeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    codeBtn.layer.cornerRadius = 17.0f;
    codeBtn.layer.masksToBounds = YES;
    [codeBtn addTarget:self action:@selector(sendCode) forControlEvents:UIControlEventTouchUpInside];
    self.codeBtn = codeBtn;
    Verifycode.rightView = codeBtn;
    Verifycode.rightViewMode = UITextFieldViewModeAlways;
    
    UIView *lineView2 = [[UIView alloc] init];
    lineView2.backgroundColor = RGB(42, 42, 42);
    lineView2.frame = CGRectMake(self.verifyCode.x, CGRectGetMaxY(self.verifyCode.frame), self.verifyCode.width, 1);
    [contentView addSubview:lineView2];
    
    // 是否显示密码
    UIButton *isShowPwdButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [isShowPwdButton setImage:[UIImage imageNamed:@"unview_passpord"] forState:UIControlStateNormal];
    [isShowPwdButton setImage:[UIImage imageNamed:@"view_passpord"] forState:UIControlStateSelected];
    isShowPwdButton.size = CGSizeMake(40, 40);
    [isShowPwdButton addTarget:self action:@selector(isShowPassword:) forControlEvents:UIControlEventTouchUpInside];
    
    UITextField *password = [[UITextField alloc]initWithFrame:CGRectMake(self.cellphone.x,CGRectGetMaxY(Verifycode.frame) + 10,_cellphone.width,_cellphone.height)];
    password.delegate = self;
    password.placeholder= @"设置密码";
    password.rightView = isShowPwdButton;
    password.rightViewMode = UITextFieldViewModeAlways;
    [password setSecureTextEntry:YES];
    password.textAlignment = NSTextAlignmentLeft;
    password.font = kPingFangRegularFont(16);
    password.backgroundColor = [UIColor clearColor];
    password.textColor = [UIColor whiteColor];
    [password setValue:ThemeColor8 forKeyPath:@"_placeholderLabel.textColor"];
    password.keyboardType = UIKeyboardTypeAlphabet;
    password.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [contentView addSubview:password];
    self.password = password;
    
    UIView *lineView3 = [[UIView alloc] init];
    lineView3.backgroundColor = RGB(42, 42, 42);
    lineView3.frame = CGRectMake(self.password.x, CGRectGetMaxY(self.password.frame), self.password.width, 1);
    [contentView addSubview:lineView3];
    
    UIButton * submitBtn = [[UIButton alloc] init];
    [submitBtn setTitle:@"完成" forState:UIControlStateNormal];
    submitBtn.titleLabel.font = kPingFangRegularFont(16);
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    submitBtn.layer.cornerRadius = 24;
    submitBtn.layer.masksToBounds = YES;
    submitBtn.backgroundColor = RGB(88,74,48);
    submitBtn.frame = CGRectMake(30, CGRectGetMaxY(password.frame) + 50, self.view.frame.size.width - 60, 45);
    [submitBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:submitBtn];
    self.submitBtn = submitBtn;
//    [submitBtn setShadowBackgroundColor];
    
//    _voiceCallMsgLabel = [[UILabel alloc] init];
//    _voiceCallMsgLabel.frame = CGRectMake(30, CGRectGetMaxY(self.submitBtn.frame) + 10, self.view.frame.size.width - 60, 25);
//    _voiceCallMsgLabel.textAlignment = NSTextAlignmentCenter;
//    [_voiceCallMsgLabel setFont:kPingFangRegularFont(12)];
//    _voiceCallMsgLabel.text = @"您也可以选择电话收听语音验证码：";
//    _voiceCallMsgLabel.textColor = TextColor;
//    [contentView addSubview:_voiceCallMsgLabel];
//    _voiceCallMsgLabel.hidden = YES;
//
//    _voiceCallButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    [_voiceCallButton setBackgroundColor:[UIColor whiteColor]];
//    _voiceCallButton.layer.cornerRadius = 20;
//    _voiceCallButton.layer.shadowRadius = 3;
//    _voiceCallButton.layer.shadowOffset = CGSizeMake(0, 1);
//    _voiceCallButton.layer.shadowOpacity = 0.8;
//    _voiceCallButton.layer.shadowColor = RGBA(0, 0, 0, 0.17).CGColor;
//    _voiceCallButton.titleLabel.font = kPingFangRegularFont(14);
//    [_voiceCallButton setTitle:@"语音验证码" forState:UIControlStateNormal];
//    [_voiceCallButton setTitleColor:ThemeColor1 forState:UIControlStateNormal];
//    [_voiceCallButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
//    [_voiceCallButton addTarget:self action:@selector(tryVoiceCall) forControlEvents:UIControlEventTouchUpInside];
//
//    _voiceCallButton.size = CGSizeMake(148, 46);
//    _voiceCallButton.y = CGRectGetMaxY(_voiceCallMsgLabel.frame) + 10;
//    _voiceCallButton.centerX = _voiceCallMsgLabel.centerX;
//    [contentView addSubview:_voiceCallButton];
//    _voiceCallButton.hidden = YES;
    
    contentView.contentSize = CGSizeMake(SCREEN_WIDTH, MAX(CGRectGetMaxY(_voiceCallButton.frame) + 48, self.view.height));
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setTitle:@"已有账号？登录" forState:UIControlStateNormal];
    [backBtn setTitleColor:TextColor forState:UIControlStateNormal];
    backBtn.titleLabel.font = kPingFangRegularFont(12);
    [backBtn setBackgroundColor:[UIColor clearColor]];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 44));
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-10);;
        } else {
            make.bottom.mas_equalTo(-10);
        }
        make.centerX.mas_equalTo(self.view);
    }];
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.view endEditing:YES];
}

- (void)isShowPassword:(UIButton *)btn {
    btn.selected = !btn.selected;
    [self.password setSecureTextEntry:!btn.selected];
}

- (void)sendCode {
    
    NSString *msg;
    if ([self.cellphone.text isEqualToString:@""]||(self.cellphone.text == nil)) {
        msg = @"手机号码不能为空";
    }
    if (msg.length !=0) {
        UIAlertView  *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        [alert show];
        return;
    }
    if (![FormatValidate validateMobile:self.cellphone.text]) {
        UIAlertView  *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"手机号格式不正确" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        [alert show];
        return;
    }
    
    [self performSelector:@selector(countClick) withObject:nil];
    
    NSString *str2 = [self.areaCodeField.text stringByReplacingOccurrencesOfString:@"" withString:@"+"];
    NSLog(@"%@",str2);
    
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"cellphone"] = self.cellphone.text;
    paras[@"zone"] = str2;
    
    // 阿里云发验证码
    [FKL_DataService requestURL:[NSString sendCode] parameters:paras withType:@"POST" format:@"JSON" complete:^(id result) {
        if ([result[@"code"] integerValue] == 200) {
            NSLog(@"获取验证码成功");
        } else {
            [self.view makeToast:result[@"message"] duration:2.0 position:CSToastPositionCenter];
        }
        
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"错误信息：%@",error);
    }];
    
//    self.getCodeMethod = SMSGetCodeMethodSMS;
//
//    //带自定义模版
//    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.cellphone.text zone:str2 template:SMS_template result:^(NSError *error) {
//
//        if (!error) {
//            NSLog(@"获取验证码成功");
//        } else {
//            NSLog(@"错误信息：%@",error);
//            UIAlertView  *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"%@",[[error.userInfo objectForKey:@"description"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
//            [alert show];
//        }
//    }];
}

-(void)countClick
{
    self.codeBtn.enabled =NO;
    _count = 60;
    [_codeBtn setTitle:@"60秒" forState:UIControlStateDisabled];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
}

-(void)timerFired:(NSTimer *)timer
{
    if (_count !=1) {
        _count -=1;
        [_codeBtn setTitle:[NSString stringWithFormat:@"%ld秒",(long)_count] forState:UIControlStateDisabled];
    }
    else
    {
        [timer invalidate];
        _codeBtn.enabled = YES;
        [_codeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
    }
    
    
    if (_count == 30)
    {
        if (self.getCodeMethod == SMSGetCodeMethodSMS) {
            
            if (_voiceCallMsgLabel.hidden)
            {
                _voiceCallMsgLabel.hidden = NO;
            }
            
            if (_voiceCallButton.hidden)
            {
                _voiceCallButton.hidden = NO;
            }
        }
        
    }
}


- (void)areaSelected {
    XD_WeakSelf
    SMSSDKUIZonesViewController *vc = [[SMSSDKUIZonesViewController alloc] initWithResult:^(BOOL cancel, NSString *zone, NSString *countryName) {
        XD_StrongSelf
        if (!cancel && zone && countryName)
        {
            self.areaCodeField.text = zone;
        }
    }];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

#pragma mark - 发送语言验证码
- (void)tryVoiceCall {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"确定后将致电您的手机号，语音播报验证码。如不希望被来电打扰请使用短信验证码。"
                                                    message:[NSString stringWithFormat:@"%@: %@ %@",@"我们将发送验证码短信到这个号码",self.areaCodeField.text, self.cellphone.text]
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
    [alert show];
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView cancelButtonIndex] != buttonIndex)
    {
        NSString *str2 = [self.areaCodeField.text stringByReplacingOccurrencesOfString:@"+" withString:@""];
        
        //带自定义模版
        [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodVoice phoneNumber:self.cellphone.text zone:str2 template:SMS_template result:^(NSError *error) {
            
            if (error)
            {
                NSString *messageStr = [NSString stringWithFormat:@"%@",[[error.userInfo objectForKey:@"description"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"发送失败"
                                                                message:messageStr
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil, nil];
                [alert show];
            }
        }];
        
    }
}

#pragma mark - 忘记密码
- (void)submit {
    
    if (self.verifyCode.text.length == 0){
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"验证码不能为空"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    if (self.password.text.length < 6 || self.password.text.length > 15) {
        [MBProgressHUD showError:@"密码应在6~15位之间"];
        self.password.text = @"";
        return ;
    }
    
    NSString *str2 = [self.areaCodeField.text stringByReplacingOccurrencesOfString:@"" withString:@"+"];
    
    XD_WeakSelf
    [self showHudInView:self.view hint:@"修改中..."];
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"password_hash"] = self.password.text;
    paras[@"cellphone"] = self.cellphone.text;
    paras[@"zone"] = str2;
    paras[@"from"] = @"ali";
    paras[@"code"] = self.verifyCode.text;
    
    [FKL_DataService requestURL:[NSString url_resetPassword_withZone] parameters:paras withType:@"POST" format:@"JSON" complete:^(id result) {
        XD_StrongSelf
        [self hideHud];
        if ([result[@"code"] integerValue] == 200) {
            [MBProgressHUD showSuccess:@"密码重置成功"];
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self.view makeToast:result[@"message"] duration:2.0 position:CSToastPositionCenter];
        }
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        XD_StrongSelf
        [self hideHud];
        [self.view makeToast:error.localizedDescription duration:2.0 position:CSToastPositionCenter];
    }];
}

@end
