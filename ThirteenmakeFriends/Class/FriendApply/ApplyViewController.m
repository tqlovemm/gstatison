/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import "ApplyViewController.h"

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
#import "XDGiftItemModel.h"

//#import "XDOtherViewController.h"
#import "XDApplyModel.h"

static ApplyViewController *controller = nil;

@interface ApplyViewController ()<ApplyFriendCellDelegate>

/** 是否可以刷新ui */
@property (nonatomic, assign, getter = isFinished) BOOL finish;

@end

@implementation ApplyViewController

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
    
    // Uncomment the following line to preserve selection between presentations.
//    self.title = NSLocalizedString(@"title.apply", @"Application and notification");
    self.title = @"官方提醒";
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//    [self loadDataSourceFromLocalDB];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.finish = YES;
    [self loadDataSourceFromLocalDB];
    [self loadUserProfileInBackgroundWithBuddy:self.dataSource];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.finish = NO;
    [self back];
}

- (void)loadUserProfileInBackgroundWithBuddy:(NSArray*)buddyList
{
    NSMutableString *jsonString = [[NSMutableString alloc] initWithString:@"["];
    for(ApplyEntity *buddy in buddyList){
        
        //2. 遍历数组，取出键值对并按json格式存放
        NSString *string;
        
        string  = [NSString stringWithFormat:
                   @"\"%@\",",buddy.applicantUsername];
        
        [jsonString appendString:string];
        
    }
    
    // 3. 获取末尾逗号所在位置
    NSUInteger location = [jsonString length]-1;
    
    NSRange range = NSMakeRange(location, 1);
    // 4. 将末尾逗号换成结束的]}
    [jsonString replaceCharactersInRange:range withString:@"]"];
    
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"data"] = (NSArray *)jsonString;
    
    [FKL_DataService requestURL:[NSString url_getIconAndNickname] parameters:paras withType:@"GET" format:@"JSON" complete:^(id result) {
        NSArray *array = result;
        for (NSDictionary *dic in array) {
            [UserProfileManager saveInfo:dic[@"username"] imgUrl:dic[@"avatar"] nickName:dic[@"nickname"]];
        }
        [self.tableView reloadData];
        
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"获得昵称失败:%@",error);
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
            if (entity.reason) {
                NSData *jsonData = [entity.reason dataUsingEncoding:NSUTF8StringEncoding];
                NSError *err;
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                    options:NSJSONReadingMutableContainers
                                                                      error:&err];
                
                if ([dic allKeys]) {
                    XDGiftItemModel *giftmodel = [XDGiftItemModel objectWithKeyValues:dic];
                    cell.contentLabel.text = [NSString stringWithFormat:@"送你%@",giftmodel.name];
                }else{
                      cell.contentLabel.text = entity.reason;
                }
            }
          
