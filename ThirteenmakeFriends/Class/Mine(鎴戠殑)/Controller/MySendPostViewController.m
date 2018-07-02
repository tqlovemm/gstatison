//
//  MySendPostViewController.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 15/12/30.
//  Copyright © 2015年 ThirtyOneDay. All rights reserved.
//  我的发帖

#import "MySendPostViewController.h"
#import "MJExtension.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
//#import "XDPostDetailController.h"
//#import "XDPostsCell.h"
//#import "XDPostModel.h"
//#import "XDPostFrameModel.h"
//#import "XDThreadReportController.h"
#import "XDAccountTool.h"
#import "ProfileUser.h"
#import "XDPhotoBrowser.h"

@interface MySendPostViewController ()<UITableViewDelegate,UITableViewDataSource,XDErrorViewDelegate,UIActionSheetDelegate>
{
    XDErrorView *_errorView;
}

@property (nonatomic ,strong) NSMutableArray *threadsArray;

@property (nonatomic ,weak) UITableView *tableView;

//! 分页页码
@property (nonatomic, assign) NSInteger pageIndex;
//! 分页最大页码
@property (nonatomic, assign) NSInteger MaxPage;

@property (nonatomic ,weak) NSIndexPath *selectIndexPath;

@end

@implementation MySendPostViewController

- (NSMutableArray *)threadsArray {
    if (_threadsArray == nil) {
        _threadsArray = [NSMutableArray array];
    }
    return _threadsArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"title.myPost", @"I'm Posting");
    self.view.backgroundColor = GlobalBGColor;
    
    [self xdd_setupTableView];
    
    [self setupErrorView];
    // 集成刷新控件
    [self xdd_setupRefreshControl];
    
    [self setupTableFootview];
    
    [self addObservers];
}

- (void)setupTableFootview {
    if (iPhoneX) { // MJRefresh 适配
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kSafeBottomHeight)];
        
        [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, -kSafeBottomHeight, 0)];
    }
}

#pragma mark - 错误视图
-(void)setupErrorView{
    _errorView = [XDErrorView errorViewWithSuperView:self.view Frame:self.view.bounds];
    _errorView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
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
    [self.tableView.mj_header beginRefreshing];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(reloadMoreData)];
}

- (void)addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postCommented:) name:XDPostCommentNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postLiked:) name:XDPostLikeNotification object:nil];
}

