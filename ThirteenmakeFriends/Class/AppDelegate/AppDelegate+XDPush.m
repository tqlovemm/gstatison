//
//  AppDelegate+XDPush.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 17/4/26.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "AppDelegate+XDPush.h"
#import "MJExtension.h"
#import "PushModel.h"
#import "PushDealTool.h"
#import "AppUpdateInfo.h"
#import <objc/runtime.h>
#import "MBProgressHUD+Add.h"
#import "UserProfileManager.h"

#import <UserNotifications/UserNotifications.h>

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end


@implementation AppDelegate (XDPush)

- (void)pushApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 注册 APNS
    [self registerUserNotification];
    // 处理远程通知启动 APP
    [self receiveNotificationByLaunchingOptions:launchOptions];
    // 通过个推平台分配的 appId、 appKey 、appSecret 启动 SDK,注: 该方法需要在主线程中调用
    [GeTuiSdk startSdkWithAppId:kGtAppId appKey:kGtAppKey appSecret:kGtAppSecret delegate:self];
    // SDK注册 APNS文件的名字, 需要与后台上传证书时的名字一一对应
    NSString *apnsCertName = nil;
#if DEBUG
    apnsCertName = apns_dev;
#else
    apnsCertName = apns_distribe;
#endif
    
    [[EaseMob sharedInstance] registerSDKWithAppKey:AppKey apnsCertName:apnsCertName otherConfig:@{kSDKConfigEnableConsoleLogger:@YES}];
//    [[EaseSDKHelper shareHelper] easemobApplication:application
//                      didFinishLaunchingWithOptions:launchOptions
//                                             appkey:AppKey
//                                       apnsCertName:apnsCertName
//                                        otherConfig:@{kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:YES]}];
    
    // 登录成功后，自动去取好友列表
    // SDK获取结束后，会回调
    // - (void)didFetchedBuddyList:(NSArray *)buddyList error:(EMError *)error方法。
    [[EaseMob sharedInstance].chatManager setIsAutoFetchBuddyList:YES];
    
    // 注册环信监听
    [self registerEaseMobNotification];
    [[EaseMob sharedInstance] application:application
            didFinishLaunchingWithOptions:launchOptions];
    
    [self setupNotifiers];
}

#pragma mark - 用户通知(推送) _自定义方法

/** 注册用户通知 */
- (void)registerUserNotification {
    
    UIApplication *application = [UIApplication sharedApplication];
    application.applicationIconBadgeNumber = 0;
    
    if([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
#if !TARGET_IPHONE_SIMULATOR
    //iOS8 注册APNS
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
//        [application registerForRemoteNotifications];
        dispatch_async(dispatch_get_main_queue(), ^{
            [application registerForRemoteNotifications];
        });
    }else{
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound |
        UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
#endif
    
//    /*
//     警告：Xcode8 需要手动开启"TARGETS -> Capabilities -> Push Notifications"
//     */
//    
//    /*
//     警告：该方法需要开发者自定义，以下代码根据 APP 支持的 iOS 系统不同，代码可以对应修改。
//     以下为演示代码，注意根据实际需要修改，注意测试支持的 iOS 系统都能获取到 DeviceToken
//     */
//    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0 // Xcode 8编译会调用
//        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
//        center.delegate = self;
//        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionCarPlay) completionHandler:^(BOOL granted, NSError *_Nullable error) {
//            if (!error) {
//                NSLog(@"request authorization succeeded!");
//            }
//        }];
//        
//        [[UIApplication sharedApplication] registerForRemoteNotifications];
//#else // Xcode 7编译会调用
//        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
//        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
//        [[UIApplication sharedApplication] registerForRemoteNotifications];
//        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
//#endif
//    } else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
//        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
//        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
//        [[UIApplication sharedApplication] registerForRemoteNotifications];
//        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
//    } else {
//        UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert |
//                                                                       UIRemoteNotificationTypeSound |
//                                                                       UIRemoteNotificationTypeBadge);
//        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
//    }
}

/** 自定义：APP被“推送”启动时处理推送消息处理（APP 未启动--》启动）*/
- (void)receiveNotificationByLaunchingOptions:(NSDictionary *)launchOptions {
    
    if (!launchOptions)
        return;
    
    /*
     通过“远程推送”启动APP
     UIApplicationLaunchOptionsRemoteNotificationKey 远程推送Key
     */
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        NSLog(@"\n>>>[Launching RemoteNotification]:%@", userInfo);
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    } else {
        userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    }
}

#pragma mark - 用户通知(推送)回调 _IOS 8.0以上使用

/** 已登记用户通知 */
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    // 注册远程通知（推送）
//    [application registerForRemoteNotifications];
    dispatch_async(dispatch_get_main_queue(), ^{
        [application registerForRemoteNotifications];
    });
}