//            cell.titleLabel.text = entity.applicantUsername;
//            [cell.headerImageView sd_setImageWithURL:[NSURL URLWithString:entity.applicantAvatar] placeholderImage:[UIImage imageNamed:@"chatListCellHead"]];
//            
            if ([entity.is_dealed isEqualToString:@"0"]) {
                cell.addButton.hidden = NO;
                cell.refuseButton.hidden = NO;
                cell.dealLabel.hidden = YES;
            } else {
                cell.addButton.hidden= YES;
                cell.refuseButton.hidden = YES;
                cell.dealLabel.hidden = NO;
                
                if ([entity.is_dealed isEqualToString:@"1"]) {
                    cell.dealLabel.text = @"已接受";
                    cell.dealLabel.textColor = RGB(29, 185, 14);
                } else if ([entity.is_dealed isEqualToString:@"2"]) {
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
    NSString *reason;
    if (entity.reason) {
        NSData *jsonData = [entity.reason dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
        
        
        if ([dic allKeys]) {
            XDGiftItemModel *giftmodel = [XDGiftItemModel objectWithKeyValues:dic];
            reason = [NSString stringWithFormat:@"送你%@",giftmodel.name];
        }else{
            reason = entity.reason;
        }
    }
    return [ApplyFriendCell heightWithContent:reason];
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
//                XDAddFriendApplyController *personVC = [[XDAddFriendApplyController alloc] init];
//                personVC.username = entity.applicantUsername;
//                personVC.is_dealed = entity.is_dealed;
//                    XDOtherViewController * otherVC = [[XDOtherViewController alloc] init];
//                    otherVC.username = entity.applicantUsername;
//                
//                    [self.navigationController pushViewController:otherVC animated:YES];
//                [self.navigationController pushViewController:personVC animated:YES];
				
				
				
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
        
        ApplyStyle applyStyle = [entity.style intValue];
        EMError *error;
        
        /*if (applyStyle == ApplyStyleGroupInvitation) {
            [[EaseMob sharedInstance].chatManager acceptInvitationFromGroup:entity.groupId error:&error];
        }
        else */if (applyStyle == ApplyStyleJoinGroup)
        {
            [[EaseMob sharedInstance].chatManager acceptApplyJoinGroup:entity.groupId groupname:entity.groupSubject applicant:entity.applicantUsername error:&error];
        }
        else if(applyStyle == ApplyStyleFriend){
            [[EaseMob sharedInstance].chatManager acceptBuddyRequest:entity.applicantUsername error:&error];
        }
        
        [self hideHud];
        if (!error) {
//            [self.dataSource removeObject:entity];
//            NSString *loginUsername = [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:kSDKUsername];
            
            // 已处理的消息从本地数据库移除
//            [[InvitationManager sharedInstance] removeInvitation:entity loginUser:loginUsername];
            // 申请与通知
            entity.is_dealed = @"1";
            NSString *loginUsername = [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:kSDKUsername];
            [[InvitationManager sharedInstance] updateInvitation:entity loginUser:loginUsername];
            [self.undealedData removeObject:entity];
//            [self.tableView reloadData];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            
            if (applyStyle == ApplyStyleJoinGroup) {
                // 打招呼
//                [ChatSendHelper sendTextMessageWithString:[NSString stringWithFormat:@"\"%@\"加入了群组",entity.applicantUsername] toUsername:entity.groupId isChatGroup:YES requireEncryption:NO ext:[NSDictionary dictionaryWithObjectsAndKeys:@YES, ksayHello_extKey_sayHelloPrompt, nil]];
                
                [EaseSDKHelper sendTextMessage:[NSString stringWithFormat:@"\"%@\"加入了群组",entity.applicantUsername] to:entity.groupId messageType:eMessageTypeGroupChat requireEncryption:NO messageExt:[NSDictionary dictionaryWithObjectsAndKeys:@YES, @"em_revoke_extKey_revokePrompt", nil]];
                
            } else if (applyStyle == ApplyStyleFriend) {
                // 打招呼
//                [ChatSendHelper sendTextMessageWithString:@"你们已经成为好友，开始聊天吧"
//                                               toUsername:entity.applicantUsername
//                                              messageType:eMessageTypeChat
//                                        requireEncryption:NO
//                                                      ext:[NSDictionary dictionaryWithObjectsAndKeys:@YES, ksayHello_extKey_sayHelloPrompt, nil]];
//                [];
//                if (entity.reason) {
//                    NSData *jsonData = [entity.reason dataUsingEncoding:NSUTF8StringEncoding];
//                    NSError *err;
//                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
//                                                                        options:NSJSONReadingMutableContainers
//                                                                          error:&err];
//
//                    if ([dic allKeys]) {
//                          XDGiftItemModel *giftmodel = [XDGiftItemModel objectWithKeyValues:dic];
//                        [self acceptRejectGifts:4 XDApplyModel:entity];
//                    }
//                }
                 [self acceptRejectGifts:4 XDApplyModel:entity];
                [EaseSDKHelper sendTextMessage:@"聊天权限已开启，现在可以聊天了" to:entity.applicantUsername messageType:eMessageTypeChat requireEncryption:NO messageExt:[NSDictionary dictionaryWithObjectsAndKeys:@YES, @"em_revoke_extKey_revokePrompt", nil]];
            }
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
        
        ApplyStyle applyStyle = [entity.style intValue];
        EMError *error;
        
        if (applyStyle == ApplyStyleGroupInvitation) {
            [[EaseMob sharedInstance].chatManager rejectInvitationForGroup:entity.groupId toInviter:entity.applicantUsername reason:@""];
        }
        else if (applyStyle == ApplyStyleJoinGroup)
        {
            [[EaseMob sharedInstance].chatManager rejectApplyJoinGroup:entity.groupId groupname:entity.groupSubject toApplicant:entity.applicantUsername reason:nil];
        }
        else if(applyStyle == ApplyStyleFriend){
//            if (entity.reason) {
//                NSData *jsonData = [entity.reason dataUsingEncoding:NSUTF8StringEncoding];
//                NSError *err;
//                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
//                                                                    options:NSJSONReadingMutableContainers
//                                                                      error:&err];
//
//                if ([dic allKeys]) {
//                    XDGiftItemModel *giftmodel = [XDGiftItemModel objectWithKeyValues:dic];
//                    [self acceptRejectGifts:3 XDApplyModel:giftmodel];
//                }
//            }
             [self acceptRejectGifts:3 XDApplyModel:entity];
            [[EaseMob sharedInstance].chatManager rejectBuddyRequest:entity.applicantUsername reason:@"" error:&error];
        }
        
        [self hideHud];
        if (!error) {
//            [self.dataSource removeObject:entity];
//            NSString *loginUsername = [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:kSDKUsername];
            
            // 已处理的消息从本地数据库移除
//            [[InvitationManager sharedInstance] removeInvitation:entity loginUser:loginUsername];
            // 申请与通知
            entity.is_dealed = @"2";
            NSString *loginUsername = [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:kSDKUsername];
            [[InvitationManager sharedInstance] updateInvitation:entity loginUser:loginUsername];
            [self.undealedData removeObject:entity];
//            [self.tableView reloadData];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
        else{
            [self showHint:NSLocalizedString(@"rejectFail", @"reject failure")];
        }
    }
}

#pragma mark - public

- (void)addNewApply:(NSDictionary *)dictionary
{
    
#warning <#message#>
    return;
    
    if (dictionary && [dictionary count] > 0) {
        NSString *applyUsername = [dictionary objectForKey:@"username"];
        ApplyStyle style = [[dictionary objectForKey:@"applyStyle"] intValue];
        
        if (applyUsername && applyUsername.length > 0) {
            for (int i = ((int)[_dataSource count] - 1); i >= 0; i--) {
                ApplyEntity *oldEntity = [_dataSource objectAtIndex:i];
                ApplyStyle oldStyle = [oldEntity.style intValue];
                if (oldStyle == style && [applyUsername isEqualToString:oldEntity.applicantUsername]) {
                    if(style != ApplyStyleFriend)
                    {
                        NSString *newGroupid = [dictionary objectForKey:@"groupname"];
                        if (newGroupid || [newGroupid length] > 0 || [newGroupid isEqualToString:oldEntity.groupId]) {
                            break;
                        }
                    }
                    
//                    oldEntity.reason = [dictionary objectForKey:@"applyMessage"];
                    // 申请与通知头像昵称
                    NSString *resonStr = [dictionary objectForKey:@"applyMessage"];
//                    NSString *nickName = [dictionary objectForKey:@"applicantNick"];
                    resonStr = [resonStr stringByReplacingOccurrencesOfString:applyUsername withString:[dictionary objectForKey:@"applicantNick"] ? [dictionary objectForKey:@"applicantNick"] : applyUsername];
                    oldEntity.reason = resonStr;
                    // 申请与通知
                    oldEntity.is_dealed = [dictionary objectForKey:@"is_dealed"];
                    oldEntity.applicantNick = [dictionary objectForKey:@"applicantNick"];
                    oldEntity.applicantAvatar = [dictionary objectForKey:@"applicantAvatar"];
                    
                    [_dataSource removeObject:oldEntity];
                    [_dataSource insertObject:oldEntity atIndex:0];
                    
                    // 申请与通知
                    [_undealedData removeObject:oldEntity];
                    [_undealedData insertObject:oldEntity atIndex:0];
                    
                    // 更新原有的entity
                    NSString *loginUsername = [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:kSDKUsername];
                    [[InvitationManager sharedInstance] updateInvitation:oldEntity loginUser:loginUsername];
                    
//                    [self.tableView reloadData];
                    
                    return;
                }
            }
            
            //new apply
            ApplyEntity * newEntity= [[ApplyEntity alloc] init];
            newEntity.applicantUsername = [dictionary objectForKey:@"username"];
            newEntity.style = [dictionary objectForKey:@"applyStyle"];
//            newEntity.reason = [dictionary objectForKey:@"applyMessage"];
            // 申请与通知头像昵称
            NSString *resonStr = [dictionary objectForKey:@"applyMessage"];
            [resonStr stringByReplacingOccurrencesOfString:applyUsername withString:[dictionary objectForKey:@"applicantNick"] ? [dictionary objectForKey:@"applicantNick"] : applyUsername];
            newEntity.reason = resonStr;
            // 申请与通知头像昵称
            newEntity.applicantNick = [dictionary objectForKey:@"applicantNick"];
            newEntity.applicantAvatar = [dictionary objectForKey:@"applicantAvatar"];
            
            NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
            NSString *loginName = [loginInfo objectForKey:kSDKUsername];
            newEntity.receiverUsername = loginName;
            
            NSString *groupId = [dictionary objectForKey:@"groupId"];
            newEntity.groupId = (groupId && groupId.length > 0) ? groupId : @"";
            
            NSString *groupSubject = [dictionary objectForKey:@"groupname"];
            newEntity.groupSubject = (groupSubject && groupSubject.length > 0) ? groupSubject : @"";
            
            // 申请与通知
            newEntity.is_dealed = [dictionary objectForKey:@"is_dealed"];
            
            NSString *loginUsername = [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:kSDKUsername];
            [[InvitationManager sharedInstance] addInvitation:newEntity loginUser:loginUsername];
            
            [_dataSource insertObject:newEntity atIndex:0];
            
            // 申请与通知
            [_undealedData insertObject:newEntity atIndex:0];
            
//            [self.tableView reloadData];

        }
    }
}

- (void)loadDataSourceFromLocalDB
{
    

    //
    [_dataSource removeAllObjects];
    // 申请与通知头像昵称
    [_undealedData removeAllObjects];
    
    NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
    NSString *loginName = [loginInfo objectForKey:kSDKUsername];
    if(loginName && [loginName length] > 0)
    {
        
        NSArray * applyArray = [[InvitationManager sharedInstance] applyEmtitiesWithloginUser:loginName];
        
//        [self.dataSource addObjectsFromArray:applyArray];
//        
//        // 申请与通知头像昵称
//        for (ApplyEntity *entity in applyArray) {
//            if ([entity.is_dealed isEqualToString:@"0"]) {
//                [self.undealedData addObject:entity];
//                continue;
//            }
//        }
//        
//        [self.tableView reloadData];
        
        // ******************* 对申请与通知消息进行排序 *************************
        NSArray* sorte = [applyArray sortedArrayUsingComparator:
                          ^(ApplyEntity *obj1, ApplyEntity* obj2){
                              
                              if ([obj1.is_dealed isEqualToString:@"0"]) {
                                  return(NSComparisonResult)NSOrderedAscending;
                              } else {
                                  return(NSComparisonResult)NSOrderedDescending;
                              }
                          }];
        
        // ******************* 结束 *************************
//
//        [self.dataSource addObjectsFromArray:sorte];
//
//        // 申请与通知头像昵称
        NSMutableArray *undealedDataArr = [NSMutableArray array];
        for (ApplyEntity *entity in sorte) {
            if ([entity.is_dealed isEqualToString:@"0"]) {
                [undealedDataArr addObject:entity];
                continue;
            }
        }
        
        
//        [self.tableView reloadData];
        
          [self applyList];
    }
}


/**
 获取头像与昵称
 */
- (void)getNickAndAvatarwithArray:(NSMutableArray *)arr {
    NSMutableString *jsonString = [[NSMutableString alloc] initWithString:@"["];
    for(ApplyEntity *mobile in arr){
        
        //2. 遍历数组，取出键值对并按json格式存放
        NSString *string;
        
        string  = [NSString stringWithFormat:
                   @"\"%@\",",mobile.applicantUsername];
        
        [jsonString appendString:string];
        
    }
    // 3. 获取末尾逗号所在位置
    NSUInteger location = [jsonString length]-1;
    
    NSRange range = NSMakeRange(location, 1);
    // 4. 将末尾逗号换成结束的]}
    [jsonString replaceCharactersInRange:range withString:@"]"];
    
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"data"] = jsonString;
    
    [FKL_DataService requestURL:[NSString url_getIconAndNickname] parameters:paras withType:@"GET" format:@"JSON" complete:^(id result) {
        NSArray *array = result;
//        for (NSDictionary *dic in array) {
//            [UserProfileManager saveInfo:dic[@"username"] imgUrl:dic[@"avatar"] nickName:dic[@"nickname"]];
//        }
        [UserProfileManager saveAllDicts:array];
        [self.tableView reloadData];
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"获得昵称失败:%@",error);
    }];
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
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return UITableViewCellEditingStyleDelete;
//}
//
//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return @"删除";
//}
//
///*删除用到的函数*/
//-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete)
//    {
//        
//        [self applyCellDeleteFriendAtIndexPath:indexPath];
//    }
//}

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
        ApplyEntity *entity = [self.dataSource objectAtIndex:indexPath.row];
        
        ApplyStyle applyStyle = [entity.style intValue];
        EMError *error;
        
        if ([entity.is_dealed isEqualToString:@"0"]) { // 未处理
            
            if (applyStyle == ApplyStyleGroupInvitation) {
                [[EaseMob sharedInstance].chatManager rejectInvitationForGroup:entity.groupId toInviter:entity.applicantUsername reason:@""];
            }
            else if (applyStyle == ApplyStyleJoinGroup)
            {
                [[EaseMob sharedInstance].chatManager rejectApplyJoinGroup:entity.groupId groupname:entity.groupSubject toApplicant:entity.applicantUsername reason:nil];
            }
            else if(applyStyle == ApplyStyleFriend){
                [[EaseMob sharedInstance].chatManager rejectBuddyRequest:entity.applicantUsername reason:@"" error:&error];
            }
            
            if (!error) {
                // 拒绝
                entity.is_dealed = @"2";
                [self.dataSource removeObject:entity];
                [self.undealedData removeObject:entity];
                NSString *loginUsername = [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:kSDKUsername];
                
                // 已处理的消息从本地数据库移除
                [[InvitationManager sharedInstance] removeInvitation:entity loginUser:loginUsername];
//                [self.tableView reloadData];
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
            else{
                [self showHint:NSLocalizedString(@"rejectFail", @"reject failure")];
            }
            
        } else { // 已处理
            [self.dataSource removeObject:entity];
            NSString *loginUsername = [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:kSDKUsername];
            
            // 已处理的消息从本地数据库移除
            [[InvitationManager sharedInstance] removeInvitation:entity loginUser:loginUsername];
//            [self.tableView reloadData];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
        
        
    }
}

/**
 addNewApply方法后执行
 */
- (void)reloadUI {
    if (self.isFinished) {
        [self.tableView reloadData];
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





-(void)applyList{
    [self.dataSource removeAllObjects];
    [self.undealedData removeAllObjects];
    [self showHudInView:self.view hint:@"正在加载中"];
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"rank_type"]   =  @(300);
  
    // 公钥加密
    NSString *encryWithPublicKeyStr = [RSAUtil encryptString:[NSString stringWithFormat:@"%@",User_ID] publicKey:kRSA_Public_key];
    [FKL_DataService requestURL:[NSString url_getAcceptRejectGifts] parameters:paras headerKey:@"sign" headerValue:encryWithPublicKeyStr withType:@"GET" format:@"JSON" complete:^(id result) {
        [self hideHud];
      
        if ([result[@"code"] integerValue] == 200) {
           
            NSArray *records = [XDApplyModel objectArrayWithKeyValuesArray:result[@"data"]];
            
//            if (self.dataSource.count == 0 && records.count == 0) {
//                // 无数据
//                _errorView = [_errorView addErrorViewWithType:error_nodata_flag];
//                return ;
//            }
            
            for (XDApplyModel *model in records) {
                ApplyEntity *entity = [ApplyEntity new];
                entity.applicantUsername = model.send_username;
                entity.applicantNick     = model.send_name;
                entity.applicantAvatar   = model.send_avatar_url;
                entity.reason            = model.gifts_img_url.length?@"送你礼物":@"加个好友呗";
                //                entity.receiverUsername  = model.send_name;
                //                entity.receiverNick      = model.send_name;
                //                entity.style             = model.send_name;
                entity.groupId              = [NSString stringWithFormat:@"%ld",(long)model.applyId];
                //                entity.groupSubject      = model.send_name;
                NSString *is_returnable = nil;
                if (model.is_returnable == 4) {
                    is_returnable = @"1";
                }else if (model.is_returnable == 3) {
                    is_returnable = @"2";
                }else{
                     is_returnable = @"0";
                }
                entity.is_dealed         = is_returnable;  //2：等待操作中；3：拒绝，4接受  0:未处理 1：已接受 2：已拒绝
                
                if (model.is_returnable == 2 ) {
                    [self.undealedData addObject:entity];
                }
                [self.dataSource addObject:entity];
            }
            [self loadUserProfileInBackgroundWithBuddy:self.dataSource];
            [self.tableView reloadData];
            // 移除ErrorView
//            _errorView = [_errorView removeErrorView];
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
    }];
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

@end
