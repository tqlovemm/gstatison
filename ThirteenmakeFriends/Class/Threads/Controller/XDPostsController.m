//
//  XDPostsController.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 17/3/23.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDPostsController.h"
#import "MJRefresh.h"
#import "XDPostsCell.h"
#import "XDPostModel.h"
#import "XDPostFrameModel.h"
#import "XDisCommentPostController.h"
#import "XDThreadReportController.h"
#import "PostFoundViewController.h"
//#import "XDCommentView.h"
#import "MBProgressHUD+MJ.h"
#import "XDAccountTool.h"
#import "ProfileUser.h"
#import "XDPostDetailController.h"
//#import "XDOtherViewController.h"

#import "XDPostsTopicView.h"
#import "XDNavigationController.h"
#import "RKNotificationHub.h"
#import "XDUnreadCount.h"
#import "IQKeyboardManager.h"

#import "HMSegmentedControl.h"
#import "XDPostHeaderView.h"

#import "XDPostTopModel.h"
#import "XDRefreshHeader.h"

#import "XDUMSharedView.h"
#import "XDNewReportViewController.h"
#import "XDPhotoModel.h"

#import "AppDelegate+ThirdLogin.h"

#import "XDRankListModel.h"
#import "CYPromptCoverView.h"

static CGFloat textFieldH = 44;

@interface XDPostsController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITableViewDataSource,UITableViewDelegate,XDErrorViewDelegate,XDUMSharedViewDelegate>
{
    XDErrorView *_errorView;
    CGFloat _totalKeybordHeight;
    
    RKNotificationHub *_dynamicHub;
}

@property (nonatomic ,strong) NSMutableArray *threadsArray;

@property (nonatomic ,weak) UITableView *tableView;

//! 分页页码
@property (nonatomic, assign) NSInteger pageIndex;
//! 分页最大页码
@property (nonatomic, assign) NSInteger MaxPage;

//! 评论框
//@property (nonatomic, strong) XDCommentView *bottomView;
//! 选择的indexpath
@property (nonatomic ,weak) NSIndexPath *selectIndexPath;

/** 筛选类型 */
@property (nonatomic, assign) NSInteger selectedNum;

@property (nonatomic, strong) HMSegmentedControl *segmentControl;


@property (nonatomic, strong) XDPostHeaderView *headerView;

@end

@implementation XDPostsController

- (NSMutableArray *)threadsArray {
    if (_threadsArray == nil) {
        _threadsArray = [NSMutableArray array];
    }
    return _threadsArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self xdd_setupTableView];
    [self setupErrorView];
//    [self setupCommentField];

    if (self.topic) {
        self.tableView.height = SCREEN_HEIGHT - NavigationBar_Height;
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    } else {
        self.tableView.height = SCREEN_HEIGHT - NavigationBar_Height - TabBar_Height;
        [self setupNavbar];
    }
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    // 放在 setupNavbar 方法后面 (设置_viewDrop默认选中值)
    [self xdd_setupRefreshControl];
    [self addObservers];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadUnreadMessageCount];
    [IQKeyboardManager sharedManager].enable = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [_bottomView.inputTextView resignFirstResponder];
//    _bottomView.inputTextView.placehoder = nil;
    [IQKeyboardManager sharedManager].enable = YES;
}

