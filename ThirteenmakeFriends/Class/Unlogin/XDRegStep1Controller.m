//
//  XDRegStep1Controller.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/11/30.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDRegStep1Controller.h"
#import <SMS_SDK/SMSSDK.h>
#import "SMSSDKUIZonesViewController.h"

#import "FormatValidate.h"
#import "MBProgressHUD+MJ.h"
#import "XDLocalHtmlViewController.h"
#import "XDRegStep2Controller.h"

#import "UIView+XDGradientColor.h"
#import "DefineKeyChain.h"

#import "XDThirdRegStep1Controller.h"
#import <UMSocialCore/UMSocialCore.h>
#import "ShiSanUser.h"
#import "UserProfileManager.h"
#import "XDAccountTool.h"
#import "ProfileUser.h"
#import "MJExtension.h"

#define TextColor RGB(19, 19, 19)

@interface XDRegStep1Controller ()<UIAlertViewDelegate,UITextFieldDelegate>
{
    NSInteger _count;
}
/**  手机号 */
@property(nonatomic,strong) UITextField *cellphone;
/**  验证码 */
@property(nonatomic,weak) UITextField *verifyCode;
/**  密码 */
@property(nonatomic,weak) UITextField *password;
/**  会员码 */
@property(nonatomic,weak) UITextField *memberTf;
/**  验证码按钮 */
@property(nonatomic,weak) UIButton *codeBtn;
/**  下一步按钮 */
@property(nonatomic,weak) UIButton * submitBtn;

/**  用户协议 */
@property(nonatomic,strong) UILabel * agreeLabel;

/**  区域码按钮 */
@property(nonatomic,weak) UILabel *areaCodeField;

@property(nonatomic,strong) UILabel *voiceCallMsgLabel;

@property(nonatomic,strong) UIButton *voiceCallButton;

@property (nonatomic) SMSGetCodeMethod getCodeMethod;

@end

@implementation XDRegStep1Controller

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"注册";
    
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
    if ([self.password isFirstResponder]) {
        self.password.text = @"********";
    }
    
    
    [self.navigationController popViewControllerAnimated:YES];
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
    _cellphone.placeholder = @"请输入手机号";
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
    password.placeholder= @"请输入6~15位新密码";
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
    
    UITextField *memberTf = [[UITextField alloc]initWithFrame:CGRectMake(self.cellphone.x,CGRectGetMaxY(password.frame) + 10,_cellphone.width,_cellphone.height)];
    memberTf.delegate = self;
    memberTf.placeholder= @"会员码";
    //memberTf.rightView = isShowPwdButton;
    //memberTf.rightViewMode = UITextFieldViewModeAlways;
    //[memberTf setSecureTextEntry:YES];
    memberTf.textAlignment = NSTextAlignmentLeft;
    memberTf.font = kPingFangRegularFont(16);
    memberTf.backgroundColor = [UIColor clearColor];
    memberTf.textColor = [UIColor whiteColor];
    [memberTf setValue:ThemeColor8 forKeyPath:@"_placeholderLabel.textColor"];
    memberTf.keyboardType = UIKeyboardTypeAlphabet;
    memberTf.autocapitalizationType = UITextAutocapitalizationTypeNone;
   [contentView addSubview:memberTf];
    self.memberTf = memberTf;
    
   UIView *lineView4 = [[UIView alloc] init];
   lineView4.backgroundColor = RGB(42, 42, 42);
    lineView4.frame = CGRectMake(self.memberTf.x, CGRectGetMaxY(self.memberTf.frame), self.memberTf.width, 1);
    [contentView addSubview:lineView4];
    
    UIButton * submitBtn = [[UIButton alloc] init];
    [submitBtn setTitle:@"下一步" forState:UIControlStateNormal];
    submitBtn.titleLabel.font = kPingFangRegularFont(16);
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    submitBtn.layer.cornerRadius = 24;
    submitBtn.layer.masksToBounds = YES;
    
    submitBtn.frame = CGRectMake(30, CGRectGetMaxY(memberTf.frame) + 50, self.view.frame.size.width - 60, 45);
    submitBtn.backgroundColor = RGB(91,76,48);
    [submitBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:submitBtn];
    self.submitBtn = submitBtn;
//    [submitBtn setShadowBackgroundColor];
    
    _agreeLabel = [[UILabel alloc] init];
    _agreeLabel.frame = CGRectMake(30, CGRectGetMaxY(submitBtn.frame) + 10, self.view.frame.size.width - 60, 25);
    _agreeLabel.textAlignment = NSTextAlignmentCenter;
    _agreeLabel.textColor = TextColor;
    _agreeLabel.font = kPingFangRegularFont(12);
    
