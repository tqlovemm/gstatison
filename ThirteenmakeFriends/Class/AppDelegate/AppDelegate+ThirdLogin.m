//
//  AppDelegate+ThirdLogin.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 16/3/23.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//  友盟统计，分享，第三方登陆,ping++聚合支付

#import "AppDelegate+ThirdLogin.h"
#import <UMSocialCore/UMSocialCore.h>
#import <UMAnalytics/MobClick.h>
#import <UMCommon/UMCommon.h>
//#import "XDPostDetailController.h"

@implementation AppDelegate (ThirdLogin)

- (void)thirdLoginApplication:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 友盟统计
//#if DEBUG
//    [MobClick setLogEnabled:YES];
//#else
//    [MobClick setLogEnabled:NO];
//#endif
//    UMConfigInstance.appKey = UM_Statistics_AppKey;
//    UMConfigInstance.ePolicy = BATCH;
//    [MobClick startWithConfigure:UMConfigInstance];
    
    [UMConfigure initWithAppkey:UM_Statistics_AppKey channel:@"App Store"];
    [MobClick setScenarioType:E_UM_NORMAL];
    // ----------- 第三方登录 -------------------
#if DEBUG
    //打开调试日志
    [[UMSocialManager defaultManager] openLog:YES];
#else
    [[UMSocialManager defaultManager] openLog:NO];
#endif
    //设置友盟appkey
    [[UMSocialManager defaultManager] setUmSocialAppkey:UM_Statistics_AppKey];
    
    //设置微信的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WX_AppKey appSecret:WX_AppSecret redirectURL:WX_redirectURL];
    
    //设置分享到QQ互联的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:QQ_AppKey  appSecret:QQ_AppSecret redirectURL:QQ_redirectURL];
    
    //设置新浪的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:WB_AppKey  appSecret:WB_AppSecret redirectURL:WB_redirectURL];
    [UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;;
    // ----------- ending -------------------
    
//    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//    [MobClick setAppVersion:version];
    
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
         [self openThread:url];
    }
    return result;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
        [self openThread:url];
    }
    return result;
}

-(void)openThread:(NSURL*)url{
    if (![myAppDelegate.window.rootViewController isKindOfClass:[MainViewController class]]) {
        // 若跟视图不是SQTabBarController
        return;
    }
    NSString *thread_id = @"";
    if ([[url query] containsString:@"thread_id="]) {
        NSRange rang = [[url query]rangeOfString:@"thread_id="];
        thread_id = [[url query] substringFromIndex:rang.length];
    }
    if(thread_id.length){
        //            url = platform13://com.13platform.www.puppet/thread?thread_id=1000
        MainViewController *tabVC = (MainViewController *)myAppDelegate.window.rootViewController;
        [tabVC setSelectedIndex:3];
        UINavigationController *sqNav = tabVC.selectedViewController;
//        XDPostDetailController *replyCommentVC = [[XDPostDetailController alloc] init];
//        replyCommentVC.thread_id = thread_id;
//        [sqNav pushViewController:replyCommentVC animated:YES];
    }
}
@end
