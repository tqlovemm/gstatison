//
//  ConversationListController.m
//  ChatDemo-UI3.0
//
//  Created by dhc on 15/6/25.
//  Copyright (c) 2015年 easemob.com. All rights reserved.
//
#import "ConversationListController.h"
//#import "ChatViewController.h"
#import "EMSearchBar.h"
#import "EMSearchDisplayController.h"
#import "RobotManager.h"
#import "RobotChatViewController.h"
#import "UserProfileManager.h"
#import "RealtimeSearchUtil.h"
//#import "RedPacketChatViewController.h"
//#import "RedpacketOpenConst.h"
#import "XDAddFriendController.h"
#import "XDAccountTool.h"
#import "ProfileUser.h"
#import "XDMembersCenterController.h"
#import "ContactListViewController.h"
#import "XDMessageCategoryController.h"
#import "YBPopupMenu.h"
#import "XDCustomPopupCell.h"
#import "RKNotificationHub.h"
#import "XDUnreadCount.h"
#import "ICESharedView.h"
#import <QuartzCore/QuartzCore.h>

#import "ApplyListViewController.h"
@implementation EMConversation (search)

//根据用户昵称,环信机器人名称,群名称进行搜索
- (NSString*)showName
{
    if (self.conversationType == eConversationTypeChat) {
        if ([[RobotManager sharedInstance] isRobotWithUsername:self.chatter]) {
            return [[RobotManager sharedInstance] getRobotNickWithUsername:self.chatter];
        }
        //return [[UserProfileManager sharedInstance] getNickNameWithUsername:self.chatter];
        // hx头像昵称
        return [UserProfileManager getNickById:self.chatter];
    } else if (self.conversationType == eConversationTypeGroupChat) {
        if ([self.ext objectForKey:@"groupSubject"] || [self.ext objectForKey:@"isPublic"]) {
            return [self.ext objectForKey:@"groupSubject"];
        }
    }
    return self.chatter;
}
@end
@interface ConversationListController ()<EaseConversationListViewControllerDelegate, EaseConversationListViewControllerDataSource,UISearchDisplayDelegate, UISearchBarDelegate,UIAlertViewDelegate,YBPopupMenuDelegate,ICESharedViewDelegate>
{
    RKNotificationHub *_countHub;
}
@property (nonatomic, strong) UIView *networkStateView;
@property (nonatomic, strong) EMSearchBar           *searchBar;
@property (strong, nonatomic) EMSearchDisplayController *searchController;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *iconArray;
@end
@implementation ConversationListController
- (void)viewDidLoad {
    [super viewDidLoad];
    // 分割线设置
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, EaseConversationCellMinHeight, 0, 0)];
        [self.tableView setSeparatorColor:RGB(230, 230, 230)];
    }
    [[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabaseWithAppend2Chat:NO];
    // Do any additional setup after loading the view.
    self.showRefreshHeader = YES;
    self.delegate = self;
    self.dataSource = self;
    [self tableViewDidTriggerHeaderRefresh];
    [self.view addSubview:self.searchBar];
    self.tableView.frame = CGRectMake(0, self.searchBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.searchBar.frame.size.height);
    [self networkStateView];
    [self searchController];
    [self removeEmptyConversationsFromDB];
    [self configEaseMessageHelp];
    [self setupNavBar];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadUnreadMessageCount];
}
- (void)setupNavBar
{
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [leftBtn setImage:[UIImage imageNamed:@"conversation_friend_list"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBrnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    UIButton *addfriendBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [addfriendBtn setImage:[UIImage imageNamed:@"contacts_add_friend"] forState:UIControlStateNormal];
    [addfriendBtn addTarget:self action:@selector(addFriendAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addfriendItem = [[UIBarButtonItem alloc] initWithCustomView:addfriendBtn];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -6;
    self.navigationItem.leftBarButtonItems = @[negativeSpacer, leftItem];
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, addfriendItem];
//    // 设置未读消息数
    _countHub = [[RKNotificationHub alloc] initWithView:addfriendBtn];
    [_countHub scaleCircleSizeBy:0.5];
    [_countHub moveCircleByX:6 Y:-2];
}
#pragma mark - 设置帖子未读数
- (void)reloadUnreadMessageCount{
    XDUnreadCount *unreacCount = [[XDUnreadCount alloc] init];
    NSInteger unreadCountApply = [[[ApplyViewController shareController] undealedData] count];
    [_countHub setCount:unreacCount.system_total_count + (int)unreadCountApply];
  //[_countHub hideCount];
}
#pragma mark - 我的好友
- (void)leftBrnClicked:(UIButton *)leftBtn {

    ContactListViewController *contactVC = [[ContactListViewController alloc] init];
    contactVC.title = @"好友";
//    CATransition* transition = [CATransition animation];
//    transition.type = kCATransitionPush;
//    transition.subtype = kCATransitionFromLeft;
//    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController pushViewController:contactVC animated:YES];
}
- (UITableViewCell *)ybPopupMenu:(YBPopupMenu *)ybPopupMenu cellForRowAtIndex:(NSInteger)index
{
    if (ybPopupMenu.tag != 100) {
        return nil;
    }
    XDCustomPopupCell *cell = [XDCustomPopupCell cellWithTableView:ybPopupMenu.tableView];
    
    cell.titleLabel.text = self.titleArray[index];
    cell.iconView.image = [UIImage imageNamed:self.iconArray[index]];
    
    if (index == 0) {
        XDUnreadCount *unreacCount = [[XDUnreadCount alloc] init];
        cell.badgeValue = unreacCount.system_total_count;
    } else {
        cell.badgeValue = [[[ApplyViewController shareController] undealedData] count];
    }
    
    return cell;
}

- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index
{
    //推荐回调
    if (index == 0) {
        XDMessageCategoryController *categoryVC = [[XDMessageCategoryController alloc] init];
        [self.navigationController pushViewController:categoryVC animated:YES];
    } else {
        [self.navigationController pushViewController:[ApplyViewController shareController] animated:YES];
//          [self.navigationController pushViewController:[ApplyListViewController shareController] animated:YES];
    }
}

#pragma mark - 添加好友
- (void)addFriendAction:(UIButton *)addBtn
{
//    if ([User_Sex isEqualToString:@"1"]) {
//        XDAddFriendController *addController = [[XDAddFriendController alloc] init];
//        [self.navigationController pushViewController:addController animated:YES];
//    } else {
//        ProfileUser *user = [XDAccountTool account];
//        if ([user.groupid intValue] > 0) { // 会员等级判断
//            XDAddFriendController *addController = [[XDAddFriendController alloc] init];
//            [self.navigationController pushViewController:addController animated:YES];
//        } else {
//            [self showUpgradeAlertView];
//        }
//    }
    
    self.titleArray = @[@"系统消息", @"互动通知"];
    self.iconArray = @[@"conversation_system_msg",@"conversation_interaction_msg"];

    [YBPopupMenu showRelyOnView:addBtn titles:self.titleArray icons:self.iconArray menuWidth:147 otherSettings:^(YBPopupMenu *popupMenu) {
        popupMenu.dismissOnSelected = YES;
        popupMenu.isShowShadow = YES;
        popupMenu.delegate = self;
        popupMenu.type = YBPopupMenuTypeDefault;
        popupMenu.cornerRadius = 3;
        popupMenu.rectCorner = UIRectCornerTopLeft| UIRectCornerTopRight;
        popupMenu.tag = 100;
        //如果不加这句默认是 UITableViewCellSeparatorStyleNone 的
        popupMenu.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        popupMenu.backColor = RGB(240, 239, 245);
    }];
}

#pragma mark - 升级会员
- (void)showUpgradeAlertView {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"升级成为会员才可以加好友哟"
                                                    message:@"是否现在升级会员"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
    [alert show];
}

#pragma mark - UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([alertView cancelButtonIndex] != buttonIndex) {
        XDMembersCenterController *memberVC = [[XDMembersCenterController alloc] init];
        [self.navigationController pushViewController:memberVC animated:YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)removeEmptyConversationsFromDB
{
    NSArray *conversations = [[EaseMob sharedInstance].chatManager conversations];
    NSMutableArray *needRemoveConversations;
    for (EMConversation *conversation in conversations) {
        if (!conversation.latestMessage || (conversation.conversationType == eConversationTypeChatRoom)) {
            if (!needRemoveConversations) {
                needRemoveConversations = [[NSMutableArray alloc] initWithCapacity:0];
            }
            
            [needRemoveConversations addObject:conversation.chatter];
        }
    }
    if (needRemoveConversations && needRemoveConversations.count > 0) {
        [[EaseMob sharedInstance].chatManager removeConversationsByChatters:needRemoveConversations
                                                             deleteMessages:YES
                                                                append2Chat:NO];
    }
}
#pragma mark - getter
- (UIView *)networkStateView
{
    if (_networkStateView == nil) {
        _networkStateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44)];
        _networkStateView.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:199 / 255.0 blue:199 / 255.0 alpha:0.5];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (_networkStateView.frame.size.height - 20) / 2, 20, 20)];
        imageView.image = [UIImage imageNamed:@"messageSendFail"];
        [_networkStateView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 5, 0, _networkStateView.frame.size.width - (CGRectGetMaxX(imageView.frame) + 15), _networkStateView.frame.size.height)];
        label.font = [UIFont systemFontOfSize:15.0];
        label.textColor = [UIColor grayColor];
        label.backgroundColor = [UIColor clearColor];
        label.text = NSLocalizedString(@"network.disconnection", @"Network disconnection");
        [_networkStateView addSubview:label];
    }
    
    return _networkStateView;
}

- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[EMSearchBar alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, 44)];
        if (@available(iOS 11.0, *)) { // ios11 searchbar高度
            _searchBar.height = 56;
        } else {
            _searchBar.height = 44;
        }
        _searchBar.delegate = self;
        _searchBar.placeholder = NSLocalizedString(@"search", @"Search");
//        _searchBar.backgroundColor = [UIColor colorWithRed:0.747 green:0.756 blue:0.751 alpha:1.000];
        _searchBar.backgroundColor = RGB(240, 239, 245);
        _searchBar.barTintColor = RGB(240, 239, 245);
        _searchBar.backgroundImage = [UIImage imageWithColor:[UIColor clearColor]];
    }
    
    return _searchBar;
}

//- (EMSearchDisplayController *)searchController
//{
//    if (_searchController == nil) {
//        _searchController = [[EMSearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
//        _searchController.delegate = self;
//        _searchController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//        _searchController.searchResultsTableView.tableFooterView = [[UIView alloc] init];
//
//        __weak ConversationListController *weakSelf = self;
//        [_searchController setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
//            NSString *CellIdentifier = [EaseConversationCell cellIdentifierWithModel:nil];
//            EaseConversationCell *cell = (EaseConversationCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//
//            // Configure the cell...
//            if (cell == nil) {
//                cell = [[EaseConversationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//            }
//
//            id<IConversationModel> model = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
//            cell.model = model;
//
//            cell.detailLabel.text = [weakSelf conversationListViewController:weakSelf latestMessageTitleForConversationModel:model];
//            cell.detailLabel.attributedText = [EaseEmotionEscape attStringFromTextForChatting:cell.detailLabel.text];
//            cell.timeLabel.text = [weakSelf conversationListViewController:weakSelf latestMessageTimeForConversationModel:model];
//            return cell;
//        }];
//
//        [_searchController setHeightForRowAtIndexPathCompletion:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
//            return [EaseConversationCell cellHeightWithModel:nil];
//        }];
//
//        [_searchController setDidSelectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
//            [tableView deselectRowAtIndexPath:indexPath animated:YES];
//            [weakSelf.searchController.searchBar endEditing:YES];
//            id<IConversationModel> model = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
//            EMConversation *conversation = model.conversation;
//
//            ChatViewController *chatController;
//            if ([[RobotManager sharedInstance] isRobotWithUsername:conversation.chatter]) {
//                chatController = [[RobotChatViewController alloc] initWithConversationChatter:conversation.chatter conversationType:conversation.conversationType];
//                chatController.title = [[RobotManager sharedInstance] getRobotNickWithUsername:conversation.chatter];
//            }else {
//
//#ifdef REDPACKET_AVALABLE
//                /**
//                 * TODO: 会话列表-红包聊天窗口
//                 */
//                chatController = [[RedPacketChatViewController alloc] initWithConversationChatter:conversation.chatter conversationType:conversation.conversationType];
//#else
//                chatController = [[ChatViewController alloc] initWithConversationChatter:conversation.chatter conversationType:conversation.conversationType];
//#endif
//                chatController.title = [conversation showName];
//            }
//            [weakSelf.navigationController pushViewController:chatController animated:YES];
//        }];
//    }
//
//    return _searchController;
//}

