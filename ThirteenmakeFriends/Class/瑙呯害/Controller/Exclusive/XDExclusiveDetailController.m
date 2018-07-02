//
//  XDExclusiveDetailController.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/9/5.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDExclusiveDetailController.h"
#import "XDPhotoScrollView.h"
#import "XDExclusiveDetailCell.h"
#import "XDPayCoinView.h"
#import "XDSeekPaySucessController.h"
#import "FlopPhoto.h"
#import "ProfileUser.h"
#import "XDAccountTool.h"
#import "ExclusiveModel.h"
#import "XDReportPersonController.h"

@interface XDExclusiveDetailController ()<UITableViewDelegate,UITableViewDataSource,XDPayCoinViewDelegate>

/** 导航栏 */
@property (nonatomic, weak) UIView *navView;
/** tableView */
@property (nonatomic ,weak) UITableView *tableView;
/** 支付心动币view */
@property (nonatomic ,strong) XDPayCoinView *seekPayView;

/** 返回按钮 */
@property (nonatomic, weak) UIButton *leftBtn;

/** 举报按钮 */
@property (nonatomic, weak) UIButton *rightBtn;

@end

@implementation XDExclusiveDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:20]}];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //去除 navigationBar 底部的细线
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    [self xdd_setupTableView];
    [self setupTableHeaderView];
    [self configNav];
    [self setupNavBar];
}

- (void)setupNavBar
{
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [leftBtn setImage:[UIImage imageNamed:@"navigationBar_arrow"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -12;
    
    self.navigationItem.leftBarButtonItems = @[negativeSpacer, leftItem];
    self.leftBtn = leftBtn;
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [rightBtn setImage:[UIImage imageNamed:@"barbuttonicon_more_white"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(pushtoreport) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, rightItem];
    
    self.rightBtn = rightBtn;
}

- (void)pushtoreport {
    XDReportPersonController *reportVC = [[XDReportPersonController alloc] init];
    reportVC.number = [NSString stringWithFormat:@"%@",self.seekModel.girlNum];
    [self.navigationController pushViewController:reportVC animated:YES];
}

- (void)leftBtnAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Private
- (void)configNav {
    
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    navView.backgroundColor = RGB(248, 248, 248);
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 32, SCREEN_WIDTH, 20)];
    titleLabel.text = @"专属详情";
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = RGB(65, 65, 65);
    [navView addSubview:titleLabel];
    navView.alpha = 0;
    [self.view insertSubview:navView aboveSubview:self.view];
    
    _navView = navView;
}


#pragma mark - 创建tableview相关控件
/**
 *  创建tableview
 */
- (void)xdd_setupTableView {
    // 今日觅约
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = RGB(240, 239, 245);
    tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        tableView.contentInset = UIEdgeInsetsMake(-kNavBarHeight, 0, 0, 0);
        tableView.scrollIndicatorInsets = tableView.contentInset;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)setupTableHeaderView {
    XDPhotoScrollView *headerView = [[XDPhotoScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)];
    NSMutableArray *photosArray = [NSMutableArray array];
    for (FlopPhoto *photo in self.seekModel.photos) {
        [photosArray addObject:photo.img_path];
    }
    headerView.photos = photosArray;
    self.tableView.tableHeaderView = headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 1、创建Cell
    XDExclusiveDetailCell *cell = [XDExclusiveDetailCell cellWithTableView:tableView];
    // 2.赋值
    cell.seekModel = self.seekModel;
    XD_WeakSelf
    cell.payButtonClicked = ^(UIButton *payBtn) {
        XD_StrongSelf
        if ([User_Sex isEqualToString:@"1"]) {
            [myAppDelegate.window makeToast:@"尚未开放" duration:1 position:CSToastPositionCenter];
            return;
        }
        
        ProfileUser *user = [XDAccountTool account];
        if ([user.groupid isEqualToString:@"4"]||[user.groupid isEqualToString:@"5"]) {// 会员等级判断
            // 必须调用initWithFrame方法创建对象
            self.seekPayView            = [[XDPayCoinView alloc] initWithFrame:[[UIApplication sharedApplication].keyWindow bounds]];
            self.seekPayView.delegate   = self;
            self.seekPayView.price      = self.seekModel.coin;
            self.seekPayView.noticeType = DateNotice;
            [self.seekPayView startAnim];
            [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:self.seekPayView];
        }
        else {
            [self.view makeToast:@"您的等级不足，专属女生仅限至尊及以上会员报名" duration:1 position:CSToastPositionCenter];
        }
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

#pragma mark - BaseTabelView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY > SCREEN_WIDTH - NavigationBar_Height) {
        self.navView.alpha = 1;
        [self.leftBtn setImage:[UIImage imageNamed:@"otherVIew_gray_back"] forState:UIControlStateNormal];
        [self.rightBtn setImage:[UIImage imageNamed:@"barbuttonicon_more"] forState:UIControlStateNormal];
        [self setNeedsStatusBarAppearanceUpdate];
    } else {
        self.navView.alpha = 0;
        [self.leftBtn setImage:[UIImage imageNamed:@"navigationBar_arrow"] forState:UIControlStateNormal];
        [self.rightBtn setImage:[UIImage imageNamed:@"barbuttonicon_more_white"] forState:UIControlStateNormal];
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

#pragma mark - XDPayCoinViewDelegate
- (void)entryPay {
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"user_id"]          = User_ID;
    paras[@"zid"]              = F(@"%@",self.seekModel.zid);
    // 公钥加密
    NSString *encryWithPublicKeyStr = [RSAUtil encryptString:[NSString stringWithFormat:@"%@",User_ID] publicKey:kRSA_Public_key];
    [FKL_DataService requestURL:[NSString url_exclusive_recommend] parameters:paras headerKey:@"sign" headerValue:encryWithPublicKeyStr withType:@"POST" format:@"JSON" complete:^(id result) {
        
        if ([result[@"code"] integerValue] == 200) {
            XDSeekPaySucessController *paySuccessVC = [[XDSeekPaySucessController alloc] init];
            paySuccessVC.payMoney = [self.seekModel.coin integerValue];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:paySuccessVC];
            [self presentViewController:nav animated:YES completion:nil];
        } else {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:result[@"message"]
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        [self.view makeToast:error.localizedDescription
                    duration:2.0
                    position:CSToastPositionCenter];
    }];
}

@end
