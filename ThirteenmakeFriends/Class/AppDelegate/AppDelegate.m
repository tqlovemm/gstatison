/************************************************************
 *  * EaseMob CONFIDENTIAL
 * __________________
 * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of EaseMob Technologies.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from EaseMob Technologies.
 */

#import "AppDelegate.h"
//#import "XDUserSelectController.h"
#import "XDLoginSelectController.h"

#import "AppDelegate+XDPush.h"
#import "AppDelegate+ThirdLogin.h"
#import "AppDelegate+VersionUpdate.h"
#import "HMNewfeatureViewController.h"
#import "SDWebImageManager.h"
#import "XDThreadLocation.h"
#import "AppDelegate+XDLaunchAD.h"

//BQMM集成
#import <BQMM/BQMM.h>
// 键盘管理
#import "IQKeyboardManager.h"
#import "XHLaunchAd.h"

#import "XDNavigationController.h"
#import "ProfileUser.h"
#import "XDAccountTool.h"
#import "UserProfileManager.h"

#import "XDSignInView.h"
//#import "XDAuthoritationCenterController.h"
#import "XDSignInModel.h"
#import "MJExtension.h"

@interface AppDelegate ()
@end
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
#if APP_Puppet  // Puppet
    NSLog(@"a");
#elif APP_myPuppet
    NSLog(@"b");
#elif APP_Peach
    NSLog(@"c");
#else // 正常
    NSLog(@"d");
#endif
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    _connectionState = eEMConnectionConnected;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStateChange:)
                                                 name:KNOTIFICATION_LOGINCHANGE
                                               object:nil];
    // 版本更新
    [self versionUpdateApplication:application didFinishLaunchingWithOptions:launchOptions];

    [self pushApplication:application didFinishLaunchingWithOptions:launchOptions];

    [self thirdLoginApplication:application didFinishLaunchingWithOptions:launchOptions];

    //BQMM集成
    // 初始化表情MMSDK
    [[MMEmotionCentre defaultCentre] setAppId:BQMM_AppKey
                                       secret:BQMM_AppSecret];

    // 开启网络监听
    [self initAppNetworking];

    // 设置吐司显示不加入队列
    [CSToastManager setQueueEnabled:NO];

    // 获取定位信息
    [self startLocation];

    [self selectRootViewController];

    [self setupXHLaunchAd];
    // 键盘管理
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;

    if (@available(iOS 11.0, *)) {
        [[UITableView appearance] setEstimatedSectionHeaderHeight:0];
        [[UITableView appearance] setEstimatedSectionFooterHeight:0];
        [[UITableView appearance] setEstimatedRowHeight:0];
    }
    
    return YES;
}

- (void)xhLaunchShowFinish:(XHLaunchAd *)launchAd {
    [_pwdVc showTouchIDView:YES];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if (_mainController) {
        [_mainController jumpToChatList];
    }
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    if (_mainController) {
        [_mainController didReceiveLocalNotification:notification];
    }
}