//#pragma mark - EaseConversationListViewControllerDelegate
//
//- (void)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
//            didSelectConversationModel:(id<IConversationModel>)conversationModel
//{
//    if (conversationModel) {
//        EMConversation *conversation = conversationModel.conversation;
//        if (conversation) {
//            if ([[RobotManager sharedInstance] isRobotWithUsername:conversation.chatter]) {
//                RobotChatViewController *chatController = [[RobotChatViewController alloc] initWithConversationChatter:conversation.chatter conversationType:conversation.conversationType];
//                chatController.title = [[RobotManager sharedInstance] getRobotNickWithUsername:conversation.chatter];
//                [self.navigationController pushViewController:chatController animated:YES];
//            } else {
//#ifdef REDPACKET_AVALABLE
//                /**
//                 * TODO: 会话列表-红包聊天窗口
//                 */
//                RedPacketChatViewController *chatController = [[RedPacketChatViewController alloc] initWithConversationChatter:conversation.chatter conversationType:conversation.conversationType];
//#else
//                NSDictionary *dict = @{@"来源" : @"会话列表"};
//                [MobClick event:@"service_source" attributes:dict];
//                ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:conversation.chatter conversationType:conversation.conversationType];
//#endif
//
//                chatController.title = [conversationModel.title isEqualToString:kServiceName] ? kServiceNiceName : conversationModel.title;
//                [self.navigationController pushViewController:chatController animated:YES];
//            }
//        }
//    }
//}

