//
//  EditPasswordViewController.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 15/12/30.
//  Copyright © 2015年 ThirtyOneDay. All rights reserved.
//

#import "EditPasswordViewController.h"
#import "MBProgressHUD+Add.h"

@interface EditPasswordViewController ()<UIAlertViewDelegate>
@property (nonatomic, weak) UITextField * original;

@property (nonatomic, weak) UITextField * newpassWord;

@property (nonatomic, weak) UITextField * reuse;

@end

@implementation EditPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"修改密码";
    self.view.backgroundColor = GlobalBGColor;
    
    [self setupTextFields];
    
    [self setupBtn];
    
    // 关闭键盘
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    [self.view endEditing:YES];
}

/**
 *  创建输入框
 */
- (void)setupTextFields {
    UITextField *original = [[UITextField alloc]initWithFrame:CGRectMake(15, 15, SCREEN_WIDTH - 30, TabBar_Height)];
    original.clearButtonMode = UITextFieldViewModeWhileEditing;
    original.secureTextEntry = YES;
    original.placeholder = @"输入原始密码";
    original.font = [UIFont systemFontOfSize:15.0f];
    original.borderStyle = UITextBorderStyleRoundedRect;
    self.original = original;
    [self.view addSubview:original];
    
    UITextField *newPassWord = [[UITextField alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(original.frame) + 15, SCREEN_WIDTH - 30, TabBar_Height)];
    newPassWord.clearButtonMode = UITextFieldViewModeWhileEditing;
    newPassWord.secureTextEntry = YES;
    newPassWord.placeholder = @"输入6~15位新密码";
    newPassWord.font = [UIFont systemFontOfSize:15.0f];
    newPassWord.borderStyle = UITextBorderStyleRoundedRect;
    self.newpassWord = newPassWord;
    [self.view addSubview:newPassWord];
    
    UITextField *reuse = [[UITextField alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(newPassWord.frame) + 15, SCREEN_WIDTH - 30, TabBar_Height)];
    reuse.clearButtonMode = UITextFieldViewModeWhileEditing;
    reuse.secureTextEntry = YES;
    reuse.placeholder = @"再次输入新密码";
    reuse.font = [UIFont systemFontOfSize:15.0f];
    reuse.borderStyle = UITextBorderStyleRoundedRect;
    self.reuse = reuse;
    [self.view addSubview:reuse];
}

/**
 *  提交按钮
 */
- (void)setupBtn {
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(self.reuse.frame) + 15, SCREEN_WIDTH - 30, 35)];
    
    [btn setTitle:@"确认提交" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = ThemeColor;
    [btn addTarget:self action:@selector(uploadContent) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
}

- (void)uploadContent {

    if ([self.newpassWord.text isEqualToString:@""] || [self.reuse.text isEqualToString:@""] || [self.original.text isEqualToString:@""])
    {
        [MBProgressHUD showError:@"密码不能为空" toView:nil];
        return;
    }
    
    if (![self.newpassWord.text isEqualToString:self.reuse.text]) {
        [MBProgressHUD showError:@"两次输入的密码不一样" toView:nil];
        return;
    }
    
    if (self.newpassWord.text.length < 6 || self.newpassWord.text.length > 15) {
        [MBProgressHUD showError:@"密码应在6~15位之间" toView:nil];
        self.newpassWord.text = @"";
        self.reuse.text = @"";
        return ;
    }
    
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"new_password_hash"] = self.newpassWord.text;
    paras[@"old_password_hash"] = self.original.text;
    [XDRequestHttpTool request_EditPassword_withUser_id:User_ID Parameters:paras complete:^(id result) {
        
        if ([result[@"code"] integerValue] == 200) {
            // 密码修改成功
            [MBProgressHUD showSuccess:@"修改成功" toView:nil];
            //            [self.navigationController popViewControllerAnimated:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"由于您的密码已经更改,需要重新登录" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        } else {
            [self.view makeToast:result[@"message"] duration:2.0 position:CSToastPositionCenter];
        }
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        [self.view makeToast:error.localizedDescription duration:2.0 position:CSToastPositionCenter];
    }];
}


#pragma mark - uialertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([alertView cancelButtonIndex] != buttonIndex) {
        [self logoutAction];
    }
}

- (void)logoutAction
{
    // 公钥加密
    NSString *encryWithPublicKeyStr = [RSAUtil encryptString:[NSString stringWithFormat:@"%@",User_ID] publicKey:kRSA_Public_key];
    
    [FKL_DataService requestURL:[NSString url_loginout_clearCidWithUserId:User_ID] parameters:nil headerKey:@"sign" headerValue:encryWithPublicKeyStr withType:@"DELETE" format:@"JSON" complete:^(id result) {
        if ([result[@"code"] integerValue] == 200) { // 删除成功
            
        } else if ([result[@"code"] integerValue] == 201) { // 不存在
            
        } else if ([result[@"code"] integerValue] == 202) { // 删除失败
            
        }
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
    
    __weak EditPasswordViewController *weakSelf = self;
    [self showHudInView:self.view hint:NSLocalizedString(@"setting.logoutOngoing", @"loging out...")];
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
        [weakSelf hideHud];
        if (error && error.errorCode != EMErrorServerNotLogin) {
            [weakSelf showHint:error.description];
        }
        else{
            [[ApplyViewController shareController] clear];
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
            // 关闭账号统计
            [MobClick profileSignOff];
        }
    } onQueue:nil];
}

@end
