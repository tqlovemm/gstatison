//
//  XDThirdRegStep2Controller.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/12/1.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDThirdRegStep2Controller.h"
#import <SMS_SDK/SMSSDK.h>
#import "SMSSDKUIZonesViewController.h"
#import "FormatValidate.h"
#import "MBProgressHUD+MJ.h"
#import "XDLocalHtmlViewController.h"
#import "XDRegStep2Controller.h"

#import "UIView+XDGradientColor.h"
#import "FormatValidate.h"
#import "ShiSanUser.h"
#import "ProfileUser.h"
#import "XDAccountTool.h"
#import "UserProfileManager.h"

#define TextColor RGB(19, 19, 19)

@interface XDThirdRegStep2Controller ()<UIAlertViewDelegate,UITextFieldDelegate>
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

/**  用户协议 */
@property(nonatomic,strong) UILabel * agreeLabel;

/**  区域码按钮 */
@property(nonatomic,weak) UILabel *areaCodeField;

@property(nonatomic,strong) UILabel *voiceCallMsgLabel;

@property(nonatomic,strong) UIButton *voiceCallButton;

@property (nonatomic) SMSGetCodeMethod getCodeMethod;

@end

@implementation XDThirdRegStep2Controller

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"第三方登录";
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:RGB(24, 22, 20)] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName:kPingFangRegularFont(18)}];
    //去除 navigationBar 底部的细线
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    [self setupSubViews];
    
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

- (void)setupSubViews {
    
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
    areaCodeField.textColor = TextColor;
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
    lineView1.backgroundColor = RGB(240, 239, 245);
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
    [codeBtn setBackgroundColor:ThemeColor1];
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
    password.enablesReturnKeyAutomatically = YES;
    [contentView addSubview:password];
    self.password = password;
    
    UIView *lineView3 = [[UIView alloc] init];
    lineView3.backgroundColor = RGB(240, 239, 245);
    lineView3.frame = CGRectMake(self.password.x, CGRectGetMaxY(self.password.frame), self.password.width, 1);
    [contentView addSubview:lineView3];
    
    
    UIButton * submitBtn = [[UIButton alloc] init];
    [submitBtn setTitle:@"完成" forState:UIControlStateNormal];
    submitBtn.titleLabel.font = kPingFangRegularFont(16);
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    submitBtn.layer.cornerRadius = 24;
    submitBtn.layer.masksToBounds = YES;
    submitBtn.backgroundColor = RGB(91,76,48);
    submitBtn.frame = CGRectMake(30, CGRectGetMaxY(password.frame) + 50, self.view.frame.size.width - 60, 45);
    [submitBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:submitBtn];
    self.submitBtn = submitBtn;
    
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
//
//             if (error)
//             {
//                 //                 NSString *messageStr = [NSString stringWithFormat:@"%zidescription",error.code];
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

#pragma mark - 注册
//- (void)submit {
//    NSString *str2 = [self.areaCodeField.text stringByReplacingOccurrencesOfString:@"" withString:@"+"];

//    [SMSSDK commitVerificationCode:self.verifyCode.text phoneNumber:self.cellphone.text zone:str2 result:^(NSError *error) {
//        if (!error) {
//            [self doRegister];
//        } else {
//            [self.view makeToast:[NSString stringWithFormat:@"%@",error.userInfo[@"commitVerificationCode"]] duration:2.0 position:CSToastPositionCenter];
//        }
//    }];
//}

- (void)submit {
    
    if (![self isEmpty]) {
        //隐藏键盘
        [self.view endEditing:YES];
        
        if (![FormatValidate validateLetterAndNumber:self.cellphone.text]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"用户名只能输入英文和数字的组合"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            
            [alert show];
            
            return;
        }
        
        NSString *sexStr = @"0";
        if ([self.sex isEqualToString:@"男"]) {
            sexStr = @"1";
        } else if ([self.sex isEqualToString:@"女"]) {
            sexStr = @"2";
        }
        
        NSDictionary *dict = @{@"出生年份" : [self.birthdate substringWithRange:NSMakeRange(0, 4)],@"性别" : [sexStr isEqualToString:@"1"] ? @"男" : @"女"};
        [MobClick event:@"register" attributes:dict];
        
        NSMutableDictionary *paras = [NSMutableDictionary dictionary];
        paras[@"cellphone"] = self.cellphone.text;
        paras[@"zone"] = [self.areaCodeField.text stringByReplacingOccurrencesOfString:@"" withString:@"+"];
        paras[@"code"] = self.verifyCode.text;
        paras[@"username"] = self.nickName;
        paras[@"avatar"] = self.avatar;
        paras[@"openId"] = self.user.openId;
        paras[@"sex"] = sexStr;
        paras[@"birthday"] = self.birthdate;
        paras[@"client_id"] = [GeTuiSdk clientId];
        paras[@"password_hash"] = self.password.text;
        
        [self showHudInView:self.view hint:@"注册登录中..."];
        
        [FKL_DataService requestURL:[NSString url_third_register] parameters:paras withType:@"POST" format:@"JSON" complete:^(id result) {
            if ([result[@"code"] intValue] == 200) {
                
                ProfileUser *user = [ProfileUser objectWithKeyValues:result[@"data"]];
                [XDAccountTool save:user];
                
                // 保存用户信息
                [self saveLoginMessage:result];
                // 账号统计
//                [MobClick profileSignInWithPUID:[NSString stringWithFormat:@"%@",result[@"data"][@"id"]]];
                // 头像昵称
                [UserProfileManager saveInfo:result[@"data"][@"username"] imgUrl:result[@"data"][@"avatar"] nickName:result[@"data"][@"nickname"]];
                
                // 登录
//                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//                NSString *hxpassword = [ud objectForKey:HuangXingPwd];
//                [self loginWithUsername:User_Name password:hxpassword];
            } else {
                [self.view makeToast:result[@"message"] duration:2.0 position:CSToastPositionCenter];
            }
            
            [self hideHud];
        } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"%@",error);
            [self hideHud];
            [self.view makeToast:error.localizedDescription duration:2.0 position:CSToastPositionCenter];
        }];
    }
}

//判断账号和密码是否为空
- (BOOL)isEmpty{
    
    BOOL ret = NO;
    NSString *username = self.cellphone.text;
    NSString *sexStr = self.sex;
    NSString *avatar = self.avatar;
    NSString *nickname = self.nickName;
    
    NSString *phoneStr = self.cellphone.text;
    NSString *birthdate = self.birthdate;
    NSString *password = self.password.text;
    
    if (username.length == 0 || sexStr.length == 0 || avatar.length == 0 || nickname.length == 0 || phoneStr.length == 0 || birthdate.length == 0 || password.length == 0) {
        ret = YES;
        [EMAlertView showAlertWithTitle:NSLocalizedString(@"prompt", @"Prompt")
                                message:@"所有信息不能为空"
                        completionBlock:nil
                      cancelButtonTitle:NSLocalizedString(@"ok", @"OK")
                      otherButtonTitles:nil];
    }
    
    return ret;
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
    [self showHudInView:self.view hint:NSLocalizedString(@"login.ongoing", @"Is Login...")];
    //异步登陆账号
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:username
                                                        password:password
                                                      completion:
     ^(NSDictionary *loginInfo, EMError *error) {
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
             [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@([[[EaseMob sharedInstance] chatManager] isLoggedIn])];
             
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

#pragma mark - textfield delegate
//点击return 按钮 去掉
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