- (void)setupNavbar {

    //左边按钮
    UIButton *unreadMessageBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [unreadMessageBtn setBackgroundImage:[UIImage imageNamed:@"thread_message"] forState:UIControlStateNormal];
    [unreadMessageBtn addTarget:self action:@selector(goToThreadMessage) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *unreadMessageItem = [[UIBarButtonItem alloc] initWithCustomView:unreadMessageBtn];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -6;
    self.navigationItem.leftBarButtonItems = @[negativeSpacer, unreadMessageItem];
    
    UIButton *sendThreadBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [sendThreadBtn setImage:[UIImage imageNamed:@"thread_camera"] forState:UIControlStateNormal];
    [sendThreadBtn addTarget:self action:@selector(goToSendThreadController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:sendThreadBtn];
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, rightItem];
    [self sendThreadNewbieGuide];
    // 设置未读消息数
    _dynamicHub = [[RKNotificationHub alloc] initWithView:unreadMessageBtn];
    [_dynamicHub scaleCircleSizeBy:0.6];
    [_dynamicHub moveCircleByX:6 Y:-2];
    
    self.segmentControl = [[HMSegmentedControl alloc]init];
    self.segmentControl.sectionTitles = @[@"全部",@"女生",@"男生"];
    self.segmentControl.backgroundColor = [UIColor clearColor];
    self.segmentControl.frame                        = CGRectMake(0, 0, 180, Normal_Height);
    self.segmentControl.segmentEdgeInset             = UIEdgeInsetsMake(0, 0, 0, 0);
    self.segmentControl.selectionIndicatorEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    self.segmentControl.selectedSegmentIndex         = 0;
    self.segmentControl.selectionStyle               = HMSegmentedControlSelectionStyleTextWidthStripe;
    self.segmentControl.selectionIndicatorLocation   = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segmentControl.selectionIndicatorColor      = ThemeColor1;
    self.segmentControl.selectionIndicatorHeight     = 2;
    self.segmentControl.titleTextAttributes          = @{
                                                         NSFontAttributeName : kPingFangBoldFont(12),
                                                         NSForegroundColorAttributeName : RGB(205, 205, 205)
                                                         };
#if APP_Puppet  // Puppet
    self.segmentControl.selectedTitleTextAttributes  = @{
                                                         NSFontAttributeName : kPingFangBoldFont(14),
                                                         NSForegroundColorAttributeName : ThemeColor1
                                                         };
#elif APP_myPuppet
    self.segmentControl.selectedTitleTextAttributes  = @{
                                                         NSFontAttributeName : kPingFangBoldFont(14),
                                                         NSForegroundColorAttributeName : kNav_Text_color
                                                         };
#else // 正常
    self.segmentControl.selectedTitleTextAttributes  = @{
                                                         NSFontAttributeName : kPingFangBoldFont(14),
                                                         NSForegroundColorAttributeName : RGB(20, 19, 19)
                                                         };
#endif
    
    self.navigationItem.titleView = self.segmentControl;
    
    XD_WeakSelf
    [self.segmentControl setIndexChangeBlock:^(NSInteger index) {
        XD_StrongSelf
//        [self didSelectItem:index];
    }];
}


/**
 加号引导
 */
- (void)sendThreadNewbieGuide {
    
    if (!myAppDelegate.newVersion) {
        return;
    }
    
    CYPromptCoverView *cover0 = [[CYPromptCoverView alloc] initWithRevalView:nil layoutType:CYPromptCoverViewLayoutTypeLeftDown];
    cover0.revealType = CYPromptCoverViewRevealTypeOval;
    cover0.insetX = 8;
    cover0.insetY = 8;
    cover0.des = nil;
    cover0.revealFrame = CGRectMake(SCREEN_WIDTH - 50, kStatusBarHeight, 40, 40);
    cover0.detailDes = @"点击按钮发布第一条帖子哦";
    
    [cover0 showInView:self.tabBarController.view];
}

- (void)xdd_setupTableView {
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT - NavigationBar_Height - TabBar_Height) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = RGB(240, 239, 245);
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

/**
 *  创建评论框
 */
//- (void)setupCommentField {
//    _bottomView = [[XDCommentView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, textFieldH)];
//    _bottomView.inputTextView.placehoder = @"评论";
//    [_bottomView.sendBtn addTarget:self action:@selector(sendComments) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_bottomView];
//
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
//}

/**
 *  初始化--错误提示界面
 */
- (void)setupErrorView {
    _errorView = [XDErrorView errorViewWithSuperView:self.view Frame:self.view.bounds];
    _errorView.delegate = self;
}

- (void)addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postCommented:) name:XDPostCommentNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postLiked:) name:XDPostLikeNotification object:nil];
}

