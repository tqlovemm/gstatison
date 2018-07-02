//
//  XDWomanSeekDetailController.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/11/17.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDWomanSeekDetailController.h"
#import "XDPhotoScrollView.h"
#import "XDPayCoinView.h"

#import "XDWomanSeekDetailCell.h"
//#import "MyJCBViewController.h"
//#import "XDAuthoritationCenterController.h"
#import "XDReportPersonController.h"
#import "XDWomanSeekModel.h"
#import "XDSeekPaySucessController.h"

@interface XDWomanSeekDetailController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,XDPayCoinViewDelegate>

/** 导航栏 */
@property (nonatomic, weak) UIView *navView;
/** tableView */
@property (nonatomic ,weak) UITableView *tableView;
/** 支付心动币view */
@property (nonatomic ,strong) XDPayCoinView *seekPayView;

/** 钱不足 */
@property (nonatomic, strong) UIAlertView* coinAlert;
/** 等级不足 */
@property (nonatomic, strong) UIAlertView* levelAlert;

@end

@implementation XDWomanSeekDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"觅约详情";
    [self xdd_setupTableView];
    [self setupTableHeaderView];
    [self setupNavBar];
}

- (void)setupNavBar
{
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -12;
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBtn setTitle:@"举报" forState:UIControlStateNormal];
    [rightBtn setTitleColor:NormalNavBtnColor forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [rightBtn addTarget:self action:@selector(pushtoreport) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, rightItem];
}

- (void)pushtoreport {
    
    XDReportPersonController *reportVC = [[XDReportPersonController alloc] init];
    reportVC.number = self.user.thirteen_platform_number;
    [self.navigationController pushViewController:reportVC animated:YES];
}

#pragma mark - 创建tableview相关控件
/**
 *  创建tableview
 */
- (void)xdd_setupTableView {
    // 今日觅约
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT - NavigationBar_Height) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = RGB(240, 239, 245);
    tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)setupTableHeaderView {
    XDPhotoScrollView *headerView = [[XDPhotoScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)];
    headerView.photos = self.user.photos;
    self.tableView.tableHeaderView = headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 1、创建Cell
    XDWomanSeekDetailCell *cell = [XDWomanSeekDetailCell cellWithTableView:tableView];
    // 2.赋值
    cell.user = self.user;
    XD_WeakSelf
    cell.payButtonClicked = ^(UIButton *payBtn) {
        XD_StrongSelf
        // 必须调用initWithFrame方法创建对象
        self.seekPayView            = [[XDPayCoinView alloc] initWithFrame:[[UIApplication sharedApplication].keyWindow bounds]];
        self.seekPayView.delegate   = self;
        self.seekPayView.price      = [NSString stringWithFormat:@"%ld",self.user.worth];
        self.seekPayView.noticeType = DateNotice;
        [self.seekPayView startAnim];
        [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:self.seekPayView];
    };
    // 3、返回Cell
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewAutomaticDimension;
}

#pragma mark - XDPayCoinViewDelegate
- (void)entryPay {
    
    [self showHudInView:self.view hint:@"正在报名..."];
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"boy_number"] = self.user.thirteen_platform_number;
    
    // 公钥加密
    NSString *encryWithPublicKeyStr = [RSAUtil encryptString:[NSString stringWithFormat:@"%@",User_ID] publicKey:kRSA_Public_key];
    [FKL_DataService requestURL:[NSString url_seekWomanSignUp] parameters:paras headerKey:@"sign" headerValue:encryWithPublicKeyStr withType:@"POST" format:@"JSON" complete:^(id result) {
        [self hideHud];
        NSString *code = [NSString stringWithFormat:@"%@",result[@"code"]];
        NSString *resultStr = [NSString stringWithFormat:@"%@",result[@"message"]];
        
        if ([code isEqualToString:@"200"]) {
            XDSeekPaySucessController *paySuccessVC = [[XDSeekPaySucessController alloc] init];
            paySuccessVC.payMoney = self.user.worth;
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:paySuccessVC];
            [self presentViewController:nav animated:YES completion:nil];
        } else if ([code isEqualToString:@"203"]) { // 心动币不足
            _coinAlert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:resultStr
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定",nil];
            [_coinAlert show];
        } else if ([code isEqualToString:@"202"]) { // 认证权限不足
            _levelAlert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                     message:resultStr
                                                    delegate:self
                                           cancelButtonTitle:@"取消"
                                           otherButtonTitles:@"确定",nil];
            [_levelAlert show];
        } else {
            [self.view makeToast:resultStr
                        duration:2.0
                        position:CSToastPositionCenter];
        }
        
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideHud];
        [self.view makeToast:error.localizedDescription
                                         duration:2.0
                                         position:CSToastPositionCenter];
    }];
}

#pragma mark - UIAlertViewDelegate
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    if ([alertView cancelButtonIndex] != buttonIndex) {
//        if ([alertView isEqual:_coinAlert]) {
//            MyJCBViewController *coinVC = [[MyJCBViewController alloc] init];
//            [self.navigationController pushViewController:coinVC animated:YES];
//        } else if ([alertView isEqual:_levelAlert]) {
//            XDAuthoritationCenterController *authVC = [[XDAuthoritationCenterController alloc] init];
//            [self.navigationController pushViewController:authVC animated:YES];
//        }
//    }
//}

@end
