//
//  XDPostDetailController.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 17/3/29.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDPostDetailController.h"
#import "XDPostModel.h"
#import "MJExtension.h"
#import "XDPostCommentCell.h"
//#import "XDCommentView.h"
#import "MBProgressHUD+MJ.h"
#import "XDDetailHeaderView.h"
#import "XDThreadReportController.h"
#import "MJRefresh.h"
#import "IQKeyboardManager.h"
#import "XDUMSharedView.h"
#import "XDPhotoModel.h"
#import "XDNewReportViewController.h"
@interface XDPostDetailController ()<UITableViewDataSource,UITableViewDelegate,XDErrorViewDelegate,XDUMSharedViewDelegate>
{
    XDErrorView *_errorView;
}

@property (nonatomic ,strong) NSMutableArray *commentsArray;

@property (nonatomic ,weak) UITableView *tableView;

/** tableHeadView */
@property (nonatomic, strong) XDDetailHeaderView *headerView;

//! 评论框
//@property (nonatomic, weak) XDCommentView *bottomView;
//! 是否是回复评论
@property (nonatomic, assign) BOOL isReplayingComment;
//! 回复的模型
@property (nonatomic ,strong) XDPostCommentItemModel *selectModel;

//! 当前帖子模型
@property (nonatomic ,strong) XDPostModel *model;

//! 分页页码
@property (nonatomic, assign) NSInteger pageIndex;
//! 分页最大页码
@property (nonatomic, assign) NSInteger MaxPage;

@end

@implementation XDPostDetailController

- (NSMutableArray *)commentsArray {
    if (_commentsArray == nil) {
        _commentsArray = [NSMutableArray array];
    }
    
    return _commentsArray;
}

- (XDDetailHeaderView *)headerView {
    if (_headerView == nil) {
        _headerView = [[XDDetailHeaderView alloc] init];
    }
    return _headerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Do any additional setup after loading the view.
    self.title = @"动态详情";
    
    [self xdd_setupTableView];
    
    [self setupErrorView];
    
    [self setupCommentField];
    
    [self setupDatas];
    
//    [self setupRefreshControl];
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    
    [self addObservers];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [IQKeyboardManager sharedManager].enable = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [IQKeyboardManager sharedManager].enable = YES;
}

//-(void)viewTapped:(UITapGestureRecognizer*)tapGr
//{
//    CGPoint point = [tapGr locationInView:self.bottomView.sendBtn];
//    if (point.x >= 0 && point.y >= 0) {
//        [self sendComments];
//    } else {
//        self.bottomView.inputTextView.placehoder = @"评论";
//        self.bottomView.inputTextView.text = @"";
//        [self.bottomView textViewDidChange:self.bottomView.inputTextView];
//        [self.bottomView.inputTextView resignFirstResponder];
//        self.isReplayingComment = NO;
//        self.selectModel = nil;
//    }
//
//    [self.view endEditing:YES];
//
//}

- (void)xdd_setupTableView {
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,iPhoneX ? SCREEN_HEIGHT - NavigationBar_Height - Normal_Height - kSafeBottomHeight : SCREEN_HEIGHT - NavigationBar_Height - Normal_Height) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

/**
 *  创建评论框
 */
- (void)setupCommentField {
//    XDCommentView *bottomView = [[XDCommentView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - NavigationBar_Height - Normal_Height, SCREEN_WIDTH, Normal_Height)];
    
//    XDCommentView *bottomView = [[XDCommentView alloc]initWithFrame:CGRectMake(0, iPhoneX ? SCREEN_HEIGHT - NavigationBar_Height - Normal_Height - kSafeBottomHeight : SCREEN_HEIGHT - NavigationBar_Height - Normal_Height, SCREEN_WIDTH, iPhoneX ? Normal_Height + kSafeBottomHeight : Normal_Height)];
//    bottomView.inputTextView.placehoder = @"评论";
//    [self.view addSubview:bottomView];
//    self.bottomView = bottomView;
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postCommented:) name:XDPostCommentNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postLiked:) name:XDPostLikeNotification object:nil];
}

- (void)postCommented:(NSNotification *)notification {
    XDPostModel *object = (XDPostModel *)notification.object;
    
    self.model = object;
    [self setupTableHeaderView:self.model];
    [self.tableView reloadData];
}

