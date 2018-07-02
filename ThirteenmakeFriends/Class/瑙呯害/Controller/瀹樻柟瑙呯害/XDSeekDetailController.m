//
//  XDSeekDetailController.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/8/30.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDSeekDetailController.h"
#import "XDPhotoScrollView.h"
#import "XDSeekDetailCell.h"
#import "Seek.h"
#import "XDPayCoinView.h"
#import "XDSeekPaySucessController.h"
#import "FlopPhoto.h"
#import "ProfileUser.h"
#import "XDAccountTool.h"
//#import "MyJCBViewController.h"
#import "XDMembersCenterController.h"
#import "XDReportPersonController.h"

@interface XDSeekDetailController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,XDPayCoinViewDelegate>

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

/** 钱不足 */
@property (nonatomic, strong) UIAlertView* coinAlert;
/** 等级不足 */
@property (nonatomic, strong) UIAlertView* levelAlert;

@end

@implementation XDSeekDetailController

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
    titleLabel.text = @"觅约详情";
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
    for (FlopPhoto *photo in self.seekModel.seekPicture) {
        [photosArray addObject:photo.path];
    }
    headerView.photos = photosArray;
    self.tableView.tableHeaderView = headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 1、创建Cell
    XDSeekDetailCell *cell = [XDSeekDetailCell cellWithTableView:tableView];
    // 2.赋值
    cell.seekModel = self.seekModel;
    XD_WeakSelf
    cell.payButtonClicked = ^(UIButton *payBtn) {
        XD_StrongSelf
        if ([User_Sex isEqualToString:@"1"]) {
            [myAppDelegate.window makeToast:@"尚未开放" duration:1 position:CSToastPositionCenter];
            return;
        } else {
            ProfileUser *user = [XDAccountTool account];
            if ([user.groupid integerValue] == 0) {// 会员等级判断
                self.levelAlert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                         message:@"高端和至尊会员才可求推荐哦，是否升级"
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                               otherButtonTitles:@"确定",nil];
                [self.levelAlert show];
            }
        }
        
        // 必须调用initWithFrame方法创建对象
        self.seekPayView            = [[XDPayCoinView alloc] initWithFrame:[[UIApplication sharedApplication].keyWindow bounds]];
        self.seekPayView.delegate   = self;
        self.seekPayView.price      = self.seekModel.worth;
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
    paras[@"signup_number"] = self.seekModel.girlNum;
    
    [XDRequestHttpTool request_seekTosignup_withParameters:paras complete:^(id result) {
        NSString *code = [NSString stringWithFormat:@"%@",result[@"code"]];
        NSString *resultStr = [NSString stringWithFormat:@"%@",result[@"message"]];
        
        if ([code isEqualToString:@"200"]) {
            XDSeekPaySucessController *paySuccessVC = [[XDSeekPaySucessController alloc] init];
            paySuccessVC.payMoney = [self.seekModel.worth integerValue];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:paySuccessVC];
            [self presentViewController:nav animated:YES completion:nil];
        } else if ([code isEqualToString:@"203"]) { // 心动币不足
            _coinAlert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:resultStr
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定",nil];
            [_coinAlert show];
        } else if ([code isEqualToString:@"202"] || [code isEqualToString:@"206"] || [code isEqualToString:@"207"]) { // 等级不足
            _levelAlert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                     message:resultStr
                                                    delegate:self
                                           cancelButtonTitle:@"取消"
                                           otherButtonTitles:@"确定",nil];
            [_levelAlert show];
        } else {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:resultStr
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"错误信息--%@",error);
        [self.navigationController.view makeToast:error.localizedDescription
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
//            XDMembersCenterController *memberVC = [[XDMembersCenterController alloc] init];
//            memberVC.title = @"心动会员";
//            [self.navigationController pushViewController:memberVC animated:YES];
//        }
//    }
//}

@end
