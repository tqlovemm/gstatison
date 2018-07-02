//
//  XDMatchRecordController.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/12/14.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDMatchRecordController.h"
#import "XDMatchCommentController.h"

#import "XDMatchRecordCell.h"
#import "XDRefreshHeader.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "XDMatchRecordModel.h"

@interface XDMatchRecordController ()<UITableViewDelegate,UITableViewDataSource,XDErrorViewDelegate>
{
    XDErrorView *_errorView;
}

@property (nonatomic ,weak) UITableView *tableView;

@property (nonatomic ,strong) NSMutableArray *threadsArray;

//! 分页页码
@property (nonatomic, assign) NSInteger pageIndex;
//! 分页最大页码
@property (nonatomic, assign) NSInteger MaxPage;

@end

@implementation XDMatchRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"记录";
    
    [self xdd_setupTableView];
    [self setupErrorView];
    [self xdd_setupRefreshControl];
}

/**
 *  创建tableView
 */
- (void)xdd_setupTableView {
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT - NavigationBar_Height) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.rowHeight = 65;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 70, 0, 0)];
    }
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

/**
 *  初始化--错误提示界面
 */
- (void)setupErrorView {
    _errorView = [XDErrorView errorViewWithSuperView:self.view Frame:self.view.bounds];
    _errorView.delegate = self;
}


#pragma mark - 获取数据
- (void)reloadNewData {
    
    if (![[AppUpdateInfo sharedInstance] isHavingNetworking]) {
        
        if (self.threadsArray.count == 0) {
            // 添加自定义错误(断网)提示
            _errorView = [_errorView addErrorViewWithType:@"error_nonet"];
        }
        
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
    // 公钥加密
    NSString *encryWithPublicKeyStr = [RSAUtil encryptString:[NSString stringWithFormat:@"%@",User_ID] publicKey:kRSA_Public_key];
    [FKL_DataService requestURL:[NSString url_getMatch_HistoryRecords] parameters:paras headerKey:@"sign" headerValue:encryWithPublicKeyStr withType:@"GET" format:@"JSON" complete:^(id result) {
        
        if ([result[@"code"] integerValue] == 200) {
            self.MaxPage = [result[@"data"][@"_meta"][@"pageCount"] integerValue];
            if (_pageIndex == 1) {
                self.threadsArray = [NSMutableArray array];
            }
            
            NSArray *records = [XDMatchRecordModel objectArrayWithKeyValuesArray:result[@"data"][@"items"]];
            
            if (self.threadsArray.count == 0 && records.count == 0) {
                // 无数据
                _errorView = [_errorView addErrorViewWithType:error_nodata_flag];
                return ;
            }
            
            [self.threadsArray addObjectsFromArray:records];
            // 移除ErrorView
            _errorView = [_errorView removeErrorView];
            
            [self.tableView reloadData];
        } else {
            [self.view makeToast:result[@"message"]
                        duration:2.0
                        position:CSToastPositionCenter];
        }
        
        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.tableView.mj_header endRefreshing];
        // 拿到当前的上拉刷新控件，结束刷新状态
        [self.tableView.mj_footer endRefreshing];
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        [self.view makeToast:error.localizedDescription
                    duration:2.0
                    position:CSToastPositionCenter];
        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.tableView.mj_header endRefreshing];
        // 拿到当前的上拉刷新控件，结束刷新状态
        [self.tableView.mj_footer endRefreshing];
    }];
    
}

#pragma mark -TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.threadsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 创建cell
    XDMatchRecordCell *cell = [XDMatchRecordCell cellWithTableView:tableView];
    cell.recordModel = self.threadsArray[indexPath.row];
    XD_WeakSelf
    cell.commentButtonClickedBlock = ^(UIButton *btn) {
        XD_StrongSelf
        XDMatchRecordModel *model = self.threadsArray[indexPath.row];
        [self commentPerson:model indexPath:indexPath];
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //    XDFlopEvaluationModel *matchModel = self.threadsArray[indexPath.row];
    //    XDOtherViewController * otherVC = [[XDOtherViewController alloc] init];
    //    otherVC.user_id = matchModel.info.user_id;
    //    [self.navigationController pushViewController:otherVC animated:YES];
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

#pragma mark - 网络
/**
 去评论
 */
- (void)commentPerson:(XDMatchRecordModel *)model indexPath:(NSIndexPath *)indexPath{
    XDMatchCommentController *commentVC = [[XDMatchCommentController alloc] init];
    commentVC.user = model;
    XD_WeakSelf
    commentVC.hasevaluated = ^(NSString *str) {
        XD_StrongSelf
        model.comment_level = str;
        model.is_comment = 1;
        [self.tableView reloadData];
        
        [self.view makeToast:@"评论成功"
                    duration:2.0
                    position:CSToastPositionCenter];
    };
    [self.navigationController pushViewController:commentVC animated:YES];
}

@end
