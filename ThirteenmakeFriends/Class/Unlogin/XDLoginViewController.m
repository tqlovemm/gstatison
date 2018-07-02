//
//  XDLoginViewController.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/11/30.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDLoginViewController.h"
//#import "XDThirdRegController.h"
#import "XDThirdRegStep1Controller.h"
#import "XDNavigationController.h"
#import "XDForgetPasswordController.h"
#import <UMSocialCore/UMSocialCore.h>
#import "UserProfileManager.h"
#import "ProfileUser.h"
#import "XDAccountTool.h"
#import "ShiSanUser.h"

#import "UIView+XDGradientColor.h"

@interface XDLoginViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) UITextField *usernameField;
@property (weak, nonatomic) UITextField *passwordField;
@property (nonatomic, weak) UIButton * submitBtn;

@end

@implementation XDLoginViewController

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"登录";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:RGB(24, 22, 20)] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName:kPingFangRegularFont(18)}];
    //去除 navigationBar 底部的细线
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    [self setupForDismissKeyboard];
    
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
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)xdd_setupSubViews {
    
    // 背景图
    UIImageView *backgroundImage = [[UIImageView alloc]init];
    backgroundImage.userInteractionEnabled = YES;
    [backgroundImage setImage: [UIImage imageNamed:@"login_bg"]];
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
    
    UITextField *usernameField = [[UITextField alloc] init];
    usernameField.frame = CGRectMake(30, 80, self.view.frame.size.width - 60, 45);
    usernameField.placeholder = @"请输入手机号";
    [usernameField setValue:ThemeColor8 forKeyPath:@"_placeholderLabel.textColor"];
    usernameField.textColor = [UIColor whiteColor];
    usernameField.font = [UIFont fontWithName:@"Helvetica" size:15];
    usernameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    usernameField.keyboardType = UIKeyboardTypeAlphabet;
    usernameField.delegate = self;
    usernameField.autocapitalizationType = UITextAutocapitalizationTypeNone; // 关闭首字母大写
    [contentView addSubview:usernameField];
    self.usernameField = usernameField;
    
    NSString *username = [self lastLoginUsername];
    if (username && username.length > 0) {
        self.usernameField.text = username;
    }
    
    if ([[UIScreen mainScreen] bounds].size.width == 320.0f && [[UIScreen mainScreen] bounds].size.height == 480.0f) {
        usernameField.y = 10;
    }
    
    UIView *upLineView = [[UIView alloc] init];
    upLineView.backgroundColor = RGB(42, 42, 42);
    upLineView.frame = CGRectMake(usernameField.x, CGRectGetMaxY(usernameField.frame), usernameField.width, 1);
    [contentView addSubview:upLineView];
    
    UITextField *passwordField = [[UITextField alloc] init];
    passwordField.frame = CGRectMake(30, CGRectGetMaxY(usernameField.frame) + 20, self.view.frame.size.width - 60, 45);
    passwordField.placeholder = @"密码";
    [passwordField setValue:ThemeColor8 forKeyPath:@"_placeholderLabel.textColor"];
    passwordField.textColor = [UIColor whiteColor];
    passwordField.font = [UIFont fontWithName:@"Helvetica" size:15];
    passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    passwordField.keyboardType = UIKeyboardTypeDefault;
    [passwordField setSecureTextEntry:YES];
    passwordField.returnKeyType = UIReturnKeyGo;
    passwordField.delegate = self;
    passwordField.autocapitalizationType = UITextAutocapitalizationTypeNone; // 关闭首字母大写
    [contentView addSubview:passwordField];
    self.passwordField = passwordField;
    
    UIView *bottomLineView = [[UIView alloc] init];
    bottomLineView.backgroundColor = RGB(42, 42, 42);
    bottomLineView.frame = CGRectMake(passwordField.x, CGRectGetMaxY(passwordField.frame), passwordField.width, 1);
    [contentView addSubview:bottomLineView];
    
    UIButton *submitBtn = [[UIButton alloc] init];
    submitBtn.titleLabel.font = kPingFangRegularFont(16);
    [submitBtn setTitle:@"登录" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    submitBtn.layer.cornerRadius = 24;
    submitBtn.layer.masksToBounds = YES;
    [submitBtn addTarget:self action:@selector(doLogin:) forControlEvents:UIControlEventTouchUpInside];
    submitBtn.backgroundColor = RGB(87, 74, 47);
    submitBtn.size = CGSizeMake(SCREEN_WIDTH - 60, 49);
    submitBtn.y = CGRectGetMaxY(passwordField.frame) + 50;
    submitBtn.centerX = passwordField.centerX;
    [contentView addSubview:submitBtn];
    self.submitBtn = submitBtn;
    
//    [submitBtn setShadowBackgroundColor];
    
    // 背景图
//    UIImageView *backgroundImage = [[UIImageView alloc]init];
//    [contentView addSubview:backgroundImage];
//    [contentView sendSubviewToBack:backgroundImage];
//    backgroundImage.x = 0;
//    backgroundImage.size = CGSizeMake(SCREEN_WIDTH, 120);
//    backgroundImage.y = CGRectGetMaxY(submitBtn.frame);
//    backgroundImage.userInteractionEnabled = YES;
    
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
    
    // 忘记密码
    UIButton *forgetBtn = [[UIButton alloc] init];
    forgetBtn.titleLabel.font = kPingFangRegularFont(12);
    [forgetBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [forgetBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [forgetBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [forgetBtn addTarget:self action:@selector(doForgetPassword:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:forgetBtn];
    
    [forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 44));
//        if (@available(iOS 11.0, *)) {
//            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-10);;
//        } else {
//            make.bottom.mas_equalTo(-10);
//        }
        make.top.equalTo(submitBtn.mas_bottom).offset(20);
        make.centerX.mas_equalTo(self.view);
    }];
}

//登陆账号接口已调通
- (void)doLogin:(UIButton *)sender {
    if (![self isEmpty]) {
        [self.view endEditing:YES];
        
        [self showHudInView:self.view hint:@"正在登录"];
       
        NSMutableDictionary *paras = [NSMutableDictionary dictionary];
        paras[@"username"] = self.usernameField.text;
        paras[@"password_hash"] = self.passwordField.text;
        paras[@"client_id"] = [GeTuiSdk clientId];
        
        [XDRequestHttpTool request_login_withParameters:paras complete:^(id result) {
            
            [self hideHud];
            if ([result[@"code"] integerValue] == 200) {
                
                ProfileUser *user = [ProfileUser objectWithKeyValues:result[@"data"]];
                [XDAccountTool save:user];
      
                // 发送登录通知
                [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@(YES)];

//                NSString *hxpassword = result[@"data"][@"none"];
//                [self loginWithUsername:result[@"data"][@"username"] password:hxpassword];
                // 账号统计
//                [MobClick profileSignInWithPUID:[NSString stringWithFormat:@"%@",result[@"data"][@"id"]]];
                // 保存用户信息
                [self saveLoginMessage:result];
                
                // 头像昵称
                [UserProfileManager saveInfo:result[@"data"][@"username"] imgUrl:result[@"data"][@"avatar"] nickName:result[@"data"][@"nickname"]];
            } else {
                [self.view makeToast:result[@"message"] duration:2.0 position:CSToastPositionCenter];
            }
        } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"%@",error);
            [self.view makeToast:error.localizedDescription duration:2.0 position:CSToastPositionCenter];
            [self hideHud];
        }];
        
    }
}

