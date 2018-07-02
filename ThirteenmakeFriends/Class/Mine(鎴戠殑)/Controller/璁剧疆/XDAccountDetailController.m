//
//  XDAccountDetailController.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 16/8/23.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import "XDAccountDetailController.h"
#import "HMCommonLabelItem.h"
#import "HMCommonGroup.h"
#import "HMCommonItem.h"
#import "HMCommonCell.h"
#import "HMCommonArrowItem.h"
#import "ProfileUser.h"
#import "MBProgressHUD+MJ.h"
#import "EditPasswordViewController.h"
#import "FormatValidate.h"
#import "XDBindingPhoneController.h"
#import "XDAccountTool.h"

@interface XDAccountDetailController ()<UIAlertViewDelegate,UIActionSheetDelegate>

@property (nonatomic, strong) ProfileUser *user;

@property (nonatomic, weak) HMCommonLabelItem *cellPhone;

//! 昵称
@property (nonatomic, weak) UIAlertView *phoneAlert;


@property (nonatomic, weak) HMCommonLabelItem *email;
//! 邮箱
@property (nonatomic, weak) UIAlertView *emailAlert;

@end

@implementation XDAccountDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGB(239, 239, 239);
    
    [self setupGroups];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.cellPhone.text = self.user.cellphone;
    [self.tableView reloadData];
}

/**
 *  初始化模型数据
 */
- (void)setupGroups
{
    [self setupGroup1];
}