- (void)postCommented:(NSNotification *)notification
{
    XDPostModel *object = (XDPostModel *)notification.object;
    [self.threadsArray enumerateObjectsUsingBlock:^(XDPostFrameModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.model.wid integerValue] == [object.wid integerValue]) {
            obj.model = object;
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:idx inSection:0],nil] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
            *stop = YES;
        }
    }];
}

- (void)postLiked:(NSNotification *)notification {
    XDPostModel *object = (XDPostModel *)notification.object;
    
    [self.threadsArray enumerateObjectsUsingBlock:^(XDPostFrameModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.model.wid integerValue] == [object.wid integerValue]) {
            obj.model = object;
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:idx inSection:0],nil] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
            *stop = YES;
        }
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
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(reloadMoreData)];
}

#pragma mark - 获取数据
- (void)reloadNewData {
    if (![[AppUpdateInfo sharedInstance] isHavingNetworking]) {
        // 获取缓存数据
//        [self getCacheDatas];
        
        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.tableView.mj_header endRefreshing];
        
        if (self.threadsArray.count == 0) {
            // 添加自定义错误(断网)提示
            _errorView = [_errorView addErrorViewWithType:error_nonet_flag];
        }
        return;
    }
    _pageIndex = 1;
    [self requestData];
    
    if (!self.topic) {
        [self requestHeaderData];
        [self requestHeaderDataRankWeekRX];
      
    }
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
- (void)requestHeaderData {
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"type"] = @"1"; // 帖子头部接口
    [FKL_DataService requestURL:[NSString url_getdynamicrecommend] parameters:paras withType:@"GET" format:@"JSON" complete:^(id result) {
        if ([result[@"code"] integerValue] == 200) {
            NSArray *bannersArray = [XDPostTopModel objectArrayWithKeyValuesArray:result[@"data"][@"banner"]];
            NSArray *tdstarsArray = [XDRecommendPersonModel objectArrayWithKeyValuesArray:result[@"data"][@"tdstar"]];
            NSArray *activitiesArray = [XDAcitivityModel objectArrayWithKeyValuesArray:result[@"data"][@"tag"]];
            if (!self.headerView) {
                self.headerView = [[XDPostHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 290)];
            }
            [self.headerView setBanners:bannersArray tdstars:tdstarsArray activitise:activitiesArray];
            self.tableView.tableHeaderView = self.headerView;
        } else {
            [self.view makeToast:result[@"code"] duration:2.0 position:CSToastPositionCenter];
        }
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        [self.view makeToast:error.localizedDescription duration:2.0 position:CSToastPositionCenter];
    }];
}
- (void)requestData {
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"page"] = @(_pageIndex);
    paras[@"user_id"] = User_ID;
    
    if (self.topic) {
        paras[@"tag"] = self.topic;
    } else {
        if (self.selectedNum == 0) {
            paras[@"sex"] = @(3);
        } else if (self.selectedNum == 1) {
            paras[@"sex"] = @(1);
        } else if (self.selectedNum == 2) {
            paras[@"sex"] = @(0);
        } else if (self.selectedNum == 3) {
            paras[@"sort"] = @(1);
        } else if (self.selectedNum == 4) {
            paras[@"follow"] = @(1);
        }
    }
    [XDRequestHttpTool request_getAllThreadsInfo_withParameters:paras complete:^(id result) {
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
#if APP_Puppet  // Puppet
            if ([thread.user_id integerValue] == 35112 || [thread.user_id integerValue] == 30585) {
                continue;
            }
#elif APP_myPuppet
            if ([thread.user_id integerValue] == 35112 || [thread.user_id integerValue] == 30585) {
                continue;
            }
#else // 正常

#endif
            XDPostFrameModel *threadFrame = [[XDPostFrameModel alloc] init];
            threadFrame.model = thread;
            [self.threadsArray addObject:threadFrame];
        }
        // 移除ErrorView
        _errorView = [_errorView removeErrorView];
        
        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.tableView.mj_header endRefreshing];
        // 拿到当前的上拉刷新控件，结束刷新状态
        [self.tableView.mj_footer endRefreshing];
        
        [self.tableView reloadData];

        
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        [self.view makeToast:error.localizedDescription duration:2.0 position:CSToastPositionCenter];
        
        _errorView = [_errorView addErrorViewWithType:error_getfail_flag];
