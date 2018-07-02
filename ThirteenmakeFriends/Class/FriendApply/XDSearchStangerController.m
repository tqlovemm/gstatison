//
//  XDSearchStangerController.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 16/12/13.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import "XDSearchStangerController.h"
#import "XDPersonHeaderView.h"
#import "XDPersonPhotosCell.h"
#import "ShiSanUser.h"
#import "XDPersonOtherInfoCell.h"
#import "XDAddFriendValidateController.h"
#import "XDNavigationController.h"
#import "XDPersonPhotosController.h"

@interface XDSearchStangerController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,weak) UITableView *tableView;

@end

@implementation XDSearchStangerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"详细资料";
    self.view.backgroundColor = RGB(240, 240, 242);
    
    [self xdd_setupTableView];
    
    XDPersonHeaderView *headerView = [[XDPersonHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80) andUserInfo:self.user];
    self.tableView.tableHeaderView = headerView;
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 90)];
    footView.userInteractionEnabled = YES;
    UIButton * addFriendBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 20, SCREEN_WIDTH - 30, 44)];
    [addFriendBtn addTarget:self action:@selector(addFriendBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [addFriendBtn setTitle:@"添加好友" forState:UIControlStateNormal];
    [addFriendBtn setTitleColor:BtnThemeColor forState:UIControlStateNormal];
    [addFriendBtn setBackgroundColor:[UIColor whiteColor]];
    addFriendBtn.layer.cornerRadius = 5;
    addFriendBtn.layer.masksToBounds = YES;
    [footView addSubview:addFriendBtn];
    
    if ([self didBuddyExist:self.user.username]) { // 好友
        NSLog(@"已是好友");
        [addFriendBtn setTitle:@"已是好友" forState:UIControlStateNormal];
        addFriendBtn.enabled = NO;
    } else { // 非好友
        NSLog(@"添加好友");
        [addFriendBtn setTitle:@"添加好友" forState:UIControlStateNormal];
        addFriendBtn.enabled = YES;
    }
    
    self.tableView.tableFooterView = footView;
}

/**
 *  创建tableView
 */
- (void)xdd_setupTableView {
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

#pragma mark - 添加好友
- (void)addFriendBtnClicked:(UIButton *)btn {
    NSLog(@"添加好友被点击");
    
    XDAddFriendValidateController *validateVC = [[XDAddFriendValidateController alloc]init];
    validateVC.user = self.user;
    
    XDNavigationController *nav = [[XDNavigationController alloc] initWithRootViewController:validateVC];
    [self presentViewController:nav animated:YES completion:nil];
    
}

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
