//
//  XDLoginSelectController.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/11/30.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDLoginSelectController.h"
#import "XDLoginViewController.h"
#import "XDRegStep1Controller.h"
#import "XDThirdRegStep1Controller.h"
#import <UMSocialCore/UMSocialCore.h>
#import "ShiSanUser.h"
#import "UserProfileManager.h"
#import "XDAccountTool.h"
#import "ProfileUser.h"
#import "MJExtension.h"

#define DistanceToHeight 118.0/375*SCREEN_WIDTH
#define DistanceToDown 87.0/375*SCREEN_WIDTH

@interface XDLoginSelectController ()

@end

@implementation XDLoginSelectController

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:20]}];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    
    //去除 navigationBar 底部的细线
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    [self xdd_setupSubViews];
//    [self setupSubView];
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
    
    //logo图片
    UIImageView *logoImage = [[UIImageView alloc]init];
    [logoImage setImage: [UIImage imageNamed:@"login_logo"]];
    [self.view addSubview:logoImage];
    
    [logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(DistanceToHeight);
        make.width.equalTo(@110);
        make.height.equalTo(@162);
    }];
    
    // 登录按钮
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    loginButton.layer.cornerRadius = 20;
    loginButton.layer.shadowRadius = 3;
    loginButton.layer.shadowOffset = CGSizeMake(0, 1);
    loginButton.backgroundColor = RGB(91,76,48);
    //    loginButton.layer.shadowOpacity = 0.8;
    loginButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:loginButton];
    [loginButton addTarget:self action:@selector(loginBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.width.equalTo(self.view).offset(-30);
        make.bottom.equalTo(self.view).offset(-DistanceToDown);
        make.height.equalTo(@45);
    }];
    
    // 注册按钮
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerButton setTitle:@"注册" forState:UIControlStateNormal];
    registerButton.layer.cornerRadius = 20;
    registerButton.layer.shadowRadius = 3;
    registerButton.layer.shadowOffset = CGSizeMake(0, 1);
    registerButton.backgroundColor = RGB(60,60,60);
    registerButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:registerButton];
    [registerButton addTarget:self action:@selector(registerButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(loginButton);
        make.bottom.equalTo(loginButton.mas_top).offset(-30);
        make.height.equalTo(@45);
    }];
}

// 登录按钮点击
- (void)loginBtnClicked {
    NSLog(@"登录按钮点击了");
    XDLoginViewController *loginVC = [[XDLoginViewController alloc] init];
    [self.navigationController pushViewController:loginVC animated:YES];
}