#pragma mark - EaseConversationListViewControllerDataSource

- (id<IConversationModel>)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
                                    modelForConversation:(EMConversation *)conversation
{
    EaseConversationModel *model = [[EaseConversationModel alloc] initWithConversation:conversation];
    if (model.conversation.conversationType == eConversationTypeChat) {
        if ([[RobotManager sharedInstance] isRobotWithUsername:conversation.chatter]) {
            model.title = [[RobotManager sharedInstance] getRobotNickWithUsername:conversation.chatter];
        } else {
            /*
            UserProfileEntity *profileEntity = [[UserProfileManager sharedInstance] getUserProfileByUsername:conversation.chatter];
            if (profileEntity) {
                model.title = profileEntity.nickname == nil ? profileEntity.username : profileEntity.nickname;
                model.avatarURLPath = profileEntity.imageUrl;
            } */
            
            // hx头像昵称
            UserCacheInfo *cacheInfo = [UserProfileManager getById:conversation.chatter];
            
            if (cacheInfo) {
                model.title = cacheInfo.NickName == nil ? cacheInfo.Id : cacheInfo.NickName;
                model.avatarURLPath = cacheInfo.AvatarUrl;
            }
        }
    } else if (model.conversation.conversationType == eConversationTypeGroupChat) {
        NSString *imageName = @"groupPublicHeader";
        if (![conversation.ext objectForKey:@"groupSubject"] || ![conversation.ext objectForKey:@"isPublic"])
        {
            NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
            for (EMGroup *group in groupArray) {
                if ([group.groupId isEqualToString:conversation.chatter]) {
                    model.title = group.groupSubject;
                    imageName = group.isPublic ? @"groupPublicHeader" : @"groupPrivateHeader";
                    model.avatarImage = [UIImage imageNamed:imageName];
                    NSMutableDictionary *ext = [NSMutableDictionary dictionaryWithDictionary:conversation.ext];
                    [ext setObject:group.groupSubject forKey:@"groupSubject"];
                    [ext setObject:[NSNumber numberWithBool:group.isPublic] forKey:@"isPublic"];
                    conversation.ext = ext;
                    break;
                }
            }
        } else {
            NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
            for (EMGroup *group in groupArray) {
                if ([group.groupId isEqualToString:conversation.chatter]) {
                    imageName = group.isPublic ? @"groupPublicHeader" : @"groupPrivateHeader";
                    NSMutableDictionary *ext = [NSMutableDictionary dictionaryWithDictionary:conversation.ext];
                    [ext setObject:group.groupSubject forKey:@"groupSubject"];
                    [ext setObject:[NSNumber numberWithBool:group.isPublic] forKey:@"isPublic"];
                    NSString *groupSubject = [ext objectForKey:@"groupSubject"];
                    NSString *conversationSubject = [conversation.ext objectForKey:@"groupSubject"];
                    if (groupSubject && conversationSubject && ![groupSubject isEqualToString:conversationSubject]) {
                        conversation.ext = ext;
                    }
                    break;
                }
            }
            model.title = [conversation.ext objectForKey:@"groupSubject"];
            imageName = [[conversation.ext objectForKey:@"isPublic"] boolValue] ? @"groupPublicHeader" : @"groupPrivateHeader";
            model.avatarImage = [UIImage imageNamed:imageName];
        }
    }
    return model;
}