//    NSMutableAttributedString *searchStr = [[NSMutableAttributedString alloc] initWithString:@"注册即表示同意"];
//    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"《十三用户协议》" attributes:@{NSForegroundColorAttributeName:ThemeColor1, NSFontAttributeName:[UIFont boldSystemFontOfSize:14]                                                                             }];
//    [searchStr appendAttributedString:str];
//    _agreeLabel.attributedText = searchStr;
//    [contentView addSubview:_agreeLabel];
//    _agreeLabel.userInteractionEnabled = YES;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(agreeViewClicked)];
//    [_agreeLabel addGestureRecognizer:tap];
    
    contentView.contentSize = CGSizeMake(SCREEN_WIDTH, MAX(CGRectGetMaxY(_voiceCallButton.frame) + 48, self.view.height));
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setTitle:@"已有账号？登录" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    backBtn.titleLabel.font = kPingFangRegularFont(12);
    [backBtn setBackgroundColor:[UIColor clearColor]];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:backBtn];
    
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 44));
//        if (@available(iOS 11.0, *)) {
//            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-10);;
//        } else {
//            make.bottom.mas_equalTo(-10);
//        }
        make.top.equalTo(submitBtn.mas_bottom).offset(30);
        make.centerX.mas_equalTo(self.view);
    }];
    
//    _voiceCallMsgLabel = [[UILabel alloc] init];
//    _voiceCallMsgLabel.frame = CGRectMake(30, CGRectGetMaxY(backBtn.frame) + 10, self.view.frame.size.width - 60, 25);
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
    
    UILabel *quicklyLogin = [[UILabel alloc]init];
    quicklyLogin.text = @"第三方登录";
    quicklyLogin.font = [UIFont systemFontOfSize:9];
    quicklyLogin.textAlignment = NSTextAlignmentCenter;
    quicklyLogin.textColor = [UIColor whiteColor];
    quicklyLogin.backgroundColor = [UIColor clearColor];
    quicklyLogin.size = [quicklyLogin.text sizeWithFont:[UIFont systemFontOfSize:9]];
    [self.view addSubview:quicklyLogin];
    [quicklyLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView);
        make.bottom.equalTo(contentView).offset(-63);
    }];
    
    UIView *leftLineView = [[UIView alloc] init];
    leftLineView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:leftLineView];
    [leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 1));
        make.centerY.mas_equalTo(quicklyLogin);
        make.right.mas_equalTo(quicklyLogin.mas_left).offset(-10);
    }];
    
    UIView *rightLineView = [[UIView alloc] init];
    rightLineView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:rightLineView];
    [rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 1));
        make.centerY.mas_equalTo(quicklyLogin);
        make.left.mas_equalTo(quicklyLogin.mas_right).offset(10);
    }];
    
    NSMutableArray *arr = [[NSMutableArray alloc]initWithCapacity:0];
    NSMutableArray *imgArr = [[NSMutableArray alloc]initWithCapacity:0];
    
    
//    if ([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatSession]) {
        [arr addObject:@(UMSocialPlatformType_WechatSession)];
        [imgArr addObject:@"wechat_login_white"];
//    }
    
//    if ([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_QQ]) {
        [arr addObject:@(UMSocialPlatformType_QQ)];
        [imgArr addObject:@"qq_login_white"];
//    }
    
    [arr addObject:@(UMSocialPlatformType_Sina)];
    [imgArr addObject:@"weibo_login_white"];
    
    CGFloat btnWH = 47;
    CGFloat btnMargin = ((SCREEN_WIDTH - 76) - btnWH * arr.count) / (arr.count + 1.0);
    
    for (int index = 0; index < arr.count; index++) {
        UIButton * weiboBtn = [[UIButton alloc] init];
        [weiboBtn setImage:[UIImage imageNamed:[imgArr objectAtIndex:index]] forState:UIControlStateNormal];
        
        NSInteger tag = [[arr objectAtIndex:index] integerValue];
        weiboBtn.tag = tag; //UMSocialPlatformType_QQ
        [weiboBtn addTarget:self action:@selector(getUserInfoForPlatform:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:weiboBtn];
        [weiboBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(38 + btnMargin + (btnWH + btnMargin) * index));
            make.top.equalTo(quicklyLogin.mas_bottom).offset(15);
            make.width.height.equalTo(@(btnWH));
        }];
    }
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
    //带自定义模版
