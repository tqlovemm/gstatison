//
//  XDMatchPersonController.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/12/18.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDMatchPersonController.h"
//#import "ChatViewController.h"
#import "XDReportPersonController.h"
#import "XDMembersCenterController.h"
//#import "XDAuthoritationCenterController.h"

#import "XDMatchPersonCell.h"
#import "XDPersonLabelCell.h"
#import "XDPersonWechatCell.h"
#import "XDPersonQrCoderCell.h"
#import "XDPersonForbiddenCell.h"
#import "XDPhotoScrollView.h"
#import "ShiSanUser.h"
#import "UserProfileManager.h"
#import "ProfileUser.h"
#import "XDAccountTool.h"
#import "UIView+XDGradientColor.h"

@interface XDMatchPersonController ()<UITableViewDelegate,UITableViewDataSource,XDErrorViewDelegate>
{
    XDErrorView *_errorView;
}

/** 导航栏 */
@property (nonatomic, weak) UIView *navView;
/** tableView */
@property (nonatomic ,weak) UITableView *tableView;
/** tableHeaderView */
@property (nonatomic, weak) XDPhotoScrollView *headerView;
/** 返回按钮 */
@property (nonatomic, weak) UIButton *leftBtn;

/** 举报按钮 */
@property (nonatomic, weak) UIButton *rightBtn;

@property (nonatomic, strong) ShiSanUser *user;

@end

@implementation XDMatchPersonController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:20]}];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //去除 navigationBar 底部的细线
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    [self setEdgesForExtendedLayout:UIRectEdgeAll];
    
    [self setupErrorView];
    [self xdd_setupTableView];
    [self setupTableHeaderView];
    [self setupTableFooterView];
    [self configNav];
    [self setupNavBar];
    
    [self getPersonInfo];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    ProfileUser *user = [XDAccountTool account];
    if (([user.sex integerValue] == 1 && user.is_renzheng == 1) || ([user.sex integerValue] != 1 && [user.groupid integerValue] > 0)) {
        [self.tableView reloadData];
    }
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
    reportVC.user = self.user;
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
//    NSMutableArray *photosArray = [NSMutableArray array];
//    photosArray = @[@"http://ounw0bp6w.bkt.clouddn.com/uploads/user/files/2017/08/29/zy34659a4d1cf5fb4c59a54f34957da.jpg",@"http://ounw0bp6w.bkt.clouddn.com/uploads/user/avatar/2017/08/30/4158259a65fe87e079.jpg"];
//    headerView.photos = photosArray;
    self.tableView.tableHeaderView = headerView;
    self.headerView = headerView;
}

- (void)setupTableFooterView {
    if (![self.user_id isEqualToString:User_ID]) {
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 90)];
        backView.backgroundColor = [UIColor whiteColor];
        
        UIButton *submitBtn = [[UIButton alloc] init];
        submitBtn.titleLabel.font = kPingFangRegularFont(16);
        [submitBtn setTitle:@"发消息" forState:UIControlStateNormal];
        [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [submitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        submitBtn.layer.cornerRadius = 20;
        submitBtn.layer.masksToBounds = YES;
        [submitBtn addTarget:self action:@selector(chatToPerson:) forControlEvents:UIControlEventTouchUpInside];
        
        submitBtn.size = CGSizeMake(188, 40);
        submitBtn.y = 30;
        submitBtn.centerX = self.view.width / 2.0;
        [backView addSubview:submitBtn];
        
        [submitBtn setShadowBackgroundColor];
        
        self.tableView.tableFooterView = backView;
    }
}

- (void)chatToPerson:(UIButton *)btn {
    if (self.user) {
//        ChatViewController *chatVC = [[ChatViewController alloc] initWithConversationChatter:self.user.username conversationType:eConversationTypeChat];
//        chatVC.title = self.user.nickname;
//        [self.navigationController pushViewController:chatVC animated:YES];
    }
}

