//
//  XDAddFriendApplyController.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 16/12/14.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import "XDAddFriendApplyController.h"
#import "XDPersonHeaderView.h"
#import "XDPersonPhotosCell.h"
#import "ShiSanUser.h"
#import "XDPersonOtherInfoCell.h"
#import "XDPersonPhotosController.h"
#import "MJExtension.h"
#import "InvitationManager.h"
//#import "ChatSendHelper.h"
//#import "ChatViewController.h"
#import "MBProgressHUD+MJ.h"
#import "UserProfileManager.h"

@interface XDAddFriendApplyController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,weak) UITableView *tableView;

@property (strong, nonatomic) ShiSanUser * user;

/** 拒绝 */
@property (nonatomic ,weak) UIButton *refuseBtn;

/** 接受 */
@property (nonatomic ,weak) UIButton *addBtn;

/** 已处理按钮 */
@property (nonatomic ,weak) UIButton *addFriendBtn;

@property (strong, nonatomic) ApplyEntity *entity;

/** 已处理过的footView */
@property (strong, nonatomic) UIView *dealedView;
/** 未处理过的footView */
@property (strong, nonatomic) UIView *undealedView;

@end

@implementation XDAddFriendApplyController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"详细资料";
    self.view.backgroundColor = RGB(240, 240, 242);
    
    [self setupNavBar];
    
    [self showHudInView:self.view hint:@"正在加载中..."];
    
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"username"] = self.username;
    // 公钥加密
    NSString *encryWithPublicKeyStr = [RSAUtil encryptString:[NSString stringWithFormat:@"%@",self.username] publicKey:kRSA_Public_key];
    
    [FKL_DataService requestURL:[NSString url_searchUser] parameters:paras headerKey:@"sign" headerValue:encryWithPublicKeyStr withType:@"GET" format:@"JSON" complete:^(id result) {
        [self hideHud];
        
        if ([result[@"code"] intValue] == 200) {
            self.user = [ShiSanUser objectWithKeyValues:result[@"data"]];
            [UserProfileManager saveInfo:self.user.username imgUrl:self.user.avatar nickName:self.user.nickname.length > 0 ? self.user.nickname : self.user.username];
            [self setupSubViews];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该用户不存在" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            
            [alert show];
        }
        
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideHud];
        NSLog(@"%@",error);
        [MBProgressHUD showError:@"请求超时,请稍后再试"];
    }];
    
    
}

/**
 *  设置导航条内容
 */
- (void)setupNavBar
{
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -12;
    
    UIButton *saveButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [saveButton setImage:[UIImage imageNamed:@"barbuttonicon_more"] forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithCustomView:saveButton];
    
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, saveItem];
    
}

