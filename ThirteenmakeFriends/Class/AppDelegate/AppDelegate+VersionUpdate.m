//
//  AppDelegate+VersionUpdate.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 16/4/15.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import "AppDelegate+VersionUpdate.h"
#import "AppUpdateInfo.h"
#import "MJExtension.h"
#import "XDUpdateVersionView.h"
@implementation AppDelegate (VersionUpdate)

- (void)versionUpdateApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self requestAppBaseInfo];
}

- (void)requestAppBaseInfo {
    __weak typeof(self) WeakSelf = self;
    [XDRequestHttpTool request_getAppVersionInfo_withParameters:nil complete:^(id result) {
        if ([result[@"code"] integerValue] == 200) {
            
            [AppUpdateInfo objectWithKeyValues:result[@"data"]];
            [WeakSelf checkAppUpdata];
        } else {
            NSLog(@"%@",result[@"message"]);
        }
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"获取app信息失败-%@",error);
    }];
}

- (void)checkAppUpdata {
    AppUpdateInfo *updateInfo = [AppUpdateInfo sharedInstance];
    
    NSString *shortVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    
    NSInteger serverInteger = [self convertStringVersion:updateInfo.version];
    NSInteger currentInteger = [self convertStringVersion:shortVersion];
    
    if(serverInteger > currentInteger){//需要升级
        
        
        AppUpdateInfo *updateInfo = [AppUpdateInfo sharedInstance];
        UIView *keyView = [UIApplication sharedApplication].keyWindow;
        XDUpdateVersionView *view = [[XDUpdateVersionView alloc] initWithFrame:keyView.bounds];
        view.updateInfo = updateInfo;
        [keyView addSubview:view];
        
//        NSString *uploadInfo = [NSString stringWithFormat:@"您的版本:V %@ , 最新版本:V %@\n\n此版本乃程序员GG不眠不休不泡妞连续奋战几昼夜的结晶哦!\nso为了保证您的使用体验,马上升级到最新版本吧!\n\n%@\n",shortVersion,updateInfo.version,updateInfo.update_info];
//
//        if ([updateInfo.is_force_update isEqualToNumber:[NSNumber numberWithInt:1]]) {
//
//            //强制升级
//            UIAlertView *updateAlertFORCE = [[UIAlertView alloc]initWithTitle:@"有新版本,赶紧升级吧" message:uploadInfo delegate:self cancelButtonTitle:@"立即升级" otherButtonTitles:nil, nil];
//            updateAlertFORCE.tag = 200;
//            [updateAlertFORCE show];
//        } else if ([updateInfo.is_force_update isEqualToNumber:[NSNumber numberWithInt:0]]){
//
//            //非强制升级
//            UIAlertView * updateAlertNormal = [[UIAlertView alloc]initWithTitle:@"有新版本,赶紧升级吧" message:uploadInfo delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即升级", nil];
//            updateAlertNormal.tag = 100;
//            [updateAlertNormal show];
//        } else {
//
//        }
    }
}

#pragma mark - alertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(alertView.tag == 100){
        
        switch (buttonIndex) {
            case 0:
                //取消更新
                break;
            case 1:
                //前往更新
                [[AppUpdateInfo sharedInstance] goToAppStore];
                break;
            default:
                break;
        }
        
    }else if(alertView.tag == 200){
        
        AppUpdateInfo *updateInfo = [AppUpdateInfo sharedInstance];
        
        [updateInfo goToAppStore];
        
        NSString *shortVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        NSString *uploadInfo = [NSString stringWithFormat:@"您的版本:V %@ , 最新版本:V %@\n\n此版本乃程序员GG不眠不休不泡妞连续奋战几昼夜的结晶哦!\nso为了保证您的使用体验,马上升级到最新版本吧!\n\n%@\n\n",shortVersion,updateInfo.version,updateInfo.update_info];
        UIAlertView * updateAlertFORCE = [[UIAlertView alloc]initWithTitle:@"有新版本,赶紧升级吧" message:uploadInfo delegate:self cancelButtonTitle:@"立即升级" otherButtonTitles:nil, nil];
        updateAlertFORCE.tag = 200;
        [updateAlertFORCE show];
    }
}


/**
 *  把版本号去除点后转换成数字
 */
- (NSInteger)convertStringVersion:(NSString *)strVersion {
    strVersion = [strVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    return [strVersion integerValue];
}

@end