//    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.cellphone.text zone:str2 template:SMS_template result:^(NSError *error) {
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
//- (void)tryVoiceCall {
//    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"确定后将致电您的手机号，语音播报验证码。如不希望被来电打扰请使用短信验证码。"
//                                                    message:[NSString stringWithFormat:@"%@: %@ %@",@"我们将发送验证码短信到这个号码",self.areaCodeField.text, self.cellphone.text]
//                                                   delegate:self
//                                          cancelButtonTitle:@"取消"
//                                          otherButtonTitles:@"确定", nil];
//    [alert show];
//}

#pragma mark - UIAlertViewDelegate
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if ([alertView cancelButtonIndex] != buttonIndex)
//    {
//        NSString *str2 = [self.areaCodeField.text stringByReplacingOccurrencesOfString:@"+" withString:@""];
//        //带自定义模版
//        [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodVoice phoneNumber:self.cellphone.text zone:str2 template:SMS_template result:^(NSError *error) {
//             if (error)
//             {
//                 NSString *messageStr = [NSString stringWithFormat:@"%@",[[error.userInfo objectForKey:@"description"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//                 UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"发送失败"
//                                                                 message:messageStr
//                                                                delegate:nil
//                                                       cancelButtonTitle:@"确定"
//                                                       otherButtonTitles:nil, nil];
//                 [alert show];
//             }
//         }];
//    }
//}

#pragma mark - 用户协议
- (void)agreeViewClicked {
    XDLocalHtmlViewController *agreeVC = [XDLocalHtmlViewController localHtmlViewControllerWithHtmlTitle:@"用户协议" HtmlString:@"http://www.vcooline.com/app/materials/320540"];
    
    [self.navigationController pushViewController:agreeVC animated:YES];
}

#pragma mark - 下一步
- (void)submit {
    
    NSMutableDictionary *readUserInfoamtion = (NSMutableDictionary *)[DefineKeyChain load:@"KEY_INFORMATION"];
    NSLog(@"++++++++++>%@",[readUserInfoamtion objectForKey:@"KEY_IDENT"]);
    if ([readUserInfoamtion objectForKey:@"KEY_IDENT"] == nil ) {
        if (self.cellphone.text.length == 0){
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请输入正确的手机号"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];

            return;
        }

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
        // 校验验证码，防止用户在当前界面停滞时间太久导致验证码失效
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        param[@"cellphone"] = self.cellphone.text;
        param[@"code"] = self.verifyCode.text;
        param[@"zone"] = [self.areaCodeField.text stringByReplacingOccurrencesOfString:@"" withString:@"+"];
        param[@"from"] = @"ali";
        
        [FKL_DataService requestURL:[NSString url_codeVerifies] parameters:param withType:@"POST" format:@"JSON" complete:^(id result) {
            if ([result[@"code"] integerValue]== 200) {
                NSLog(@"%@",result[@"message"]);
                // 验证码未失效
                // 校验手机号是否注册过
                [FKL_DataService requestURL:[NSString url_validateIsRegister_withPhone:self.cellphone.text] parameters:nil withType:@"GET" format:@"JSON" complete:^(id result) {
                    if ([result[@"code"] integerValue] == 200) {
                        // 手机号未注册，进入完善资料界面
                        XDRegStep2Controller *regVC = [[XDRegStep2Controller alloc] init];
                        regVC.cellPhone = self.cellphone.text;
                        regVC.password = self.password.text;
                        regVC.verificationCode = self.verifyCode.text;
                        regVC.zone = [self.areaCodeField.text stringByReplacingOccurrencesOfString:@"" withString:@"+"];
                        regVC.inviteCode = self.memberTf.text;
                        
                        [self.navigationController pushViewController:regVC animated:YES];
                    } else {
                        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                        message:@"该手机号已被注册"
                                                                       delegate:nil
                                                              cancelButtonTitle:@"确定"
                                                              otherButtonTitles:nil];
                        [alert show];
                    }
                } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
                    
                }];
            }
        } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    } else {
        [MBProgressHUD showError:@"一个设备只能注册一个手机号" toView:self.view];
    }
}