- (void)save {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)setupSubViews {
    [self setupTableView];
    
    XDPersonHeaderView *headerView = [[XDPersonHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80) andUserInfo:self.user];
    self.tableView.tableHeaderView = headerView;
    
    self.dealedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 90)];
    UIButton * addFriendBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 20, SCREEN_WIDTH - 30, 44)];
    [addFriendBtn setBackgroundColor:[UIColor whiteColor]];
    [addFriendBtn setTitleColor:BtnThemeColor forState:UIControlStateNormal];
    addFriendBtn.layer.cornerRadius = 5;
    addFriendBtn.layer.masksToBounds = YES;
    [addFriendBtn addTarget:self action:@selector(addFriendBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.dealedView addSubview:addFriendBtn];
    self.addFriendBtn = addFriendBtn;
    
    self.undealedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 90)];
    UIButton * refuseBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 20, (SCREEN_WIDTH - 40) / 2.0, 44)];
    [refuseBtn setTitle:@"拒绝" forState:UIControlStateNormal];
    [refuseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [refuseBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [refuseBtn setBackgroundColor:[UIColor whiteColor]];
    [refuseBtn.layer setBorderWidth:0.5];
    [refuseBtn.layer setBorderColor:RGB(65, 65, 65).CGColor];
    refuseBtn.layer.cornerRadius = 5;
    refuseBtn.layer.masksToBounds = YES;
    [self.undealedView addSubview:refuseBtn];
    self.refuseBtn = refuseBtn;
    [refuseBtn addTarget:self action:@selector(refuseBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * addBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(refuseBtn.frame) + 10, 20, refuseBtn.width, 44)];
    [addBtn setTitle:@"接受" forState:UIControlStateNormal];
    [addBtn setTitleColor:BtnThemeColor forState:UIControlStateNormal];
    [addBtn.layer setBorderWidth:0.5];
    [addBtn.layer setBorderColor:BtnThemeColor.CGColor];
    [addBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [addBtn setBackgroundColor:[UIColor whiteColor]];
    addBtn.layer.cornerRadius = 5;
    addBtn.layer.masksToBounds = YES;
    [self.undealedView addSubview:addBtn];
    self.addBtn = addBtn;
    [addBtn addTarget:self action:@selector(addBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([self.is_dealed isEqualToString:@"1"]) { // 已接受
        [addFriendBtn setTitle:@"发消息" forState:UIControlStateNormal];
        addFriendBtn.enabled = YES;
        self.tableView.tableFooterView = self.dealedView;
    } else if ([self.is_dealed isEqualToString:@"2"]) { // 已拒绝
        [addFriendBtn setTitle:@"已拒绝" forState:UIControlStateNormal];
        addFriendBtn.enabled = NO;
        self.tableView.tableFooterView = self.dealedView;
    } else if ([self.is_dealed isEqualToString:@"0"]) { // 已拒绝
        self.tableView.tableFooterView = self.undealedView;
    }
}

/**
 *  创建tableView
 */
- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT - NavigationBar_Height) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = HEXCOLOR(0xefeff4);
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

#pragma mark -TableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return 4;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        // 创建cell
        XDPersonPhotosCell *cell = [XDPersonPhotosCell cellWithTableView:tableView];
        // 传递模型
        cell.user = self.user;
        
        return cell;
    } else {
        XDPersonOtherInfoCell *otherInfocell = [XDPersonOtherInfoCell cellWithTableView:tableView];
        if (indexPath.row == 0) {
            
            [otherInfocell cellWithTitle:@"地点" andContent:self.user.area_one andPlaceholder:@"暂无"];
        } else if (indexPath.row == 1) {
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            //生日
            NSDate *birthDay = [dateFormatter dateFromString:self.user.birthdate];
            NSTimeInterval dateDiff = [birthDay timeIntervalSinceNow];
            int age = trunc(dateDiff/(60*60*24))/365;
            
            [otherInfocell cellWithTitle:@"年龄" andContent:[NSString stringWithFormat:@"%d 岁",abs(age)] andPlaceholder:@"暂无"];
        } else if (indexPath.row == 2) {
            [otherInfocell cellWithTitle:@"身高" andContent:[NSString stringWithFormat:@"%@ cm",self.user.height] andPlaceholder:@"暂无"];
        }  else if (indexPath.row == 3) {
            
            [otherInfocell cellWithTitle:@"体重" andContent:[NSString stringWithFormat:@"%@ kg",self.user.weight] andPlaceholder:@"暂无"];
        }
        
        return otherInfocell;
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        XDPersonPhotosController *photoVC = [[XDPersonPhotosController alloc] init];
        photoVC.photos = self.user.photos;
        [self.navigationController pushViewController:photoVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (self.user.photos.count == 0) {
            return 0;
        } else {
            return 90;
        }
    }
    else{
        return 48;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        if (self.user.photos.count == 0) {
            return 0;
        } else {
            return 10;
        }
    } else {
        return 10;
    }
}

#pragma mark - 接受拒绝好友

- (void)refuseBtnClicked:(UIButton *)btn {
    
    NSMutableArray *entityArray = [NSMutableArray array];
    
    NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
    NSString *loginName = [loginInfo objectForKey:kSDKUsername];
    if(loginName && [loginName length] > 0)
    {
        
        NSArray * applyArray = [[InvitationManager sharedInstance] applyEmtitiesWithloginUser:loginName];
        [entityArray addObjectsFromArray:applyArray];
    }
    
    for (int i = 0 ; i < entityArray.count; i++) {
        ApplyEntity *entity = [entityArray objectAtIndex:i];
        
        if ([entity.applicantUsername isEqualToString:self.username] && [self.entity.style intValue] == ApplyStyleFriend) {
            self.entity = entity;
            break;
        }
    }
    
    if (self.entity == nil) {
        [self showHint:@"拒绝失败"];
        return;
    }
    
    [self showHudInView:self.view hint:NSLocalizedString(@"sendingApply", @"sending apply...")];
    
    EMError *error;
    [[EaseMob sharedInstance].chatManager rejectBuddyRequest:self.entity.applicantUsername reason:@"" error:&error];
    
    [self hideHud];
    if (!error) {
        // 申请与通知
        self.entity.is_dealed = @"2";
        NSString *loginUsername = [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:kSDKUsername];
        [[InvitationManager sharedInstance] updateInvitation:self.entity loginUser:loginUsername];
        
        self.tableView.tableFooterView = self.dealedView;
        [self.addFriendBtn setTitle:@"已拒绝" forState:UIControlStateNormal];
        self.addFriendBtn.enabled = NO;
        [self.tableView reloadData];
    }
}

- (void)addBtnClicked:(UIButton *)btn {
    NSMutableArray *entityArray = [NSMutableArray array];
    
    NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
    NSString *loginName = [loginInfo objectForKey:kSDKUsername];
    if(loginName && [loginName length] > 0)
    {
        
        NSArray * applyArray = [[InvitationManager sharedInstance] applyEmtitiesWithloginUser:loginName];
        [entityArray addObjectsFromArray:applyArray];
    }
    
    for (int i = 0 ; i < entityArray.count; i++) {
        ApplyEntity *entity = [entityArray objectAtIndex:i];
        
        if ([entity.applicantUsername isEqualToString:self.username] && [self.entity.style intValue] == ApplyStyleFriend) {
            self.entity = entity;
            break;
        }
    }
    
    if (self.entity == nil) {
        [self showHint:@"接受失败"];
        return;
    }
    
    [self showHudInView:self.view hint:NSLocalizedString(@"sendingApply", @"sending apply...")];
    
    EMError *error;
    [[EaseMob sharedInstance].chatManager acceptBuddyRequest:self.entity.applicantUsername error:&error];
    
    [self hideHud];
    if (!error) {
        // 申请与通知
        self.entity.is_dealed = @"1";
        NSString *loginUsername = [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:kSDKUsername];
        [[InvitationManager sharedInstance] updateInvitation:self.entity loginUser:loginUsername];
        
        // 打招呼
//        [ChatSendHelper sendTextMessageWithString:@"你们已经成为好友，开始聊天吧"
//                                       toUsername:self.entity.applicantUsername
//                                      messageType:eMessageTypeChat
//                                requireEncryption:NO
//                                              ext:[NSDictionary dictionaryWithObjectsAndKeys:@YES, ksayHello_extKey_sayHelloPrompt, nil]];
        
        [EaseSDKHelper sendTextMessage:@"聊天权限已开启，现在可以聊天了" to:self.entity.applicantUsername messageType:eMessageTypeChat requireEncryption:NO messageExt:[NSDictionary dictionaryWithObjectsAndKeys:@YES, @"em_revoke_extKey_revokePrompt", nil]];
        
        self.tableView.tableFooterView = self.dealedView;
        [self.addFriendBtn setTitle:@"发消息" forState:UIControlStateNormal];
        self.addFriendBtn.enabled = YES;
        [self.tableView reloadData];
    }
}


/**
 成为好友，发消息
 */
- (void)addFriendBtnClicked {
//    ChatViewController *chatController = [[ChatViewController alloc] initWithChatter:self.user.username conversationType:eConversationTypeChat];
//    ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:self.user.username conversationType:eConversationTypeChat];
//    chatController.title = self.user.nickname.length > 0 ? self.user.nickname : self.user.username;
//    [self.navigationController pushViewController:chatController animated:YES];
}

@end
