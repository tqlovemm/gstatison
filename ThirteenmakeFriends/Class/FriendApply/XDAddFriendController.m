//
//  XDAddFriendController.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 16/12/9.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import "XDAddFriendController.h"
#import "XDContactsSearchController.h"
#import "AddFriendCell.h"
#import "EMSearchBar.h"
#import <RTRootNavigationController.h>

static NSString *ID = @"XDAddFriendID";

@interface XDAddFriendController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (nonatomic, strong) EMSearchBar * searchBar;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (strong, nonatomic) NSIndexPath *selectedIndexPath;

@end

@implementation XDAddFriendController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"添加好友";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupNavigationItem];
    
    self.searchBar = [[EMSearchBar alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, 44)];
    if (@available(iOS 11.0, *)) { // ios11 searchbar高度
        self.searchBar.height = 56;
    } else {
        self.searchBar.height = 44;
    }
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"用户名/手机号";
    self.searchBar.backgroundColor = RGB(240, 239, 245);
    self.searchBar.barTintColor = RGB(240, 239, 245);
    self.searchBar.backgroundImage = [UIImage imageWithColor:[UIColor clearColor]];
//    [self.view addSubview:self.searchBar];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationBar_Height) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.rowHeight = 60;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 16, 0, 0);
    self.tableView.tableHeaderView = self.searchBar;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController setNavigationBarHidden:self.navigationController.navigationBarHidden animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self performSelectorOnMainThread:@selector(showNavigationBarAnimated) withObject:nil waitUntilDone:NO];
}

- (void)showNavigationBarAnimated {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
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
    static NSString *CellIdentifier = @"AddFriendCellID";
    AddFriendCell *cell = (AddFriendCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[AddFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.imageView.image = [UIImage imageNamed:@"chatListCellHead.png"];
    cell.textLabel.text = [self.dataSource objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectedIndexPath = indexPath;
    NSString *buddyName = [self.dataSource objectAtIndex:indexPath.row];
    if ([self didBuddyExist:buddyName]) {
        NSString *message = [NSString stringWithFormat:NSLocalizedString(@"friend.repeat", @"'%@'has been your friend!"), buddyName];
        
        [EMAlertView showAlertWithTitle:message
                                message:nil
                        completionBlock:nil
                      cancelButtonTitle:NSLocalizedString(@"ok", @"OK")
                      otherButtonTitles:nil];
        
    }
    else if([self hasSendBuddyRequest:buddyName])
    {
        NSString *message = [NSString stringWithFormat:NSLocalizedString(@"friend.repeatApply", @"you have send fridend request to '%@'!"), buddyName];
        [EMAlertView showAlertWithTitle:message
                                message:nil
                        completionBlock:nil
                      cancelButtonTitle:NSLocalizedString(@"ok", @"OK")
                      otherButtonTitles:nil];
        
    }else{
        [self showMessageAlertView];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - SearchBar delegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf presentChatIdSearchController];
    });
    
    return NO;
}

- (void)presentChatIdSearchController {
    XDContactsSearchController *vc = [[XDContactsSearchController alloc] init];
    vc.fromControllerClass = self.class;
    
////    NSMutableArray<UIViewController *> *childViewControllers = [self.navigationController.childViewControllers mutableCopy];
//    NSMutableArray<UIViewController *> *childViewControllers = [self.rt_navigationController.childViewControllers mutableCopy];
//    
//    [childViewControllers replaceObjectAtIndex:childViewControllers.count - 1 withObject:vc];
//    if (childViewControllers.count > 1) {
//        vc.hidesBottomBarWhenPushed = YES;
//    }
//    [self.navigationController setViewControllers:childViewControllers animated:NO];
    
    [self.rt_navigationController pushViewController:vc
                                            animated:NO
                                            complete:^(BOOL finished) {
                                                [self.rt_navigationController removeViewController:self];
                                            }];
}

#pragma mark - action

- (void)searchAction
{
//    [_textField resignFirstResponder];
//    if(_textField.text.length > 0)
//    {
//#warning 由用户体系的用户，需要添加方法在已有的用户体系中查询符合填写内容的用户
//#warning 以下代码为测试代码，默认用户体系中有一个符合要求的同名用户
//        NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
//        NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
//        if ([_textField.text isEqualToString:loginUsername]) {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"friend.notAddSelf", @"can't add yourself as a friend") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
//            [alertView show];
//            
//            return;
//        }
//        
//        //判断是否已发来申请
//        NSArray *applyArray = [[ApplyViewController shareController] dataSource];
//        if (applyArray && [applyArray count] > 0) {
//            for (ApplyEntity *entity in applyArray) {
//                ApplyStyle style = [entity.style intValue];
//                BOOL isGroup = style == ApplyStyleFriend ? NO : YES;
//                if (!isGroup && [entity.applicantUsername isEqualToString:_textField.text]) {
//                    NSString *str = [NSString stringWithFormat:NSLocalizedString(@"friend.repeatInvite", @"%@ have sent the application to you"), _textField.text];
//                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:str delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
//                    [alertView show];
//                    
//                    return;
//                }
//            }
//        }
//        
//        [self.dataSource removeAllObjects];
//        [self.dataSource addObject:_textField.text];
//        [self.tableView reloadData];
//    }
}

- (BOOL)hasSendBuddyRequest:(NSString *)buddyName
{
    NSArray *buddyList = [[[EaseMob sharedInstance] chatManager] buddyList];
    for (EMBuddy *buddy in buddyList) {
        if ([buddy.username isEqualToString:buddyName] &&
            buddy.followState == eEMBuddyFollowState_NotFollowed &&
            buddy.isPendingApproval) {
            return YES;
        }
    }
    return NO;
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

- (void)showMessageAlertView
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:NSLocalizedString(@"saySomething", @"say somthing")
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"cancel", @"Cancel")
                                          otherButtonTitles:NSLocalizedString(@"ok", @"OK"), nil];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([alertView cancelButtonIndex] != buttonIndex) {
        UITextField *messageTextField = [alertView textFieldAtIndex:0];
        
        NSString *messageStr = @"";
        NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
        NSString *username = [loginInfo objectForKey:kSDKUsername];
        if (messageTextField.text.length > 0) {
            messageStr = [NSString stringWithFormat:@"%@：%@", username, messageTextField.text];
        }
        else{
            messageStr = [NSString stringWithFormat:NSLocalizedString(@"friend.somebodyInvite", @"%@ invite you as a friend"), username];
        }
        [self sendFriendApplyAtIndexPath:self.selectedIndexPath
                                 message:messageStr];
    }
}

- (void)sendFriendApplyAtIndexPath:(NSIndexPath *)indexPath
                           message:(NSString *)message
{
    NSString *buddyName = [self.dataSource objectAtIndex:indexPath.row];
    if (buddyName && buddyName.length > 0) {
        [self showHudInView:self.view hint:NSLocalizedString(@"friend.sendApply", @"sending application...")];
        EMError *error;
        [[EaseMob sharedInstance].chatManager addBuddy:buddyName message:message error:&error];
        [self hideHud];
        if (error) {
            [self showHint:NSLocalizedString(@"friend.sendApplyFail", @"send application fails, please operate again")];
        }
        else{
            [self showHint:NSLocalizedString(@"friend.sendApplySuccess", @"send successfully")];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

@end
