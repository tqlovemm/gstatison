//
//  XDContactsSearchController.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 16/12/12.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import "XDContactsSearchController.h"
#import "EMSearchBar.h"
#import "XDTableViewCellDate.h"
#import "XDSearchStangerController.h"
#import "MJExtension.h"
#import "ShiSanUser.h"
#import "MBProgressHUD+MJ.h"
#import "UserProfileManager.h"
#import <RTRootNavigationController.h>

@interface XDContactsSearchController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIGestureRecognizerDelegate>

@property (nonatomic) UITableView *tableView;

@property (nonatomic) EMSearchBar *searchBar;

@property (nonatomic) XDTableViewCellDate *cellData;


@end

@implementation XDContactsSearchController{
    //    BOOL navigationBarTranslucent;
    BOOL isSearching;
    BOOL shouldBecomeFirstResponder;
    id<UIGestureRecognizerDelegate> popGestureDelegate;
    UINavigationController *navigationController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.rt_disableInteractivePop = YES;
    
    [self setupNavigationItem];
    
    shouldBecomeFirstResponder = YES;
    UIView *barView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NavigationBar_Height)];
    NSInteger _barHeight = 44;
    if (@available(iOS 11.0, *)) { // ios11 searchbar高度
        _barHeight = 56;
    } else {
        _barHeight = 44;
    }
    self.searchBar = [[EMSearchBar alloc] initWithFrame:CGRectMake(0, NavigationBar_Height - _barHeight, SCREEN_WIDTH, _barHeight)];
    self.searchBar.placeholder = @"用户名/手机号";
    self.searchBar.delegate = self;
    self.searchBar.tintColor = RGB(29, 185, 14);
    self.searchBar.backgroundColor = RGB(240, 239, 245);
    self.searchBar.barTintColor = RGB(240, 239, 245);
    self.searchBar.backgroundImage = [UIImage imageWithColor:[UIColor clearColor]];
    // 设计键盘样式，只能输入字母和数字
//    self.searchBar.keyboardType = UIKeyboardTypeNamePhonePad;
    self.searchBar.keyboardType = UIKeyboardTypeAlphabet;
    
    barView.backgroundColor = self.searchBar.barTintColor;
    [barView addSubview:self.searchBar];
    [self.view addSubview:barView];
    
    self.view.backgroundColor = RGB(203, 203, 203);
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavigationBar_Height, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationBar_Height) style:UITableViewStylePlain];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.rowHeight = 56;
    self.tableView.preservesSuperviewLayoutMargins = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.hidden = YES;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 0);
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
//    tap.numberOfTapsRequired = 1;
//    tap.numberOfTouchesRequired = 1;
//    [self.view addGestureRecognizer:tap];
//
//    tap.cancelsTouchesInView = NO;
//    tap.delegate = self;
    
    self.cellData = [[XDTableViewCellDate alloc] initWithTitle:nil iconName:@"add_friend_icon_search"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    UIView *contentView;
    if ([[self.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] )
        contentView = [self.tabBarController.view.subviews objectAtIndex:1];
    else
        contentView = [self.tabBarController.view.subviews objectAtIndex:0];
    contentView.frame = CGRectMake(contentView.bounds.origin.x,  contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height + self.tabBarController.tabBar.frame.size.height);
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (shouldBecomeFirstResponder) {
        navigationController = self.navigationController;
        popGestureDelegate = self.navigationController.interactivePopGestureRecognizer.delegate;
    }
    
    [UIView setAnimationsEnabled:NO];
    if (shouldBecomeFirstResponder) {
        shouldBecomeFirstResponder = NO;
        [self.searchBar becomeFirstResponder];
    }
    
    [self.searchBar setShowsCancelButton:YES animated:NO];
    [UIView setAnimationsEnabled:YES];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self setNeedsStatusBarAppearanceUpdate];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    navigationController.interactivePopGestureRecognizer.delegate = popGestureDelegate;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.interactivePopGestureRecognizer.delegate = popGestureDelegate;
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)dismissToExit {
    UIViewController *vc = (UIViewController *)[[self.fromControllerClass alloc] init];
    
//    NSMutableArray<UIViewController *> *childViewControllers = [self.navigationController.childViewControllers mutableCopy];
    NSMutableArray<UIViewController *> *childViewControllers = [self.rt_navigationController.childViewControllers mutableCopy];
    [childViewControllers replaceObjectAtIndex:childViewControllers.count - 1 withObject:vc];
    if (childViewControllers.count > 1) {
        vc.hidesBottomBarWhenPushed = YES;
    }
    [self.navigationController setViewControllers:childViewControllers animated:NO];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([gestureRecognizer isKindOfClass:NSClassFromString(@"UIScreenEdgePanGestureRecognizer")]) {
        return self.searchBar.text.length > 0 && !self.searchBar.isFirstResponder;
    }else if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        return self.searchBar.text.length == 0;
    }
    
    return YES;
}