- (void)postLiked:(NSNotification *)notification {
    XDPostModel *object = (XDPostModel *)notification.object;
    
    self.model = object;
    [self setupTableHeaderView:self.model];
    [self.tableView reloadData];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupTableHeaderView:(XDPostModel *)model {
    self.headerView.model = model;
    self.headerView.height = self.headerView.headerHeight;
    self.tableView.tableHeaderView = self.headerView;
    
    [self.headerView setAttentionVIewisHiddden:YES];
//    if ([[NSString stringWithFormat:@"%@",model.user_id] isEqualToString:[NSString stringWithFormat:@"%@",User_ID]]) {
//        [self.headerView setAttentionVIewisHiddden:YES];
//    } else {
//        [self.headerView setAttentionVIewisHiddden:NO];
//    }
    
    XD_WeakSelf
    self.headerView.otherButtonClickedBlock = ^{
        XD_StrongSelf
        
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
        
        if ([model.user_id integerValue] != [User_ID integerValue]) {
//            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"举报" otherButtonTitles:nil, nil];
//            sheet.tag = 1;
//            [sheet showInView:self.view];
            
           sureAC2=[UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//               XDThreadReportController *reportVC = [[XDThreadReportController alloc] init];
//               reportVC.thread_id = self.thread_id;
//               reportVC.user_id = User_ID;
//               [self.navigationController pushViewController:reportVC animated:YES];
               XDNewReportViewController *reportVC = [XDNewReportViewController new];
               reportVC.thread_id = self.thread_id;
               reportVC.user_id = User_ID;
               [self.navigationController pushViewController:reportVC animated:YES];
            }];
            
        } else {
//            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil, nil];
//            sheet.tag = 2;
//            [sheet showInView:self.view];
            
            sureAC2=[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [XDRequestHttpTool request_deleteOneThread_withThread_id:self.thread_id Parameters:nil complete:^(id result) {
                    [MBProgressHUD showSuccess:@"删除成功"];
                    
                    if (self.deleteButtonClicked) {
                        self.deleteButtonClicked();
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
                    NSLog(@"%@",error);
                    [self.view makeToast:error.localizedDescription duration:2.0 position:CSToastPositionCenter];
                }];
            }];
            
        }
        [alertController addAction:cancelAC];
        [alertController addAction:sureAC1];
        [alertController addAction:sureAC2];
        [self presentViewController:alertController animated:YES completion:nil];
    };
    
    self.headerView.likeButtonClickedOperation = ^{
        XD_StrongSelf
        if (self.model.isLiked) {
            return ;
        }
        
        NSMutableDictionary *paras = [NSMutableDictionary dictionary];
        paras[@"user_id"] = User_ID;
        paras[@"thread_id"] = self.thread_id;
        
        [XDRequestHttpTool request_thumbupThreadInfo_withParameters:paras complete:^(id result) {
            if (result[@"code"] == nil) { // 点赞成功
                self.model = [XDPostModel objectWithKeyValues:result];
                [self setupTableHeaderView:self.model];
                [[NSNotificationCenter defaultCenter] postNotificationName:XDPostLikeNotification object:self.model];
                
            } else {
                [self.view makeToast:result[@"message"] duration:2.0 position:CSToastPositionCenter];
            }
        } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
            [self.view makeToast:error.localizedDescription duration:2.0 position:CSToastPositionCenter];
        }];
    };
    
//    self.headerView.commentButtonClickedOperation = ^{
//        XD_StrongSelf
//        [self.bottomView.inputTextView becomeFirstResponder];
//    };
    
    self.headerView.attentionViewClickedBlock = ^(UIImageView *attentionView){
        XD_StrongSelf
        attentionView.userInteractionEnabled = NO;
        NSLog(@"关注被点击");
        NSMutableDictionary *paras = [NSMutableDictionary dictionary];
        paras[@"user_id"] = self.model.user_id;
        
        [XDRequestHttpTool request_ismyfollowsInfo_withUserID:User_ID Parameters:paras complete:^(id result) {
            if ([result[@"code"] integerValue] == 202) {
                if(self.attentionViewClickedBlock) {
                    self.attentionViewClickedBlock(202);
                }
                self.model.follow = YES;
                [MBProgressHUD showSuccess:@"关注成功" toView:nil];
                [self setupTableHeaderView:self.model];
                [self.tableView reloadData];
            } else if ([result[@"code"] integerValue] == 200) {
                if(self.attentionViewClickedBlock) {
                    self.attentionViewClickedBlock(200);
                }
                [MBProgressHUD showSuccess:@"取消关注成功" toView:nil];
                self.model.follow = NO;
                [self setupTableHeaderView:self.model];
                [self.tableView reloadData];
            } else {
                [self.view makeToast:result[@"message"] duration:2.0 position:CSToastPositionCenter];
            }
            attentionView.userInteractionEnabled = YES;
        } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"%@",error);
            attentionView.userInteractionEnabled = YES;
            [self.view makeToast:error.localizedDescription duration:2.0 position:CSToastPositionCenter];
        }];
    };
}