#pragma mark - 远程通知(推送)回调

/** 远程通知注册成功委托 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *myToken = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    myToken = [myToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    // 将得到的deviceToken传给SDK个推
    [GeTuiSdk registerDeviceToken:myToken];
    
    NSLog(@"\n>>>[DeviceToken Success]:%@\n\n", myToken);
    
    // 将得到的deviceToken传给SDK环信
    [[EaseMob sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

/** 远程通知注册失败委托 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    // 个推
    [GeTuiSdk registerDeviceToken:@""];
    
    NSLog(@"\n>>>[DeviceToken Error]:%@\n\n", error.description);
    
    // 环信
    [[EaseMob sharedInstance] application:application didFailToRegisterForRemoteNotificationsWithError:error];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"apns.failToRegisterApns", Fail to register apns)
                                                    message:error.description
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"ok", @"OK")
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark - APP运行中接收到通知(推送)处理

/** APP已经接收到“远程”通知(推送) - (App运行在后台/App运行在前台) */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    application.applicationIconBadgeNumber = 0; // 标签
    
    NSLog(@"\n>>>[Receive RemoteNotification]:%@\n\n", userInfo);
}

/** APP已经接收到“远程”通知(推送) - 透传推送消息  */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    // 处理APN
    NSLog(@"\n>>>[Receive RemoteNotification - Background Fetch]:%@\n\n", userInfo);
    
//    [[UIApplication sharedApplication] cancelAllLocalNotifications];
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    // 处于后台时点击-推送列表
    _clickedAtBackgound = YES;
    
    PushModel *pushModel = nil;
    NSData *jsonData = [[userInfo objectForKey:@"payload"] dataUsingEncoding:NSUTF8StringEncoding];
    if (jsonData != nil) {
        NSDictionary *textDic = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        pushModel = [PushModel objectWithKeyValues:textDic];
    }
    
    if (pushModel == nil) {
        return;
    }
    
    // 进行处理本地通知内容
    [PushDealTool chuliTuiSongWithPushModel:pushModel];
    
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark - GeTuiSdkDelegate

/** SDK启动成功返回cid */
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    // [4-EXT-1]: 个推SDK已注册，返回clientId
    NSLog(@"\n>>>[GeTuiSdk RegisterClient]:%@\n\n", clientId);
}

/** SDK遇到错误回调 */
- (void)GeTuiSdkDidOccurError:(NSError *)error {
    // [EXT]:个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
    NSLog(@"\n>>>[GexinSdk error]:%@\n\n", [error localizedDescription]);
}


/** SDK收到透传消息回调 */
- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId {
    
    // [ GTSdk ]：汇报个推自定义事件(反馈透传消息)
    [GeTuiSdk sendFeedbackMessage:90001 andTaskId:taskId andMsgId:msgId];
    
    // 数据转换
    NSString *payloadMsg = nil;
    if (payloadData) {
        payloadMsg = [[NSString alloc] initWithBytes:payloadData.bytes length:payloadData.length encoding:NSUTF8StringEncoding];
    }
    
    // 控制台打印日志
    NSString *msg = [NSString stringWithFormat:@"taskId=%@,messageId:%@,payloadMsg:%@%@", taskId, msgId, payloadMsg, offLine ? @"<离线消息>" : @""];
    NSLog(@"\n>>[GTSdk ReceivePayload]:%@\n\n", msg);
    
    // 更新未读消息数量
    [[NSNotificationCenter defaultCenter] postNotificationName:@"unreadOtherMessageCount" object:nil];
    
    /**
     *  处理 推送内容
     */
    NSData *jsonData = [payloadMsg dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *textDic = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    
    if (textDic == nil) {
        return;
    }
    
    PushModel *pushModel = [PushModel objectWithKeyValues:textDic];
    if (pushModel == nil) {
        return;
    }
    
    // 判断推送类型是否需要及时处理
    if ([self pushDealAtNow:pushModel.push_type]) {
        // 立即处理推送
        [self dealAtNowPush:pushModel];
        return;
    }
    
    if ([pushModel.push_type isEqualToString:PUSH_SSCOMM_SAVEME]) {
        // 通知更新救我
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:@YES forKey:[NSString stringWithFormat:@"SaveMe_%@",User_ID]];
        [ud synchronize];
    }
    
    // 后台状态返回
    if (offLine)
    {
        return;
    } else {
        // 创建本地通知localLocation
        [self createOneLocalNotificationWithDic:textDic];
    }
}