- (void)setupNavigationItem {
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"gray_back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -12;
    self.navigationItem.leftBarButtonItems = @[negativeSpacer, backItem];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Table View -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _cellData.title ? 1 : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"XDContactsSearchID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.imageView.layer.cornerRadius = 6;
        cell.textLabel.textColor = RGB(17, 137, 30);
        cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
    }
    
    XDTableViewCellDate *data = self.cellData;
    cell.imageView.image = data.icon;
    NSMutableAttributedString *searchStr = [[NSMutableAttributedString alloc] initWithString:data.title];
    
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"搜索: " attributes:@{NSForegroundColorAttributeName:[UIColor blackColor],
                                                                                              NSFontAttributeName:[UIFont boldSystemFontOfSize:15]                                                                             }];
    [searchStr insertAttributedString:str atIndex:0];
    
    cell.textLabel.attributedText = searchStr;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (!isSearching) {
        [self searchContactByChatIdOrPhoneNumber:_cellData.title];
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self tapHandler:nil];
}

#pragma mark - Search Delegete -

- (void)tapHandler:(id)sender {
    if (self.tableView.hidden && sender) {
        [self dismissToExit];
    }else {
        [self.searchBar resignFirstResponder];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self dismissToExit];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchBar.text.length == 0) {
        _cellData.title = nil;
        self.tableView.hidden = YES;
    }else {
        self.tableView.hidden = NO;
        self.cellData.title = searchBar.text;
        [self.tableView reloadData];
    }
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if (!isSearching) {
        [self searchContactByChatIdOrPhoneNumber:searchBar.text];
    }
}

// 设置searchBar的按钮
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = YES;
    for(UIView *view in  [[[searchBar subviews] objectAtIndex:0] subviews]) {
        if([view isKindOfClass:[NSClassFromString(@"UINavigationButton") class]]) {
            UIButton * cancel =(UIButton *)view;
            [cancel setTitle:@"取消" forState:UIControlStateNormal];
            [cancel setTitleColor:RGB(29, 185, 14) forState:UIControlStateNormal];
            [cancel setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        }
    }
}


#pragma mark - 搜索 -

//FIXME:此处只进行非常非常基础的判断
- (void)searchContactByChatIdOrPhoneNumber:(NSString *)chatId {
    isSearching = YES;
    [self.searchBar resignFirstResponder];
    
    NSString *buddyName = [_searchBar.text lowercaseString];
    NSString *loginUsername = [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:kSDKUsername];
    if ([buddyName isEqualToString:loginUsername]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"你不能添加自己到通讯录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        isSearching = NO;
        return;
    }
    
    NSArray *buddyList = [[[EaseMob sharedInstance] chatManager] buddyList];
    for (EMBuddy *buddy in buddyList) {
        if ([buddy.username isEqualToString:buddyName] &&
            buddy.followState != eEMBuddyFollowState_NotFollowed) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"对方已是您好友" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            isSearching = NO;
            return ;
        }
    }
    
    [self showHudInView:self.view hint:@"正在查找中..."];
    
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"username"] = chatId;
    
    NSString *url = [NSString url_searchUser];
    NSString *nonespaceUrl = [url stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    // 公钥加密
    NSString *encryWithPublicKeyStr = [RSAUtil encryptString:[NSString stringWithFormat:@"%@",chatId] publicKey:kRSA_Public_key];
    
    [FKL_DataService requestURL:nonespaceUrl parameters:paras headerKey:@"sign" headerValue:encryWithPublicKeyStr withType:@"GET" format:@"JSON" complete:^(id result) {
        [self hideHud];
        isSearching = NO;
        if ([result[@"code"] intValue] == 200) {
            ShiSanUser *user = [ShiSanUser objectWithKeyValues:result[@"data"]];
            [UserProfileManager saveInfo:user.username imgUrl:user.avatar nickName:user.nickname.length > 0 ? user.nickname : user.username];
            
            if ([user.username isEqualToString:loginUsername]) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"你不能添加自己到通讯录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                
                isSearching = NO;
                return;
            }
            
            for (EMBuddy *buddy in buddyList) {
                if ([buddy.username isEqualToString:user.username] &&
                    buddy.followState != eEMBuddyFollowState_NotFollowed) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"对方已是您好友" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                    isSearching = NO;
                    return ;
                }
            }
            
            XDSearchStangerController *strangerVC = [[XDSearchStangerController alloc] init];
            strangerVC.user = user;
            [self.navigationController pushViewController:strangerVC animated:YES];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:result[@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            
            [alert show];
        }
        
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideHud];
        isSearching = NO;
        NSLog(@"%@",error);
        
        [self.view makeToast:error.localizedDescription duration:2.0 position:CSToastPositionCenter];
    }];
//    [self dismissToExit];
    
}

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
