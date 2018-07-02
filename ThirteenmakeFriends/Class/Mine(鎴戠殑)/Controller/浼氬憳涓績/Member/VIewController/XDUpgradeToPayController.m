//
//  XDUpgradeToPayController.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/7/19.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDUpgradeToPayController.h"
#import "XDTimeAndPriceCell.h"
#import "XDUseCouponsCell.h"
#import "XDPayOptionCell.h"
#import "XDVoucherShareView.h"
#import "XDUMSharedView.h"
#import "XDSurePayView.h"
#import "XDPay.h"
#import "XDCardModel.h"
#import "ProfileUser.h"
#import "XDAccountTool.h"
#import "XDUpgradeSuccessController.h"
#import <RTRootNavigationController.h>
#import "NSString+XDUrlCode.h"

@interface XDUpgradeToPayController ()<UITableViewDelegate,UITableViewDataSource,XDUMSharedViewDelegate>

@property (nonatomic ,weak) UITableView *tableView;

@property (nonatomic ,weak) XDSurePayView *payView;

@property (nonatomic ,strong) NSArray *payOptionArray;

@property (nonatomic ,weak) XDPay *selectPay;

/**
 实际赠送心动币
 */
@property (nonatomic ,assign) NSInteger realGiveaway;

/** 刚刚是否充值过 */
@property (nonatomic ,assign) BOOL isTopup;

@end

@implementation XDUpgradeToPayController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"升级支付";
    
    [self xdd_setupTableView];
    [self setupTableHeaderView];
    [self setupBottomView];
    
    [self.tableView reloadData];
    
    // app从后台进入前台都会调用这个方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationBecomeActive) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)xdd_setupTableView {
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH,SCREEN_HEIGHT - NavigationBar_Height - 58) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = RGB(240, 239, 245);
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

- (void)setupTableHeaderView {
    XDVoucherShareView *shareView = [[XDVoucherShareView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 232)];
    self.tableView.tableHeaderView = shareView;
    
    shareView.shareButtonClicked = ^(UIButton *btn) {
//        //显示分享面板
//        XDUMSharedView *view = [[XDUMSharedView alloc] init];
//        view.delegate = self;
//        [view show];
        
        [self.view makeToast:@"暂未开放，敬请期待" duration:2.0 position:CSToastPositionCenter];
    };
}

- (void)setupBottomView {
    XDSurePayView *payView = [[XDSurePayView alloc] initWithFrame:CGRectMake(0, self.tableView.height, SCREEN_WIDTH, 58)];
    [self.view addSubview:payView];
    self.payView = payView;
    
    payView.layer.shadowColor = RGBA(119, 101, 101, 0.3).CGColor;
    payView.layer.shadowOffset = CGSizeMake(0,-1);
    payView.layer.shadowOpacity = 0.4;
    payView.layer.shadowRadius = 4;
    payView.clipsToBounds = NO;
    payView.price = self.cardModel.allPrice;
    
    WEAKSELF
    payView.payButtonClicked = ^(UIButton *btn) {
//        [weakSelf paySure];
    };
}

#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 2) {
        return 2;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        // 创建cell
        XDTimeAndPriceCell *cell = [XDTimeAndPriceCell cellWithTableView:tableView];
        XD_WeakSelf
        cell.timeButtonClicked = ^(NSInteger index) {
            XD_StrongSelf
            if (index == 1) {
                self.payView.price = self.cardModel.halfPrice;
                self.realGiveaway = self.cardModel.semiAnnualGiveaway;
            } else {
                self.payView.price = self.cardModel.allPrice;
                self.realGiveaway = self.cardModel.giveaway;
            }
        };
        cell.cardModel = self.cardModel;
        return cell;
    } else if (indexPath.section == 1) {
        // 创建cell
        XDUseCouponsCell *cell = [XDUseCouponsCell cellWithTableView:tableView];
        
        return cell;
    } else {
        // 创建cell
        XDPayOptionCell *cell = [XDPayOptionCell cellWithTableView:tableView];
        cell.payItem = self.payOptionArray[indexPath.row];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 取消选中这一行
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        
    } else if (indexPath.section == 1) {
        
    } else {
        
        for (int i = 0; i < self.payOptionArray.count; i++) {
            XDPay *pay = [self.payOptionArray objectAtIndex:i];
            pay.checked = NO;
        }

        XDPay *pay = [self.payOptionArray objectAtIndex:indexPath.row];
        pay.checked = YES;
        self.selectPay = pay;

        [self.tableView reloadData];
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 120;
    } else if (indexPath.section == 1) {
        return 41;
    } else {
        return 61;
    }
}

#pragma mark - XDUMSharedView Delegate
- (void)didSelectedToShare:(UMSocialPlatformType)clickedType {
    
    [self shareTextToPlatformType:clickedType];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - app从后台进入前台
- (void)applicationBecomeActive {
    if (self.isTopup) {
        self.isTopup = NO;
        
        [self showHudInView:self.view hint:@"查询支付结果中..."];
        ProfileUser *user = [XDAccountTool account];
        
        NSMutableDictionary *paras = [NSMutableDictionary dictionary];
        paras[@"number"] = user.thirteen_platform_number;
        [FKL_DataService requestURL:[NSString url_checkPayResult_withType:2] parameters:paras withType:@"GET" format:@"JSON" complete:^(id result) {
            [self hideHud];
            if ([result[@"code"] integerValue] == 200) {
                // 支付成功
                user.groupid = [NSString stringWithFormat:@"%@",result[@"data"][@"groupid"]];
                user.jiecao_coin = [result[@"data"][@"jiecao_coin"] integerValue];
                [XDAccountTool save:user];
                
                XDUpgradeSuccessController *upgradeVC = [[XDUpgradeSuccessController alloc] init];
                
                upgradeVC.recharge_id = [NSString stringWithFormat:@"%@",result[@"data"][@"order_number"]];
                [self.rt_navigationController pushViewController:upgradeVC
                                                        animated:YES
                                                        complete:^(BOOL finished) {
                                                            [self.rt_navigationController removeViewController:self];
                                                        }];
            } else {
                [self.view makeToast:result[@"message"] duration:2.0 position:CSToastPositionCenter];
            }
        } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
            [self hideHud];
            [self.view makeToast:error.localizedDescription duration:2.0 position:CSToastPositionCenter];
        }];
    }
}

@end