/** SDK收到sendMessage消息回调 */
- (void)GeTuiSdkDidSendMessage:(NSString *)messageId result:(int)result {
    // [4-EXT]:发送上行消息结果反馈
    NSString *msg = [NSString stringWithFormat:@"sendmessage=%@,result=%d", messageId, result];
    NSLog(@"\n>>>[GexinSdk DidSendMessage]:%@\n\n", msg);
}

/** SDK运行状态通知 */
- (void)GeTuiSDkDidNotifySdkState:(SdkStatus)aStatus {
    // [EXT]:通知SDK运行状态
    NSLog(@"\n>>>[GexinSdk SdkState]:%u\n\n", aStatus);
}

/** SDK设置推送模式回调 */
- (void)GeTuiSdkDidSetPushMode:(BOOL)isModeOff error:(NSError *)error {
    if (error) {
        NSLog(@"\n>>>[GexinSdk SetModeOff Error]:%@\n\n", [error localizedDescription]);
        return;
    }
    
    NSLog(@"\n>>>[GexinSdk SetModeOff]:%@\n\n", isModeOff ? @"开启" : @"关闭");
}

/**
 *  判断推送类型是否需要及时处理
 */
- (BOOL)pushDealAtNow:(NSString *)pushFunction {
    if ([pushFunction isEqualToString:PUSH_LOGINOUT]) {
        // 强制退出
        return YES;
    }
    else {
        return NO;
    }
    return NO;
}

/**
 *  处理--推送(即刻需处理)
 */
- (void)dealAtNowPush:(PushModel *)pushModel {
    if ([AppUpdateInfo sharedInstance].pushModelNow) {
        // 存在即刻处理的推送 -- 不处理之后的推送
        return;
    }
    
    // 保存推送内容
    [AppUpdateInfo sharedInstance].pushModelNow = pushModel;
    
    if (![[[EaseMob sharedInstance] chatManager] isLoggedIn]) {
        // 未登录、不处理
        return ;
    }
    
    // 立即处理
    [PushDealTool dealAtNowPushContent:pushModel];
}

#pragma mark - 创建一条推送
- (void)createOneLocalNotificationWithDic:(NSDictionary *)dic {
    
    PushModel *pushModel = [PushModel objectWithKeyValues:dic];
    
    if (iOS10) {
        //authorization
        UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound)
                              completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                  if(granted)
                                  {
                                      NSLog(@"授权成功");
                                  }
                              }];
        
        center.delegate = self;
        //regitser
        UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
        
        content.body = pushModel.push_content;
        content.userInfo = dic;
        content.sound = [UNNotificationSound defaultSound];
        
        // Deliver the notification in ten seconds.
        UNTimeIntervalNotificationTrigger* trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1 repeats:NO];
        
        UNNotificationRequest* request = [UNNotificationRequest requestWithIdentifier:@"FiveSecond"
                                                                              content:content
                                                                              trigger:trigger];
        
        // Schedule the notification.
        [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            if(error)
            {
                NSLog(@"%@",error);
            } else {
                NSLog(@"已成功加推送%@",request.content);
            }
        }];
        
    } else {
        // 创建一个本地推送
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        
        // 设置调用时间
        notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1.0];// 通知触发的时间，1s以后
        
        notification.repeatInterval = 2;// 通知重复次数
        //notification.repeatCalendar=[NSCalendar currentCalendar];// 当前日历，使用前最好设置时区等信息以便能够自动同步时间
        
        //    NSString *body = @"要交友就找十三平台~";
        NSString *body = pushModel.push_title;
        //设置通知属性
        if (pushModel.push_content) {
            body = pushModel.push_content;
        }
        notification.alertBody = body; // 通知主体
        notification.applicationIconBadgeNumber = 1;// 应用程序图标右上角显示的消息数
        //    notification.soundName = UILocalNotificationDefaultSoundName;//收到通知时播放的声音，默认消息声音
        
        //设置用户信息
        notification.userInfo = dic;// 绑定到通知上的其他附加信息
        
        //添加推送到UIApplication
        UIApplication *app = [UIApplication sharedApplication];
        
        // 本地通知首次创建
        _clickedLocalNoticeAuto = YES;
        
        // 播放音效
        //    mySQSingleObject.playNotifvoiWav;
        
        [app scheduleLocalNotification:notification];
        
    }
    
}