//        if (_pageIndex == 1) {
//            [self getCacheDatas];
//        }
        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.tableView.mj_header endRefreshing];
        // 拿到当前的上拉刷新控件，结束刷新状态
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.threadsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 创建cell
    XDPostsCell *cell = [XDPostsCell cellWithTableView:tableView];
    cell.indexPath = indexPath;
    XD_WeakSelf

    if (!cell.moreButtonClickedBlock) { // 是否展开
        [cell setMoreButtonClickedBlock:^(NSIndexPath *indexPath) {
            XD_StrongSelf
            XDPostFrameModel *modelFrame = self.threadsArray[indexPath.row];
            modelFrame.model.isOpening   = !modelFrame.model.isOpening;
            modelFrame.model             = modelFrame.model;
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
    }
    cell.attentionViewClickedBlock = ^(UIImageView *attentionView){
        XD_StrongSelf
        attentionView.userInteractionEnabled = NO;
        XDPostFrameModel *modelFrame = self.threadsArray[indexPath.row];
        NSMutableDictionary *paras = [NSMutableDictionary dictionary];
        paras[@"user_id"] = modelFrame.model.user_id;

        [XDRequestHttpTool request_ismyfollowsInfo_withUserID:User_ID Parameters:paras complete:^(id result) {
            if ([result[@"code"] integerValue] == 202) {
                for (XDPostFrameModel *postFModel in self.threadsArray) {
                    if ([postFModel.model.user_id integerValue] == [modelFrame.model.user_id integerValue]) {
                        postFModel.model.follow = YES;
                    }
                }
                [MBProgressHUD showSuccess:@"关注成功" toView:nil];
                [self.tableView reloadData];
            } else if ([result[@"code"] integerValue] == 200) {
                [MBProgressHUD showSuccess:@"取消关注成功" toView:nil];
                for (XDPostFrameModel *postFModel in self.threadsArray) {
                    if ([postFModel.model.user_id integerValue] == [modelFrame.model.user_id integerValue]) {
                        postFModel.model.follow = NO;
                    }
                }
                [self.tableView reloadData];
            } else {
                [self.view makeToast:result[@"message"] duration:2.0 position:CSToastPositionCenter];
            }
            attentionView.userInteractionEnabled = YES;
        } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"%@",error);
            [self.view makeToast:error.localizedDescription duration:2.0 position:CSToastPositionCenter];
            attentionView.userInteractionEnabled = YES;
        }];
    };
    cell.commentButtonClickedBlock = ^(){
        XD_StrongSelf
        self.selectIndexPath = indexPath;

//        [self.bottomView.inputTextView becomeFirstResponder];
//        self.bottomView.inputTextView.placehoder = @"评论";

        [self adjustTableViewToFitKeyboard];
    };
    cell.praiseButtonClickedBlock = ^(){
        XD_StrongSelf
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    };

    cell.otherButtonClickedBlock = ^(NSIndexPath *indexPath) {
        XD_StrongSelf
        self.selectIndexPath = indexPath;
        UIAlertController *alertController=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelAC=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *sureAC1=[UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5/*延迟执行时间*/ * NSEC_PER_SEC));
            
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                XDUMSharedView *view = [[XDUMSharedView alloc] init];
                view.delegate = self;
                [view show];
            });
        }];
        UIAlertAction *sureAC2 = nil;
        if ([cell.postFrameModel.model.user_id integerValue] != [User_ID integerValue]) {
           
           sureAC2=[UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//                XDThreadReportController *reportVC = [[XDThreadReportController alloc] init];
//                XDPostFrameModel *modelFrame = self.threadsArray[self.selectIndexPath.row];
//                reportVC.thread_id = modelFrame.model.wid;
//                reportVC.user_id = User_ID;
//                [self.navigationController pushViewController:reportVC animated:YES];
                XDNewReportViewController *reportVC = [XDNewReportViewController new];
                XDPostFrameModel *modelFrame = self.threadsArray[self.selectIndexPath.row];
                reportVC.thread_id = modelFrame.model.wid;
                reportVC.user_id = User_ID;
                [self.navigationController pushViewController:reportVC animated:YES];
                
            }];
            
        } else {

            sureAC2=[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"删除帖子");
                XDPostFrameModel *modelFrame = self.threadsArray[self.selectIndexPath.row];
                [XDRequestHttpTool request_deleteOneThread_withThread_id:modelFrame.model.wid Parameters:nil complete:^(id result) {
                    if ([result[@"code"] intValue] == 200) { // 删除成功
                        [self.threadsArray removeObject:modelFrame];
                        [self.tableView reloadData];
                    } else { // 删除失败
                        [self showHint:@"删除失败"];
                    }
                } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
                    [self.view makeToast:error.localizedDescription duration:2.0 position:CSToastPositionCenter];
                }];
            }];
            
        }
        [alertController addAction:cancelAC];
        [alertController addAction:sureAC1];
        [alertController addAction:sureAC2];
        [self presentViewController:alertController animated:YES completion:nil];

    };
    
    
