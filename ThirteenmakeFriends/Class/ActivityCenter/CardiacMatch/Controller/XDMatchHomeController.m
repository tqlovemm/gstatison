//
//  XDMatchHomeController.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/11/29.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDMatchHomeController.h"
#import "XDIsMatchingController.h"
#import "XDMatchSuccessController.h"
#import "XDMatchFailController.h"
#import "XDNavigationController.h"
#import "XDSeekHelpController.h"
#import "XDMatchRecordController.h"
#import "XDEditdataController.h"

#import "XDMatchUserModel.h"
#import "XDIntroduceModel.h"

@interface XDMatchHomeController ()<UIAlertViewDelegate>

@property (nonatomic, weak) UIButton *matchBtn;

/** 匹配成功的用户信息 */
@property (nonatomic, strong) XDMatchUserModel *user;

/** 1.匹配成功 2.匹配失败 3.正在匹配 4.尚未匹配 5.匹配信息不完整 0.其他错误*/
@property (nonatomic, assign) NSInteger match_status;

@end

@implementation XDMatchHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:20]}];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    //去除 navigationBar 底部的细线
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    [self setupNavbar];
    
    [self xdd_setupSubViews];
    
    [self getMatchResults];
    
    [self addNotificatons];
}

- (void)addNotificatons {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMatchSuccessNotification:) name:XDMatchResultSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMatchResultsNotification:) name:XDMatchResultFailedNotification     object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMatchResultsNotification:) name:XDMatchResultMatchingNotification object:nil];
}

// 匹配成功
- (void)getMatchSuccessNotification:(NSNotification *)notification {
    XDMatchUserModel *user = (XDMatchUserModel *)notification.object;
    self.user = user;
    self.match_status = 1;
    [self setMatchBtnStatus];
}

// 失败或匹配中
- (void)getMatchResultsNotification:(NSNotification *)notification {
    NSNumber *is_status = (NSNumber *)notification.object;
    self.match_status = [is_status integerValue];
    [self setMatchBtnStatus];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 导航栏
- (void)setupNavbar {
    
    //左边按钮
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [leftBtn setImage:[UIImage imageNamed:@"seek_question"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -6;
//    self.navigationItem.leftBarButtonItems = @[negativeSpacer, leftItem];
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [rightBtn setTitle:@"记录" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBtn setTitleColor:NormalNavBtnColor forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [rightBtn addTarget:self action:@selector(rightButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItems = @[negativeSpacer,rightItem ,leftItem];
    
}

- (void)leftButtonClicked {
    XDSeekHelpController *helpVC = [[XDSeekHelpController alloc] init];
    XDIntroduceModel *step1 = [[XDIntroduceModel alloc] init];
    step1.title = @"①填写资料 ";
    step1.des = [NSString stringWithFormat:@"·填写资料 展示你独特的一面\n·有选填和必填栏目\n·填的越详细 匹配成功率越大！"];
    
    XDIntroduceModel *step2 = [[XDIntroduceModel alloc] init];
    step2.title = @"②等待匹配";
    step2.des = [NSString stringWithFormat:@"·等待匹配，基于海量会员数据匹配\n·24小时出结果\n·也可申请人工匹配"];
    
    XDIntroduceModel *step3 = [[XDIntroduceModel alloc] init];
    step3.title = @"③匹配成功";
    step3.des = @"·匹配成功后将收到对方名片\n·可查看对方资料或直接加微信";
    
    XDIntroduceModel *step4 = [[XDIntroduceModel alloc] init];
    step4.title = @"④人工客服";
    step4.des = @"·人工客服，一对一在线服务，牵线搭桥\n·客服可协助匹配";
    
    helpVC.dataArray = @[step1,step2,step3,step4];
    XDNavigationController *nav = [[XDNavigationController alloc] initWithRootViewController:helpVC];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)rightButtonClicked {
    XDMatchRecordController *recordVC = [[XDMatchRecordController alloc] init];
    [self.navigationController pushViewController:recordVC animated:YES];
}

#pragma mark - 创建子视图
- (void)xdd_setupSubViews {
    UIScrollView *contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationBar_Height)];
    [self.view addSubview:contentView];
    contentView.contentSize = CGSizeMake(0, 555);
    
    UIImageView *backgroundView = [[UIImageView alloc] init];
    backgroundView.image = [UIImage imageNamed:@"match_backgroud_image"];
    [contentView addSubview:backgroundView];
    
    UIButton *matchBtn = [[UIButton alloc] init];
    [matchBtn setImage:[UIImage imageNamed:@"match_btn_in"] forState:UIControlStateNormal];
    [matchBtn addTarget:self action:@selector(matchBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:matchBtn];
    self.matchBtn = matchBtn;
    
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(318, 492));
//        make.top.mas_equalTo(0);
        make.centerY.mas_equalTo(contentView);
        make.centerX.mas_equalTo(contentView);
    }];
    
    [matchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(188, 40));
        make.centerX.mas_equalTo(backgroundView.mas_centerX);
        make.bottom.mas_equalTo(backgroundView.mas_bottom).offset(-53);
    }];
    
}

