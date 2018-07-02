//
//  ApplyListViewController.m
//  ThirteenmakeFriends
//
//  Created by 空谷凌虚 on 2018/5/21.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import "ApplyListViewController.h"

#import "ApplyFriendCell.h"
#import "InvitationManager.h"
#import "XDAddFriendApplyController.h"
#import "UIImageView+WebCache.h"
//#import "ChatSendHelper.h"
#import "XDNoticeCell.h"
//#import "MessageViewController.h"
#import "Notice.h"

#import "UserProfileManager.h"
#import "XDUnreadCount.h"

#import "EaseSDKHelper.h"
#import "CYPromptCoverView.h"
#import "XDApplyModel.h"

#import "XDRefreshHeader.h"
#import "MJRefresh.h"

static ApplyListViewController *controller = nil;

@interface ApplyListViewController ()<ApplyFriendCellDelegate,XDErrorViewDelegate>{
    XDErrorView *_errorView;
}

//! 分页页码
@property (nonatomic, assign) NSInteger pageIndex;
//! 分页最大页码
@property (nonatomic, assign) NSInteger MaxPage;


@end

@implementation ApplyListViewController

- (UIStatusBarStyle)preferredStatusBarStyle{
    
#if APP_Puppet  // Puppet
    return UIStatusBarStyleLightContent;
#elif APP_myPuppet
    return UIStatusBarStyleLightContent;
#else // 正常
    return UIStatusBarStyleDefault;
#endif
    
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _dataSource = [[NSMutableArray alloc] init];
        _undealedData = [[NSMutableArray alloc] init];
    }
    return self;
}
+ (instancetype)shareController
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        controller = [[self alloc] initWithStyle:UITableViewStylePlain];
    });
    
    return controller;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"官方提醒";
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.dataSource removeAllObjects];
    // 申请与通知头像昵称
    [self.undealedData removeAllObjects];
    [self setupErrorView];
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    WEAKSELF
    self.tableView.mj_header = [XDRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf reloadNewData];
    }];
    
   
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(reloadMoreData)];
}

#pragma mark - 获取数据
- (void)reloadNewData {
    
    if (![[AppUpdateInfo sharedInstance] isHavingNetworking]) {
        
        if (self.dataSource.count == 0) {
            // 添加自定义错误(断网)提示
            _errorView = [_errorView addErrorViewWithType:@"error_nonet"];
        }
        
        
        return;
    }
    
    _pageIndex = 1;
    
    [self applyList];
}

- (void)reloadMoreData {
    if (_pageIndex < self.MaxPage) {
        _pageIndex = _pageIndex + 1;
        
        [self applyList];
        
    } else {
        // 已经全部加载完毕
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self back];
}


-(void)applyList{
    [self.dataSource removeAllObjects];
    [self.undealedData removeAllObjects];
    [self showHudInView:self.view hint:@"正在加载中"];
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"rank_type"]   =  @(300);
    paras[@"page"] = @(_pageIndex);
    
    // 公钥加密
    NSString *encryWithPublicKeyStr = [RSAUtil encryptString:[NSString stringWithFormat:@"%@",User_ID] publicKey:kRSA_Public_key];
    [FKL_DataService requestURL:[NSString url_getAcceptRejectGifts] parameters:paras headerKey:@"sign" headerValue:encryWithPublicKeyStr withType:@"GET" format:@"JSON" complete:^(id result) {
        [self hideHud];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if ([result[@"code"] integerValue] == 200) {
            self.MaxPage = [result[@"maxpage"] integerValue];
            if (_pageIndex == 1) {
                [self.dataSource removeAllObjects];
                [self.undealedData removeAllObjects];
            }
            NSArray *records = [XDApplyModel objectArrayWithKeyValuesArray:result[@"data"]];
            
            if (self.dataSource.count == 0 && records.count == 0) {
                // 无数据
                _errorView = [_errorView addErrorViewWithType:error_nodata_flag];
                return ;
            }
         
            for (XDApplyModel *model in records) {
                ApplyEntity *entity = [ApplyEntity new];
                entity.applicantUsername = model.send_name;
                entity.applicantNick     = model.send_name;
                entity.applicantAvatar   = model.send_avatar_url;
                entity.reason            = model.gifts_img_url.length?@"送你礼物":@"加个好友呗";
//                entity.receiverUsername  = model.send_name;
//                entity.receiverNick      = model.send_name;
//                entity.style             = model.send_name;
                entity.groupId              = [NSString stringWithFormat:@"%ld",(long)model.applyId];
//                entity.groupSubject      = model.send_name;
                entity.is_dealed         = [NSString stringWithFormat:@"%ld",(long)model.is_returnable];////2：等待操作中；3：拒绝，4接受
                
                if (model.is_returnable == 2 ) {
                     [self.undealedData addObject:entity];
                }
                 [self.dataSource addObject:entity];
            }
            [self.tableView reloadData];
            // 移除ErrorView
            _errorView = [_errorView removeErrorView];
        } else {
            [self.view makeToast:result[@"message"]
                        duration:2.0
                        position:CSToastPositionCenter];
        }

    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideHud];
        [self.view makeToast:error.localizedDescription
                    duration:2.0
                    position:CSToastPositionCenter];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - getter

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}