//    XDPostFrameModel *fm = self.threadsArray[indexPath.row];
//    NSLog(@"%@",User_ID);
//    if ([[NSString stringWithFormat:@"%@",fm.model.user_id] isEqualToString:[NSString stringWithFormat:@"%@",User_ID]]) {
//        [cell setAttentionVIewisHiddden:YES];
//    } else {
//        [cell setAttentionVIewisHiddden:NO];
//    }
    [cell setAttentionVIewisHiddden:YES];
    cell.postFrameModel = self.threadsArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if ([_bottomView.inputTextView isFirstResponder]) {
//        self.bottomView.inputTextView.text = @"";
//        [self.bottomView textViewDidChange:self.bottomView.inputTextView];
//        [self.bottomView.inputTextView resignFirstResponder];
    
        return ;
    }
    
//    XDPostFrameModel *modelFrame              = self.threadsArray[indexPath.row];
//    XDPostDetailController *threadDetailVC    = [[XDPostDetailController alloc] init];
//    XD_WeakSelf
//    threadDetailVC.deleteButtonClicked = ^{
//        XD_StrongSelf
//        [self.threadsArray removeObject:modelFrame];
//        //删除某一行
//        [self.tableView reloadData];
//    };
//    threadDetailVC.attentionViewClickedBlock = ^(NSInteger code){
//        XD_StrongSelf
//        if (code == 202) {
//            for (XDPostFrameModel *postFModel in self.threadsArray) {
//                if ([postFModel.model.user_id integerValue] == [modelFrame.model.user_id integerValue]) {
//                    postFModel.model.follow = YES;
//                }
//            }
//            [self.tableView reloadData];
//        } else if (code == 200) {
//            for (XDPostFrameModel *postFModel in self.threadsArray) {
//                if ([postFModel.model.user_id integerValue] == [modelFrame.model.user_id integerValue]) {
//                    postFModel.model.follow = NO;
//                }
//            }
//            [self.tableView reloadData];
//        }
//    };
//
//    threadDetailVC.thread_id = modelFrame.model.wid;
//    [self.navigationController pushViewController:threadDetailVC animated:YES];
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // >>>>>>>>>>>>>>>>>>>>> * cell自适应 * >>>>>>>>>>>>>>>>>>>>>>>>
    
    XDPostFrameModel *modelFrame = self.threadsArray[indexPath.row];
    return modelFrame.cellHeight;
}

#pragma mark - 导航按钮点击事件
- (void)goToThreadMessage {
    XDisCommentPostController *isCommentVC = [[XDisCommentPostController alloc] init];
    [self.navigationController pushViewController:isCommentVC animated:YES];
}

