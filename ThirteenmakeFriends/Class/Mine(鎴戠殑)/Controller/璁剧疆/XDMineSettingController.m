//
//  XDMineSettingController.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 16/8/23.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import "XDMineSettingController.h"
#import "HMCommonGroup.h"
#import "HMCommonItem.h"
#import "HMCommonCell.h"
#import "HMCommonArrowItem.h"
#import "HMCommonLabelItem.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "XDAccountDetailController.h"
#import "XDLocalHtmlViewController.h"
#import "SettingsViewController.h"
#import "ICEPasswordViewController.h"
#import "PasswordChangeTableViewController.h"
#import <StoreKit/StoreKit.h>

@interface XDMineSettingController ()<SKStoreProductViewControllerDelegate>
@property (nonatomic,weak) HMCommonLabelItem *clearCache;

@property (strong, nonatomic) UIView *footerView;
@end

@implementation XDMineSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGB(239, 239, 239);
    
    // 初始化模型数据
    [self setupGroups];
    
    self.tableView.tableFooterView = self.footerView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

/**
 *  初始化模型数据
 */
- (void) setupGroups
{
    [self setupGroup1];
    [self setupGroup2];
    
#if APP_Puppet  // Puppet
    
#elif APP_myPuppet
    
#else // 正常
    [self setupGroup3];
#endif
}

- (void)setupGroup1
{
    // 1.创建组
    HMCommonGroup *group = [HMCommonGroup group];
    [self.groups addObject:group];

    // 2.设置组的所有行数据
    HMCommonArrowItem *account = [HMCommonArrowItem itemWithTitle:@"账号信息" icon:@"nil"];
    account.destVcClass = [XDAccountDetailController class];


    HMCommonArrowItem *changeGesturePWD = [HMCommonArrowItem itemWithTitle:@"密码管理" icon:@"nil"];
    XD_WeakSelf
    changeGesturePWD.operation = ^{
        XD_StrongSelf
        PasswordChangeTableViewController *vc = [[PasswordChangeTableViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    };

    group.items = @[account,changeGesturePWD];

}

- (void)setupGroup2
{
    // 1.创建组
    HMCommonGroup *group = [HMCommonGroup group];
    [self.groups addObject:group];

    XD_WeakSelf
    // 2.设置组的所有行数据
    HMCommonArrowItem *setting = [HMCommonArrowItem itemWithTitle:@"消息设置" icon:@"nil"];
    setting.operation = ^{
        XD_StrongSelf
        SettingsViewController *settingVC = [[SettingsViewController alloc]init];
        settingVC.title = @"消息设置";
        [settingVC refreshConfig];
        [self.navigationController pushViewController:settingVC animated:YES];
    };

    // 评论与反馈
    HMCommonArrowItem *goodCommment = [HMCommonArrowItem itemWithTitle:@"评论与反馈" icon:@"nil"];
    goodCommment.operation = ^{
        XD_StrongSelf
        [self loadAppStoreController];
    };

    // 清理缓存
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    CGFloat cacheContentSize = [self folderSizeAtPath:cachePath];

    HMCommonLabelItem *clearCache = [HMCommonLabelItem itemWithTitle:@"清理缓存" icon:@"nil"];
    clearCache.text = [NSString stringWithFormat:@"%.2f M",cacheContentSize];
    __weak typeof(clearCache) weakCache = clearCache;
    clearCache.operation = ^{
        XD_StrongSelf
        NSString *hint = [NSString stringWithFormat:@"缓存大小为%.2fM,确定要清理缓存吗？",cacheContentSize];

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:hint preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self clearCacheWithMemory];
            CGFloat cacheSize = [self folderSizeAtPath:[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]];
            weakCache.text = [NSString stringWithFormat:@"%.2f M",cacheSize];
            [self.tableView reloadData];
        }]];

        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            ;
        }]];

        [self presentViewController:alert animated:YES completion:nil];
    };
    self.clearCache = clearCache;
    group.items = @[setting,goodCommment,clearCache];
}

- (void)setupGroup3
{
    // 1.创建组
    HMCommonGroup *group = [HMCommonGroup group];
    [self.groups addObject:group];

    // 2.设置组的所有行数据
    // 关于我们
    XD_WeakSelf
    HMCommonArrowItem *aboutMe = [HMCommonArrowItem itemWithTitle:@"关于我们" icon:@"nil"];
    aboutMe.operation = ^{
        XD_StrongSelf
        XDLocalHtmlViewController *aboutMeVC = [XDLocalHtmlViewController localHtmlViewControllerWithHtmlTitle:@"13平台" HtmlString:@"http://www.13loveme.com"];

        [self.navigationController pushViewController:aboutMeVC animated:YES];
    };

    group.items = @[aboutMe];

}