#pragma mark - private
//登陆状态改变
-(void)loginStateChange:(NSNotification *)notification {
    
    BOOL isAutoLogin = [[[EaseMob sharedInstance] chatManager] isAutoLoginEnabled];
//    BOOL loginSuccess = [notification.object boolValue];
    
    
    if ([User_ID length]) {
        // 已注册登录过
        if (_mainController == nil) {
            _mainController = [[MainViewController alloc] init];
            [_mainController networkChanged:_connectionState];
        }
        self.window.rootViewController = _mainController;
        [self.window makeKeyAndVisible];
    } else {
        BOOL loginSuccess = [notification.object boolValue];
        if (loginSuccess) {
            if (_mainController == nil) {
                _mainController = [[MainViewController alloc] init];
                [_mainController networkChanged:_connectionState];
            }
            self.window.rootViewController = _mainController;
            [self.window makeKeyAndVisible];
        } else {
            _mainController = nil;
            XDLoginSelectController *loginController = [[XDLoginSelectController alloc] init];
            XDNavigationController *nav = [[XDNavigationController alloc] initWithRootViewController:loginController];
            self.window.rootViewController = nav;
            [self.window makeKeyAndVisible];
        }
    }
    
//    if (loginSuccess) { // 登陆成功加载主窗口控制器
////        // 绑定用户的cid
////        [self requestBindingWithCid];
//        if (notification == nil && isAutoLogin) {
//            [self autoLogin13app];
//        }
//
//        //加载申请通知的数据
//        [[ApplyViewController shareController] loadDataSourceFromLocalDB];
//
//        NSString *strPwd  = [UserDefaults objectForKey:CombinationLock];
//        NSString *openPWD = [UserDefaults objectForKey:OpenedGesPWD];
//        NSString *touchid = [UserDefaults objectForKey:TouchID];
//
//        if (notification.userInfo == nil && StringEqual(openPWD, @"YES")) {
//
//            if ([touchid isEqualToString:@"YES"] || strPwd.length > 0 ) {
//                XD_WeakSelf
//                _pwdVc  = [[ICELoginPWDViewController alloc]init];
//                if (strPwd.length > 0 && strPwd != nil ) {
//                }
//                else if (touchid.length > 0 && touchid != nil) {
//                    _pwdVc.combinationLockHidden = YES;
//                }
//
//                self.window.rootViewController = _pwdVc;
//                [self.window makeKeyAndVisible];
//                _pwdVc.popBlock = ^(){
//                    XD_StrongSelf
//                    self.window.rootViewController = nil;
//                    if (self.mainController == nil) {
//                        self.mainController = [[MainViewController alloc] init];
//                        [self.mainController networkChanged:self.connectionState];
//                    }
//
//                    self.window.rootViewController = self.mainController;
//                    [self.window makeKeyAndVisible];
//
//                    if ([User_Sex isEqualToString:@"1"]) {
//                        [self todaySignIn];
//                    }
//                };
//            } else {
//                if (_mainController == nil) {
//                    _mainController = [[MainViewController alloc] init];
//                    [_mainController networkChanged:_connectionState];
//                }
//                self.window.rootViewController = _mainController;
//                [self.window makeKeyAndVisible];
//
//                if ([User_Sex isEqualToString:@"1"]) {
//                    [self todaySignIn];
//                }
//            }
//        } else { //登陆成功没开启手势密码
//            if (_mainController == nil) {
//                _mainController = [[MainViewController alloc] init];
//                [_mainController networkChanged:_connectionState];
//            }
//            self.window.rootViewController = _mainController;
//            [self.window makeKeyAndVisible];
//
//            if ([User_Sex isEqualToString:@"1"]) {
//                [self todaySignIn];
//            }
//        }
//    } else { //登陆失败加载登陆页面控制器
//        _mainController = nil;
//        XDLoginSelectController *loginController = [[XDLoginSelectController alloc] init];
//        XDNavigationController *nav = [[XDNavigationController alloc] initWithRootViewController:loginController];
//        self.window.rootViewController = nav;
//        [self.window makeKeyAndVisible];
//    }
}

- (void)selectRootViewController {
    // 如何知道第一次使用这个版本？比较上次的使用情况
    NSString *versionKey = (__bridge NSString *)kCFBundleVersionKey;
    // 从沙盒中取出上次存储的软件版本号(取出用户上次的使用记录)
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *lastVersion = [defaults objectForKey:versionKey];
    // 获得当前打开软件的版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[versionKey];
    if ([currentVersion isEqualToString:lastVersion]) {
        _newVersion = NO;
//        [self loginStateChange:nil];
        BOOL isAutoLogin = [[[EaseMob sharedInstance] chatManager] isAutoLoginEnabled];
        if (isAutoLogin){
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
        }
    } else { // 当前版本号 != 上次使用的版本：显示版本新特性
        _newVersion = YES;
        self.window.rootViewController = [[HMNewfeatureViewController alloc] init];
        [self.window makeKeyAndVisible];
//        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@([[[EaseMob sharedInstance] chatManager] isLoggedIn])];
        // 存储这次使用的软件版本
        [defaults setObject:currentVersion forKey:versionKey];
        [defaults synchronize];
    }
}

/**
 *  应用内存发生警告时调用
 */
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    
    // 停止下载所有图片
    [[SDWebImageManager sharedManager] cancelAll];
    // 清除内存中的图片
    [[SDWebImageManager sharedManager].imageCache clearMemory];
    
}

- (void)requestBindingWithCid {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"cid"] = [GeTuiSdk clientId];
    
    [XDRequestHttpTool request_BindingWithCid_withParameters:params complete:^(id result) {
        NSLog(@"个推cid绑定成功");
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"个推cid绑定失败%@",error);
    }];
    
}
- (void)initAppNetworking {
    // 2.判断网络状况
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"AFNetworkReachabilityStatusUnknown");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"AFNetworkReachabilityStatusNotReachable");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"AFNetworkReachabilityStatusReachableViaWiFi");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"AFNetworkReachabilityStatusReachableViaWWAN");
                break;
            default:
                break;
        }
    }];
    // 开始监控网络可达性的变化状态
    [mgr startMonitoring];
}