- (void)goToSendThreadController {
    PostFoundViewController *sendvc = [[PostFoundViewController alloc]init];
    XDNavigationController *nav     = [[XDNavigationController alloc] initWithRootViewController:sendvc];
    XD_WeakSelf
    sendvc.sendPostSuccessBlock = ^{
        XD_StrongSelf
        [self.tableView.mj_header beginRefreshing];
    };
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - 发送评论
//- (void)sendComments {
//
//    if ([self.bottomView.inputTextView.text isEqualToString:@""]) {
//        self.bottomView.inputTextView.text = @"";
//        [self.bottomView textViewDidChange:self.bottomView.inputTextView];
//        [self.bottomView.inputTextView resignFirstResponder];
//        [MBProgressHUD showError:@"评论不能为空" toView:nil];
//        return ;
//    }
//
//    XDPostFrameModel *frameModel = [self.threadsArray objectAtIndex:self.selectIndexPath.row];
//    NSLog(@"评论了%@的帖子",frameModel.model.nickname);
//
//    // 添加评论接口
//    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
//    paras[@"first_id"] = User_ID;
//    paras[@"comment"] = self.bottomView.inputTextView.text;
//    paras[@"thread_id"] = frameModel.model.wid;
//
//    self.bottomView.inputTextView.text = @"";
//    [self.bottomView textViewDidChange:self.bottomView.inputTextView];
//    [self.bottomView.inputTextView resignFirstResponder];
//
//    [XDRequestHttpTool request_addPostCommentInfo_withParameters:paras complete:^(id result) {
//
//        if (result[@"code"] == nil) {
//            [MBProgressHUD showSuccess:@"评论成功"];
//
//            if (frameModel.model.commentItemsArray.count < 5) {
//                frameModel.model.commentCount += 1;
//                XDPostCommentItemModel *commentModel = [XDPostCommentItemModel objectWithKeyValues:result];
//                [frameModel.model.commentItemsArray addObject:commentModel];
//                frameModel.model = frameModel.model;
//
////                [self.tableView beginUpdates];
////                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:_selectIndexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
////                [self.tableView endUpdates];
//
//            } else {
//                frameModel.model.commentCount += 1;
//                if (frameModel.model.commentCount == frameModel.model.commentItemsArray.count + 1) { // 显示查看所有留言
//                    frameModel.model = frameModel.model;
//                }
//
////                [self.tableView beginUpdates];
////                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:_selectIndexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
////                [self.tableView endUpdates];
//            }
//            [[NSNotificationCenter defaultCenter] postNotificationName:XDPostCommentNotification object:frameModel.model];
//        } else {
//            [self.view makeToast:result[@"message"] duration:2.0 position:CSToastPositionCenter];
//        }
//
//    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
//        [self.view makeToast:error.localizedDescription duration:2.0 position:CSToastPositionCenter];
//    }];
//}

#pragma mark - ICEDropMenuDelegate
//- (void)didSelectItem:(NSInteger)selectedNum {
//    NSLog(@"选择：%ld",(long)selectedNum);
//    self.selectedNum = selectedNum;
//    //[self.viewDrop hideDropControl];
//
//    // 马上进入刷新状态
//    if (self.threadsArray.count == 0) {
//        [self reloadNewData];
//    }
//    else {
//        [self.tableView.mj_header beginRefreshing];
//    }
//
//    [_bottomView.inputTextView resignFirstResponder];
//    _bottomView.inputTextView.placehoder = nil;
//}
//
//- (void)dealloc {
//    [self.bottomView removeFromSuperview];
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}