// 忘记密码
- (void)doForgetPassword:(UIButton *)sender {
    XDForgetPasswordController *forgetVC = [[XDForgetPasswordController alloc]init];
    XDNavigationController *nav = [[XDNavigationController alloc] initWithRootViewController:forgetVC];
    [self presentViewController:nav animated:YES completion:nil];
    
}

//点击登陆后的操作
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
             NSLog(@"%@",loginInfo);

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
         } else {
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

//判断账号和密码是否为空
- (BOOL)isEmpty{
    BOOL ret = NO;
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    if (username.length == 0 || password.length == 0) {
        ret = YES;
        [EMAlertView showAlertWithTitle:NSLocalizedString(@"prompt", @"Prompt")
                                message:NSLocalizedString(@"login.inputNameAndPswd", @"Please enter username and password")
                        completionBlock:nil
                      cancelButtonTitle:NSLocalizedString(@"ok", @"OK")
                      otherButtonTitles:nil];
    }
    
    return ret;
}


#pragma  mark - TextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.usernameField) {
        [self.usernameField resignFirstResponder];
        [self.passwordField becomeFirstResponder];
    } else if (textField == self.passwordField) {
        [self.usernameField resignFirstResponder];
        [self doLogin:nil];
    }
    return YES;
}

- (void)textFieldDidChange:(UITextField *)TextField {
    if (self.usernameField.text.length > 0 && self.passwordField.text.length > 0) {
        self.submitBtn.layer.borderWidth = 1;
        self.submitBtn.layer.borderColor = ThemeColor2.CGColor;
        [self.submitBtn setTitleColor:ThemeColor1 forState:UIControlStateNormal];
        [self.submitBtn setBackgroundColor:ThemeColor2];
    } else {
        self.submitBtn.layer.borderWidth = 1;
        self.submitBtn.layer.borderColor = ThemeColor5.CGColor;
        [self.submitBtn setBackgroundColor:ThemeColor4];
        [self.submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([textField isEqual:self.usernameField]) {
        self.usernameField.text = [self.usernameField.text stringByReplacingOccurrencesOfString:@" "  withString:@""];
    }
}

#pragma  mark - private
- (void)saveLastLoginUsername
{
    NSString *username = [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:kSDKUsername];
    NSString *token = [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:kSDKToken];
    if (username && username.length > 0) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:username forKey:[NSString stringWithFormat:@"em_lastLogin_%@",kSDKUsername]];
        [ud setObject:token forKey:kSDKToken];
        [ud synchronize];
    }
}

