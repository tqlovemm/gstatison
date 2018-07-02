//
//  XDHistoryPostMessageController.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 17/3/31.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//  

#import "XDHistoryPostMessageController.h"
#import "XDPostModel.h"
#import "XDUnreadPostFrame.h"
#import "XDUnreadPostMessageCell.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "XDPostDetailController.h"

@interface XDHistoryPostMessageController ()<UITableViewDataSource,UITableViewDelegate,XDErrorViewDelegate,UIAlertViewDelegate>
{
    XDErrorView *_errorView;
}

@property (nonatomic ,strong) NSMutableArray *threadsArray;

@property (nonatomic ,weak) UITableView *tableView;

//! 分页页码
@property (nonatomic, assign) NSInteger pageIndex;
//! 分页最大页码
@property (nonatomic, assign) NSInteger MaxPage;

@end

@implementation XDHistoryPostMessageController

- (NSMutableArray *)threadsArray {
    if (_threadsArray == nil) {
        _threadsArray = [NSMutableArray array];
    }
    return _threadsArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavbar];
    
    [self xdd_setupTableView];
    
    [self setupErrorView];
    
    [self xdd_setupRefreshControl];
}

- (void)setupNavbar {
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -10;
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBtn setTitle:@"清空" forState:UIControlStateNormal];
    [rightBtn setTitleColor:NormalNavBtnColor forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [rightBtn addTarget:self action:@selector(removeAllUnreadMessages) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, rightBtnItem];
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


/**
 清空
 */
- (void)removeAllUnreadMessages {
    
    if (self.threadsArray.count == 0) {
        [self showHint:@"没有需要删除的消息"];
        return;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"你确定要删除所有消息吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
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
    paras[@"user_id"] = User_ID;
    
    [FKL_DataService requestURL:[NSString url_getThreadMessages] parameters:paras withType:@"GET" format:@"JSON" complete:^(id result) {
    
        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.tableView.mj_header endRefreshing];
        // 拿到当前的上拉刷新控件，结束刷新状态
        [self.tableView.mj_footer endRefreshing];
        
        if ([result[@"code"] integerValue] == 200) {
            self.MaxPage = [result[@"_meta"][@"pageCount"] integerValue];
            if (_pageIndex == 1) {
                self.threadsArray = [NSMutableArray array];
            }
            
            NSArray *records = [XDPostModel objectArrayWithKeyValuesArray:result[@"data"]];
            
            if (self.threadsArray.count == 0 && records.count == 0) {
                // 无数据
                _errorView = [_errorView addErrorViewWithType:error_nodata_flag];
                return ;
            }
            
            for (XDPostModel *thread in records) {
                XDUnreadPostFrame *unreadFrame = [[XDUnreadPostFrame alloc] init];
                unreadFrame.model = thread;
                [self.threadsArray addObject:unreadFrame];
            }
            
            //        [self.threadsArray addObjectsFromArray:records];
            // 移除ErrorView
            _errorView = [_errorView removeErrorView];
            
            [self.tableView reloadData];
        } else {
            [self.view makeToast:result[@"message"] duration:2.0 position:CSToastPositionCenter];
        }
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
    return self.threadsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 创建cell
    static NSString *ID = @"XDUnreadPostMessageCellID";
    XDUnreadPostMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if(cell == nil)
    {
        cell = [[XDUnreadPostMessageCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    cell.unreadThread = self.threadsArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XDUnreadPostFrame *modelFrame = self.threadsArray[indexPath.row];
    if (modelFrame.model.unreadContent.length == 0 && modelFrame.model.imgItemsArray.count == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"该帖子不存在或已删除" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    } else {
        XDPostDetailController *threadDetailVC = [[XDPostDetailController alloc] init];
        threadDetailVC.thread_id = modelFrame.model.wid;
        [self.navigationController pushViewController:threadDetailVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XDUnreadPostFrame *unreadThread = self.threadsArray[indexPath.row];
    return unreadThread.cellHeight;
}

#pragma mark - 编辑cell
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

/*删除用到的函数*/
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // 删除某条消息
        [self deleteOneMessageWithIndexPath:indexPath];
        
    }
}

#pragma mark - 删除某条消息
- (void)deleteOneMessageWithIndexPath:(NSIndexPath *)indexPath {
    XDUnreadPostFrame *modelFrame = self.threadsArray[indexPath.row];
    
    __weak typeof(self) weakSelf = self;
    NSString *url = [NSString stringWithFormat:@"%@/v11/form-thread-push-msgs/%@?user_id=%@&type=11",DomainUrl2,@(modelFrame.model.mid),User_ID];
    // 公钥加密
    NSString *encryWithPublicKeyStr = [RSAUtil encryptString:[NSString stringWithFormat:@"%@",User_ID] publicKey:kRSA_Public_key];
    [FKL_DataService requestURL:url parameters:nil headerKey:@"sign" headerValue:encryWithPublicKeyStr withType:@"DELETE" format:@"JSON" complete:^(id result) {
        if ([result[@"code"] integerValue] == 200) {
            XDUnreadPostFrame *modelFrame = weakSelf.threadsArray[indexPath.row];
            [weakSelf.threadsArray removeObject:modelFrame];
            //删除某一行
            [weakSelf.tableView reloadData];
        } else {
            [self.view makeToast:result[@"message"] duration:2 position:CSToastPositionCenter];
        }
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        [self.view makeToast:error.localizedDescription duration:2 position:CSToastPositionCenter];
    }];
}

#pragma mark - UIAlertViewDelegate (清空所有消息)
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([alertView cancelButtonIndex] != buttonIndex) {
        __weak typeof(self) weakSelf = self;
        NSString *url = [NSString stringWithFormat:@"%@/v11/form-thread-push-msgs/1?user_id=%@&type=12",DomainUrl2,User_ID];
        // 公钥加密
        NSString *encryWithPublicKeyStr = [RSAUtil encryptString:[NSString stringWithFormat:@"%@",User_ID] publicKey:kRSA_Public_key];
        [FKL_DataService requestURL:url parameters:nil headerKey:@"sign" headerValue:encryWithPublicKeyStr withType:@"DELETE" format:@"JSON" complete:^(id result) {
            if ([result[@"code"] intValue] == 200) {
                [self.threadsArray removeAllObjects];
                [weakSelf.tableView reloadData];
            } else {
                [self.view makeToast:result[@"message"] duration:2 position:CSToastPositionCenter];
            }
        } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
            [self.view makeToast:error.localizedDescription duration:2 position:CSToastPositionCenter];
        }];
    }
}

@end