//- (void)postCommented:(NSNotification *)notification
//{
//    XDPostModel *object = (XDPostModel *)notification.object;
//
//    [self.threadsArray enumerateObjectsUsingBlock:^(XDPostFrameModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if ([obj.model.wid integerValue] == [object.wid integerValue]) {
//            obj.model = object;
//            [self.tableView beginUpdates];
//            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:idx inSection:0],nil] withRowAnimation:UITableViewRowAnimationNone];
//            [self.tableView endUpdates];
//            *stop = YES;
//        }
//    }];
//}
//
//- (void)postLiked:(NSNotification *)notification {
//    XDPostModel *object = (XDPostModel *)notification.object;
//
//    [self.threadsArray enumerateObjectsUsingBlock:^(XDPostFrameModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if ([obj.model.wid integerValue] == [object.wid integerValue]) {
//            obj.model = object;
//            [self.tableView beginUpdates];
//            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:idx inSection:0],nil] withRowAnimation:UITableViewRowAnimationNone];
//            [self.tableView endUpdates];
//            *stop = YES;
//        }
//    }];
//}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    paras[@"people"] = self.user_id;
    paras[@"user_id"] = User_ID;
    paras[@"access-token"] = [GeTuiSdk clientId];
    
    [FKL_DataService requestURL:[NSString url_getPersonThreadsList] parameters:paras withType:@"GET" format:@"JSON" complete:^(id result) {
        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.tableView.mj_header endRefreshing];
        // 拿到当前的上拉刷新控件，结束刷新状态
        [self.tableView.mj_footer endRefreshing];
        
        if ([result[@"code"] integerValue] == 200) {
            self.MaxPage = [result[@"_meta"][@"pageCount"] integerValue];
            if (_pageIndex == 1) {
                self.threadsArray = [NSMutableArray array];
            }
            
//            NSArray *records = [XDPostModel objectArrayWithKeyValuesArray:result[@"data"]];
            
//            if (self.threadsArray.count == 0 && records.count == 0) {
//                // 无数据
//                _errorView = [_errorView addErrorViewWithType:error_nodata_flag];
//                return ;
//            }
            
//            for (XDPostModel *thread in records) {
//                XDPostFrameModel *threadFrame = [[XDPostFrameModel alloc] init];
//                threadFrame.model = thread;
//                [self.threadsArray addObject:threadFrame];
//            }
            
            // 移除ErrorView
            _errorView = [_errorView removeErrorView];
            
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

/**
 *  创建tableView
 */
- (void)xdd_setupTableView {
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT - NavigationBar_Height) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.backgroundColor = RGB(226, 226, 226);
    [self.view addSubview:tableView];
    self.tableView = tableView;
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

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    // 创建cell
//    XDPostsCell *cell = [XDPostsCell cellWithTableView:tableView];
//    cell.indexPath = indexPath;
//    XD_WeakSelf
//
//    if (!cell.moreButtonClickedBlock) {
//        [cell setMoreButtonClickedBlock:^(NSIndexPath *indexPath) {
//            XD_StrongSelf
//            XDPostFrameModel *modelFrame = self.threadsArray[indexPath.row];
//            modelFrame.model.isOpening = !modelFrame.model.isOpening;
//            modelFrame.model = modelFrame.model;
//            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//        }];
//    }
//    cell.commentButtonClickedBlock = ^(){
//        XD_StrongSelf
//        self.selectIndexPath = indexPath;

//        [_bottomView.inputTextView becomeFirstResponder];
//        _bottomView.inputTextView.placehoder = @"评论";
//        
//        [self adjustTableViewToFitKeyboard];
        
//        [self tableView:tableView didSelectRowAtIndexPath:indexPath];
//    };
//
//    cell.praiseButtonClickedBlock = ^(){
//        XD_StrongSelf
//        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//    };
//
//    cell.otherButtonClickedBlock = ^(NSIndexPath *indexPath) {
//        XD_StrongSelf
//        self.selectIndexPath = indexPath;
//        if ([cell.postFrameModel.model.user_id integerValue] != [User_ID integerValue]) {
//            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"举报", nil];
//            [sheet showInView:self.view];
//            sheet.tag = 1;
//        } else {
//            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"删除", nil];
//            sheet.tag = 2;
//            [sheet showInView:self.view];
//        }
//    };
//
//    [cell setAttentionVIewisHiddden:YES];
//    cell.postFrameModel = self.threadsArray[indexPath.row];
//
//    return cell;
//    
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if ([_bottomView.inputTextView isFirstResponder]) {
//        [_bottomView.inputTextView resignFirstResponder];
//        _bottomView.inputTextView.placehoder = nil;
//        
//        return ;
//    }
    
//    XDPostFrameModel *modelFrame = self.threadsArray[indexPath.row];
//    XDPostDetailController *threadDetailVC = [[XDPostDetailController alloc] init];
//    XD_WeakSelf
//    threadDetailVC.deleteButtonClicked = ^{
//        XD_StrongSelf
//        [self.threadsArray removeObject:modelFrame];
//        //删除某一行
//        [self.tableView reloadData];
//    };
//
//    threadDetailVC.thread_id = modelFrame.model.wid;
//    [self.navigationController pushViewController:threadDetailVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // >>>>>>>>>>>>>>>>>>>>> * cell自适应 * >>>>>>>>>>>>>>>>>>>>>>>>
    
//    XDPostFrameModel *modelFrame = self.threadsArray[indexPath.row];
//    return modelFrame.cellHeight;
    return 0.f;
}

//- (void)didClickcCommentButtonInCell:(XDThreadCell *)cell {
//    XDThreadDetailController *threadVC = [[XDThreadDetailController alloc] init];
//    threadVC.thread_id = cell.modelFrame.model.wid;
//    [self.navigationController pushViewController:threadVC animated:YES];
//}

//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
//    if ([actionSheet cancelButtonIndex] != buttonIndex) {
//        if (actionSheet.tag == 1) {
//            XDThreadReportController *reportVC = [[XDThreadReportController alloc] init];
//
//            XDPostFrameModel *modelFrame = self.threadsArray[self.selectIndexPath.row];
//            reportVC.thread_id = modelFrame.model.wid;
//            reportVC.user_id = User_ID;
//
//            [self.navigationController pushViewController:reportVC animated:YES];
//        } else if (actionSheet.tag == 2) {
//            NSLog(@"删除帖子");
            
//            XDPostFrameModel *modelFrame = self.threadsArray[self.selectIndexPath.row];
//            [XDRequestHttpTool request_deleteOneThread_withThread_id:modelFrame.model.wid Parameters:nil complete:^(id result) {
//
//                if ([result[@"code"] intValue] == 200) { // 删除成功
//                    [self.threadsArray removeObject:modelFrame];
//                    //删除某一行
//                    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:self.selectIndexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
//                } else { // 删除失败
//                    [self showHint:@"删除失败"];
//                }
//            } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
//                [self.view makeToast:error.localizedDescription duration:2.0 position:CSToastPositionCenter];
//            }];
//        }
//    }
//}

#pragma mark - UIResponder actions
//- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo
//{
//    if ([eventName isEqualToString:kRouterEventHeadIconViewTapEventName]) {
//        XDPostModel *model = [userInfo objectForKey:XDPostCellModelKey];
//        UIImageView *fromView = [userInfo objectForKey:XDPostCellModelViewKey];
//        [self headIconPressed:model.avatar fromView:fromView];
//    }
//}

- (void)headIconPressed:(NSString *)imgUrl fromView:(UIImageView *)imgView {
    [[XDPhotoBrowser defaultManager] showBrowserWithImages:@[imgUrl] andCurrentIndex:0 fromImageContainer:imgView];
}

@end