- (void)getUserInfoForPlatform:(UIButton *)btn {
    NSLog(@"点击了登录");
    UMSocialPlatformType platformType = (UMSocialPlatformType)btn.tag;
    
    //如果需要获得用户信息直接跳转的话，需要先取消授权
    //step1 取消授权
    [[UMSocialManager defaultManager] cancelAuthWithPlatform:platformType completion:^(id result, NSError *error) {
        [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:self completion:^(id result, NSError *error) {
            
            if (error) {
                NSString *result = @"";
                switch (error.code) {
                    case UMSocialPlatformErrorType_Unknow:
                        result = @"未知错误";
                        break;
                    case UMSocialPlatformErrorType_NotSupport:
                        result = @"不支持（url scheme 没配置，或者没有配置-ObjC， 或则SDK版本不支持或则客户端版本不支持";
                        break;
                    case UMSocialPlatformErrorType_AuthorizeFailed:
                        result = @"授权失败";
                        break;
                    case UMSocialPlatformErrorType_ShareFailed:
                        result = @"分享失败";
                        break;
                    case UMSocialPlatformErrorType_RequestForUserProfileFailed:
                        result = @"请求用户信息失败";
                        break;
                    case UMSocialPlatformErrorType_ShareDataNil:
                        result = @"分享内容为空";
                        break;
                    case UMSocialPlatformErrorType_ShareDataTypeIllegal:
                        result = @"分享内容不支持";
                        break;
                    case UMSocialPlatformErrorType_CheckUrlSchemaFail:
                        result = @"schemaurl fail";
                        break;
                    case UMSocialPlatformErrorType_NotInstall:
                        result = @"应用未安装";
                        break;
                        
                    case UMSocialPlatformErrorType_NotNetWork:
                        result = @"网络异常";
                        break;
                    case UMSocialPlatformErrorType_SourceError:
                        result = @"第三方错误";
                        break;
                    case UMSocialPlatformErrorType_ProtocolNotOverride:
                        result = @"对应的  UMSocialPlatformProvider的方法没有实现";
                        break;
                    default:
                        break;
                }
                if (result.length > 0) {
                    [self.view makeToast:result duration:2.0 position:CSToastPositionCenter];
                }
            } else {
                [self showHudInView:self.view hint:nil];
                
                UMSocialUserInfoResponse *resp = result;
                
                NSMutableDictionary *paras = [NSMutableDictionary dictionary];
                paras[@"cid"] = [GeTuiSdk clientId];
                paras[@"openid"] = platformType == UMSocialPlatformType_Sina ? resp.uid : resp.openid;
                
                [FKL_DataService requestURL:[NSString url_third_login] parameters:paras withType:@"GET" format:@"JSON" complete:^(id result) {
                    [self hideHud];
                    if ([result[@"code"] intValue] == 200) {
                        ProfileUser *user = [ProfileUser objectWithKeyValues:result[@"data"]];
                        [XDAccountTool save:user];
                        // 保存用户信息
                        [self saveLoginMessage:result];
                        // 账号统计
                        [MobClick profileSignInWithPUID:[NSString stringWithFormat:@"%@",result[@"data"][@"id"]]];
                        
                        // 头像昵称
                        [UserProfileManager saveInfo:result[@"data"][@"username"] imgUrl:result[@"data"][@"avatar"] nickName:result[@"data"][@"nickname"]];
                        
                        // 登录
                        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                        NSString *hxpassword = [ud objectForKey:HuangXingPwd];
                        [self loginWithUsername:User_Name password:hxpassword];
                        
                    } else if ([result[@"code"] intValue] == 201) {
                        ShiSanUser * user = [self getUserInfoForThirdWithPlat:platformType andInfo:resp.originalResponse andOpenid:platformType == UMSocialPlatformType_Sina ? resp.uid : resp.openid];
                        XDThirdRegStep1Controller *thirdVC = [[XDThirdRegStep1Controller alloc] initWithUser:user];
                        [self.navigationController pushViewController:thirdVC animated:YES];
                    } else {
                        [self.view makeToast:result[@"message"] duration:2.0 position:CSToastPositionCenter];
                    }
                } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
                    [self hideHud];
                    [self.view makeToast:error.localizedDescription duration:2.0 position:CSToastPositionCenter];
                }];
                
            }
        }];
        
    }];
    
    //    ShiSanUser * user = [self getUserInfoForThirdWithPlat:platformType andInfo:nil andOpenid:nil];
    //    XDThirdRegController *thirdVC = [[XDThirdRegController alloc] initWithUser:user];
    //    thirdVC.title = @"完善个人信息";
    //    [self.navigationController pushViewController:thirdVC animated:YES];
}

