//
//  XDExclusiveListController.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/9/5.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDExclusiveListController.h"
#import "ExclusiveModel.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "XDPayCoinView.h"
#import "XDExclusiveDetailController.h"
#import "XDAccountTool.h"
#import "ProfileUser.h"
#import "XDAreaModel.h"
#import "XDSeekPaySucessController.h"
#import "XDExclusiveCell.h"

@interface XDExclusiveListController ()<UITableViewDelegate,UITableViewDataSource,XDErrorViewDelegate,XDPayCoinViewDelegate,XDSeekCellDelegate,UIAlertViewDelegate>
{
    XDErrorView *_errorView;
}

/** tableView */
@property (nonatomic ,weak) UITableView *tableView;
/** 今日觅约的数组 */
@property (nonatomic ,strong) NSMutableArray *seekFrameArray;

//! 分页页码
@property (nonatomic, assign) NSInteger pageIndex;
//! 分页最大页码
@property (nonatomic, assign) NSInteger MaxPage;

//! 求推荐的觅约模型
@property (nonatomic, strong) ExclusiveModel *seek;

//! 求推荐视图
@property (nonatomic, strong) XDPayCoinView *seekPayView;

@end

@implementation XDExclusiveListController

- (NSMutableArray *)seekFrameArray {
    if (_seekFrameArray == nil) {
        _seekFrameArray = [NSMutableArray array];
    }
    return _seekFrameArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 创建tableView
    [self xdd_setupTableView];
    _pageIndex = 1;
    
    // 创建ErrorView
    [self setupErrorView];
    
    // 集成刷新控件
    [self xdd_setupRefreshControl];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.seekFrameArray.count > 0) {
        // 缓存最新数据
        [self saveCacheDatas];
    }
}

#pragma mark - 创建tableview相关控件
/**
 *  创建tableview
 */
- (void)xdd_setupTableView {
    // 今日觅约
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT - NavigationBar_Height - TabBar_Height) style:UITableViewStylePlain];
    tableView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = RGB(240, 239, 245);
    tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

/**
 *  集成刷新控件
 */
- (void)xdd_setupRefreshControl {
    __unsafe_unretained __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.mj_header = [XDRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf reloadNewData];
    }];
    
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(reloadMoreData)];
    // 忽略掉顶部inset
    self.tableView.mj_header.ignoredScrollViewContentInsetTop = 10;
    
}

#pragma mark - 获取觅约数据
/**
 *  加载新数据
 */
- (void)reloadNewData {
    
    // 判断网络状况
    if (!isNetworking) {
        // 获取缓存数据
        [self getCacheDatas];
        
        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.tableView.mj_header endRefreshing];
        
        if (self.seekFrameArray.count == 0) {
            // 添加自定义错误(断网)提示
            _errorView = [_errorView addErrorViewWithType:@"error_nonet"];
        }
        return;
    }
    
    _pageIndex = 1;
    [self requestData];
}

/**
 *  加载更多数据
 */