- (void)setupGroup1 {
    // 1.创建组
    HMCommonGroup *group = [HMCommonGroup group];
    [self.groups addObject:group];
    
    group.footer = @"注：*手机号和邮箱一旦确认后便不能修改";
    
    self.user = [[ProfileUser alloc]init];
    // 2.设置组的所有行数据
    XD_WeakSelf
    
    HMCommonLabelItem *cellphone = [HMCommonLabelItem itemWithTitle:@"手机号码" icon:@"nil"];
    cellphone.text = self.user.cellphone.length > 0 ? self.user.cellphone : @"尚未绑定";
    cellphone.operation = ^{
        XD_StrongSelf
        if (self.user.openId.length > 0 && self.user.cellphone.length > 0) {
            ;
        } else if (self.user.openId.length > 0 && self.user.cellphone.length == 0) {
            NSLog(@"绑定手机号");
            XDBindingPhoneController *bindingVC = [[XDBindingPhoneController alloc] init];
            [self.navigationController pushViewController:bindingVC animated:YES];
        } else if (self.user.openId.length == 0 && self.user.cellphone.length > 0) {
//            XDBindingPhoneController *bindingVC = [[XDBindingPhoneController alloc] init];
//            [self.navigationController pushViewController:bindingVC animated:YES];
        } else {
            UIAlertView *phoneAlert = [[UIAlertView alloc]initWithTitle:nil message:@"手机号" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [phoneAlert setAlertViewStyle:UIAlertViewStylePlainTextInput];
            UITextField *tf = [phoneAlert textFieldAtIndex:0];
            tf.text = self.user.cellphone;
            [phoneAlert show];
            self.phoneAlert = phoneAlert;
        }
    };
    self.cellPhone = cellphone;
    
    HMCommonLabelItem *email = [HMCommonLabelItem itemWithTitle:@"邮箱" icon:@"nil"];
    email.text = self.user.email;
    email.operation = ^{
        XD_StrongSelf
        if (self.user.email.length > 0 ) {
            ;
        } else {
            UIAlertView *emailAlert = [[UIAlertView alloc]initWithTitle:nil message:@"邮箱" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [emailAlert setAlertViewStyle:UIAlertViewStylePlainTextInput];
            UITextField *tf = [emailAlert textFieldAtIndex:0];
            tf.text = self.user.email;
            [emailAlert show];
            self.emailAlert = emailAlert;
        }
    };
    self.email = email;
    
    HMCommonLabelItem *number = [HMCommonLabelItem itemWithTitle:@"用户编号" icon:@"nil"];
    number.text = self.user.thirteen_platform_number;
    number.operation = ^{
        XD_StrongSelf
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"用户编号" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"复制" otherButtonTitles:nil, nil];
        sheet.tag = 3;
        [sheet showInView:self.view];
    };
    
    group.items = @[cellphone,email,number];
    
}

#pragma mark - tableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    __weak typeof(self) weakSelf = self;
    
    if ([alertView cancelButtonIndex] != buttonIndex) {
        if ([alertView isEqual:self.phoneAlert]) { // 手机号
            NSLog(@"修改手机号");
            if (!isNetworking) {
                [MBProgressHUD showError:kNET_IS_LOST toView:nil];
                return;
            }
            //获取文本输入框
            UITextField *nameTextField = [alertView textFieldAtIndex:0];
            if(nameTextField.text.length > 0 && [FormatValidate validateMobile:nameTextField.text])
            {
                //设置推送设置
                NSMutableDictionary *paras = [NSMutableDictionary dictionary];
                paras[@"cellphone"] = nameTextField.text;
                
                // 公钥加密
                NSString *encryWithPublicKeyStr = [RSAUtil encryptString:[NSString stringWithFormat:@"%@",User_ID] publicKey:kRSA_Public_key];
                [FKL_DataService requestURL:[NSString url_editPersonInfo_withNumber:self.user.thirteen_platform_number] parameters:paras headerKey:@"sign" headerValue:encryWithPublicKeyStr withType:@"PATCH" format:@"JSON" complete:^(id result) {
                    if ([result[@"code"] integerValue] == 200) {
                        weakSelf.user.cellphone = nameTextField.text;
                        weakSelf.cellPhone.text = nameTextField.text;
                        [XDAccountTool save:weakSelf.user];
                        [weakSelf.tableView reloadData];
                    } else {
                        [self.view makeToast:result[@"message"] duration:2.0 position:CSToastPositionCenter];
                    }
                } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
                    [self.view makeToast:error.localizedDescription duration:2.0 position:CSToastPositionCenter];
                }];
                
            } else {
                [self showHint:@"手机号码格式不正确"];
            }
        } else if ([alertView isEqual:self.emailAlert]) {
            NSLog(@"修改邮箱");
            if (!isNetworking) {
                [MBProgressHUD showError:kNET_IS_LOST toView:nil];
                return;
            }
            //获取文本输入框
            UITextField *nameTextField = [alertView textFieldAtIndex:0];
            if(nameTextField.text.length > 0 && [FormatValidate validateEmail:nameTextField.text])
            {
                //设置推送设置
                NSMutableDictionary *paras = [NSMutableDictionary dictionary];
                paras[@"email"] = nameTextField.text;
                
                // 公钥加密
                NSString *encryWithPublicKeyStr = [RSAUtil encryptString:[NSString stringWithFormat:@"%@",User_ID] publicKey:kRSA_Public_key];
                [FKL_DataService requestURL:[NSString url_editPersonInfo_withNumber:self.user.thirteen_platform_number] parameters:paras headerKey:@"sign" headerValue:encryWithPublicKeyStr withType:@"PATCH" format:@"JSON" complete:^(id result) {
                    if ([result[@"code"] integerValue] == 200) {
                        weakSelf.user.email = nameTextField.text;
                        weakSelf.email.text = nameTextField.text;
                        [XDAccountTool save:weakSelf.user];
                        [weakSelf.tableView reloadData];
                    } else {
                        [self.view makeToast:result[@"message"] duration:2.0 position:CSToastPositionCenter];
                    }
                } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
                    [self.view makeToast:error.localizedDescription duration:2.0 position:CSToastPositionCenter];
                }];
                
            } else {
                [self showHint:@"邮箱格式不正确"];
            }
        } else {
            NSLog(@"其他");
        }
        
    }
}

#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([actionSheet cancelButtonIndex] != buttonIndex) {
        [MBProgressHUD showSuccess:@"复制成功!"];
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.user.thirteen_platform_number;
    }
}

@end