- (NSMutableArray *)undealedData {
    if (_undealedData == nil) {
        _undealedData = [NSMutableArray array];
    }
    
    return _undealedData;
}


- (NSString *)loginUsername
{
    NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
    return [loginInfo objectForKey:kSDKUsername];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ApplyFriendCell";
    ApplyFriendCell *cell = (ApplyFriendCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[ApplyFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if(self.dataSource.count > indexPath.row)
    {
        ApplyEntity *entity = [self.dataSource objectAtIndex:indexPath.row];
        if (entity) {
            cell.indexPath = indexPath;
            ApplyStyle applyStyle = [entity.style intValue];
            if (applyStyle == ApplyStyleGroupInvitation) {
                cell.titleLabel.text = NSLocalizedString(@"title.groupApply", @"Group Notification");
                cell.headerImageView.image = [UIImage imageNamed:@"groupPrivateHeader"];
            }
            else if (applyStyle == ApplyStyleJoinGroup)
            {
                cell.titleLabel.text = NSLocalizedString(@"title.groupApply", @"Group Notification");
                cell.headerImageView.image = [UIImage imageNamed:@"groupPrivateHeader"];
            }
            else if(applyStyle == ApplyStyleFriend){
                //                cell.titleLabel.text = entity.applicantUsername;
                //                cell.headerImageView.image = [UIImage imageNamed:@"chatListCellHead"];
                // 申请与通知头像昵称
                UserCacheInfo *cacheInfo = [UserProfileManager getById:entity.applicantUsername];
                cell.titleLabel.text = cacheInfo.NickName;
                [cell.headerImageView sd_setImageWithURL:[NSURL URLWithString:cacheInfo.AvatarUrl] placeholderImage:[UIImage imageNamed:@"chatListCellHead"]];
            }
//            if (entity.reason) {
//                NSData *jsonData = [entity.reason dataUsingEncoding:NSUTF8StringEncoding];
//                NSError *err;
//                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
//                                                                    options:NSJSONReadingMutableContainers
//                                                                      error:&err];
//
//                if ([dic allKeys]) {
//                    XDGiftItemModel *giftmodel = [XDGiftItemModel objectWithKeyValues:dic];
//                    cell.contentLabel.text = [NSString stringWithFormat:@"送你%@",giftmodel.name];
//                }else{
//                    cell.contentLabel.text = entity.reason;
//                }
//            }
//
             cell.contentLabel.text = entity.reason;
            if ([entity.is_dealed isEqualToString:@"2"]) {
                cell.addButton.hidden = NO;
                cell.refuseButton.hidden = NO;
                cell.dealLabel.hidden = YES;
            } else {
                cell.addButton.hidden= YES;
                cell.refuseButton.hidden = YES;
                cell.dealLabel.hidden = NO;
                //2：等待操作中；3：拒绝，4接受
                if ([entity.is_dealed isEqualToString:@"4"]) {
                    cell.dealLabel.text = @"已接受";
                    cell.dealLabel.textColor = RGB(29, 185, 14);
                } else if ([entity.is_dealed isEqualToString:@"3"]) {
                    cell.dealLabel.text = @"已拒绝";
                    cell.dealLabel.textColor = RGB(246, 72, 68);
                } else {
                    cell.dealLabel.text = @"已处理";
                    cell.dealLabel.textColor = [UIColor lightGrayColor];
                }
            }
        }
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ApplyEntity *entity = [self.dataSource objectAtIndex:indexPath.row];
    return [ApplyFriendCell heightWithContent:entity.reason];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(self.dataSource.count > indexPath.row)
    {
        ApplyEntity *entity = [self.dataSource objectAtIndex:indexPath.row];
        if (entity) {
            ApplyStyle applyStyle = [entity.style intValue];
            if (applyStyle == ApplyStyleGroupInvitation) {
                
            }
            else if (applyStyle == ApplyStyleJoinGroup)
            {
                
            }
            else if(applyStyle == ApplyStyleFriend){
                //2：等待操作中；3：拒绝，4接受  0:未处理 1：已接受 2：已拒绝
                NSString *is_dealed = nil;
                if ([entity.is_dealed isEqualToString:@"4"]) {
                    is_dealed = @"1";
                } else if ([entity.is_dealed isEqualToString:@"3"]) {
                    is_dealed = @"2";
                } else {
                    is_dealed = @"0";
                }
                XDAddFriendApplyController *personVC = [[XDAddFriendApplyController alloc] init];
                personVC.username = entity.applicantUsername;
                personVC.is_dealed = is_dealed;
                [self.navigationController pushViewController:personVC animated:YES];
            }
        }
    }
}

#pragma mark - ApplyFriendCellDelegate
/**
 接受添加好友
 */
- (void)applyCellAddFriendAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [self.dataSource count]) {
        [self showHudInView:self.view hint:NSLocalizedString(@"sendingApply", @"sending apply...")];
        
        ApplyEntity *entity = [self.dataSource objectAtIndex:indexPath.row];
        
       
        EMError *error;
        [[EaseMob sharedInstance].chatManager acceptBuddyRequest:entity.applicantUsername error:&error];
        
        
        [self hideHud];
        if (!error) {
            [self acceptRejectGifts:4 XDApplyModel:entity];
            [self.undealedData removeObject:entity];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];

            [EaseSDKHelper sendTextMessage:@"聊天权限已开启，现在可以聊天了" to:entity.applicantUsername messageType:eMessageTypeChat requireEncryption:NO messageExt:[NSDictionary dictionaryWithObjectsAndKeys:@YES, @"em_revoke_extKey_revokePrompt", nil]];
        }
        else{
            [self showHint:NSLocalizedString(@"acceptFail", @"accept failure")];
        }
    }
}