/**
 *  集成刷新控件
 */
- (void)setupRefreshControl {
    __unsafe_unretained __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.mj_header = [XDRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf reloadNewData];
    }];
    
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
- (void)setupDatas {
    
    if (![[AppUpdateInfo sharedInstance] isHavingNetworking]) {
        // 添加自定义错误(断网)提示
        _errorView = [_errorView addErrorViewWithType:@"error_nonet"];
        return;
    }
    
    [self showHudInView:self.view hint:@"正在加载中..."];
    
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"user_id"] = User_ID;
    paras[@"type"]    = @(1);
    
    [FKL_DataService requestURL:[NSString url_getThreadInfo_withThreadId:self.thread_id] parameters:paras withType:@"GET" format:@"JSON" complete:^(id result) {
        [self hideHud];
        // 移除ErrorView
        _errorView = [_errorView removeErrorView];
        
        if ([result[@"code"]integerValue] == 200) {
            self.commentsArray = [NSMutableArray array];
        
            XDPostModel *thread = [XDPostModel objectWithKeyValues:result[@"data"]];
            self.model = thread;
            
            [self.commentsArray addObjectsFromArray:thread.commentItemsArray];
            
            [self setupTableHeaderView:thread];
            
            // 更新未读消息数量
            [[NSNotificationCenter defaultCenter] postNotificationName:@"unreadOtherMessageCount" object:nil];
            
            [self.tableView reloadData];
        } else  if ([result[@"code"]integerValue] == 201){
           _errorView = [_errorView addErrorViewWithType:@"error_threadDele"];
        }else{
              [self.view makeToast:result[@"message"] duration:2.0 position:CSToastPositionCenter];
        }
        
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
        // 添加自定义错误(断网)提示
        _errorView = [_errorView addErrorViewWithType:@"error_getfail"];
        [self hideHud];
    }];
}

