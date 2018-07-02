//
//  XDPostPraiseController.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 17/5/15.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDPostPraiseController.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "XDPostPraiseModel.h"
#import "XDPostPraiseFrameModel.h"
#import "XDPostPraiseCell.h"
//#import "XDOtherViewController.h"

@interface XDPostPraiseController ()<UITableViewDataSource,UITableViewDelegate,XDErrorViewDelegate>
{
    XDErrorView *_errorView;
}

@property (nonatomic ,strong) NSMutableArray *praisesArray;
@property (nonatomic ,weak) UITableView *tableView;

//! 分页页码
@property (nonatomic, assign) NSInteger pageIndex;
//! 分页最大页码
@property (nonatomic, assign) NSInteger MaxPage;

@end

@implementation XDPostPraiseController

- (NSMutableArray *)praisesArray {
    if (_praisesArray == nil) {
        _praisesArray = [NSMutableArray array];
    }
    return _praisesArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"收到的赞";
    
    [self setupErrorView];
    [self xdd_setupTableView];
    [self xdd_setupRefreshControl];
    
    [self setupTableFootview];
}

- (void)setupTableFootview {
    if (iPhoneX) { // MJRefresh 适配
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kSafeBottomHeight)];
        
        [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, -kSafeBottomHeight, 0)];
    }
}

- (void)xdd_setupTableView {
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT - NavigationBar_Height) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = RGB(226, 226, 226);
    tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

/**
 *  初始化--错误提示界面
 */
- (void)setupErrorView {
    _errorView = [XDErrorView errorViewWithSuperView:self.view Frame:self.view.bounds];
    _errorView.delegate = self;
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
}

#pragma mark - 获取数据
- (void)reloadNewData {
    
    if (![[AppUpdateInfo sharedInstance] isHavingNetworking]) {
        // 添加自定义错误(断网)提示
        _errorView = [_errorView addErrorViewWithType:@"error_nonet"];
        return;
    }
    
    _pageIndex = 1;
    
    [self requestData];
}

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
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"page"] = @(_pageIndex);
    //    paras[@"words_id"] = self.thread_id;
    //    NSString *url = [NSString stringWithFormat:@"%@/v7/likes",DomainUrl2];
    
    paras[@"thread_id"] = self.thread_id;
    
    [FKL_DataService requestURL:[NSString url_getThreadLikesList] parameters:paras withType:@"GET" format:@"JSON" complete:^(id result) {
//        self.MaxPage = (NSInteger)result[@"_meta"][@"pageCount"];
        if (!result[@"code"]) {
            self.MaxPage = [result[@"_meta"][@"pageCount"] integerValue];
            if (_pageIndex == 1) {
                self.praisesArray = [NSMutableArray array];
            }
            
            NSArray *records = [XDPostPraiseModel objectArrayWithKeyValuesArray:result[@"items"]];
            
            if (self.praisesArray.count == 0 && records.count == 0) {
                // 无数据
                _errorView = [_errorView addErrorViewWithType:error_nodata_flag];
                return ;
            }
            
            for (XDPostPraiseModel *praiseModel in records) {
                XDPostPraiseFrameModel *praiseFrameModel = [[XDPostPraiseFrameModel alloc] init];
                praiseFrameModel.praiseModel = praiseModel;
                
                [self.praisesArray addObject:praiseFrameModel];
            }
            
            [self.tableView reloadData];
        } else {
            [self.view makeToast:result[@"message"] duration:2.0 position:CSToastPositionCenter];
        }
        
        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.tableView.mj_header endRefreshing];
        // 拿到当前的上拉刷新控件，结束刷新状态
        [self.tableView.mj_footer endRefreshing];
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
        [self.view makeToast:error.localizedDescription duration:2.0 position:CSToastPositionCenter];
        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.tableView.mj_header endRefreshing];
        // 拿到当前的上拉刷新控件，结束刷新状态
        [self.tableView.mj_footer endRefreshing];
    }];
    
    
}

#pragma mark - XDErrorViewDelegate
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

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.praisesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 创建cell
    XDPostPraiseCell *cell = [XDPostPraiseCell cellWithTableView:tableView];
    
    cell.praiseFrameModel = self.praisesArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
//    XDPostPraiseFrameModel *praiseFrameModel = self.praisesArray[indexPath.row];
//    XDOtherViewController *otherVC = [[XDOtherViewController alloc] init];
//    otherVC.user_id = [NSString stringWithFormat:@"%ld",praiseFrameModel.praiseModel.user_id];
//    [self.navigationController pushViewController:otherVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // >>>>>>>>>>>>>>>>>>>>> * cell自适应 * >>>>>>>>>>>>>>>>>>>>>>>>
    XDPostPraiseFrameModel *praiseFrameModel = self.praisesArray[indexPath.row];
    return praiseFrameModel.cellHeight;
}

@end