- (ShiSanUser *)getUserInfoForThirdWithPlat:(UMSocialPlatformType )platformType andInfo:(NSDictionary *)userInfo andOpenid:(NSString *)openid{
    ShiSanUser *user = [[ShiSanUser alloc] init];
    if (platformType == UMSocialPlatformType_QQ) {
        user.nickname = userInfo[@"nickname"];
        user.sex = [userInfo[@"gender"] isEqualToString:@"女"] ? @"1" : @"0";
        user.avatar = userInfo[@"figureurl_qq_2"] ? userInfo[@"figureurl_qq_2"] : userInfo[@"figureurl_qq_1"];
        user.birthdate = nil;
        user.openId = openid;
        return user;
    } else if (platformType == UMSocialPlatformType_Sina) {
        user.nickname = userInfo[@"screen_name"];
        user.sex = [userInfo[@"gender"] isEqualToString:@"f"] ? @"1" : @"0";
        user.avatar = userInfo[@"avatar_large"] ? userInfo[@"avatar_large"] : userInfo[@"profile_image_url"];
        user.birthdate = nil;
        user.openId = openid;
        
        return user;
    } else if (platformType == UMSocialPlatformType_WechatSession) { // 微信头像需在自己服务器保存
        
        user.nickname = userInfo[@"nickname"];
        user.sex = [userInfo[@"gender"] intValue] == 2 ? @"1" : @"0";
        user.avatar = userInfo[@"headimgurl"];
        user.birthdate = nil;
        user.openId = openid;
        
        return user;
    } else {
        return user;
    }
}

- (void)saveLoginMessage:(NSDictionary *)result {
    // 将数据全部存储到NSUserDefaults中
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:[NSString stringWithFormat:@"%@",result[@"data"][@"user_id"]] forKey:LoginUserID];
    [ud setObject:result[@"data"][@"username"] forKey:LoginName];
    [ud setObject:result[@"data"][@"sex"] forKey:LoginSex];
    [ud setObject:result[@"data"][@"avatar"] forKey:LoginAvatar];
    [ud setObject:result[@"data"][@"none"] forKey:HuangXingPwd];
    
    // 这里建议同步存储到磁盘中，但是不是必须的
    [ud synchronize];
}

#pragma mark - //点击登陆后的操作
- (void)loginWithUsername:(NSString *)username password:(NSString *)password
{
    [self showHudInView:self.view hint:@"正在登录..."];
    //异步登陆账号
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:username
                                                        password:password
                                                      completion:
     ^(NSDictionary *loginInfo, EMError *error) {
         // 隐藏正在登录提示
         [self hideHud];
         if (loginInfo && !error) {
             //设置是否自动登录
             [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
             
             // 旧数据转换 (如果您的sdk是由2.1.2版本升级过来的，需要家这句话)
             [[EaseMob sharedInstance].chatManager importDataToNewDatabase];
             //获取数据库中数据
             [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
             
             //获取群组列表
             [[EaseMob sharedInstance].chatManager asyncFetchMyGroupsList];
             
             //发送自动登陆状态通知
             //             [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
             // 加userinfo是为了手势密码
             [[NSNotificationCenter defaultCenter]postNotificationName:KNOTIFICATION_LOGINCHANGE object:@([[[EaseMob sharedInstance] chatManager] isLoggedIn]) userInfo:@{@"abc":@"def"}];
             
             //保存最近一次登录用户名
             [self saveLastLoginUsername];
         }
         else
         {
             switch (error.errorCode)
             {
                 case EMErrorNotFound:
                     TTAlertNoTitle(error.description);
                     break;
                 case EMErrorNetworkNotConnected:
                     TTAlertNoTitle(NSLocalizedString(@"error.connectNetworkFail", @"No network connection!"));
                     break;
                 case EMErrorServerNotReachable:
                     TTAlertNoTitle(NSLocalizedString(@"error.connectServerFail", @"Connect to the server failed!"));
                     break;
                 case EMErrorServerAuthenticationFailure:
                     TTAlertNoTitle(error.description);
                     break;
                 case EMErrorServerTimeout:
                     TTAlertNoTitle(NSLocalizedString(@"error.connectServerTimeout", @"Connect to the server timed out!"));
                     break;
                 default:
                     TTAlertNoTitle(NSLocalizedString(@"login.fail", @"Login failure"));
                     break;
             }
         }
     } onQueue:nil];
}

#pragma  mark - private
- (void)saveLastLoginUsername
{
    NSString *username = [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:kSDKUsername];
    if (username && username.length > 0) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:username forKey:[NSString stringWithFormat:@"em_lastLogin_%@",kSDKUsername]];
        [ud synchronize];
    }
}
@end
