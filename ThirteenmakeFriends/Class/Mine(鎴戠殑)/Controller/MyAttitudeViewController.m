//
//  MyAttitudeViewController.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 15/12/30.
//  Copyright © 2015年 ThirtyOneDay. All rights reserved.
//

#import "MyAttitudeViewController.h"
#import "AttitudeCell.h"
#import "AttitudeAndFansFrame.h"
#import "ShiSanUser.h"
#import "MJExtension.h"
#import "ProfileUser.h"
#import "MJRefresh.h"

@interface MyAttitudeViewController ()<UITableViewDataSource,UITableViewDelegate,AttitudeCellDelegate,XDErrorViewDelegate>
{
    XDErrorView *_errorView;
}

@property (nonatomic,weak) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *attitudeArray;

/** 分页页码 */
@property (nonatomic, assign) NSInteger pageIndex;
/** 分页最大页码 */
@property (nonatomic, assign) NSInteger MaxPage;

@end

@implementation MyAttitudeViewController

- (NSMutableArray *)attitudeArray {
    if (_attitudeArray == nil) {
        _attitudeArray = [NSMutableArray array];
    }
    return _attitudeArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"title.myAttention", @"My Attention");
    self.view.backgroundColor = GlobalBGColor;
    
    [self xdd_setupTableView];
    
    [self setupErrorView];
    
    [self xdd_setupRefreshControl];
    
    [self setupTableFootview];
}

- (void)setupTableFootview {
    if (iPhoneX) { // MJRefresh 适配
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kSafeBottomHeight)];
        
        [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, -kSafeBottomHeight, 0)];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self setupData];
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
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
//    [self.tableView.mj_header beginRefreshing];
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(reloadMoreData)];
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
        
        if (self.attitudeArray.count == 0) {
            // 添加自定义错误(断网)提示
            _errorView = [_errorView addErrorViewWithType:error_nonet_flag];
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

/**
 *  创建tableView
 */
- (void)xdd_setupTableView
{
    UITableView *tableView = [[UITableView alloc] init];
    tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationBar_Height);
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = GlobalBGColor;
    
    // 这句话可以使cell有多少行显示多少条分割线
    tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

#pragma mark - 错误视图
-(void)setupErrorView{
    _errorView = [XDErrorView errorViewWithSuperView:self.view Frame:self.view.bounds];
    _errorView.delegate = self;
}

- (void)requestData {
    
//    [self showHudInView:self.view hint:@"正在加载中..."];
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"get_type"] = @"1";
    paras[@"page"] = @(_pageIndex);

    [FKL_DataService requestURL:[NSString url_getAttentionAndFans] parameters:paras withType:@"GET" format:@"JSON" complete:^(id result) {
        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
//        [self hideHud];
        if ([result[@"code"] integerValue] == 200) {
            if (_pageIndex == 1) {
                self.attitudeArray = [NSMutableArray array];
            }
            
            NSArray *followArray = [ShiSanUser objectArrayWithKeyValuesArray:result[@"data"][@"items"]];
            self.MaxPage = [result[@"data"][@"_meta"][@"pageCount"] integerValue];
            
            if (followArray.count == 0) {
                _errorView = [_errorView addErrorViewWithType:error_nodata_flag];
                return ;
            }
            
            for (ShiSanUser *user in followArray) {
                
                AttitudeAndFansFrame *attitudeFrame = [[AttitudeAndFansFrame alloc]init];
                // 传递微博模型数据
                attitudeFrame.user = user;
                
                [self.attitudeArray addObject:attitudeFrame];
            }
            
            _errorView = [_errorView removeErrorView];
            
            [self.tableView reloadData];
        } else {
            [self.view makeToast:result[@"message"] duration:2.0 position:CSToastPositionCenter];
        }
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
//        [self hideHud];
        [self.view makeToast:error.localizedDescription duration:2.0 position:CSToastPositionCenter];
    }];
    
}

#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.attitudeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"InfoCell";
    AttitudeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(cell == nil)
    {
        cell = [[AttitudeCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        cell.delegate = self;
    }
    
    cell.attitudeFrame = self.attitudeArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    AttitudeAndFansFrame *attitudeF = self.attitudeArray[indexPath.row];
    
    return attitudeF.cellHeight;
}

#pragma mark - 取消关注
- (void)attitudeCell:(AttitudeCell *)attitudeCell ClickedBtnWithAttitudeAndFansFrame:(AttitudeAndFansFrame *)attitudeFrame {
    
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"user_id"] = attitudeFrame.user.user_id;
    
    [self showHudInView:self.view hint:@"取消关注中..."];
    [XDRequestHttpTool request_ismyfollowsInfo_withUserID:User_ID Parameters:paras complete:^(id result) {
        NSLog(@"%@",result);
        
        if ([result[@"code"] integerValue] == 200) {
            ProfileUser *user = [[ProfileUser alloc] init];
            user.following_count = [NSString stringWithFormat:@"%d",[user.following_count intValue] - 1];
            [self.attitudeArray removeObject:attitudeFrame];
            [self.tableView reloadData];
        } else if ([result[@"code"] integerValue] == 202) {
            
        } else {
            [self.view makeToast:result[@"message"] duration:2.0 position:CSToastPositionCenter];
        }

        [self hideHud];
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
        [self hideHud];
        [self.view makeToast:error.localizedDescription duration:2.0 position:CSToastPositionCenter];
    }];
}

#pragma mark - XDErrorView
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

@end