- (NSString *)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
      latestMessageTitleForConversationModel:(id<IConversationModel>)conversationModel
{
    NSString *latestMessageTitle = @"";
    EMMessage *latestMessage = [conversationModel.conversation latestMessage];
    if (latestMessage)
    {
        latestMessageTitle = [self commonLatestMessageTitle:latestMessage];
    }
    return latestMessageTitle;
}

- (NSString *)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
       latestMessageTimeForConversationModel:(id<IConversationModel>)conversationModel
{
    NSString *latestMessageTime = @"";
    EMMessage *lastMessage = [conversationModel.conversation latestMessage];;
    if (lastMessage) {
        latestMessageTime = [NSDate formattedTimeFromTimeInterval:lastMessage.timestamp];
    }
    return latestMessageTime;
}

#pragma mark - 阅后即焚或普通消息内容显示
- (NSString *)commonLatestMessageTitle:(EMMessage *)latestMessage
{
    NSString *latestMessageTitle = @"";
    if (latestMessage.ext &&
        [EaseMessageHelper isRemoveAfterReadMessage:latestMessage] &&
        [latestMessage.to isEqualToString:[[EaseMob sharedInstance].chatManager loginInfo][kSDKUsername]])
    {
        latestMessageTitle = NSLocalizedString(@"message.burn", @"[Burn after reading]");
        return latestMessageTitle;
    }
    
    id<IEMMessageBody> messageBody = latestMessage.messageBodies.lastObject;
    switch (messageBody.messageBodyType) {
        case eMessageBodyType_Image:{
            latestMessageTitle = NSLocalizedString(@"message.image1", @"[image]");
        } break;
        case eMessageBodyType_Text:{
            // 表情映射。
            NSString *didReceiveText = [EaseConvertToCommonEmoticonsHelper
                                        convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
            latestMessageTitle = didReceiveText;
        } break;
        case eMessageBodyType_Voice:{
            latestMessageTitle = NSLocalizedString(@"message.voice1", @"[voice]");
        } break;
        case eMessageBodyType_Location: {
            latestMessageTitle = NSLocalizedString(@"message.location1", @"[location]");
        } break;
        case eMessageBodyType_Video: {
            latestMessageTitle = NSLocalizedString(@"message.video1", @"[video]");
        } break;
        case eMessageBodyType_File: {
            latestMessageTitle = NSLocalizedString(@"message.file1", @"[file]");
        } break;
        default: {
        } break;
    }
    return latestMessageTitle;
}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    __weak typeof(self) weakSelf = self;
    [[RealtimeSearchUtil currentUtil] realtimeSearchWithSource:self.dataArray searchText:(NSString *)searchText collationStringSelector:@selector(title) resultBlock:^(NSArray *results) {
        if (results) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.searchController.resultsSource removeAllObjects];
                [weakSelf.searchController.resultsSource addObjectsFromArray:results];
                [weakSelf.searchController.searchResultsTableView reloadData];
            });
        }
    }];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [[RealtimeSearchUtil currentUtil] realtimeSearchStop];
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

