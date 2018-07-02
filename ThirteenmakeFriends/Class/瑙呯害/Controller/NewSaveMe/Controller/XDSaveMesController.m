//
//  XDSaveMesController.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2018/1/3.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import "XDSaveMesController.h"
#import "XDCheckSignUpController.h"
#import "XDSaveMeItemCell.h"
#import "MJRefresh.h"
#import "XDSaveMeModel.h"
#import "XDEmptyView.h"
#import "XDPayCoinView.h"

@interface XDSaveMesController ()<UITableViewDataSource,UITableViewDelegate,XDPayCoinViewDelegate>

@property (nonatomic ,strong) NSMutableArray *dataArray;

@property (nonatomic ,weak) UITableView *tableView;

/** 分页页码 */
@property (nonatomic, assign) NSInteger pageIndex;
/** 分页最大页码 */
@property (nonatomic, assign) NSInteger MaxPage;
/** 是否获取过期的 */
@property (nonatomic, assign, getter=isExpired) BOOL expire;

@property (nonatomic, strong) XDEmptyView *noDataView;
@property (nonatomic, strong) XDEmptyView *noNetworkView;

/** 支付心动币view */
@property (nonatomic ,strong) XDPayCoinView *payView;

@property (nonatomic, strong) XDSaveMeModel *selectModel;

@end

@implementation XDSaveMesController

- (XDEmptyView *)noDataView{
    if (!_noDataView) {
        _noDataView = [XDEmptyView diyEmptyView];
    }
    return _noDataView;
}
- (XDEmptyView *)noNetworkView{
    if (!_noNetworkView) {
        _noNetworkView = [XDEmptyView diyEmptyActionViewWithTarget:self action:@selector(retryNewData)];
    }
    return _noNetworkView;
}

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    [self xdd_setupTableView];
    [self xdd_setupRefreshControl];
}

- (void)xdd_setupTableView {
    UITableView *tableView = [[UITableView alloc]init];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = RGB(240, 239, 245);
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
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
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(reloadMoreData)];
}

#pragma mark - 获取数据
- (void)retryNewData {
    
    // 消除没有更多数据的状态
    [self.tableView.mj_footer resetNoMoreData];
    
    [self.tableView.mj_header beginRefreshing];
    
}