#pragma mark - 清除缓存
- (void)clearCacheWithMemory {

    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];

    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachePath];

    for (NSString *p in files) {

        NSError *error;

        NSString *path = [cachePath stringByAppendingPathComponent:p];

        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {

            [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
        }
    }
}

#pragma mark - 计算缓存文件大小
/**
 *  遍历文件夹获得文件夹大小，返回多少M
 */
- (float )folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}

/**
 *  单个文件的大小
 *
 *  @param filePath 文件路径
 */
- (long long)fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

- (UIView *)footerView
{
    if (_footerView == nil) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
        _footerView.backgroundColor = [UIColor clearColor];

        UIButton *logoutButton = [[UIButton alloc] initWithFrame:CGRectMake(70, 20, _footerView.frame.size.width - 140, 44)];
        [logoutButton setBackgroundColor:[UIColor whiteColor]];
        NSString *logoutButtonTitle = [[NSString alloc] initWithFormat:NSLocalizedString(@"setting.loginUser", @"log out")];

        [logoutButton setTitle:logoutButtonTitle forState:UIControlStateNormal];
        [logoutButton setTitleColor:RGB(232, 63, 120) forState:UIControlStateNormal];
        [logoutButton addTarget:self action:@selector(logoutAction) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:logoutButton];
        
        logoutButton.layer.cornerRadius = 22;
        logoutButton.layer.shadowRadius = 3;
        logoutButton.layer.shadowOffset = CGSizeMake(0, 1);
        logoutButton.layer.shadowOpacity = 0.8;
        logoutButton.layer.shadowColor = RGBA(0, 0, 0, 0.17).CGColor;

        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        // app版本
        NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        UILabel *versionLab = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(logoutButton.frame) + 10, self.view.width - 20, 30)];
        versionLab.textAlignment = NSTextAlignmentCenter;
        versionLab.text = [NSString stringWithFormat:@"版本号：%@",app_Version];
        versionLab.font = [UIFont systemFontOfSize:14];
        versionLab.textColor = RGB(135, 135, 135);
        [_footerView addSubview:versionLab];
    }

    return _footerView;
}

- (void)logoutAction
{
    // 公钥加密
    NSString *encryWithPublicKeyStr = [RSAUtil encryptString:[NSString stringWithFormat:@"%@",User_ID] publicKey:kRSA_Public_key];

    [FKL_DataService requestURL:[NSString url_loginout_clearCidWithUserId:User_ID] parameters:nil headerKey:@"sign" headerValue:encryWithPublicKeyStr withType:@"DELETE" format:@"JSON" complete:^(id result) {
        if ([result[@"code"] integerValue] == 200) { // 删除成功

        } else if ([result[@"code"] integerValue] == 201) { // 不存在

        } else if ([result[@"code"] integerValue] == 202) { // 删除失败

        }
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];

    XD_WeakSelf
    [self showHudInView:self.view hint:NSLocalizedString(@"setting.logoutOngoing", @"loging out...")];
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
        XD_StrongSelf
        [self hideHud];
        if (error && error.errorCode != EMErrorServerNotLogin) {
            [self showHint:error.description];
        }
        else{
            [[ApplyViewController shareController] clear];
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
            // 关闭账号统计
            [MobClick profileSignOff];
        }
    } onQueue:nil];
}

#pragma mark - tableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48;
}

#pragma - mark 应用内评分
- (void)loadAppStoreController
{
    [self showHudInView:self.view hint:@"正在加载，请不要离开..."];
    XD_WeakSelf
    // 初始化控制器
    SKStoreProductViewController *storeProductViewContorller = [[SKStoreProductViewController alloc] init];
    // 设置代理请求为当前控制器本身
    storeProductViewContorller.delegate = self;
    [storeProductViewContorller loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier:APPID} completionBlock:^(BOOL result, NSError *error)   {
        XD_StrongSelf
        [self hideHud];
        if(error)  {
            NSLog(@"error %@ with userInfo %@",error,[error userInfo]);
        }else  {
            // 模态弹出appstore
            [self presentViewController:storeProductViewContorller animated:YES completion:nil];
        }
    }];
}

//AppStore取消按钮监听
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