//#pragma mark - UIActionSheet Delegate
//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
//    if ([actionSheet cancelButtonIndex] != buttonIndex) {
//        if (actionSheet.tag == 1) {
//
//            if (buttonIndex == 0) {
//                XDThreadReportController *reportVC = [[XDThreadReportController alloc] init];
//                XDPostFrameModel *modelFrame = self.threadsArray[self.selectIndexPath.row];
//                reportVC.thread_id = modelFrame.model.wid;
//                reportVC.user_id = User_ID;
//                [self.navigationController pushViewController:reportVC animated:YES];
//            }else if(buttonIndex == 1){
//                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5/*延迟执行时间*/ * NSEC_PER_SEC));
//
//                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//                    XDUMSharedView *view = [[XDUMSharedView alloc] init];
//                    view.delegate = self;
//                    [view show];
//                });
//
//            }
//
//        } else if (actionSheet.tag == 2) {
//            NSLog(@"删除帖子");
//            XDPostFrameModel *modelFrame = self.threadsArray[self.selectIndexPath.row];
//            [XDRequestHttpTool request_deleteOneThread_withThread_id:modelFrame.model.wid Parameters:nil complete:^(id result) {
//                if ([result[@"code"] intValue] == 200) { // 删除成功
//                    [self.threadsArray removeObject:modelFrame];
//                    [self.tableView reloadData];
//                } else { // 删除失败
//                    [self showHint:@"删除失败"];
//                }
//            } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
//                [self.view makeToast:error.localizedDescription duration:2.0 position:CSToastPositionCenter];
//            }];
//        }
//    }
//}

#pragma mark - 键盘处理
- (void)keyboardNotification:(NSNotification *)notification
{
    NSDictionary *dict = notification.userInfo;
    CGRect rect = [dict[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGRect textFieldRect = CGRectMake(0, rect.origin.y - textFieldH - NavigationBar_Height, rect.size.width, textFieldH);
    if (rect.origin.y == [UIScreen mainScreen].bounds.size.height) {
        textFieldRect = rect;
    }
    [UIView animateWithDuration:0.25 animations:^{
//        _bottomView.frame = textFieldRect;
    }];
    CGFloat h = rect.size.height + textFieldH;
    if (_totalKeybordHeight != h) {
        _totalKeybordHeight = h;
        [self adjustTableViewToFitKeyboard];
    }
}

- (void)adjustTableViewToFitKeyboard
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:_selectIndexPath];
    CGRect rect = [cell.superview convertRect:cell.frame toView:window];
    [self adjustTableViewToFitKeyboardWithRect:rect];
}

- (void)adjustTableViewToFitKeyboardWithRect:(CGRect)rect
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGFloat delta = CGRectGetMaxY(rect) - (window.bounds.size.height - _totalKeybordHeight);
    
    CGPoint offset = self.tableView.contentOffset;
    offset.y += delta;
    if (offset.y < 0) {
        offset.y = 0;
    }
    
    [self.tableView setContentOffset:offset animated:YES];
}

//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    [_bottomView.inputTextView resignFirstResponder];
//    _bottomView.inputTextView.placehoder = nil;
//    self.bottomView.inputTextView.text = @"";
//    [self.bottomView textViewDidChange:self.bottomView.inputTextView];
//}

#pragma mark - UIResponder actions
- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo
{
    if ([eventName isEqualToString:kRouterEventPostTopicViewTapEventName]) {
        [self topicViewPressed:[userInfo objectForKey:TopicStringKey]];
    } else if ([eventName isEqualToString:kRouterEventHeadIconViewTapEventName]) {
//        XDPostModel *model = [userInfo objectForKey:XDPostCellModelKey];
//        [self headIconPressed:model.user_id];
    }
}

//话题被点击
- (void)topicViewPressed:(NSString *)topic
{
    if (!self.topic) {
        NSLog(@"话题- %@ -被点击",topic);
        self.topic = topic;
        XDPostsController *topicVC = [[XDPostsController alloc] init];
        topicVC.title = topic;
        topicVC.topic = self.topic;
        [self.navigationController pushViewController:topicVC animated:YES];
        
        self.topic = nil;
    }
}

//- (void)headIconPressed:(NSString *)user_id {
//    
//    XDOtherViewController *personVC = [[XDOtherViewController alloc] init];
//    personVC.user_id = user_id;
//    [self.navigationController pushViewController:personVC animated:YES];
//}

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

