//
//  XDCheckSignUpController.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2018/1/9.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import "XDCheckSignUpController.h"
//#import "ChatViewController.h"
#import "MJRefresh.h"
#import "XDCheckSignUpHeaderCell.h"
#import "XDCheckSignUpCell.h"
#import "XDSaveMeModel.h"
#import "XDEmptyView.h"

@interface XDCheckSignUpController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong) XDSaveMeModel *model;

@property (nonatomic ,weak) UITableView *tableView;

/** 分页页码 */
@property (nonatomic, assign) NSInteger pageIndex;
/** 分页最大页码 */
@property (nonatomic, assign) NSInteger MaxPage;

@end

@implementation XDCheckSignUpController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"查看报名";
    self.edgesForExtendedLayout = UIRectEdgeAll;
    
    [self xdd_setupTableView];
    [self xdd_setupRefreshControl];
}

- (void)xdd_setupTableView {
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = RGB(240, 239, 245);
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(reloadMoreData)];
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
    
    // 公钥加密
    NSString *encryWithPublicKeyStr = [RSAUtil encryptString:[NSString stringWithFormat:@"%@",User_ID] publicKey:kRSA_Public_key];
    [FKL_DataService requestURL:[NSString url_getNewSavemeDetail_withSavemeID:self.info_id] parameters:nil headerKey:@"sign" headerValue:encryWithPublicKeyStr withType:@"GET" format:@"JSON" complete:^(id result) {
        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.tableView.mj_header endRefreshing];
        // 拿到当前的上拉刷新控件，结束刷新状态
        [self.tableView.mj_footer endRefreshing];
        if ([result[@"code"] integerValue] == 200) {
            self.model = [XDSaveMeModel objectWithKeyValues:result[@"data"]];
            [self.tableView reloadData];
            //调用时机
            [self.tableView ly_endLoading];
        } else {
            [self.view makeToast:result[@"message"] duration:2.0 position:CSToastPositionCenter];
        }
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        [self.view makeToast:error.localizedDescription duration:2.0 position:CSToastPositionCenter];
        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.tableView.mj_header endRefreshing];
        // 拿到当前的上拉刷新控件，结束刷新状态
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.model) {
        if (section == 0) {
            return 1;
        }
        return self.model.signup.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        // 创建cell
        XDCheckSignUpHeaderCell *cell = [XDCheckSignUpHeaderCell cellWithTableView:tableView];
        cell.model = self.model;
        
        return cell;
    } else {
        // 创建cell
        XDCheckSignUpCell *cell = [XDCheckSignUpCell cellWithTableView:tableView];
        cell.model = self.model.signup[indexPath.row];
        XD_WeakSelf
        cell.sessionBtnClicked = ^(XDSignUpModel *model) {
            XD_StrongSelf
            [self contactToPerson:model];
        };
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return UITableViewAutomaticDimension;
    } else {
        return 86;
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewAutomaticDimension;
}

#pragma mark - 加好友或联系他
- (void)contactToPerson:(XDSignUpModel *)model {
    if (!model.is_friend) { //不是好友
        [self showHudInView:self.view hint:nil];
        NSMutableDictionary *paras = [NSMutableDictionary dictionary];
        paras[@"username"] = model.username;
        
        // 公钥加密
        NSString *encryWithPublicKeyStr = [RSAUtil encryptString:[NSString stringWithFormat:@"%@",User_ID] publicKey:kRSA_Public_key];
        [FKL_DataService requestURL:[NSString url_Forced_friends] parameters:paras headerKey:@"sign" headerValue:encryWithPublicKeyStr withType:@"GET" format:@"JSON" complete:^(id result) {
            [self hideHud];
            if ([result[@"code"] intValue] == 200) {
                model.is_friend = YES;
                [self.tableView reloadData];
            } else {
                [self.view makeToast:result[@"message"]
                            duration:2.0
                            position:CSToastPositionCenter];
            }
        } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
            [self hideHud];
            [self.view makeToast:error.localizedDescription duration:2.0 position:CSToastPositionCenter];
        }];
    } else {
//        ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:model.username conversationType:eConversationTypeChat];
//        chatController.title = model.nickname;
//        [self.navigationController pushViewController:chatController animated:YES];
    }
}

@end
