//
//  XDBasicDataController.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 16/8/24.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import "XDBasicDataController.h"
#import "HMCommonLabelItem.h"
#import "HMCommonGroup.h"
#import "HMCommonItem.h"
#import "HMCommonCell.h"
#import "ProfileUser.h"
#import "MBProgressHUD+MJ.h"
#import "STPickerDate.h"
#import "UserProfileManager.h"
#import "XDAccountTool.h"
// 头像昵称
//#import "UserCacheManager.h"

@interface XDBasicDataController ()<UIAlertViewDelegate>

//! 昵称
@property (nonatomic, weak) UIAlertView *nameAlert;

@property (nonatomic, strong) ProfileUser *user;

@property (nonatomic, weak) HMCommonLabelItem *nickname;

@property (nonatomic, weak) HMCommonLabelItem *birthdate;
@end

@implementation XDBasicDataController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"资料详情";
    
    [self setupGroups];
    
    [self setupNavBar];
    
}

/**
 *  设置导航条内容
 */
- (void)setupNavBar
{
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"gray_back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -12;
    self.navigationItem.leftBarButtonItems = @[negativeSpacer, backItem];
    
}

- (void)back {
    
    if ([self.delegate respondsToSelector:@selector(basicInfoChanged)]) {
        [self.delegate basicInfoChanged];
    }
    [self.navigationController popViewControllerAnimated:YES];
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
    
    group.header = @"资料详情";
    group.footer = @"*性别和生日一旦确定后便不可修改";
    
    // 2.设置组的所有行数据
    self.user = [[ProfileUser alloc] init];
    HMCommonLabelItem *nickname = [HMCommonLabelItem itemWithTitle:@"昵称" icon:@"nil"];
    nickname.text = self.user.nickname;
    XD_WeakSelf
    nickname.operation = ^{
        XD_StrongSelf
        UIAlertView *nameAlert = [[UIAlertView alloc]initWithTitle:nil message:@"昵称" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [nameAlert setAlertViewStyle:UIAlertViewStylePlainTextInput];
        UITextField *tf = [nameAlert textFieldAtIndex:0];
        tf.text = self.user.nickname;
        [nameAlert show];
        self.nameAlert = nameAlert;
    };
    self.nickname = nickname;
    
    HMCommonLabelItem *birthdate = [HMCommonLabelItem itemWithTitle:@"生日" icon:@"nil"];
    birthdate.text = self.user.birthdate;
    birthdate.operation = ^{
        XD_StrongSelf
        if (self.user.birthdate == nil) {
            STPickerDate *datePicker = [[STPickerDate alloc]initWithDelegate:self];
            [datePicker show];
        }
    };

    HMCommonLabelItem *sex = [HMCommonLabelItem itemWithTitle:@"性别" icon:@"nil"];
    sex.text = [self.user.sex isEqualToString:@"1"] ? @"女":@"男";

    group.items = @[nickname,birthdate,sex];

    self.birthdate = birthdate;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    __weak typeof(self) weakSelf = self;

    if ([alertView cancelButtonIndex] != buttonIndex) {
        if ([alertView isEqual:self.nameAlert]) { // 昵称
            NSLog(@"修改昵称");
            if (!isNetworking) {
                [MBProgressHUD showError:kNET_IS_LOST toView:nil];
                return;
            }
            //获取文本输入框
            UITextField *nameTextField = [alertView textFieldAtIndex:0];
            if(nameTextField.text.length > 0 && nameTextField.text.length < 15)
            {
                //设置推送设置
                NSMutableDictionary *paras = [NSMutableDictionary dictionary];
                paras[@"nickname"] = nameTextField.text;

                // 公钥加密
                NSString *encryWithPublicKeyStr = [RSAUtil encryptString:[NSString stringWithFormat:@"%@",User_ID] publicKey:kRSA_Public_key];
                [FKL_DataService requestURL:[NSString url_changeNickname] parameters:paras headerKey:@"sign" headerValue:encryWithPublicKeyStr withType:@"POST" format:@"JSON" complete:^(id result) {
                    if ([result[@"code"] integerValue] == 200) {
                        weakSelf.user.nickname = nameTextField.text;
                        [[EaseMob sharedInstance].chatManager setApnsNickname:nameTextField.text];
                        // 头像昵称
                        [UserProfileManager saveInfo:self.user.username imgUrl:self.user.avatar nickName:nameTextField.text];
                        weakSelf.user.nickname = nameTextField.text;
                        [XDAccountTool save:weakSelf.user];
                        weakSelf.nickname.text = nameTextField.text;
                        [weakSelf.tableView reloadData];
                        [MBProgressHUD showSuccess:@"修改成功" toView:self.navigationController.view];
                    } else {
                        [self.view makeToast:result[@"message"] duration:2.0 position:CSToastPositionCenter];
                    }

                } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
                    [self.view makeToast:error.localizedDescription duration:2.0 position:CSToastPositionCenter];
                }];

            } else {
                [self.view makeToast:@"昵称长度应小于15个字符" duration:2.0 position:CSToastPositionCenter];
            }
        } else {
            NSLog(@"其他");
        }

    }
}

#pragma mark - STPickerDateDelegate
- (void)pickerDate:(STPickerDate *)pickerDate year:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
{
    NSString *text = [NSString stringWithFormat:@"%ld-%02ld-%02ld", year, month, day];
    self.birthdate.text = text;
    [self.tableView reloadData];


    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"birthday"] = text;

    // 公钥加密
    NSString *encryWithPublicKeyStr = [RSAUtil encryptString:[NSString stringWithFormat:@"%@",User_ID] publicKey:kRSA_Public_key];
    [FKL_DataService requestURL:[NSString url_editPersonInfo_withNumber:self.user.thirteen_platform_number] parameters:paras headerKey:@"sign" headerValue:encryWithPublicKeyStr withType:@"PATCH" format:@"JSON" complete:^(id result) {

        if ([result[@"code"] intValue] == 200) {
            self.user.birthdate = text;
            [XDAccountTool save:self.user];
        } else {
            [self.view makeToast:result[@"message"] duration:2.0 position:CSToastPositionCenter];
        }

    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        [self.view makeToast:error.localizedDescription duration:2.0 position:CSToastPositionCenter];
    }];
}


@end