- (void)matchBtnClicked {
    if (self.match_status == 1) { // 匹配成功
        XDMatchSuccessController *successVC = [[XDMatchSuccessController alloc] init];
        successVC.user = self.user;
        [self.navigationController pushViewController:successVC animated:YES];
    } else if (self.match_status == 2) { // 匹配失败
        XDMatchFailController *failVC = [[XDMatchFailController alloc] init];
        [self.navigationController pushViewController:failVC animated:YES];
    } else if (self.match_status == 3) { // 正在匹配
        XDIsMatchingController *isMatchVC = [[XDIsMatchingController alloc] init];
        [self.navigationController pushViewController:isMatchVC animated:YES];
    } else {
        [self checkMatchInfo_isFull];
    }
}

- (void)setMatchBtnStatus {
    if (self.match_status == 1) { // 匹配成功
        [self.matchBtn setImage:[UIImage imageNamed:@"match_btn_result"] forState:UIControlStateNormal];
    } else if (self.match_status == 2) { // 匹配失败
        [self.matchBtn setImage:[UIImage imageNamed:@"match_btn_result"] forState:UIControlStateNormal];
    } else if (self.match_status == 3) { // 正在匹配
        [self.matchBtn setImage:[UIImage imageNamed:@"match_btn_ing"] forState:UIControlStateNormal];
    } else {
        [self.matchBtn setImage:[UIImage imageNamed:@"match_btn_in"] forState:UIControlStateNormal];
    }
}

#pragma mark - 查看匹配结果
- (void)getMatchResults {
    [self showHudInView:self.view hint:@"获取匹配结果中..."];
    NSString *encryWithPublicKeyStr = [RSAUtil encryptString:[NSString stringWithFormat:@"%@",User_ID] publicKey:kRSA_Public_key];
    [FKL_DataService requestURL:[NSString url_getMatchResults] parameters:nil headerKey:@"sign" headerValue:encryWithPublicKeyStr withType:@"GET" format:@"JSON" complete:^(id result) {
        [self hideHud];
        if ([result[@"code"] integerValue] == 200) { // 匹配成功
            self.match_status = 1;
            self.user = [XDMatchUserModel objectWithKeyValues:result[@"data"]];
        } else if ([result[@"code"] integerValue] == 206) { // 匹配失败
            self.match_status = 2;
        } else if ([result[@"code"] integerValue] == 203) { // 正在匹配
            self.match_status = 3;
        } else if ([result[@"code"] integerValue] == 202 || [result[@"code"] integerValue] == 201) { // 未参加匹配或继续下一轮匹配
            self.match_status = 4;
        } else if ([result[@"code"] integerValue] == 211) { // 匹配信息不完整
            self.match_status = 5;
            [self alertWithMessage:result[@"message"]];
        } else {
            self.match_status = 0;
            [self.view makeToast:result[@"message"] duration:2.0 position:CSToastPositionCenter];
        }
        
        [self setMatchBtnStatus];
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideHud];
        [self.view makeToast:error.localizedDescription duration:2.0 position:CSToastPositionCenter];
    }];
}

#pragma mark - 匹配报名接口
- (void)match_Registion {
    [self showHudInView:self.view hint:@"匹配报名中..."];
    NSString *encryWithPublicKeyStr = [RSAUtil encryptString:[NSString stringWithFormat:@"%@",User_ID] publicKey:kRSA_Public_key];
    [FKL_DataService requestURL:[NSString url_match_Registration] parameters:nil headerKey:@"sign" headerValue:encryWithPublicKeyStr withType:@"GET" format:@"JSON" complete:^(id result) {
        [self hideHud];
        if ([result[@"code"] integerValue] == 200 || [result[@"code"] integerValue] == 201) {
            self.match_status = 3;
            [self setMatchBtnStatus];
            XDIsMatchingController *isMatchVC = [[XDIsMatchingController alloc] init];
            [self.navigationController pushViewController:isMatchVC animated:YES];
        } else {
            [self.view makeToast:result[@"message"] duration:2.0 position:CSToastPositionCenter];
        }
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideHud];
        [self.view makeToast:error.localizedDescription duration:2.0 position:CSToastPositionCenter];
    }];
}

#pragma mark - 查询匹配信息是否完善
- (void)checkMatchInfo_isFull {
    [self showHudInView:self.view hint:@"匹配报名中..."];
    NSString *encryWithPublicKeyStr = [RSAUtil encryptString:[NSString stringWithFormat:@"%@",User_ID] publicKey:kRSA_Public_key];
    [FKL_DataService requestURL:[NSString url_judge_matchInfo_isComplete] parameters:nil headerKey:@"sign" headerValue:encryWithPublicKeyStr withType:@"GET" format:@"JSON" complete:^(id result) {
        [self hideHud];
        if ([result[@"code"] integerValue] == 200) {
            [self match_Registion];
        } else {
            [self alertWithMessage:result[@"message"]];
        }
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideHud];
        [self.view makeToast:error.localizedDescription duration:2.0 position:CSToastPositionCenter];
    }];
}

#pragma mark - UIActionSheetDelegate
- (void)alertWithMessage:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([alertView cancelButtonIndex] != buttonIndex) {
        XDEditdataController *editVC = [[XDEditdataController alloc] init];
        [self.navigationController pushViewController:editVC animated:YES];
    }
}

@end
