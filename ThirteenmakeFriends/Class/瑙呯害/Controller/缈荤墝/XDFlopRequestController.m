//
//  XDFlopRequestController.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/7/3.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDFlopRequestController.h"
#import "XDPersonHeaderView.h"
#import "XDPersonPhotosCell.h"
#import "ShiSanUser.h"
#import "XDPersonOtherInfoCell.h"
#import "XDPersonPhotosController.h"
#import "MJExtension.h"
//#import "ChatViewController.h"
#import "MBProgressHUD+MJ.h"
#import "UserProfileManager.h"

@interface XDFlopRequestController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,weak) UITableView *tableView;

@property (strong, nonatomic) ShiSanUser * user;

/** 加好友或发消息 */
@property (nonatomic ,weak) UIButton *addFriendBtn;

/** footView */
@property (strong, nonatomic) UIView *dealedView;
@end

@implementation XDFlopRequestController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Do any additional setup after loading the view.
    self.title = @"详细资料";
    self.view.backgroundColor = RGB(240, 240, 242);
    
    [self setupNavBar];
    
    [self showHudInView:self.view hint:@"正在加载中..."];
    NSString *encryWithPublicKeyStr = [RSAUtil encryptString:[NSString stringWithFormat:@"%@",self.user_id] publicKey:kRSA_Public_key];
    
    [FKL_DataService requestURL:[NSString url_getOtherPersonInfo_withUser_id:self.user_id] parameters:nil headerKey:@"sign" headerValue:encryWithPublicKeyStr withType:@"GET" format:@"JSON" complete:^(id result) {
        [self hideHud];
        
        if ([result[@"code"] integerValue] == 200) {
            self.user = [ShiSanUser objectWithKeyValues:result[@"data"]];
            [UserProfileManager saveInfo:self.user.username imgUrl:self.user.avatar nickName:self.user.nickname.length > 0 ? self.user.nickname : self.user.username];
            [self setupSubViews];
        } else {
            [self.view makeToast:result[@"message"]
                        duration:2.0
                        position:CSToastPositionCenter];
        }
        
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideHud];
        [self.view makeToast:error.localizedDescription duration:2.0 position:CSToastPositionCenter];
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
    
    
    if ([self didBuddyExist:self.user.username]) {
        [addFriendBtn setTitle:@"发消息" forState:UIControlStateNormal];
    } else {
        [addFriendBtn setTitle:@"接受" forState:UIControlStateNormal];
    }
    self.tableView.tableFooterView = self.dealedView;
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

/**
 成为好友，发消息
 */
- (void)addFriendBtnClicked {
    
    if ([self didBuddyExist:self.user.username]) {
//        ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:self.user.username conversationType:eConversationTypeChat];
//        chatController.title = self.user.nickname.length > 0 ? self.user.nickname : self.user.username;
//        [self.navigationController pushViewController:chatController animated:YES];
    } else { // 接受好友请求
        
        NSMutableDictionary *paras = [NSMutableDictionary dictionary];
        paras[@"user_id"] = User_ID;
        paras[@"user_id2"] = self.user_id;
        
        // 公钥加密
        NSString *encryWithPublicKeyStr = [RSAUtil encryptString:[NSString stringWithFormat:@"%@",User_ID] publicKey:kRSA_Public_key];
        [FKL_DataService requestURL:[NSString url_becomeFriends] parameters:paras headerKey:@"sign" headerValue:encryWithPublicKeyStr withType:@"POST" format:@"JSON" complete:^(id result) {
            if ([result[@"code"] intValue] == 200) {
                if ([self didBuddyExist:self.user.username]) {
                    [self.addFriendBtn setTitle:@"发消息" forState:UIControlStateNormal];
                } else {
                    [self.addFriendBtn setTitle:@"接受" forState:UIControlStateNormal];
                }
                
                // 打招呼
                [EaseSDKHelper sendTextMessage:@"聊天权限已开启，现在可以聊天了" to:self.user.username messageType:eMessageTypeChat requireEncryption:NO messageExt:[NSDictionary dictionaryWithObjectsAndKeys:@YES, @"em_revoke_extKey_revokePrompt", nil]];
                
                self.tableView.tableFooterView = self.dealedView;
                [self.tableView reloadData];
            } else {
                [self.view makeToast:result[@"message"]
                            duration:2.0
                            position:CSToastPositionCenter];
            }
        } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
            [self hideHud];
            [self.view makeToast:error.localizedDescription duration:2.0 position:CSToastPositionCenter];
        }];
    }
}


#pragma mark - 判断是否为好友
/**
 *  判断是否为好友
 */
- (BOOL)didBuddyExist:(NSString *)buddyName

{
    NSString *lowerbuddyName = [buddyName lowercaseString];
    NSArray *buddyList = [[[EaseMob sharedInstance] chatManager] buddyList];
    
    for (EMBuddy *buddy in buddyList) {
        
        if ([buddy.username isEqualToString:lowerbuddyName] &&
            
            buddy.followState != eEMBuddyFollowState_NotFollowed) {
            
            return YES;
            
        }
        
    }
    
    return NO;
    
}

@end
