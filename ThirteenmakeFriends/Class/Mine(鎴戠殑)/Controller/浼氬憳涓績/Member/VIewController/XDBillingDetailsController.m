//
//  XDBillingDetailsController.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/8/28.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDBillingDetailsController.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "XDXDBillingCell.h"
#import "XDBillingModel.h"
#import "XDBillingDiaModel.h"

@interface XDBillingDetailsController ()<UITableViewDataSource,UITableViewDelegate,XDErrorViewDelegate>

{
    XDErrorView *_errorView;
}

@property (nonatomic, strong) UITableView *tableView;

//! 分页页码
@property (nonatomic, assign) NSInteger pageIndex;
//! 分页最大页码
@property (nonatomic, assign) NSInteger MaxPage;

@property (nonatomic, strong) NSMutableArray *itemsArr;

@end

@implementation XDBillingDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.title = @"明细";
    [self setupErrorView];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationBar_Height) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.rowHeight = 65;
    [self.view addSubview:self.tableView];
    
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

#pragma mark  下拉刷新
- (void)reloadNewData {
    
    _pageIndex = 1;
    [self requestData];
    
}
#pragma mark 加载更多数据
- (void)reloadMoreData {
    
    if (_pageIndex < _MaxPage) {
        _pageIndex = _pageIndex + 1;
        
        [self requestData];
        
    } else {
        // 已经全部加载完毕
        [_tableView.mj_footer endRefreshingWithNoMoreData];
    }
    
    
}




- (void)requestData {
    
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"page"] = @(_pageIndex);
    // 公钥加密
    NSString *encryWithPublicKeyStr = [RSAUtil encryptString:[NSString stringWithFormat:@"%@",User_ID] publicKey:kRSA_Public_key];
    NSString *url = self.tag == 1?[NSString url_getTopupRecord_withUserId:User_ID]:[NSString stringWithFormat:@"%@/200",[NSString url_getDiamondsRechargesDetails]];
    [FKL_DataService requestURL:url parameters:paras headerKey:@"sign" headerValue:encryWithPublicKeyStr withType:@"GET" format:@"JSON" complete:^(id result) {
        
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        
        if ([result[@"code"] integerValue] == 200) {
          
            if (_pageIndex == 1) {
                _itemsArr = [NSMutableArray array];
            }
            
            NSArray *records = nil;
            if (self.tag == 1) {
              _MaxPage = [result[@"data"][@"_meta"][@"pageCount"] integerValue];
              records = [XDBillingModel objectArrayWithKeyValuesArray:result[@"data"][@"items"]];
            }else{
              _MaxPage = [result[@"_meta"][@"pageCount"] integerValue];
              records = [XDBillingDiaModel objectArrayWithKeyValuesArray:result[@"data"]];
            }
            
            if (self.itemsArr.count == 0 && records.count == 0) {
                // 无数据
                _errorView = [_errorView addErrorViewWithType:error_nodata_flag];
                return ;
            }
            
            [self.itemsArr addObjectsFromArray:records];
            // 移除ErrorView
            _errorView = [_errorView removeErrorView];
            
            if (self.MaxPage == 1) {
                // 已经全部加载完毕
                [_tableView.mj_footer endRefreshingWithNoMoreData];
            }
            
            [_tableView reloadData];
            
        } else {
            // 无数据
            _errorView = [_errorView addErrorViewWithType:error_nodata_flag];
            [self.view makeToast:result[@"message"] duration:2.0 position:CSToastPositionCenter];
        }
        
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        NSLog(@"%@",error);
        
        [self.view makeToast:error.localizedDescription duration:2.0 position:CSToastPositionCenter];
    }];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _itemsArr.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XDXDBillingCell *cell = [XDXDBillingCell cellWithTableView:tableView];
    if (self.tag == 1) {
         cell.billingModel = [_itemsArr objectAtIndex:indexPath.row];
    }else{
         cell.billingDiaModel = [_itemsArr objectAtIndex:indexPath.row];
    }
    
    return cell;
    
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

@end