- (void)reloadMoreData {
    if (_pageIndex < self.MaxPage) {
        _pageIndex = _pageIndex + 1;
        
        [self requestData];
        
    } else {
        // 已经全部加载完毕
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}

- (void)requestData {
    // 判断网络状况
    if (!isNetworking) {
        // 添加自定义错误(断网)提示
        _errorView = [_errorView addErrorViewWithType:error_nonet_flag];
        return;
    }
    
    XD_WeakSelf
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"page"]             = @(_pageIndex);
    if (self.areaModel) {
        paras[@"area"] = self.areaModel;
    }
    
    [FKL_DataService requestURL:[NSString url_getExclusiveList] parameters:paras withType:@"GET" format:@"JSON" complete:^(id result) {
        XD_StrongSelf
        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if ([result[@"code"] integerValue] == 200) {
            if (_pageIndex == 1) {
                self.seekFrameArray    = [NSMutableArray array];
            }
            
            self.MaxPage     = [result[@"_meta"][@"pageCount"] integerValue];
            NSArray *seekArr = [ExclusiveModel objectArrayWithKeyValuesArray:result[@"data"]];
            
            if (self.seekFrameArray.count == 0 && seekArr.count == 0) {
                // 无数据
                _errorView = [_errorView addErrorViewWithType:error_nodata_flag];
                return ;
            }
            
            [self.seekFrameArray addObjectsFromArray:seekArr];
            
            if (_pageIndex == 1 && seekArr.count > 0) { // 缓存数据
                [self saveCacheDatas];
            }
            // 有网，移除视图
            _errorView = [_errorView removeErrorView];
            [self.tableView reloadData];
        } else {
            [self.view makeToast:result[@"message"] duration:2.0 position:CSToastPositionCenter];
        }
        
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        XD_StrongSelf
        [self.view makeToast:error.localizedDescription duration:2.0 position:CSToastPositionCenter];
        if (_pageIndex == 1) {
            [self getCacheDatas];
        }
        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

/**
 *  往日觅约
 */
- (void)retryNewData {
    
    // 消除没有更多数据的状态
    [self.tableView.mj_footer resetNoMoreData];
    
    [self.tableView.mj_header beginRefreshing];
    
}

#pragma mark - tableview 方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.seekFrameArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XDExclusiveCell *cell = [XDExclusiveCell cellWithTableView:tableView];
    cell.delegate = self;
    cell.seekModel = self.seekFrameArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.navigationController.delegate = nil;
    
    ProfileUser *user = [XDAccountTool account];
    if ([user.groupid integerValue] < 4 && [user.sex integerValue] == 0) {
        [self.navigationController.view makeToast:@"至尊以上会员才可查看详情哦" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    
    XDExclusiveDetailController *seekDetailVC = [[XDExclusiveDetailController alloc] init];
    seekDetailVC.seekModel = self.seekFrameArray[indexPath.row];
    [self.navigationController pushViewController:seekDetailVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewAutomaticDimension;
}

#pragma mark - 求推荐点击
- (void)recommendButtonClicked:(UIButton *)recommendBtn andSeek:(ExclusiveModel *)seek {
    self.seek = seek;
    
    if ([User_Sex isEqualToString:@"1"]) {
        [self.navigationController.view makeToast:@"尚未开放" duration:1 position:CSToastPositionCenter];
        return;
    }
    ProfileUser *user = [XDAccountTool account];
    if ([user.groupid isEqualToString:@"4"]||[user.groupid isEqualToString:@"5"]) {
        // 必须调用initWithFrame方法创建对象
        self.seekPayView            = [[XDPayCoinView alloc] initWithFrame:[[UIApplication sharedApplication].keyWindow bounds]];
        self.seekPayView.delegate   = self;
        self.seekPayView.price      = seek.coin;
        self.seekPayView.noticeType = DateNotice;
        [self.seekPayView startAnim];
        [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:self.seekPayView];
    }
    else {
        [self.navigationController.view makeToast:@"您的等级不足，专属女生仅限至尊及以上会员报名"
                                         duration:1
                                         position:CSToastPositionCenter];
    }
    
}

- (void)requestRecommend:(ExclusiveModel *)seek {
    
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"user_id"]          = User_ID;
    paras[@"zid"]              = F(@"%@",seek.zid);
    // 公钥加密
    NSString *encryWithPublicKeyStr = [RSAUtil encryptString:[NSString stringWithFormat:@"%@",User_ID] publicKey:kRSA_Public_key];
    [FKL_DataService requestURL:[NSString url_exclusive_recommend] parameters:paras headerKey:@"sign" headerValue:encryWithPublicKeyStr withType:@"POST" format:@"JSON" complete:^(id result) {
        if ([result[@"code"] integerValue] == 200) {
            XDSeekPaySucessController *paySuccessVC = [[XDSeekPaySucessController alloc] init];
            paySuccessVC.payMoney = [seek.coin integerValue];
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
                                         duration:1
                                         position:CSToastPositionCenter];
    }];
}

#pragma mark - ErrorView Delegate
-(void)setupErrorView{
    _errorView = [XDErrorView errorViewWithSuperView:self.view Frame:self.view.bounds];
    _errorView.delegate = self;
}

/**
 *  XDErrorViewDelegate
 */
- (void)errorViewAddErrorView:(XDErrorView *)errorView {
    self.tableView.scrollEnabled = NO;
}

- (void)errorViewRemoveErrorView:(XDErrorView *)errorView {
    self.tableView.scrollEnabled = YES;
}

- (void)errorViewTapedErrorView:(XDErrorView *)errorView{
    // 请求数据
    [self reloadNewData];
}

#pragma mark - SeekPayViewDelegate
- (void)entryPay {
    [self requestRecommend:self.seek];
}

#pragma mark - 数据缓存

/**
 保存数据
 */
- (void)saveCacheDatas {
    NSString *cachesDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex: 0];
    NSString *path            = [NSString stringWithFormat:@"cache_Exclusive_%@—_%@.archive",User_ID,User_Sex];
    NSString *archivePath     = [cachesDirectory stringByAppendingPathComponent:path];
    [NSKeyedArchiver archiveRootObject:self.seekFrameArray toFile:archivePath];
}

/**
 获取数据
 */
- (void)getCacheDatas {
    NSString *cachesDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex: 0];
    NSString *path            = [NSString stringWithFormat:@"cache_Exclusive_%@—_%@.archive",User_ID,User_Sex];
    NSString *archivePath     = [cachesDirectory stringByAppendingPathComponent:path];
    self.seekFrameArray       = [NSKeyedUnarchiver unarchiveObjectWithFile:archivePath];
    
    [self.tableView reloadData];
}

@end