- (void)startLocation {
    
    XDThreadLocation *loc = [[XDThreadLocation alloc]init];
    [loc start];
    
    __weak __typeof(loc) weakSelf = loc;
    loc.locationOperation = ^{
        NSLog(@"定位成功");
        NSLog(@"======当前纬度为%f",weakSelf.coordinate.latitude);
        NSLog(@"======当前经度为%f",weakSelf.coordinate.longitude);
    };
    
   
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    //BQMM集成
    [[MMEmotionCentre defaultCentre] clearSession];
}

#pragma mark - 自动登录
- (void)autoLogin13app {
    ProfileUser *user = [XDAccountTool account];
    
    if (user.openId.length > 0) {
        NSMutableDictionary *paras = [NSMutableDictionary dictionary];
        paras[@"client_id"] = [GeTuiSdk clientId];
        paras[@"openid"] = user.openId;
        
        [FKL_DataService requestURL:[NSString url_third_login] parameters:paras withType:@"GET" format:@"JSON" complete:^(id result) {
            if ([result[@"code"] intValue] == 200) {
                ProfileUser *user = [ProfileUser objectWithKeyValues:result[@"data"]];
                [XDAccountTool save:user];
                
                // 头像昵称
                [UserProfileManager saveInfo:result[@"data"][@"username"] imgUrl:result[@"data"][@"avatar"] nickName:result[@"data"][@"nickname"]];
                
            } else {
                [self.window.rootViewController.view makeToast:result[@"message"] duration:2.0 position:CSToastPositionCenter];
            }
        } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
            [self.window.rootViewController.view makeToast:error.localizedDescription duration:2.0 position:CSToastPositionCenter];
        }];
        
    } else {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *password = [ud objectForKey:LoginPassword];
        
        NSMutableDictionary *paras = [NSMutableDictionary dictionary];
        paras[@"username"] = user.username;
        paras[@"password_hash"] = password;
        paras[@"client_id"] = [GeTuiSdk clientId];
        
        [XDRequestHttpTool request_login_withParameters:paras complete:^(id result) {
            if ([result[@"code"] integerValue] == 200) {
                ProfileUser *user = [ProfileUser objectWithKeyValues:result[@"data"]];
                [XDAccountTool save:user];
                // 头像昵称
                [UserProfileManager saveInfo:result[@"data"][@"username"] imgUrl:result[@"data"][@"avatar"] nickName:result[@"data"][@"nickname"]];
            } else {
                [self.window.rootViewController.view makeToast:result[@"message"] duration:2.0 position:CSToastPositionCenter];
            }
        } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
            [self.window.rootViewController.view makeToast:error.localizedDescription duration:2.0 position:CSToastPositionCenter];
        }];
    }
}

#pragma mark - 签到
- (void)todaySignIn {

//    UITabBarController *tabBar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
//    UINavigationController *nav = tabBar.selectedViewController;
//    NSString *encryWithPublicKeyStr = [RSAUtil encryptString:[NSString stringWithFormat:@"%@",User_ID] publicKey:kRSA_Public_key];
//    [FKL_DataService requestURL:[NSString url_signIn] parameters:nil headerKey:@"sign" headerValue:encryWithPublicKeyStr withType:@"GET" format:@"JSON" complete:^(id result) {
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        if ([result[@"code"] integerValue] == 200) { // 签到成功
//            [defaults setBool:YES forKey:@"is_today_SignIn"];
//            
//            XDSignInModel *signModel = [XDSignInModel objectWithKeyValues:result[@"data"]];
//            XDSignInView *likeView = [[XDSignInView alloc] init];
//            likeView.model = signModel;
//            likeView.couponButtonClicked = ^(UIButton *btn) {
//                XDAuthoritationCenterController *authVC = [[XDAuthoritationCenterController alloc] init];
//                [nav pushViewController:authVC animated:YES];
//            };
//            [likeView show:YES];
//        } else if ([result[@"code"] integerValue] == 201) { //今日已签到
//            [defaults setBool:YES forKey:@"is_today_SignIn"];
//        } else {
//            [nav.view makeToast:result[@"message"]
//                        duration:2.0
//                        position:CSToastPositionCenter];
//            [defaults setBool:NO forKey:@"is_today_SignIn"];
//        }
//        
//        [defaults synchronize];
//    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
//        [nav.view makeToast:error.localizedDescription
//                    duration:2.0
//                    position:CSToastPositionCenter];
//    }];
}

@end