#pragma mark 接收本地通知时触发--(程序还在运行中,程序并没有重新运行)
//在展示通知前进行处理，即有机会在展示通知前再修改通知内容。
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
    
    //1. 处理通知
    
    //2. 处理完成后条用 completionHandler ，用于指示在前台显示通知的形式
    completionHandler(UNNotificationPresentationOptionAlert);
    
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler {
    
    NSLog(@"%@",response);
    
    NSData *jsonData = [[response.notification.request.content.userInfo objectForKey:@"payload"] dataUsingEncoding:NSUTF8StringEncoding];
    
    PushModel *pushModel = nil;
    if (jsonData == nil) { // 本地推送
        pushModel = [PushModel objectWithKeyValues:response.notification.request.content.userInfo];
    } else { // 远程推送
        NSDictionary *textDic = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        pushModel = [PushModel objectWithKeyValues:textDic];
    }
    
    if (pushModel == nil) {
        return;
    }
    
    // 进行处理本地通知内容
    [PushDealTool chuliTuiSongWithPushModel:pushModel];
    // 解除本地推送
    [[UNUserNotificationCenter currentNotificationCenter]removeDeliveredNotificationsWithIdentifiers:@[@"FiveSecond"]];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    PushModel *pushModel = [PushModel objectWithKeyValues:notification.userInfo];
    if (pushModel == nil) {
        return;
    }
    
    if (_clickedLocalNoticeAuto) {
        _clickedLocalNoticeAuto = NO;
        
        // 创建-自定义的通知视图
        [PushDealTool showNoticeBadgeView:pushModel];
        
        return;
    }
    
    // 进行处理本地通知内容
    [PushDealTool chuliTuiSongWithPushModel:pushModel];
    // 解除本地推送
    [[UIApplication sharedApplication] cancelLocalNotification:notification];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
}

#pragma mark - 环信 *****************************************************************************

// 监听系统生命周期回调，以便将需要的事件传给SDK
- (void)setupNotifiers{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidEnterBackgroundNotif:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidFinishLaunching:)
                                                 name:UIApplicationDidFinishLaunchingNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidBecomeActiveNotif:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillResignActiveNotif:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidReceiveMemoryWarning:)
                                                 name:UIApplicationDidReceiveMemoryWarningNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillTerminateNotif:)
                                                 name:UIApplicationWillTerminateNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appProtectedDataWillBecomeUnavailableNotif:)
                                                 name:UIApplicationProtectedDataWillBecomeUnavailable
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appProtectedDataDidBecomeAvailableNotif:)
                                                 name:UIApplicationProtectedDataDidBecomeAvailable
                                               object:nil];
}

#pragma mark - notifiers
- (void)appDidEnterBackgroundNotif:(NSNotification*)notif{
    [[EaseMob sharedInstance] applicationDidEnterBackground:notif.object];
}

- (void)appWillEnterForeground:(NSNotification*)notif
{
    [[EaseMob sharedInstance] applicationWillEnterForeground:notif.object];
}

- (void)appDidFinishLaunching:(NSNotification*)notif
{
    [[EaseMob sharedInstance] applicationDidFinishLaunching:notif.object];
}

- (void)appDidBecomeActiveNotif:(NSNotification*)notif
{
    [[EaseMob sharedInstance] applicationDidBecomeActive:notif.object];
}

- (void)appWillResignActiveNotif:(NSNotification*)notif
{
    [[EaseMob sharedInstance] applicationWillResignActive:notif.object];
}

- (void)appDidReceiveMemoryWarning:(NSNotification*)notif
{
    [[EaseMob sharedInstance] applicationDidReceiveMemoryWarning:notif.object];
}

- (void)appWillTerminateNotif:(NSNotification*)notif
{
    [[EaseMob sharedInstance] applicationWillTerminate:notif.object];
}

- (void)appProtectedDataWillBecomeUnavailableNotif:(NSNotification*)notif
{
    [[EaseMob sharedInstance] applicationProtectedDataWillBecomeUnavailable:notif.object];
}

- (void)appProtectedDataDidBecomeAvailableNotif:(NSNotification*)notif
{
    [[EaseMob sharedInstance] applicationProtectedDataDidBecomeAvailable:notif.object];
}