- (void)reloadNewData {
    if (![[AppUpdateInfo sharedInstance] isHavingNetworking]) {
        if (self.dataArray.count == 0) {
            ///设置emptyView
            self.tableView.ly_emptyView = self.noNetworkView;
            //调用时机
            [self.tableView ly_endLoading];
        }
    } else {
        ///设置emptyView
        self.tableView.ly_emptyView = self.noDataView;
    }
    _pageIndex = 1;
    self.expire = NO;
    [self requestData];
}
- (void)reloadMoreData {
    if (self.pageIndex < self.MaxPage) {
        _pageIndex = _pageIndex + 1;
        [self requestData];
    } else { // 无数据
        if (!self.isExpired) { // 没过期
            self.pageIndex = 1;
            self.expire = YES;
            [self requestData];
        } else { // 没过期
            // 已经全部加载完毕
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }
}

- (void)requestData {
    
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"page"] = @(_pageIndex);
    paras[@"user_id"] = User_ID;
    if ([self.isself isEqualToString:@"1"]) {
         paras[@"self"] = @(1);
    }else if ([self.isself isEqualToString:@"0"]){
          paras[@"self"] = @(0);
    }
    paras[@"area"] = self.areaModel.areaID;
    paras[@"sex"] = self.sex;
    if (self.isExpired) {
        paras[@"expire"] = @(1);
    }
    // 公钥加密
    NSString *encryWithPublicKeyStr = [RSAUtil encryptString:[NSString stringWithFormat:@"%@",User_ID] publicKey:kRSA_Public_key];
    [FKL_DataService requestURL:[NSString url_getNewSavemeList] parameters:paras headerKey:@"sign" headerValue:encryWithPublicKeyStr withType:@"GET" format:@"JSON" complete:^(id result) {
        
        if ([result[@"code"] integerValue] == 200) {
            // 拿到当前的下拉刷新控件，结束刷新状态
            [self.tableView.mj_header endRefreshing];
            // 拿到当前的上拉刷新控件，结束刷新状态
            [self.tableView.mj_footer endRefreshing];
            self.MaxPage = [result[@"data"][@"_meta"][@"pageCount"] integerValue];
            
            if (self.pageIndex == 1 && !self.isExpired) {
                self.dataArray = [NSMutableArray array];
            }
            NSArray *records = [XDSaveMeModel objectArrayWithKeyValuesArray:result[@"data"][@"items"]];
            [self.dataArray addObjectsFromArray:records];
            
            [self.tableView reloadData];
            //调用时机
            [self.tableView ly_endLoading];
        } else {
            // 拿到当前的下拉刷新控件，结束刷新状态
            [self.tableView.mj_header endRefreshing];
            // 拿到当前的上拉刷新控件，结束刷新状态
            [self.tableView.mj_footer endRefreshing];
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

#pragma mark - XDPayCoinViewDelegate
- (void)entryPay {
    [self showHudInView:self.view hint:nil];
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"info_id"] = @(self.selectModel.info_id);
    // 公钥加密
    NSString *encryWithPublicKeyStr = [RSAUtil encryptString:[NSString stringWithFormat:@"%@",User_ID] publicKey:kRSA_Public_key];
    [FKL_DataService requestURL:[NSString url_signUpNewSaveme] parameters:paras headerKey:@"sign" headerValue:encryWithPublicKeyStr withType:@"POST" format:@"JSON" complete:^(id result) {
        [self hideHud];
        if ([result[@"code"] integerValue] == 200) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:result[@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        } else {
            [self.view makeToast:result[@"message"] duration:2.0 position:CSToastPositionCenter];
        }
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideHud];
        [self.view makeToast:error.localizedDescription duration:2.0 position:CSToastPositionCenter];
    }];
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 创建cell
    XDSaveMeItemCell *cell = [XDSaveMeItemCell cellWithTableView:tableView];
    cell.model = self.dataArray[indexPath.row];
    XD_WeakSelf
    cell.signUpBtnClicked = ^(XDSaveMeModel *model) {
        XD_StrongSelf
        [self signUpBtnClickedWithModel:model];
    };
    cell.viewBtnClicked = ^(XDSaveMeModel *model) {
        XD_StrongSelf
        [self viewBtnClickedWithModel:model];
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewAutomaticDimension;
}

#pragma mark - 报名与查看报名点击
- (void)signUpBtnClickedWithModel:(XDSaveMeModel *)model {
    if (model.is_self != 0) { // 结束报名
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"是否结束报名？" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self showHudInView:self.view hint:nil];
            // 公钥加密
            NSString *encryWithPublicKeyStr = [RSAUtil encryptString:[NSString stringWithFormat:@"%@",User_ID] publicKey:kRSA_Public_key];
            [FKL_DataService requestURL:[NSString url_EndNewSaveme_withSavemeID:[NSString stringWithFormat:@"%ld",model.info_id]] parameters:nil headerKey:@"sign" headerValue:encryWithPublicKeyStr withType:@"PATCH" format:@"JSON" complete:^(id result) {
                [self hideHud];
                if ([result[@"code"] integerValue] == 200) {
                    [self.dataArray removeObject:model];
                    [self.tableView reloadData];
                    [self.view makeToast:result[@"message"] duration:2.0 position:CSToastPositionCenter];
                } else {
                    [self.view makeToast:result[@"message"] duration:2.0 position:CSToastPositionCenter];
                }
            } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
                [self hideHud];
                [self.view makeToast:error.localizedDescription duration:2.0 position:CSToastPositionCenter];
            }];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:action];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    } else { // 报名
        
        self.selectModel = model;
        self.payView = [[XDPayCoinView alloc] initWithFrame:[[UIApplication sharedApplication].keyWindow bounds]];
        self.payView.delegate   = self;
        self.payView.price      = [NSString stringWithFormat:@"%ld",model.need_coin];
        self.payView.noticeType = SaveMeNotice;
        [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:self.payView];
        [self.payView startAnim];
    }
}

- (void)viewBtnClickedWithModel:(XDSaveMeModel *)model {
    if (model.is_self != 0) {
        XDCheckSignUpController *checkVC = [[XDCheckSignUpController alloc] init];
        checkVC.info_id = [NSString stringWithFormat:@"%ld",model.info_id];
        [self.navigationController pushViewController:checkVC animated:YES];
    } else {
        [self.view makeToast:@"只有发布者才可查看" duration:2.0 position:CSToastPositionCenter];
    }
}

@end