- (void)getPersonInfo {
    
    if (![[AppUpdateInfo sharedInstance] isHavingNetworking]) {
        // 添加自定义错误(断网)提示
        _errorView = [_errorView addErrorViewWithType:@"error_nonet"];
        [self configNav];
        _navView.alpha = 1;
        return;
    }
    
    [self showHudInView:self.view hint:@"正在加载中"];
    
    NSString *url = [NSString url_getOtherPersonInfo_withUser_id:self.user_id];
    // 公钥加密
    NSString *encryWithPublicKeyStr = [RSAUtil encryptString:[NSString stringWithFormat:@"%@",self.user_id] publicKey:kRSA_Public_key];
    
    [FKL_DataService requestURL:url parameters:nil headerKey:@"sign" headerValue:encryWithPublicKeyStr withType:@"GET" format:@"JSON" complete:^(id result) {
        if ([result[@"code"] integerValue] == 200) {
            self.user = [ShiSanUser objectWithKeyValues:result[@"data"]];
            [UserProfileManager saveInfo:self.user.username imgUrl:self.user.avatar nickName:self.user.nickname.length > 0 ? self.user.nickname : self.user.username];
            
            // 移除ErrorView
            _errorView = [_errorView removeErrorView];
            
            [self.tableView reloadData];
            self.headerView.photos = self.user.photos;
            self.rightBtn.hidden = [self.user.username isEqualToString:User_Name];
        } else {
            [self configNav];
            [self.view makeToast:result[@"message"]
                        duration:2.0
                        position:CSToastPositionCenter];
        }
        [self hideHud];
        
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideHud];
        [self.view makeToast:error.localizedDescription duration:2.0 position:CSToastPositionCenter];
    }];
}

#pragma mark - UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.row == 0) {
        // 1、创建Cell
        XDMatchPersonCell *cell = [XDMatchPersonCell cellWithTableView:tableView];
        // 2.赋值
        cell.user = self.user;
        // 3、返回Cell
        return cell;
    } else if (indexPath.row == 1) {
        
        ProfileUser *mineUser = [XDAccountTool account];
        if ([mineUser.sex integerValue] == 0) { // 男
            if ([mineUser.groupid integerValue] > 0 || [self.user_id isEqualToString:User_ID]) {
                if (self.user.weima.length > 0) {
                    XDPersonQrCoderCell *cell = [XDPersonQrCoderCell cellWithTableView:tableView];
                    cell.weichat = self.user.weima;
                    return cell;
                } else {
                    XDPersonWechatCell *cell = [XDPersonWechatCell cellWithTableView:tableView];
                    cell.weichat = self.user.wechat;
                    return cell;
                }
            } else {
                XDPersonForbiddenCell *cell = [XDPersonForbiddenCell cellWithTableView:tableView];
                XD_WeakSelf
                cell.upgradeButtonClicked = ^(NSInteger sex) {
                    XD_StrongSelf
                    [self upgradeAndAuthClicked_withSex:sex];
                };
                return cell;
            }
        } else {  // 女
            if (mineUser.is_renzheng == 1 || [self.user_id isEqualToString:User_ID]) {
                if (self.user.weima.length > 0) {
                    XDPersonQrCoderCell *cell = [XDPersonQrCoderCell cellWithTableView:tableView];
                    cell.weichat = self.user.weima;
                    return cell;
                } else {
                    XDPersonWechatCell *cell = [XDPersonWechatCell cellWithTableView:tableView];
                    cell.weichat = self.user.wechat;
                    return cell;
                }
            } else {
                XDPersonForbiddenCell *cell = [XDPersonForbiddenCell cellWithTableView:tableView];
                XD_WeakSelf
                cell.upgradeButtonClicked = ^(NSInteger sex) {
                    XD_StrongSelf
                    [self upgradeAndAuthClicked_withSex:sex];
                };
                return cell;
            }
        }
    } else {
        XDPersonLabelCell *cell = [XDPersonLabelCell cellWithTableView:tableView];
        // 2.赋值
        cell.user = self.user;
        // 3、返回Cell
        return cell;
    }
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

#pragma mark - 升级认证点击
- (void)upgradeAndAuthClicked_withSex:(NSInteger)sex {
    if (sex == 1) {
//        XDAuthoritationCenterController *authVC = [[XDAuthoritationCenterController alloc] init];
//        [self.navigationController pushViewController:authVC animated:YES];
    } else {
        XDMembersCenterController *memberVC = [[XDMembersCenterController alloc] init];
        [self.navigationController pushViewController:memberVC animated:YES];
    }
}

#pragma mark - XDErrorViewDelegate
- (void)errorViewAddErrorView:(XDErrorView *)errorView {
    //    self.tableView.scrollEnabled = NO;
}

- (void)errorViewRemoveErrorView:(XDErrorView *)errorView {
    //    self.tableView.scrollEnabled = YES;
}

- (void)errorViewTapedErrorView:(XDErrorView *)errorView{
    // 请求数据
    [self getPersonInfo];
}

/**
 *  初始化--错误提示界面
 */
- (void)setupErrorView {
    _errorView = [XDErrorView errorViewWithSuperView:self.view Frame:self.view.bounds];
    _errorView.delegate = self;
}

@end