#pragma mark - registerEaseMobNotification
- (void)registerEaseMobNotification{
    [self unRegisterEaseMobNotification];
    // 将self 添加到SDK回调中，以便本类可以收到SDK回调
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

- (void)unRegisterEaseMobNotification{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}



#pragma mark - IChatManagerDelegate
// 开始自动登录回调
-(void)willAutoLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error
{
    UIAlertView *alertView = nil;
    if (error) {
        alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"login.errorAutoLogin", @"Automatic logon failure") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
        
        //发送自动登陆状态通知
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
        
        [alertView show];
    }
    else{
        // 开始自动登陆
        //        [MBProgressHUD showSuccess:NSLocalizedString(@"login.beginAutoLogin", @"Start automatic login...") toView:nil];
        
        // 旧数据转换 (如果您的sdk是由2.1.2版本升级过来的，需要家这句话)
        [[EaseMob sharedInstance].chatManager importDataToNewDatabase];
        //获取数据库中的数据
        [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
    }
    
}

// 结束自动登录回调
-(void)didAutoLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error
{
    UIAlertView *alertView = nil;
    if (error) {
        alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"login.errorAutoLogin", @"Automatic logon failure") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
        
        //发送自动登陆状态通知
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
        
        [alertView show];
    }
    else{
        //获取群组列表
        [[EaseMob sharedInstance].chatManager asyncFetchMyGroupsList];
        
        // 结束自动登陆
        //        [MBProgressHUD showSuccess:NSLocalizedString(@"login.endAutoLogin", @"End automatic login...") toView:nil];
    }
    
}

// 好友申请回调
- (void)didReceiveBuddyRequest:(NSString *)username
                       message:(NSString *)message
{
    if (!username) {
        return;
    }
    if (!message) {
        message = [NSString stringWithFormat:NSLocalizedString(@"friend.somebodyAddWithName", @"%@ add you as a friend"), username];
    }
    //    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"title":username, @"username":username, @"applyMessage":message, @"applyStyle":[NSNumber numberWithInteger:ApplyStyleFriend]}];
    
    //    // 申请与通知
    //    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"title":username, @"username":username, @"applyMessage":message, @"applyStyle":[NSNumber numberWithInteger:ApplyStyleFriend], @"is_dealed":@"0"}];
    //    [[ApplyViewController shareController] addNewApply:dic];
    //    if (self.mainController) {
    //        [self.mainController setupUnreadMessageCount];
    //    }
    
//    static dispatch_queue_t queue;
//    if (!queue) {
//        queue = dispatch_queue_create("myQueue", DISPATCH_QUEUE_SERIAL);
//    }
//    dispatch_async(queue, ^{
//        // 申请与通知头像昵称
//        NSMutableDictionary *applyDic = [NSMutableDictionary dictionaryWithDictionary:@{@"title":username, @"username":username, @"applyMessage":message, @"applyStyle":[NSNumber numberWithInteger:ApplyStyleFriend], @"is_dealed":@"0" , @"applicantAvatar":@"" , @"applicantNick":username}];
//        [[ApplyViewController shareController] addNewApply:applyDic];
//        
//    });
//    
//    if (self.mainController) {
//        [self.mainController setupUnreadMessageCount];
//    }
    
    static dispatch_queue_t queue;
    static dispatch_group_t disgroup;
    if (!queue) {
        queue = dispatch_queue_create("myQueue", DISPATCH_QUEUE_SERIAL);
    }
    if (!disgroup) {
        disgroup = dispatch_group_create();
    }
    dispatch_group_async(disgroup, queue, ^{
        // 申请与通知头像昵称
        NSMutableDictionary *applyDic = [NSMutableDictionary dictionaryWithDictionary:@{@"title":username, @"username":username, @"applyMessage":message, @"applyStyle":[NSNumber numberWithInteger:ApplyStyleFriend], @"is_dealed":@"0" , @"applicantAvatar":@"" , @"applicantNick":username}];
        [[ApplyViewController shareController] addNewApply:applyDic];
    });
    
    dispatch_group_notify(disgroup, queue, ^{
        // 回到主线程显示图片
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.mainController) {
                [self.mainController setupUnreadMessageCount];
                [self.mainController didReceiveAddBuddyRequest];
                [[ApplyViewController shareController] reloadUI];
            }
        });
    });
}

