//
//  XDIsMatchingController.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/12/14.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDIsMatchingController.h"
#import "XDMatchRecordController.h"
//#import "ChatViewController.h"
#import "XDMatchFailController.h"
#import "XDMatchSuccessController.h"
#import <RTRootNavigationController.h>

#import "XDIsMatchHeaderView.h"
#import "XDMatchCell.h"
#import "XDMatchUserModel.h"

@interface XDIsMatchingController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, weak) UIScrollView *contentview;

@property (weak, nonatomic) UICollectionView *collectionView;

@property (weak, nonatomic) XDIsMatchHeaderView *isMatchView;

@property (nonatomic, weak) UIButton *serviceBtn;

@end

@implementation XDIsMatchingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"正在匹配";
    
    [self setupNavbar];
    
    UIScrollView *contentview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationBar_Height)];
    [self.view addSubview:contentview];
    self.contentview = contentview;
    
    [self xdd_setupSubViews];
    
    [self getMatchResults];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:XDMatchResultMatchingNotification object:@3];
}

#pragma mark - 导航栏
- (void)setupNavbar {
    
    //左边按钮
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [leftBtn setImage:[UIImage imageNamed:@"gray_back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -6;
    self.navigationItem.leftBarButtonItems = @[negativeSpacer, leftItem];
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [rightBtn setTitle:@"记录" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBtn setTitleColor:NormalNavBtnColor forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [rightBtn addTarget:self action:@selector(rightButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, rightItem];
    
}

- (void)leftButtonClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightButtonClicked {
    XDMatchRecordController *recordVC = [[XDMatchRecordController alloc] init];
    [self.navigationController pushViewController:recordVC animated:YES];
}

#pragma mark - 创建子视图
- (void)xdd_setupSubViews {
    [self.isMatchView removeFromSuperview];
    [self.collectionView removeFromSuperview];
    [self.serviceBtn removeFromSuperview];
    
    [self setupMatchView];
    [self setupCollectionView];
    [self setupBottomView];
}

- (void)setupMatchView {
    XDIsMatchHeaderView * isMatchView = [[XDIsMatchHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.width * 14 / 15.0 + 20)];
    isMatchView.minCount = 10000;
    XD_WeakSelf
    isMatchView.countdownFinished = ^(BOOL finish) {
        XD_StrongSelf
        if (finish == YES) {
            [self getMatchResults];
        }
    };
    [self.contentview addSubview:isMatchView];
    self.isMatchView = isMatchView;
}

- (void)setupCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = CGFLOAT_MIN;
    flowLayout.minimumInteritemSpacing = CGFLOAT_MIN;
    flowLayout.itemSize = CGSizeMake(174, 191);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.isMatchView.frame), self.view.frame.size.width, 191) collectionViewLayout:flowLayout];
    [self.contentview addSubview:collectionView];
    self.collectionView = collectionView;
    self.collectionView.delegate             = self;
    self.collectionView.dataSource           = self;
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[XDMatchCell class] forCellWithReuseIdentifier:@"XDMatchCellID"];
}

- (void)setupBottomView {
    UIButton * serviceBtn = [[UIButton alloc] init];
    [serviceBtn setBackgroundColor:[UIColor whiteColor]];
    serviceBtn.layer.cornerRadius = 20;
    serviceBtn.layer.shadowRadius = 3;
    serviceBtn.layer.shadowOffset = CGSizeMake(0, 1);
    serviceBtn.layer.shadowOpacity = 0.8;
    serviceBtn.layer.shadowColor = RGBA(0, 0, 0, 0.17).CGColor;
    serviceBtn.titleLabel.font = kPingFangRegularFont(18);
    [serviceBtn setTitle:@"咨询客服" forState:UIControlStateNormal];
    [serviceBtn setTitleColor:ThemeColor1 forState:UIControlStateNormal];
    [serviceBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [serviceBtn addTarget:self action:@selector(serviceBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    serviceBtn.size = CGSizeMake(188, 40);
    serviceBtn.y = CGRectGetMaxY(self.collectionView.frame) + 50;
    serviceBtn.centerX = self.contentview.width / 2.0;
    
    [self.contentview addSubview:serviceBtn];
    self.serviceBtn = serviceBtn;
    
    self.contentview.contentSize = CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(serviceBtn.frame) + 20);
}

//- (void)serviceBtnClicked {
//    NSDictionary *dict = @{@"来源" : @"心动匹配"};
//    [MobClick event:@"service_source" attributes:dict];
//    ChatViewController *chatVC = [[ChatViewController alloc] initWithConversationChatter:kServiceName conversationType:eConversationTypeChat];
//    chatVC.title = kServiceNiceName;
//    [self.navigationController  pushViewController:chatVC animated:YES];
//}

#pragma mark - layout
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XDMatchCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"XDMatchCellID" forIndexPath:indexPath];
    cell.imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"match_step%ld",indexPath.row + 1]];
    return cell;
}

#pragma mark - network
- (void)getMatchResults {
    [self showHudInView:self.view hint:@"获取匹配结果中..."];
    NSString *encryWithPublicKeyStr = [RSAUtil encryptString:[NSString stringWithFormat:@"%@",User_ID] publicKey:kRSA_Public_key];
    [FKL_DataService requestURL:[NSString url_getMatchResults] parameters:nil headerKey:@"sign" headerValue:encryWithPublicKeyStr withType:@"GET" format:@"JSON" complete:^(id result) {
        [self hideHud];
        if ([result[@"code"] integerValue] == 200) { // 匹配成功
            XDMatchUserModel *user = [XDMatchUserModel objectWithKeyValues:result[@"data"]];
            [self matchSuccessWithUser:user];
        } else if ([result[@"code"] integerValue] == 206) { // 匹配失败
            [self matchFailed];
        } else if ([result[@"code"] integerValue] == 203) { // 正在匹配
            self.isMatchView.minCount = [result[@"data"][@"countdown"] integerValue];
        } else {
            [self.view makeToast:result[@"message"] duration:2.0 position:CSToastPositionCenter];
        }
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideHud];
        [self.view makeToast:error.localizedDescription duration:2.0 position:CSToastPositionCenter];
    }];
}

- (void)matchSuccessWithUser:(XDMatchUserModel *)user {
    XDMatchSuccessController *vc = [[XDMatchSuccessController alloc] init];
    vc.user = user;
    
    //    NSMutableArray<UIViewController *> *childViewControllers = [self.navigationController.childViewControllers mutableCopy];
    NSMutableArray<UIViewController *> *childViewControllers = [self.rt_navigationController.rt_viewControllers mutableCopy];
    
    NSInteger currentIndex = [childViewControllers indexOfObject:self];
    [childViewControllers replaceObjectAtIndex:currentIndex withObject:vc];
    if (childViewControllers.count > 1) {
        vc.hidesBottomBarWhenPushed = YES;
    }
    [self.navigationController setViewControllers:childViewControllers animated:NO];
}

- (void)matchFailed {
    XDMatchFailController *vc = [[XDMatchFailController alloc] init];
    NSMutableArray<UIViewController *> *childViewControllers = [self.rt_navigationController.rt_viewControllers mutableCopy];
    NSInteger currentIndex = [childViewControllers indexOfObject:self];
    [childViewControllers replaceObjectAtIndex:currentIndex withObject:vc];
    if (childViewControllers.count > 1) {
        vc.hidesBottomBarWhenPushed = YES;
    }
    [self.navigationController setViewControllers:childViewControllers animated:NO];
}

@end
