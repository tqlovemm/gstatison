//
//  XDChatupSquareController.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2018/1/11.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import "XDChatupSquareController.h"
//#import "XDOtherViewController.h"
#import "XDChatupScreenController.h"
#import "NSString+HXAddtions.h"

#import "XDChatupItemCell.h"
#import "XDSquareRecommendView.h"
#import "MJRefresh.h"
#import "XDSquareUserModel.h"
#import "XDAreaModel.h"

@interface XDChatupSquareController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSArray<XDSquareUserModel *> *userArray;

/** 头部视图 */
@property (nonatomic, strong) XDSquareRecommendView *userView;

/** 分页页码 */
@property (nonatomic, assign) NSInteger pageIndex;
/** 分页最大页码 */
@property (nonatomic, assign) NSInteger MaxPage;

@end

@implementation XDChatupSquareController

- (UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"互撩广场";
//    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.view.backgroundColor = DefaultColor_BG_gray;
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor blackColor]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    
    [self setupNavBar];
    [self setupCollectionView];
    [self xdd_setupRefreshControl];
}

#pragma mark - 导航栏
- (void)setupNavBar
{
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -12;
    if (self.navigationController.viewControllers.count > 1) {
        UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [leftBtn setImage:[UIImage imageNamed:@"navigationBar_arrow"] forState:UIControlStateNormal];
        [leftBtn addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
        self.navigationItem.leftBarButtonItems = @[negativeSpacer, leftItem];
    }
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [rightBtn setImage:[UIImage imageNamed:@"shaixuan"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, rightItem];
    
}

- (void)rightBtnAction {
    XDChatupScreenController *chatupController = [[XDChatupScreenController alloc] init];
    chatupController.areaModel = self.areaModel;
    chatupController.sex = self.sex;
    chatupController.startAge = self.startAge;
    chatupController.endAge = self.endAge;
    chatupController.is_vip = self.is_vip;
    
    XD_WeakSelf
    chatupController.downButtonClicked = ^(XDAreaModel *areaModel, NSString *startAge, NSString *endAge, NSString *sex, NSString *is_vip) {
        XD_StrongSelf
        self.areaModel = areaModel;
        self.startAge = startAge;
        self.endAge = endAge;
        self.sex = sex;
        self.is_vip = is_vip;
        
        [self retryNewData];
    };
    
    [self.navigationController pushViewController:chatupController animated:YES];
}

- (void)leftBtnAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 创建子视图
- (void)setupCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = CGFLOAT_MIN;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - NavigationBar_Height-44) collectionViewLayout:layout];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    self.collectionView.delegate             = self;
    self.collectionView.dataSource           = self;
    
    self.collectionView.backgroundColor = [UIColor blackColor];
    [self.collectionView registerClass:[XDChatupItemCell class] forCellWithReuseIdentifier:@"XDChatupItemCellID"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"chatUpSquareHeader"];
    
//    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(0);
//        make.left.mas_equalTo(0);
//        make.right.mas_equalTo(0);
//        make.bottom.mas_equalTo(0);
//    }];
}

#pragma mark - layout
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

#pragma mark -
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    XDSquareUserModel *person = self.dataArray[indexPath.row];
//    XDOtherViewController *otherVC = [[XDOtherViewController alloc] init];
//    otherVC.user_id = [NSString stringWithFormat:@"%ld",person.user_id];
//    [self.navigationController pushViewController:otherVC animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (self.view.frame.size.width - 4 * 10) / 3.0;
    CGFloat height = width + 20;
    return CGSizeMake(width, height);
}

#pragma mmark -
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XDChatupItemCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"XDChatupItemCellID" forIndexPath:indexPath];
    cell.user = self.dataArray[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    CGFloat height = 77;
    return CGSizeMake(collectionView.frame.size.width, height);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"chatUpSquareHeader" forIndexPath:indexPath];
        view.backgroundColor = [UIColor whiteColor];
        for (UIView *subView in view.subviews) {
            if (![subView isKindOfClass:[XDSquareRecommendView class]]) {
                [subView removeFromSuperview];
            }
        }
        if (indexPath.section == 0) {
            if (!self.userView) {
                self.userView = [[XDSquareRecommendView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 77)];
                [view addSubview:self.userView];
            }
            self.userView.usersArray = self.userArray;
        }
        return view;
    }
    return nil;
}

#pragma mark - 网络请求
/**
 *  集成刷新控件
 */
- (void)xdd_setupRefreshControl {
    __unsafe_unretained __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.collectionView.mj_header = [XDRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf reloadNewData];
    }];
    
    // 马上进入刷新状态
    [self.collectionView.mj_header beginRefreshing];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(reloadMoreData)];
}

#pragma mark - 获取数据
- (void)retryNewData {
    
    // 消除没有更多数据的状态
    [self.collectionView.mj_footer resetNoMoreData];
    
    [self.collectionView.mj_header beginRefreshing];
    
}

- (void)reloadNewData {
    _pageIndex = 1;
    
    [self requestData];
}

- (void)reloadMoreData {
    if (_pageIndex < self.MaxPage) {
        _pageIndex = _pageIndex + 1;
        
        [self requestData];
        
    } else {
        // 已经全部加载完毕
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
    }
}

- (void)requestData {
    
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"page"] = @(_pageIndex);
    paras[@"start_age"] = self.startAge;
    paras[@"end_age"] = self.endAge;
    paras[@"sex"] = self.sex;
    paras[@"vip"] = self.is_vip;
    paras[@"area"] = self.areaModel.areaID;
    
    // 公钥加密
    NSString *encryWithPublicKeyStr = [RSAUtil encryptString:[NSString stringWithFormat:@"%@",User_ID] publicKey:kRSA_Public_key];
    [FKL_DataService requestURL:[NSString url_chatup_squares_list] parameters:paras headerKey:@"sign" headerValue:encryWithPublicKeyStr withType:@"GET" format:@"JSON" complete:^(id result) {
        
        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.collectionView.mj_header endRefreshing];
        // 拿到当前的上拉刷新控件，结束刷新状态
        [self.collectionView.mj_footer endRefreshing];
        
        if ([result[@"code"] integerValue] == 200) {
            self.MaxPage = [result[@"data"][@"_meta"][@"pageCount"] integerValue];
            if (self.pageIndex == 1) {
                self.dataArray = [NSMutableArray array];
            }
            
            NSArray *userArr = [result[@"message"] JsonToArrayOrNSDictionary];
            if (userArr) {
                self.userArray = [XDSquareUserModel objectArrayWithKeyValuesArray:userArr];
                self.userView.usersArray = self.userArray;
            }
            NSArray *records = [XDSquareUserModel objectArrayWithKeyValuesArray:result[@"data"][@"items"]];
            [self.dataArray addObjectsFromArray:records];
            
            [self.collectionView reloadData];
        } else {
            [self.view makeToast:result[@"message"] duration:2.0 position:CSToastPositionCenter];
        }
        
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        [self.view makeToast:error.localizedDescription duration:2.0 position:CSToastPositionCenter];
        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.collectionView.mj_header endRefreshing];
        // 拿到当前的上拉刷新控件，结束刷新状态
        [self.collectionView.mj_footer endRefreshing];
    }];
}

@end
