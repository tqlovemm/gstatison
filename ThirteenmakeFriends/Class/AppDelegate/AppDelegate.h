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

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "ApplyViewController.h"
#import <GTSDK/GeTuiSdk.h>
#import <PushKit/PushKit.h>
#import "ICELoginPWDViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, IChatManagerDelegate, GeTuiSdkDelegate>
{
    /** 处于后台时点击通知*/
    BOOL _clickedAtBackgound;
    /** 创建本地通知时,第一次执行本地通知*/
    BOOL _clickedLocalNoticeAuto;
}

@property (nonatomic, assign) EMConnectionState connectionState;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MainViewController *mainController;

/** 首次启动-推送内容*/
@property (nonatomic, strong) NSDictionary *launchOptions;

@property (nonatomic, strong) ICELoginPWDViewController *pwdVc;

@property (nonatomic, assign, readonly) BOOL newVersion;


@end
