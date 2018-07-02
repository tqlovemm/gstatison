//
//  XDMessageCategoryController.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2018/1/25.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import "XDMessageCategoryController.h"
#import "XDSingleCategoryController.h"
#import "MJRefresh.h"

#import "XDMessageCategoryCell.h"
#import "XDMsgCategoryModel.h"
#import "XDEmptyView.h"

@interface XDMessageCategoryController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,weak) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

/** 分页页码 */
@property (nonatomic, assign) NSInteger pageIndex;
/** 分页最大页码 */
@property (nonatomic, assign) NSInteger maxPage;

@end

@implementation XDMessageCategoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"消息中心";
    
    // 创建tableView
    [self xdd_setupTableView];
    
    // 集成刷新控件
    [self xdd_setupRefreshControl];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

/**
 *  创建tableView
 */
- (void)xdd_setupTableView {
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT - NavigationBar_Height) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 50;
    tableView.backgroundColor = RGB(226, 226, 226);
    tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    //设置emptyView
    self.tableView.ly_emptyView = [XDEmptyView diyEmptyView];
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
    
//    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
//    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(reloadMoreData)];
}

- (void)reloadNewData {
    
//    _pageIndex = 1;
    [self requestData];
}

#pragma mark - 获取数据
- (void)retryNewData {
//
//    // 消除没有更多数据的状态
//    [self.tableView.mj_footer resetNoMoreData];
    
    [self.tableView.mj_header beginRefreshing];
    
}

//- (void)reloadMoreData {
//    if (_pageIndex < self.maxPage) {
//        _pageIndex = _pageIndex + 1;
//
//        [self requestData];
//    } else {
//        // 已经全部加载完毕
//        [self.tableView.mj_footer endRefreshingWithNoMoreData];
//    }
//}

#pragma mark - 获取消息数据

/**
 *  获得消息数据
 */
- (void)requestData {

    [self showHudInView:self.view hint:@"加载中..."];
    [FKL_DataService encryption_requestURL:[NSString url_getAllMessageCategoryList] parameters:nil withType:@"GET" complete:^(id result) {
        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.tableView.mj_header endRefreshing];
        // 拿到当前的上拉刷新控件，结束刷新状态
        [self.tableView.mj_footer endRefreshing];
        [self hideHud];
        if ([result[@"code"] integerValue] == 200) {
            NSArray *dataArr = [XDMsgCategoryModel objectArrayWithKeyValuesArray:result[@"data"]];
            NSLog(@"%@",dataArr);
            dataArr = [dataArr sortedArrayUsingComparator:^NSComparisonResult(XDMsgCategoryModel *obj1, XDMsgCategoryModel *obj2) {
                //此处的规则含义为：若前一元素比后一元素小，则返回降序（即后一元素在前，为从大到小排列）
                if ([obj1.latest_news.created_at integerValue] < [obj2.latest_news.created_at integerValue]) {
                    return NSOrderedDescending;
                } else {
                    return NSOrderedAscending;
                }
            }];
            self.dataArray = [NSMutableArray arrayWithArray:dataArr];
            [self.tableView reloadData];
            
        } else {
            [self.view showToastMessage:result[@"message"]];
        }
        
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.tableView.mj_header endRefreshing];
        // 拿到当前的上拉刷新控件，结束刷新状态
        [self.tableView.mj_footer endRefreshing];
        [self hideHud];
        [self.view showToastMessage:error.localizedDescription];
    }];
}

#pragma mark -TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 创建cell
    XDMessageCategoryCell *cell = [XDMessageCategoryCell cellWithTableView:tableView];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XDMsgCategoryModel *msgModel = self.dataArray[indexPath.row];
    XDSingleCategoryController *singleVC = [[XDSingleCategoryController alloc] init];
    singleVC.categoryModel = msgModel;
    [self.navigationController pushViewController:singleVC animated:YES];
    msgModel.unread_count = 0;
    [self.tableView reloadData];
}

@end
