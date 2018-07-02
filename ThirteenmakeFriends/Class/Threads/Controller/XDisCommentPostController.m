//
//  XDisCommentPostController.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 17/3/31.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDisCommentPostController.h"
#import "XDPostModel.h"
#import "XDUnreadPostFrame.h"
#import "XDUnreadPostMessageCell.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "XDPostDetailController.h"
#import "XDHistoryPostMessageController.h"

@interface XDisCommentPostController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (nonatomic ,strong) NSMutableArray *threadsArray;

@property (nonatomic ,weak) UITableView *tableView;

//! 分页页码
@property (nonatomic, assign) NSInteger pageIndex;
//! 分页最大页码
@property (nonatomic, assign) NSInteger MaxPage;

@end

@implementation XDisCommentPostController

- (NSMutableArray *)threadsArray {
    if (_threadsArray == nil) {
        _threadsArray = [NSMutableArray array];
    }
    return _threadsArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我相关的";
    
    //    [self setupNavbar];
    
    [self xdd_setupTableView];
    
    [self setupTableFooterView];
    
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

- (void)setupTableFooterView {
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Normal_Height)];
    footView.backgroundColor = [UIColor whiteColor];
    UILabel *textLab = [[UILabel alloc] init];
    textLab.text = @"查看历史消息";
    textLab.font = k14Font;
    textLab.textColor = RGB(205, 205, 205);
    textLab.size = [textLab.text sizeWithFont:k14Font];
    textLab.centerX = footView.width / 2.0;
    textLab.centerY = footView.height / 2.0;
    [footView addSubview:textLab];
    
    UIImageView *underLine = [[UIImageView alloc]init];
    underLine.backgroundColor = RGB(190, 190, 190);
    underLine.frame = CGRectMake(0, footView.height - 0.5, footView.width, 0.5);
    [footView addSubview:underLine];
    
    UIImageView *uperLine = [[UIImageView alloc]init];
    uperLine.backgroundColor = RGB(190, 190, 190);
    uperLine.frame = CGRectMake(0, 0.5, footView.width, 0.5);
    [footView addSubview:uperLine];
    
    self.tableView.tableFooterView = footView;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seeHistory)];
    [footView addGestureRecognizer:tap];
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
        [self showHint:@"没有要清空的消息"];
        return;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"你确定要清空所有历史消息吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

#pragma mark - 获取数据
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
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}

- (void)requestData {
    
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"page"] = @(_pageIndex);
    paras[@"user_id"] = User_ID;
//    paras[@"access-token"] = [GeTuiSdk clientId];
//    paras[@"read_user"] = @"1";
    paras[@"type"] = @"0";
    NSString *url = [NSString stringWithFormat:@"%@/v11/form-thread-push-msgs",DomainUrl2];
    
//    // 公钥加密
//    NSString *encryWithPublicKeyStr = [RSAUtil encryptString:[NSString stringWithFormat:@"%@",User_ID] publicKey:kRSA_Public_key];
//    [FKL_DataService requestURL:url parameters:paras headerKey:@"sign" headerValue:encryWithPublicKeyStr withType:@"GET" format:@"JSON" complete:^(id result) {
    
    [FKL_DataService requestURL:url parameters:paras withType:@"GET" format:@"JSON" complete:^(id result) {
    
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
            
//            if (_pageIndex == 1 && records.count > 0) { // 标记未读消息为已读
//                [self flagReadThreadMessage];
//            }
            // 更新未读消息数量
            [[NSNotificationCenter defaultCenter] postNotificationName:@"unreadOtherMessageCount" object:nil];
            
            for (XDPostModel *thread in records) {
                XDUnreadPostFrame *unreadFrame = [[XDUnreadPostFrame alloc] init];
                unreadFrame.model = thread;
                [self.threadsArray addObject:unreadFrame];
            }
            
            [self.tableView reloadData];
        } else {
            [self.view makeToast:result[@"message"] duration:2.0 position:CSToastPositionCenter];
        }
        
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.tableView.mj_header endRefreshing];
        // 拿到当前的上拉刷新控件，结束刷新状态
        [self.tableView.mj_footer endRefreshing];
        [self.view makeToast:error.localizedDescription duration:2.0 position:CSToastPositionCenter];
    }];
}

- (void)flagReadThreadMessage { // 标记未读消息为已读
    NSString *url = [NSString stringWithFormat:@"%@/v10/messages/%@",DomainUrl2,User_ID];
    //    [FKL_DataService requestURL:url parameters:nil withType:@"PATCH" format:@"JSON" complete:^(id result) {
    // 公钥加密
    NSString *encryWithPublicKeyStr = [RSAUtil encryptString:[NSString stringWithFormat:@"%@",User_ID] publicKey:kRSA_Public_key];
    [FKL_DataService requestURL:url parameters:nil headerKey:@"sign" headerValue:encryWithPublicKeyStr withType:@"PATCH" format:@"JSON" complete:^(id result) {
        if ([result[@"code"] intValue] == 200) {
            // 更新未读消息数量
            [[NSNotificationCenter defaultCenter] postNotificationName:@"unreadOtherMessageCount" object:nil];
        } else {
            [self.view makeToast:result[@"message"] duration:2.0 position:CSToastPositionCenter];
        }
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
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

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([alertView cancelButtonIndex] != buttonIndex) {
        __weak typeof(self) weakSelf = self;
        NSString *url = [NSString stringWithFormat:@"%@/v10/messages/%@",DomainUrl2,User_ID];
        // 公钥加密
        NSString *encryWithPublicKeyStr = [RSAUtil encryptString:[NSString stringWithFormat:@"%@",User_ID] publicKey:kRSA_Public_key];
        [FKL_DataService requestURL:url parameters:nil headerKey:@"sign" headerValue:encryWithPublicKeyStr withType:@"DELETE" format:@"JSON" complete:^(id result) {
            
            if ([result[@"code"] intValue] == 200) {
                [self.threadsArray removeAllObjects];
                [weakSelf.tableView reloadData];
                // 更新未读消息数量
                [[NSNotificationCenter defaultCenter] postNotificationName:@"unreadOtherMessageCount" object:nil];
            } else {
                [self showHint:[NSString stringWithFormat:@"%@",result[@"message"]]];
            }
        } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"%@",error);
        }];
    }
}

#pragma mark - 查看历史消息
- (void)seeHistory {
    XDHistoryPostMessageController *historyVC = [[XDHistoryPostMessageController alloc] init];
    historyVC.title = @"历史消息";
    [self.navigationController pushViewController:historyVC animated:YES];
}

@end