- (NSString*)lastLoginUsername
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *username = [ud objectForKey:[NSString stringWithFormat:@"em_lastLogin_%@",kSDKUsername]];
    if (username && username.length > 0) {
        return username;
    }
    return nil;
}

#pragma mark - 保存用户信息（非环信）
- (void)saveLoginMessage:(NSDictionary *)result {
    // 将数据全部存储到NSUserDefaults中
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:[NSString stringWithFormat:@"%@",result[@"data"][@"user_id"]] forKey:LoginUserID];
    [ud setObject:result[@"data"][@"username"] forKey:LoginName];
    [ud setObject:self.passwordField.text forKey:LoginPassword];
    [ud setObject:result[@"data"][@"sex"] forKey:LoginSex];
    [ud setObject:result[@"data"][@"avatar"] forKey:LoginAvatar];
    [ud setObject:result[@"data"][@"none"] forKey:HuangXingPwd];
    
    // 这里建议同步存储到磁盘中，但是不是必须的
    [ud synchronize];
}

- (void)getUserInfoForPlatform:(UIButton *)btn {
    NSLog(@"点击了登录");
    UMSocialPlatformType platformType = (UMSocialPlatformType)btn.tag;
    
    //如果需要获得用户信息直接跳转的话，需要先取消授权
    //step1 取消授权
    [[UMSocialManager defaultManager] cancelAuthWithPlatform:platformType completion:^(id result, NSError *error) {
        [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:self completion:^(id result, NSError *error) {
            
            if (error) {
                
            } else {
                [self showHudInView:self.view hint:nil];
                
                UMSocialUserInfoResponse *resp = result;
                
                NSMutableDictionary *paras = [NSMutableDictionary dictionary];
                paras[@"client_id"] = [GeTuiSdk clientId];
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
//                        XDThirdRegController *thirdVC = [[XDThirdRegController alloc] initWithUser:user];
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

- (ShiSanUser *)getUserInfoForThirdWithPlat:(UMSocialPlatformType )platformType andInfo:(NSDictionary *)userInfo andOpenid:(NSString *)openid {
    
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

@end