- (void)reloadNewData {
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"user_id"] = User_ID;
    
    NSString *url = [NSString stringWithFormat:@"%@/v10/words/%@",DomainUrl2,self.thread_id];
    
    // 公钥加密
    NSString *encryWithPublicKeyStr = [RSAUtil encryptString:[NSString stringWithFormat:@"%@",self.thread_id] publicKey:kRSA_Public_key];
    [FKL_DataService requestURL:url parameters:paras headerKey:@"sign" headerValue:encryWithPublicKeyStr withType:@"GET" format:@"JSON" complete:^(id result) {
        if (result[@"code"] == nil) {
            XDPostModel *thread = [XDPostModel objectWithKeyValues:result];
            
//            [self setupTableHeaderView:thread];
            [self.commentsArray removeAllObjects];
            [self.commentsArray addObjectsFromArray:thread.commentItemsArray];
            
            [self.tableView reloadData];
            
        } else {
            [self.view makeToast:result[@"message"] duration:2.0 position:CSToastPositionCenter];
        }
        [self.tableView.mj_header endRefreshing];
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)reloadMoreData {
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"user_id"] = User_ID;
    
    XDPostCommentItemModel *commentModel = self.commentsArray.lastObject;
    paras[@"min_id"] = commentModel.comment_id;
    NSString *url = [NSString stringWithFormat:@"%@/v10/words/%@",DomainUrl2,self.thread_id];
    
    // 公钥加密
    NSString *encryWithPublicKeyStr = [RSAUtil encryptString:[NSString stringWithFormat:@"%@",self.thread_id] publicKey:kRSA_Public_key];
    [FKL_DataService requestURL:url parameters:paras headerKey:@"sign" headerValue:encryWithPublicKeyStr withType:@"GET" format:@"JSON" complete:^(id result) {
        
        if (result[@"code"] == nil) {
            XDPostModel *thread = [XDPostModel objectWithKeyValues:result];
            
            [self.commentsArray addObjectsFromArray:thread.commentItemsArray];
            
//            [self setupTableHeaderView:thread];
            
            [self.tableView reloadData];
        } else {
            [self.view makeToast:result[@"message"] duration:2.0 position:CSToastPositionCenter];
        }
        
        [self.tableView.mj_footer endRefreshing];
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark keyboardNotification
-(void)keyboardShow:(NSNotification *)note
{
    // 1.键盘弹出需要的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 取出键盘高度
    CGRect keyboardF = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardH = keyboardF.size.height;
    
    [UIView animateWithDuration:duration animations:^{
        
//        _bottomView.transform=CGAffineTransformMakeTranslation(0, -keyboardH);
//        self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationBar_Height - self.bottomView.height - keyboardH);
//        CGFloat transformH = iPhoneX ? keyboardH - kSafeBottomHeight : keyboardH;
//        _bottomView.transform=CGAffineTransformMakeTranslation(0, -transformH);
//        self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationBar_Height - self.bottomView.height - transformH);
        
    } completion:^(BOOL finished) {
        //        self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationBar_Height - self.bottomView.height - keyboardH);
    }];
    
}

-(void)keyboardHide:(NSNotification *)note
{
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
//        _bottomView.transform=CGAffineTransformIdentity;
//        self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationBar_Height - self.bottomView.height);
    } completion:^(BOOL finished) {
        //        self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationBar_Height - self.bottomView.height);
        //        NSLog(@"%@ -- %f",NSStringFromCGRect(self.tableView.frame), _bottomView.height);
        //        self.bottomView.frame = ;
    }];
    
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.commentsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 创建cell
    static NSString *ID = @"XDPostCommentCellID";
    XDPostCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if(cell == nil)
    {
        cell = [[XDPostCommentCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    cell.commentModel = self.commentsArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XDPostCommentItemModel *model = self.commentsArray[indexPath.row];
    self.selectModel = model;
    
    if ([model.first_id isEqualToString:[NSString stringWithFormat:@"%@",User_ID]]) {
        self.isReplayingComment = NO;
        UIAlertController *alertController=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelAC=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *sureAC=[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"删除帖子评论");
            
            NSMutableDictionary *paras = [NSMutableDictionary dictionary];
            paras[@"user_id"] = User_ID;
            
            [XDRequestHttpTool request_deleteComment_withComment_id:self.selectModel.comment_id Parameters:paras complete:^(id result) {
                if ([result[@"code"] integerValue] == 200) {
                    [self.view makeToast:@"删除成功" duration:2.0 position:CSToastPositionCenter];
                    [self.commentsArray removeObject:self.selectModel];
                    [self.tableView reloadData];
                } else {
                    [self.view makeToast:result[@"message"] duration:2.0 position:CSToastPositionCenter];
                }
            } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
                [self.view makeToast:error.localizedDescription duration:2.0 position:CSToastPositionCenter];
            }];
 
        }];
        
        [alertController addAction:cancelAC];
        [alertController addAction:sureAC];
        [self presentViewController:alertController animated:YES completion:nil];
        
//        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil, nil];
//        sheet.tag = 3;
//        [sheet showInView:self.view];
    } else {
//        self.isReplayingComment = YES;
//        self.bottomView.inputTextView.placehoder = [NSString stringWithFormat:@"回复 %@:",model.firstName];
//        [self.bottomView.inputTextView becomeFirstResponder];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewAutomaticDimension;
}

#pragma mark - 发送评论
//- (void)sendComments {
//
//    if ([self.bottomView.inputTextView.text isEqualToString:@""]) {
//
//        [MBProgressHUD showError:@"评论不能为空" toView:nil];
//        return ;
//    }
//
//    // 添加评论接口
//    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
//    paras[@"first_id"] = User_ID;
//    paras[@"comment"] = self.bottomView.inputTextView.text;
//    paras[@"thread_id"] = self.thread_id;
//
//    if (self.isReplayingComment) {
//        paras[@"second_id"] = self.selectModel.first_id;
//        self.isReplayingComment = NO;
//    }
//
//    self.bottomView.inputTextView.text = @"";
//    [self.bottomView textViewDidChange:self.bottomView.inputTextView];
//    [self.bottomView.inputTextView resignFirstResponder];
//    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationBar_Height - self.bottomView.height);
//
//    [XDRequestHttpTool request_addPostCommentInfo_withParameters:paras complete:^(id result) {
//
//        if (result[@"code"] == nil) {
//            [MBProgressHUD showSuccess:@"评论成功"];
//            self.model.commentCount += 1;
//            XDPostCommentItemModel *commentModel = [XDPostCommentItemModel objectWithKeyValues:result];
//            [self.commentsArray addObject:commentModel];
//            [self.model.commentItemsArray addObject:commentModel];
//            [self setupTableHeaderView:self.model];
//            [self.tableView reloadData];
//            [self scrollTableToFoot:YES];
//
//            [[NSNotificationCenter defaultCenter] postNotificationName:XDPostCommentNotification object:self.model];
//        } else {
//            [self.view makeToast:result[@"message"] duration:2.0 position:CSToastPositionCenter];
//        }
//
//    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
//        [self.view makeToast:error.localizedDescription duration:2.0 position:CSToastPositionCenter];
//    }];
//}

//#pragma mark - UIActionSheetDelegate
//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
//    if ([actionSheet cancelButtonIndex] != buttonIndex) {
//        if (actionSheet.tag == 1) {
//            XDThreadReportController *reportVC = [[XDThreadReportController alloc] init];
//            reportVC.thread_id = self.thread_id;
//            reportVC.user_id = User_ID;
//            
//            [self.navigationController pushViewController:reportVC animated:YES];
//        } else if (actionSheet.tag == 2) {
//            NSLog(@"删除帖子");
//            
//            [XDRequestHttpTool request_deleteOneThread_withThread_id:self.thread_id Parameters:nil complete:^(id result) {
//                [MBProgressHUD showSuccess:@"删除成功"];
//                
//                if (self.deleteButtonClicked) {
//                    self.deleteButtonClicked();
//                }
//                [self.navigationController popViewControllerAnimated:YES];
//            } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
//                NSLog(@"%@",error);
//                [self.view makeToast:error.localizedDescription duration:2.0 position:CSToastPositionCenter];
//            }];
//            
//        } else if (actionSheet.tag == 3) {
//            NSLog(@"删除帖子评论");
//            
//            NSMutableDictionary *paras = [NSMutableDictionary dictionary];
//            paras[@"user_id"] = User_ID;
//            
//            [XDRequestHttpTool request_deleteComment_withComment_id:self.selectModel.comment_id Parameters:paras complete:^(id result) {
//                if ([result[@"code"] integerValue] == 200) {
//                    [self.view makeToast:@"删除成功" duration:2.0 position:CSToastPositionCenter];
//                    [self.commentsArray removeObject:self.selectModel];
//                    [self.tableView reloadData];
//                } else {
//                    [self.view makeToast:result[@"message"] duration:2.0 position:CSToastPositionCenter];
//                }
//            } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
//                [self.view makeToast:error.localizedDescription duration:2.0 position:CSToastPositionCenter];
//            }];
//        }
//    }
//}

#pragma mark  - 滑到最底部
- (void)scrollTableToFoot:(BOOL)animated
{
    NSInteger s = [self.tableView numberOfSections];  //有多少组
    if (s<1) return;  //无数据时不执行 要不会crash
    NSInteger r = [self.tableView numberOfRowsInSection:s-1]; //最后一组有多少行
    if (r<1) return;
    NSIndexPath *ip = [NSIndexPath indexPathForRow:r-1 inSection:s-1];  //取最后一行数据
    [self.tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:animated]; //滚动到最后一行
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
    [self setupDatas];
}


#pragma mark - XDUMSharedView Delegate
- (void)didSelectedToShare:(UMSocialPlatformType)clickedType {
  
    self.UMS_Title    = [NSString stringWithFormat:@"%@在“心动交友”上发布了一条动态",self.model.nickname];
    self.UMS_Web_Desc = [NSString stringWithFormat:@"%@",self.model.content.length?self.model.content:self.model.nickname];
    //    http://13loveme.com/apphtml/suggestion/form-thread-share-link?id=19447
    self.UMS_WebLink = [NSString stringWithFormat:@"%@/apphtml/suggestion/form-thread-share-link?id=%@",ToPayUrl,self.model.wid];
    self.UMS_THUMB_IMAGE = [UIImage imageNamed:@"app_icon"];
    if (self.model.imgItemsArray.count) {
        XDPhotoModel *ptoto =  self.model.imgItemsArray.firstObject;
        self.UMS_THUMB_IMAGE = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:ptoto.img_path]]];
    }
    if (clickedType == UMSocialPlatformType_UserDefine_Begin) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.UMS_WebLink;
        [MBProgressHUD showSuccess:@"链接已复制剪贴板" toView:nil];
        return;
    }
    [self shareWebPageToPlatformType:clickedType];
}

@end