// 离开群组回调
- (void)group:(EMGroup *)group didLeave:(EMGroupLeaveReason)reason error:(EMError *)error
{
    NSString *tmpStr = group.groupSubject;
    NSString *str;
    if (!tmpStr || tmpStr.length == 0) {
        NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
        for (EMGroup *obj in groupArray) {
            if ([obj.groupId isEqualToString:group.groupId]) {
                tmpStr = obj.groupSubject;
                break;
            }
        }
    }
    
    if (reason == eGroupLeaveReason_BeRemoved) {
        str = [NSString stringWithFormat:NSLocalizedString(@"group.beKicked", @"you have been kicked out from the group of \'%@\'"), tmpStr];
    }
    if (str.length > 0) {
        TTAlertNoTitle(str);
    }
}

// 申请加入群组被拒绝回调
- (void)didReceiveRejectApplyToJoinGroupFrom:(NSString *)fromId
                                   groupname:(NSString *)groupname
                                      reason:(NSString *)reason
                                       error:(EMError *)error{
    if (!reason || reason.length == 0) {
        reason = [NSString stringWithFormat:NSLocalizedString(@"group.beRefusedToJoin", @"be refused to join the group\'%@\'"), groupname];
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:reason delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
    [alertView show];
}

//接收到入群申请
- (void)didReceiveApplyToJoinGroup:(NSString *)groupId
                         groupname:(NSString *)groupname
                     applyUsername:(NSString *)username
                            reason:(NSString *)reason
                             error:(EMError *)error
{
    if (!groupId || !username) {
        return;
    }
    
    if (!reason || reason.length == 0) {
        reason = [NSString stringWithFormat:NSLocalizedString(@"group.applyJoin", @"%@ apply to join groups\'%@\'"), username, groupname];
    }
    else{
        reason = [NSString stringWithFormat:NSLocalizedString(@"group.applyJoinWithName", @"%@ apply to join groups\'%@\'：%@"), username, groupname, reason];
    }
    
    if (error) {
        NSString *message = [NSString stringWithFormat:NSLocalizedString(@"group.sendApplyFail", @"send application failure:%@\nreason：%@"), reason, error.description];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error", @"Error") message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
        [alertView show];
    }
    else{
        //        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"title":groupname, @"groupId":groupId, @"username":username, @"groupname":groupname, @"applyMessage":reason, @"applyStyle":[NSNumber numberWithInteger:ApplyStyleJoinGroup]}];
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"title":groupname, @"groupId":groupId, @"username":username, @"groupname":groupname, @"applyMessage":reason, @"applyStyle":[NSNumber numberWithInteger:ApplyStyleJoinGroup], @"is_dealed":@"0"}];
        // 申请与通知
        [[ApplyViewController shareController] addNewApply:dic];
        if (self.mainController) {
            [self.mainController setupUnreadMessageCount];
        }
    }
}

// 已经同意并且加入群组后的回调
- (void)didAcceptInvitationFromGroup:(EMGroup *)group
                               error:(EMError *)error
{
    if(error)
    {
        return;
    }
    
    NSString *groupTag = group.groupSubject;
    if ([groupTag length] == 0) {
        groupTag = group.groupId;
    }
    
    NSString *message = [NSString stringWithFormat:NSLocalizedString(@"group.agreedAndJoined", @"agreed and joined the group of \'%@\'"), groupTag];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
    [alertView show];
}


// 绑定deviceToken回调
- (void)didBindDeviceWithError:(EMError *)error
{
    if (error) {
        TTAlertNoTitle(NSLocalizedString(@"apns.failToBindDeviceToken", @"Fail to bind device token"));
    }
}

// 网络状态变化回调
- (void)didConnectionStateChanged:(EMConnectionState)connectionState
{
    self.connectionState = connectionState;
    [self.mainController networkChanged:connectionState];
}

// 打印收到的apns信息
-(void)didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSError *parseError = nil;
    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:userInfo
                                                        options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *str =  [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"apns.content", @"Apns content")
                                                    message:str
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"ok", @"OK")
                                          otherButtonTitles:nil];
    [alert show];
    
}

- (void)didReceiveOfflineMessages:(NSArray *)offlineMessages
{
    for (EMMessage *message in offlineMessages) {
        // 头像昵称
        [UserProfileManager saveDict:message.ext];
    }
}

- (void)didFinishedReceiveOfflineMessages{
    NSLog(NSLocalizedString(@"message.endReceiveOffine", @"End to receive offline messages"));
}

@end