/**
 拒绝添加好友
 */
- (void)applyCellRefuseFriendAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [self.dataSource count]) {
        [self showHudInView:self.view hint:NSLocalizedString(@"sendingApply", @"sending apply...")];
        ApplyEntity *entity = [self.dataSource objectAtIndex:indexPath.row];

        EMError *error;

        [[EaseMob sharedInstance].chatManager rejectBuddyRequest:entity.applicantUsername reason:@"" error:&error];
        
        
        [self hideHud];
        if (!error) {
             [self acceptRejectGifts:3 XDApplyModel:entity];
             [self.undealedData removeObject:entity];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
        else{
            [self showHint:NSLocalizedString(@"rejectFail", @"reject failure")];
        }
    }
}





- (void)back
{
    MainViewController *tabBar = (MainViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [tabBar setupUnreadMessageCount];
}


- (void)clear
{
    [_dataSource removeAllObjects];
    [self.tableView reloadData];
}

#pragma mark - 左滑删除消息


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    //    return NO;
    // 左滑删除
    return NO;
}

//设置滑动时显示多个按钮
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //添加一个删除按钮
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleDestructive) title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        [self applyCellDeleteFriendAtIndexPath:indexPath];
        
    }];
    //删除按钮颜色
    deleteAction.backgroundColor = [UIColor redColor];
    
    //将设置好的按钮方到数组中返回
    return @[deleteAction];
}


#pragma mark - 删除某个好友申请消息
- (void)applyCellDeleteFriendAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < [self.dataSource count]) {
        XDApplyModel *entity = [self.dataSource objectAtIndex:indexPath.row];
    
        [self.dataSource removeObject:entity];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}


#pragma mark 礼物提示
- (void)giftTip:(NSIndexPath*)indexPath {
    
    //    if (!myAppDelegate.newVersion) {
    //        return;
    //    }
    CGRect rectInTableView = [self.tableView rectForRowAtIndexPath:indexPath];
    CGRect rectInSuperview = [self.tableView convertRect:rectInTableView toView:[self.tableView superview]];
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    //    CGRect rect1 = [sender convertRect:sender.frame fromView:self.contentView];
    //    CGRect rect2 = [sender convertRect:rect1 toView:window];
    
    CYPromptCoverView *cover0 = [[CYPromptCoverView alloc] initWithRevalView:nil layoutType:CYPromptCoverViewLayoutTypeDown];
    cover0.revealFrame = rectInSuperview;
    cover0.revealType = CYPromptCoverViewRevealTypeRect;
    cover0.des = nil;
    cover0.detailDes = @"开启即接受对方礼物，拒绝后礼物将退还给对方哦~";
    [cover0 showInView:window];
}


-(void)acceptRejectGifts:(NSInteger)tag XDApplyModel:(ApplyEntity*)model{
    
//    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
//    paras[@"id"]   =  @(model.applyId);
//    paras[@"type"] = @(tag);//4接收，3拒绝
    
    // 公钥加密
    NSString *encryWithPublicKeyStr = [RSAUtil encryptString:[NSString stringWithFormat:@"%@",User_ID] publicKey:kRSA_Public_key];
    NSString *baseUrl = [NSString url_patchAcceptRejectGifts];
    NSString *url = [NSString stringWithFormat:@"%@/%@?type=%ld",baseUrl,model.groupId,(long)tag];
    [FKL_DataService requestURL:url parameters:nil headerKey:@"sign" headerValue:encryWithPublicKeyStr withType:@"PATCH" format:@"JSON" complete:^(id result) {
        
        if ([result[@"code"] integerValue] == 200) {
            
            [self.tableView.mj_header beginRefreshing];
        } else {
            [self.view makeToast:result[@"message"]
                        duration:2.0
                        position:CSToastPositionCenter];
        }
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        [self.view makeToast:error.localizedDescription
                    duration:2.0
                    position:CSToastPositionCenter];
    }];
}




/**
 *  初始化--错误提示界面
 */
- (void)setupErrorView {
    _errorView = [XDErrorView errorViewWithSuperView:self.view Frame:self.view.bounds];
    _errorView.delegate = self;
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
    [self applyList];
}





@end
