//
//  XDAnnouncementController.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/7/25.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDAnnouncementController.h"
#import "MJExtension.h"
#import "XDAnnounceFrameModel.h"
#import "XDAnnounceCell.h"
#import "PushModel.h"
#import "XDLocalHtmlViewController.h"
//#import "SystemNoticeController.h"
#import "MJRefresh.h"

#import "XDAccountTool.h"
#import "ProfileUser.h"

@interface XDAnnouncementController ()<UITableViewDelegate,UITableViewDataSource,XDErrorViewDelegate>
{
    XDErrorView *_errorView;
}

@property (nonatomic ,weak) UITableView *tableView;

@property (nonatomic ,strong) NSMutableArray *noticeFrameArray;

@property (nonatomic, retain) NSMutableArray *removeList;//勾选时要删除的数据

/** 编辑按钮 */
@property (nonatomic ,weak) UIButton *editButton;

//! 页码
@property (nonatomic, assign) NSInteger pageIndex;
//! 最大页码
@property (nonatomic, assign) NSNumber *MaxPage;

@end

@implementation XDAnnouncementController

- (NSMutableArray *)noticeFrameArray {
    if (_noticeFrameArray == nil) {
        _noticeFrameArray = [NSMutableArray array];
    }
    return _noticeFrameArray;
}

- (NSMutableArray *)removeList {
    if (_removeList == nil) {
        _removeList = [NSMutableArray array];
    }
    return _removeList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"系统公告";
    // 创建tableView
    [self xdd_setupTableView];
    
    
    [self setupErrorView];
    
    // 集成刷新控件
    [self xdd_setupRefreshControl];
    
    [self setupTableFootview];
}

- (void)setupTableFootview {
    if (iPhoneX) { // MJRefresh 适配
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kSafeBottomHeight)];
        
        [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, -kSafeBottomHeight, 0)];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 更新未读消息数量
    [[NSNotificationCenter defaultCenter] postNotificationName:@"unreadOtherMessageCount" object:nil];
}

/**
 *  创建tableView
 */
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

- (void)reloadNewData {
    // 判断网络状况
    if (!isNetworking) {
        // 添加自定义错误(断网)提示
        _errorView = [_errorView addErrorViewWithType:error_nonet_flag];
        return;
    }
    
    _pageIndex = 1;
    [self getMessageData];
}

- (void)reloadMoreData {
    if (_pageIndex < [_MaxPage integerValue]) {
        _pageIndex = _pageIndex + 1;
        
        [self getMessageData];
    } else {
        // 已经全部加载完毕
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}

#pragma mark -TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.noticeFrameArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 创建cell
    XDAnnounceCell *cell = [XDAnnounceCell cellWithTableView:tableView];
    
    // 传递Frame模型
    cell.noticeFrame = self.noticeFrameArray[indexPath.row];
    
    return cell;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    XDAnnounceFrameModel *noticeF = self.noticeFrameArray[indexPath.row];
    return noticeF.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //得到菜单栏
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController.isMenuVisible) { // 设置菜单栏不可见
        [menuController setMenuVisible:NO animated:YES];
    }
    
    XDAnnounceFrameModel *notFrame = self.noticeFrameArray[indexPath.row];
    PushModel *pushContent = notFrame.notice;
    
    // 进入相应类型界面
    if ([pushContent.push_type isEqualToString:PUSH_AD_WEB]) {
        // 1. 点击之后进入网页
        XDLocalHtmlViewController *htmlVC = [XDLocalHtmlViewController localHtmlViewControllerWithHtmlTitle:pushContent.push_webTitle HtmlString:pushContent.push_webUrl];
        [self.navigationController pushViewController:htmlVC animated:YES];
    }
    else if ([pushContent.push_type isEqualToString:PUSH_NOTICE]) {
        // 4. 系统通知
//        SystemNoticeController *systemNoticeVC = [[SystemNoticeController alloc]init];
//        systemNoticeVC.title = pushContent.push_title;
//        systemNoticeVC.pushcontent = pushContent.push_content;
//        
//        [self.navigationController pushViewController:systemNoticeVC animated:YES];
    }
    
    if (pushContent.is_read == 0) { //未读
        [self readToUnreadMessage:pushContent.push_id IndexPath:indexPath];
    }
}

#pragma mark - 获取消息数据

/**
 *  获得消息数据
 */
- (void)getMessageData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"] = @(_pageIndex);
    
    [FKL_DataService requestURL:[NSString url_getSystemAnnouncement] parameters:params withType:@"GET" format:@"JSON" complete:^(id result) {
        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.tableView.mj_header endRefreshing];
        // 拿到当前的上拉刷新控件，结束刷新状态
        [self.tableView.mj_footer endRefreshing];
        
        if ([result[@"code"] integerValue] == 200) {
            NSArray *messageArray = [PushModel objectArrayWithKeyValuesArray:result[@"data"][@"notices"]];
            
            if (messageArray.count == 0) {
                // 无数据
                _errorView = [_errorView addErrorViewWithType:error_nodata_flag];
                return ;
            }
            
            _MaxPage = result[@"data"][@"_meta"][@"pageCount"];
            if (_pageIndex == 1) {
                self.noticeFrameArray = [NSMutableArray array];
            }
            
            for (PushModel *new in messageArray) {
                
                XDAnnounceFrameModel *noticeF = [[XDAnnounceFrameModel alloc]init];
                noticeF.notice = new;
                [self.noticeFrameArray addObject:noticeF];
            }
            
            // 移除ErrorView
            _errorView = [_errorView removeErrorView];
            
            [self.tableView reloadData];

        } else {
            [self.view makeToast:result[@"message"] duration:2.0 position:CSToastPositionCenter];
        }
        
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.tableView.mj_header endRefreshing];
        // 拿到当前的上拉刷新控件，结束刷新状态
        [self.tableView.mj_footer endRefreshing];
        [self.view makeToast:error.localizedDescription duration:2.0 position:CSToastPositionCenter];
    }];
}

#pragma mark - 处理未读消息
- (void)readToUnreadMessage:(NSUInteger)push_id IndexPath:(NSIndexPath *)indexPath{
    
    [FKL_DataService requestURL:[NSString url_changeSystemAnnouncement_withPush_id:[NSString stringWithFormat:@"%ld",push_id]] parameters:nil withType:@"GET" format:@"JSON" complete:^(id result) {
        if ([result[@"code"] integerValue] == 200) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"unreadOtherMessageCount" object:nil];
            XDAnnounceFrameModel *noticeF = self.noticeFrameArray[indexPath.row];
            noticeF.notice.is_read = 1;
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        } else {
            [self.view makeToast:result[@"message"] duration:2.0 position:CSToastPositionCenter];
        }
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        [self.view makeToast:error.localizedDescription duration:2.0 position:CSToastPositionCenter];
    }];
}

#pragma mark - XDErrorView
-(void)setupErrorView{
    _errorView = [XDErrorView errorViewWithSuperView:self.view Frame:self.view.bounds];
    _errorView.delegate = self;
}

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
