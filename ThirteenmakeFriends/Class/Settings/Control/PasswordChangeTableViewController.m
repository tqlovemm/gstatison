//
//  PasswordChangeTableViewController.m
//  ThirteenmakeFriends
//
//  Created by iOS on 21/4/17.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "PasswordChangeTableViewController.h"
#import "PassWordWithSwitchTableViewCell.h"
#import "PasswordTableViewCell.h"
#import "ICEPasswordViewController.h"
#import "MBProgressHUD+MJ.h"
#import "PhonePWDTableViewCell.h"
#import "EditPasswordViewController.h"
#import "TouchIDTableViewCell.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface PasswordChangeTableViewController ()
<
 UITableViewDelegate,
 UITableViewDataSource
>

@end

@implementation PasswordChangeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title                    = @"手势密码";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSString *pwd   = [UserDefaults objectForKey:CombinationLock];
    NSString *touch = [UserDefaults objectForKey:TouchID];

    if (pwd.length > 0 && pwd != nil) {
    }
    else {
        if (touch.length >0 && touch !=nil){
            if ([touch isEqualToString:@"NO"]) {
                [UserDefaults setObject:@"NO" forKey:OpenedGesPWD];
            }
        }
        else {
            [UserDefaults setObject:@"NO" forKey:OpenedGesPWD];
        }
    }
    [self.tableView reloadData];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 2;
     return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    else {
        if (StringEqual([UserDefaults objectForKey:OpenedGesPWD], @"YES")) {
            if ([self judgeTouchIDEnable])
                return 3;
            else {
                return 2;
            }
        }
        return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier                    = @"PassWordWithSwitchTableViewCell";
    NSString *identifier2                   = @"PasswordTableViewCell";
    NSString *pwdIdentifier                 = @"PhonePWDTableViewCell";
    NSString *touchIdentifier               = @"TouchIDTableViewCell";

    if (indexPath.section == 0) {
        PhonePWDTableViewCell *cell = (PhonePWDTableViewCell *)[tableView dequeueReusableCellWithIdentifier:pwdIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"PhonePWDTableViewCell" owner:self options:nil] lastObject];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    else {
        if (indexPath.row == 0) {
            PassWordWithSwitchTableViewCell *cell = (PassWordWithSwitchTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"PassWordWithSwitchTableViewCell" owner:self options:nil] lastObject];
            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell.enablePWD addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
            cell.enablePWD.tag = 0;
            if (StringEqual([UserDefaults objectForKey:OpenedGesPWD], @"YES"))
                cell.enablePWD.on = YES;
            else
                cell.enablePWD.on = NO;
            return cell;
        }
        else if (indexPath.row == 1) {
            PasswordTableViewCell *cell = (PasswordTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier2];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"PasswordTableViewCell" owner:self options:nil] lastObject];
            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
        else {
            TouchIDTableViewCell *cell = (TouchIDTableViewCell *)[tableView dequeueReusableCellWithIdentifier:touchIdentifier];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"TouchIDTableViewCell" owner:self options:nil] lastObject];
            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell.TouchIDSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
            cell.TouchIDSwitch.tag = 1;
            
            if ([self judgeTouchIDEnable]) {
                NSLog(@"%@",[UserDefaults objectForKey:TouchID]);
                cell.TouchIDSwitch.on = [[UserDefaults objectForKey:TouchID] isEqualToString:@"YES"]?YES:NO;
            }
            else {
                cell.TouchIDSwitch.on = NO;
                cell.userInteractionEnabled = NO;
            }
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        EditPasswordViewController *vc = [[EditPasswordViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row == 1 && indexPath.section == 1) {
        ICEPasswordViewController *vc = [[ICEPasswordViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)switchAction:(UISwitch *)sender {
    if (sender.tag == 0) {
        if (sender.on) {
            [UserDefaults setObject:@"YES" forKey:OpenedGesPWD];
            ICEPasswordViewController *vc = [[ICEPasswordViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else {
            [UserDefaults setObject:@"NO" forKey:OpenedGesPWD];
        }
    }
    else if (sender.tag == 1) {
        if (sender.on) {
            [UserDefaults setObject:@"YES" forKey:TouchID];
            [UserDefaults setObject:@"YES" forKey:OpenedGesPWD];
        }
        else {
            NSString *pwd = [UserDefaults objectForKey:CombinationLock];
            
            if (pwd.length > 0 && pwd != nil) {
                [UserDefaults setObject:@"YES" forKey:OpenedGesPWD];
            }
            else {
                [UserDefaults setObject:@"NO" forKey:OpenedGesPWD];
            }
            [UserDefaults setObject:@"NO" forKey:TouchID];
        }
    }
    [self.tableView reloadData];
}

/**
 判断touchid是否可以用
 */
- (BOOL)judgeTouchIDEnable {
    LAContext *context             = [[LAContext alloc]init];
    NSError *error                 = nil;
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) // 该设备支持指纹识别
        return YES;
    else
        return NO;
}

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//    if ([alertView cancelButtonIndex] != buttonIndex) {
//        if (!isNetworking) {
//            [MBProgressHUD showError:kNET_IS_LOST toView:nil];
//            return;
//        }
//        //获取文本输入框
//        UITextField *pwdTextField = [alertView textFieldAtIndex:0];
//        if(pwdTextField.text.length > 0)
//        {
//            
//            NSMutableDictionary *paras = [NSMutableDictionary dictionary];
//            paras[@"password"] = pwdTextField.text;
//            paras[@"cid"] = [GeTuiSdk clientId];
//            
//            [XDRequestHttpTool request_login_withUser:User_Name Parameters:paras complete:^(id result) {
//                [self hideHud];
//                NSString *codeStr = [NSString stringWithFormat:@"%@",result[@"code"]];
//                if ([codeStr isEqualToString:@"202"]) {
//                    ICEPasswordViewController *vc = [[ICEPasswordViewController alloc]init];
//                    [self.navigationController pushViewController:vc animated:YES];
//                }
//                else if ([codeStr isEqualToString:@"402"]) {
//                    [MBProgressHUD showError:@"用户名不存在" toView:nil];
//                }
//                else if ([codeStr isEqualToString:@"403"]) {
//                    [MBProgressHUD showError:@"请输入正确的密码" toView:nil];
//                }
//                else {
//                    [self.view makeToast:result[@"message"] duration:2.0 position:CSToastPositionCenter];
//                }
//            } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
//                NSLog(@"%@",error);
//                [self.view makeToast:error.localizedDescription duration:2.0 position:CSToastPositionCenter];
//                [self hideHud];
//            }];
//        }
//        else {
//            [self showHint:@"邮箱格式不正确"];
//        }
//
//    }
//}

@end
