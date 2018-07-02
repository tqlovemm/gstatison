//
//  XDTopicListController.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/10/27.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDTopicListController.h"
#import "MJRefresh.h"
#import "XDTopicItemCell.h"
#import "XDPostsController.h"
#import "XDPostTopModel.h"

@interface XDTopicListController ()<UITableViewDelegate,UITableViewDataSource>

/** tableView */
@property (nonatomic ,weak) UITableView *tableView;
/** 数组源 */
@property (nonatomic ,strong) NSMutableArray *dataArray;

/** 分页页码 */
@property (nonatomic, assign) NSInteger pageIndex;
/** 分页最大页码 */
@property (nonatomic, assign) NSInteger MaxPage;

@end

@implementation XDTopicListController

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self xdd_setupTableView];
    
    [self xdd_setupRefreshControl];
}

#pragma mark - 创建tableview相关控件
/**
 *  创建tableview
 */
- (void)xdd_setupTableView {
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = RGB(240, 239, 245);
    tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    XD_WeakSelf
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.left.right.top.bottom.mas_equalTo(self.view);
    }];
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
//    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(reloadMoreData)];
    
}

#pragma mark - 获取觅约数据
/**
 *  加载新数据
 */
- (void)reloadNewData {
    
    // 判断网络状况
    if (!isNetworking) {
        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.tableView.mj_header endRefreshing];
        
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
    
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"type"] = @"2"; // 推荐标签
    [FKL_DataService requestURL:[NSString url_getdynamicrecommend] parameters:paras withType:@"GET" format:@"JSON" complete:^(id result) {
        [self.tableView.mj_header endRefreshing];
        if ([result[@"code"] integerValue] == 200) {
            NSArray *dataArray = [XDAcitivityModel objectArrayWithKeyValuesArray:result[@"data"]];
            self.dataArray = [NSMutableArray arrayWithArray:dataArray];
            [self.tableView reloadData];
        } else {
            [self.view makeToast:result[@"code"] duration:2.0 position:CSToastPositionCenter];
        }
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.view makeToast:error.localizedDescription duration:2.0 position:CSToastPositionCenter];
    }];
}

#pragma mark - tableview 方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XDTopicItemCell *cell = [XDTopicItemCell cellWithTableView:tableView];
    cell.tagModel = self.dataArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XDAcitivityModel *tagModel = self.dataArray[indexPath.row];
    XDPostsController *postVC = [[XDPostsController alloc] init];
    postVC.title = tagModel.tag_name;
    postVC.topic = tagModel.tag_name;
    [self.navigationController pushViewController:postVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return UITableViewAutomaticDimension;
}

@end