#pragma mark - public

-(void)refreshDataSource
{
    [self tableViewDidTriggerHeaderRefresh];
    [self hideHud];
}

- (void)isConnect:(BOOL)isConnect{
    if (!isConnect) {
        self.tableView.tableHeaderView = _networkStateView;
    }
    else{
        self.tableView.tableHeaderView = nil;
    }
}

- (void)networkChanged:(EMConnectionState)connectionState
{
    if (connectionState == eEMConnectionDisconnected) {
        self.tableView.tableHeaderView = _networkStateView;
    }
    else{
        self.tableView.tableHeaderView = nil;
    }
}

- (void)willReceiveOfflineMessages{
    NSLog(NSLocalizedString(@"message.beginReceiveOffine", @"Begin to receive offline messages"));
}

- (void)didReceiveOfflineMessages:(NSArray *)offlineMessages
{
    for (EMMessage *message in offlineMessages) {
        // 头像昵称
        [UserProfileManager saveDict:message.ext];
    }
    [self refreshDataSource];
}

- (void)didFinishedReceiveOfflineMessages{
    NSLog(NSLocalizedString(@"message.endReceiveOffine", @"End to receive offline messages"));
}

#pragma mark - 配置EaseMessageHelp

- (void)configEaseMessageHelp
{
    [EaseMessageHelper openRevokePrompt];
}

//#pragma mark - EaseMessageHelpProtocal
//- (void)emHelper:(EaseMessageHelper *)emHelper handleRevokeMessage:(NSArray *)needRevokeMessags
//{
//    __block BOOL isContainChatVC = NO;
//    [self.navigationController.viewControllers enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if ([obj isKindOfClass:[ChatViewController class]])
//        {
//            isContainChatVC = YES;
//            *stop = YES;
//        }
//    }];
//    //添加判断，如果当前nav的viewControllers不含有ChatViewController且消息回撤提示可用，则进行插入
//    if (!isContainChatVC &&
//        [EaseMessageHelper revokePromptIsValid]) {
//        for (EMMessage *message in needRevokeMessags)
//        {
//            for (id<IConversationModel>model in self.dataArray)
//            {
//                if ([message.conversationChatter isEqualToString:model.conversation.chatter]) {
//                    [EaseMessageHelper insertRevokePromptMessageToDB:message];
//                    break;
//                }
//            }
//        }
//    }
//    [self tableViewDidTriggerHeaderRefresh];
//}

- (void)emHelper:(EaseMessageHelper *)emHelper handleRemoveAfterReadMessage:(EMMessage *)removeMessage
{
    [self tableViewDidTriggerHeaderRefresh];
}

@end