#pragma mark - 设置帖子未读数
- (void)reloadUnreadMessageCount{
    
    XDUnreadCount *unreacCount = [[XDUnreadCount alloc] init];
    [_dynamicHub setCount:unreacCount.thread_count];
}


#pragma mark - XDUMSharedView Delegate
- (void)didSelectedToShare:(UMSocialPlatformType)clickedType {
    
    XDPostFrameModel *modelFrame = self.threadsArray[self.selectIndexPath.row];
    self.UMS_Title    = [NSString stringWithFormat:@"%@在“心动交友”上发布了一条动态",modelFrame.model.nickname];
    
    self.UMS_Web_Desc = [NSString stringWithFormat:@"%@",modelFrame.model.content.length?modelFrame.model.content:modelFrame.model.nickname];
//    http://13loveme.com/apphtml/suggestion/form-thread-share-link?id=19447
    self.UMS_WebLink = [NSString stringWithFormat:@"%@/apphtml/suggestion/form-thread-share-link?id=%@",ToPayUrl,modelFrame.model.wid];
    
    if (clickedType == UMSocialPlatformType_UserDefine_Begin) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.UMS_WebLink;
        [MBProgressHUD showSuccess:@"链接已复制剪贴板" toView:nil];
        return;
    }
      self.UMS_THUMB_IMAGE = [UIImage imageNamed:@"app_icon"];
     if (modelFrame.model.imgItemsArray.count) {
      XDPhotoModel *ptoto =  modelFrame.model.imgItemsArray.firstObject;
         self.UMS_THUMB_IMAGE = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:ptoto.img_path]]];
    }


    [self shareWebPageToPlatformType:clickedType];
}

#pragma mark 任性周榜
- (void)requestHeaderDataRankWeekRX {
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"rank_type"] = @(100); // 100任性周榜，110魅力周榜，200任性月榜，210魅力月榜
    NSString *encryWithPublicKeyStr = [RSAUtil encryptString:[NSString stringWithFormat:@"%@",User_ID] publicKey:kRSA_Public_key];
    [FKL_DataService requestURL:[NSString url_getGiftsRankingLists] parameters:paras headerKey:@"sign" headerValue:encryWithPublicKeyStr withType:@"GET" format:@"JSON" complete:^(id result) {
        if ([result[@"code"] integerValue] == 200) {
            NSArray *ranklistArray = [XDRankListModel objectArrayWithKeyValuesArray:result[@"data"]];
            if (!self.headerView) {
                self.headerView = [[XDPostHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 290)];
            }
            [self.headerView setRankWeekRX:ranklistArray];
            self.tableView.tableHeaderView = self.headerView;
            [self requestHeaderDataRankWeekML];
        } else {
            [self.view makeToast:result[@"code"] duration:2.0 position:CSToastPositionCenter];
        }
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        [self.view makeToast:error.localizedDescription duration:2.0 position:CSToastPositionCenter];
    }];
}

#pragma mark 魅力周榜
- (void)requestHeaderDataRankWeekML {
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"rank_type"] = @(110); // 100任性周榜，110魅力周榜，200任性月榜，210魅力月榜
    NSString *encryWithPublicKeyStr = [RSAUtil encryptString:[NSString stringWithFormat:@"%@",User_ID] publicKey:kRSA_Public_key];
    [FKL_DataService requestURL:[NSString url_getGiftsRankingLists] parameters:paras headerKey:@"sign" headerValue:encryWithPublicKeyStr withType:@"GET" format:@"JSON" complete:^(id result) {
        if ([result[@"code"] integerValue] == 200) {
            NSArray *ranklistArray = [XDRankListModel objectArrayWithKeyValuesArray:result[@"data"]];
            if (!self.headerView) {
                self.headerView = [[XDPostHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 290)];
            }
            [self.headerView setRankWeekML:ranklistArray];
            self.tableView.tableHeaderView = self.headerView;
        } else {
            [self.view makeToast:result[@"code"] duration:2.0 position:CSToastPositionCenter];
        }
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        [self.view makeToast:error.localizedDescription duration:2.0 position:CSToastPositionCenter];
    }];
}
@end