// 注册按钮点击
- (void)registerButtonClicked {
    NSLog(@"注册按钮点击了");
    XDRegStep1Controller *loginVC = [[XDRegStep1Controller alloc] init];
    [self.navigationController pushViewController:loginVC animated:YES];
}
/**
 /
- (void)xdd_setupSubViews {
    
    //logo图片
    UIImageView *logoImage = [[UIImageView alloc]init];
    logoImage.image = [UIImage imageNamed:@"app_icon"];
    logoImage.layer.cornerRadius = 5.0f;
    logoImage.layer.masksToBounds = YES;
    logoImage.size = CGSizeMake(91, 91);
    logoImage.centerX = self.view.width / 2.0;
    if (iPhone5SE) {
        logoImage.y = NavigationBar_Height + 2;
    } else if ([[UIScreen mainScreen] bounds].size.width == 320.0f && [[UIScreen mainScreen] bounds].size.height == 480.0f) {
        logoImage.y = kStatusBarHeight + 20;
    } else {
        logoImage.y = 128;
    }
    [self.view addSubview:logoImage];
    
    UIButton * submitBtn = [[UIButton alloc] init];
    [submitBtn setBackgroundColor:[UIColor whiteColor]];
    submitBtn.layer.cornerRadius = 20;
    submitBtn.layer.shadowRadius = 3;
    submitBtn.layer.shadowOffset = CGSizeMake(0, 1);
    submitBtn.layer.shadowOpacity = 0.8;
    submitBtn.layer.shadowColor = RGBA(0, 0, 0, 0.17).CGColor;
    submitBtn.titleLabel.font = kPingFangRegularFont(18);
    [submitBtn setTitle:@"注册" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    
    CGFloat btnW = (SCREEN_WIDTH - 36 - 15 * 2) / 2.0;
    
    
    UIButton * loginBtn = [[UIButton alloc] init];
    [loginBtn setBackgroundColor:[UIColor whiteColor]];
    loginBtn.layer.cornerRadius = 20;
    loginBtn.layer.shadowRadius = 3;
    loginBtn.layer.shadowOffset = CGSizeMake(0, 1);
    loginBtn.layer.shadowOpacity = 0.8;
    loginBtn.layer.shadowColor = RGBA(0, 0, 0, 0.17).CGColor;
    loginBtn.titleLabel.font = kPingFangRegularFont(18);
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:ThemeColor1 forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    
    loginBtn.size = CGSizeMake(btnW, 46);
    loginBtn.y = submitBtn.y;
//    loginBtn.centerX = intro.centerX + (18 + btnW / 2.0);
    
    [self.view addSubview:loginBtn];
    [loginBtn addTarget:self action:@selector(loginBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    // 背景图
    UIImageView *backgroundImage = [[UIImageView alloc]init];
    backgroundImage.image = [UIImage imageNamed:@"unlogin_background"];
    [self.view addSubview:backgroundImage];
    [self.view sendSubviewToBack:backgroundImage];
    backgroundImage.x = 0;
    backgroundImage.size = CGSizeMake(SCREEN_WIDTH, 166);
    backgroundImage.y = self.view.height - 166;
    backgroundImage.userInteractionEnabled = YES;
    
    UILabel *quicklyLogin = [[UILabel alloc]init];
    quicklyLogin.text = @"第三方登录";
    quicklyLogin.font = [UIFont systemFontOfSize:9];
    quicklyLogin.textAlignment = NSTextAlignmentCenter;
    quicklyLogin.textColor = [UIColor whiteColor];
    quicklyLogin.backgroundColor = [UIColor clearColor];
    quicklyLogin.size = [quicklyLogin.text sizeWithFont:[UIFont systemFontOfSize:9]];
//    quicklyLogin.centerX = intro.centerX;
    quicklyLogin.y = 80;
    [backgroundImage addSubview:quicklyLogin];
    
    UIView *leftLineView = [[UIView alloc] init];
    leftLineView.backgroundColor = [UIColor whiteColor];
    [backgroundImage addSubview:leftLineView];
    [leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 1));
        make.centerY.mas_equalTo(quicklyLogin);
        make.right.mas_equalTo(quicklyLogin.mas_left).offset(-10);
    }];
    
    UIView *rightLineView = [[UIView alloc] init];
    rightLineView.backgroundColor = [UIColor whiteColor];
    [backgroundImage addSubview:rightLineView];
    [rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 1));
        make.centerY.mas_equalTo(quicklyLogin);
        make.left.mas_equalTo(quicklyLogin.mas_right).offset(10);
    }];
    
    NSMutableArray *arr = [[NSMutableArray alloc]initWithCapacity:0];
    NSMutableArray *imgArr = [[NSMutableArray alloc]initWithCapacity:0];


    if ([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_QQ]) {
        [arr addObject:@(UMSocialPlatformType_QQ)];
        [imgArr addObject:@"qq_login_white"];
    }

    if ([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatSession]) {
        [arr addObject:@(UMSocialPlatformType_WechatSession)];
        [imgArr addObject:@"wechat_login_white"];
    }

    [arr addObject:@(UMSocialPlatformType_Sina)];
    [imgArr addObject:@"weibo_login_white"];

    CGFloat btnWH = 47;
    CGFloat btnMargin = ((SCREEN_WIDTH - 76) - btnWH * arr.count) / (arr.count + 1.0);

    for (int index = 0; index < arr.count; index++) {
        UIButton * weiboBtn = [[UIButton alloc] init];
        [weiboBtn setImage:[UIImage imageNamed:[imgArr objectAtIndex:index]] forState:UIControlStateNormal];
        weiboBtn.size = CGSizeMake(btnWH, btnWH);
        weiboBtn.y = CGRectGetMaxY(quicklyLogin.frame) + 25;
        weiboBtn.x = 38 + btnMargin + (btnWH + btnMargin) * index;
        NSInteger tag = [[arr objectAtIndex:index] integerValue];
        weiboBtn.tag = tag; //UMSocialPlatformType_QQ
        [weiboBtn addTarget:self action:@selector(getUserInfoForPlatform:) forControlEvents:UIControlEventTouchUpInside];
        [backgroundImage addSubview:weiboBtn];
    }
}

//- (void)submitBtnClicked {
//    XDRegStep1Controller *loginVC = [[XDRegStep1Controller alloc] init];
//    [self.navigationController pushViewController:loginVC animated:YES];
//    
//}
//
//- (void)loginBtnClicked {
//    XDLoginViewController *loginVC = [[XDLoginViewController alloc] init];
//    [self.navigationController pushViewController:loginVC animated:YES];
//}

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
/**/
@end
