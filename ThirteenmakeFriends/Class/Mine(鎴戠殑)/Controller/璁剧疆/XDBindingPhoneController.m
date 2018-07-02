//
//  XDBindingPhoneController.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 16/11/16.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import "XDBindingPhoneController.h"
#import <SMS_SDK/SMSSDK.h>
#import "SMSSDKUIZonesViewController.h"
#import "FormatValidate.h"
#import "MBProgressHUD+MJ.h"
#import "ProfileUser.h"
#import "XDAccountTool.h"

#define LayoutColor [UIColor whiteColor]

@interface XDBindingPhoneController ()<UIAlertViewDelegate>
{
    NSInteger _count;
}
/**  手机号 */
@property(nonatomic,strong) UITextField *cellphone;
/**  验证码 */
@property(nonatomic,weak) UITextField *verifyCode;
/**  密码 */
@property(nonatomic,weak) UITextField *password;
/**  验证码按钮 */
@property(nonatomic,weak) UIButton *codeBtn;
/**  下一步按钮 */
@property(nonatomic,weak) UIButton * submitBtn;

/**  区域码按钮 */
@property(nonatomic,weak) UILabel *areaCodeField;

@property(nonatomic,strong) UILabel *voiceCallMsgLabel;

@property(nonatomic,strong) UIButton *voiceCallButton;

@property (nonatomic) SMSGetCodeMethod getCodeMethod;

@end

@implementation XDBindingPhoneController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"绑定手机号";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupSubViews];
}

- (void)setupSubViews {
    
    UIScrollView *contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    contentView.bounces = NO;
    [self.view addSubview:contentView];
    
    UILabel* areaCodeField = [[UILabel alloc] init];
    areaCodeField.size = CGSizeMake(80, 46);
    areaCodeField.text = [NSString stringWithFormat:@"+86"];
    areaCodeField.textColor = LayoutColor;
    areaCodeField.textAlignment = NSTextAlignmentCenter;
    areaCodeField.font = [UIFont fontWithName:@"Helvetica" size:18];
    areaCodeField.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *reg = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(areaSelected)];
    [areaCodeField addGestureRecognizer:reg];
    
    _cellphone = [[UITextField alloc] init];
    _cellphone.frame = CGRectMake(30, 25, self.view.frame.size.width - 60, 45);
    _cellphone.leftView = areaCodeField;
    _cellphone.leftViewMode = UITextFieldViewModeAlways;
    _cellphone.placeholder = @"请输入手机号码";
    [_cellphone setValue:RGB(186, 186, 186) forKeyPath:@"_placeholderLabel.textColor"];
    _cellphone.textColor = [UIColor whiteColor];
    _cellphone.font = [UIFont fontWithName:@"Helvetica" size:15];
    _cellphone.keyboardType = UIKeyboardTypePhonePad;
    _cellphone.clearButtonMode = UITextFieldViewModeWhileEditing;
    //改变输入框的边框颜色和样式
    _cellphone.backgroundColor = RGBA(14, 14, 14, 0.65);
    _cellphone.borderStyle = UITextBorderStyleRoundedRect;
    [contentView addSubview:_cellphone];
    self.areaCodeField = areaCodeField;
    
    UITextField *Verifycode = [[UITextField alloc]initWithFrame:CGRectMake(30,CGRectGetMaxY(_cellphone.frame) + 25,self.view.frame.size.width - 30*2 - 90 - 10,45)];
    Verifycode.borderStyle = UITextBorderStyleRoundedRect;
    Verifycode.placeholder= @"请输入验证码";
    Verifycode.textAlignment = NSTextAlignmentCenter;
    Verifycode.keyboardType = UIKeyboardTypePhonePad;
    Verifycode.font = [UIFont fontWithName:@"Helvetica" size:15];
    Verifycode.backgroundColor = [UIColor clearColor];
    Verifycode.textColor = [UIColor whiteColor];
    [Verifycode setValue:RGB(186, 186, 186) forKeyPath:@"_placeholderLabel.textColor"];
    //改变输入框的边框颜色和样式
    Verifycode.backgroundColor = RGBA(14, 14, 14, 0.65);
    Verifycode.borderStyle = UITextBorderStyleRoundedRect;
    [contentView addSubview:Verifycode];
    self.verifyCode = Verifycode;
    Verifycode.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 0)];
    //设置显示模式为永远显示(默认不显示)
    Verifycode.leftViewMode = UITextFieldViewModeAlways;
    
    UIButton * codeBtn=[UIButton new];
    [codeBtn setFrame:CGRectMake(CGRectGetMaxX(Verifycode.frame) + 10, Verifycode.frame.origin.y, 90, 45)];
    [codeBtn setBackgroundColor:[User_Sex isEqualToString:@"1"] ? Woman_NavigationBarColor : Man_NavigationBarColor];
    [codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [codeBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:15.0f]];
    [codeBtn setTitleColor:LayoutColor forState:UIControlStateNormal];
    [codeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    codeBtn.layer.cornerRadius = 5.0f;
    codeBtn.layer.masksToBounds = YES;
    [codeBtn addTarget:self action:@selector(sendCode) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:codeBtn];
    self.codeBtn = codeBtn;
    
    // 是否显示密码
    UIButton *isShowPwdButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [isShowPwdButton setImage:[UIImage imageNamed:@"unvisual"] forState:UIControlStateNormal];
    [isShowPwdButton setImage:[UIImage imageNamed:@"visual"] forState:UIControlStateSelected];
    isShowPwdButton.size = CGSizeMake(40, 40);
    [isShowPwdButton addTarget:self action:@selector(isShowPassword:) forControlEvents:UIControlEventTouchUpInside];
    
    UITextField *password = [[UITextField alloc]initWithFrame:CGRectMake(Verifycode.x,CGRectGetMaxY(Verifycode.frame) + 25,_cellphone.width,_cellphone.height)];
    password.borderStyle =UITextBorderStyleRoundedRect;
    password.placeholder= @"请设置6~15位新密码";
    password.rightView = isShowPwdButton;
    password.rightViewMode = UITextFieldViewModeAlways;
    [password setSecureTextEntry:YES];
    password.textAlignment = NSTextAlignmentCenter;
    password.font = [UIFont fontWithName:@"Helvetica" size:15];
    password.backgroundColor = [UIColor clearColor];
    password.textColor = [UIColor whiteColor];
    [password setValue:RGB(186, 186, 186) forKeyPath:@"_placeholderLabel.textColor"];
    //改变输入框的边框颜色和样式
    password.backgroundColor = RGBA(14, 14, 14, 0.65);
    password.borderStyle = UITextBorderStyleRoundedRect;
    [contentView addSubview:password];
    self.password = password;
    
    UIButton * submitBtn = [[UIButton alloc] init];
    [submitBtn setTitle:@"绑定" forState:UIControlStateNormal];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [submitBtn setTitleColor:LayoutColor forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [submitBtn setBackgroundColor:[User_Sex isEqualToString:@"1"] ? Woman_NavigationBarColor : Man_NavigationBarColor];
    submitBtn.layer.cornerRadius = 5.0f;
    submitBtn.layer.masksToBounds = YES;
    
    submitBtn.frame = CGRectMake(30, CGRectGetMaxY(password.frame) + 30, self.view.frame.size.width - 60, 45);
    [submitBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:submitBtn];
    self.submitBtn = submitBtn;
    
    _voiceCallMsgLabel = [[UILabel alloc] init];
    _voiceCallMsgLabel.frame = CGRectMake(30, CGRectGetMaxY(submitBtn.frame) + 10, self.view.frame.size.width - 60, 25);
    _voiceCallMsgLabel.textAlignment = NSTextAlignmentCenter;
    _voiceCallMsgLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
    [_voiceCallMsgLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
    _voiceCallMsgLabel.text = @"您也可以选择电话收听语音验证码：";
    _voiceCallMsgLabel.textColor = [UIColor blackColor];
    [contentView addSubview:_voiceCallMsgLabel];
    _voiceCallMsgLabel.hidden = YES;
    
    _voiceCallButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_voiceCallButton setTitle:@"收听语音验证码" forState:UIControlStateNormal];
    [_voiceCallButton setBackgroundColor:[User_Sex isEqualToString:@"1"] ? Woman_NavigationBarColor : Man_NavigationBarColor];
    _voiceCallButton.frame = CGRectMake(30, CGRectGetMaxY(_voiceCallMsgLabel.frame) + 10, self.view.frame.size.width - 60, 45);
    [_voiceCallButton setTitleColor:LayoutColor forState:UIControlStateNormal];
    [_voiceCallButton addTarget:self action:@selector(tryVoiceCall) forControlEvents:UIControlEventTouchUpInside];
    _voiceCallButton.layer.cornerRadius = 5.0f;
    _voiceCallButton.layer.masksToBounds = YES;
    [contentView addSubview:_voiceCallButton];
    _voiceCallButton.hidden = YES;
    
    contentView.contentSize = CGSizeMake(SCREEN_WIDTH, MAX(CGRectGetMaxY(_voiceCallButton.frame) + 48, self.view.height));
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.view endEditing:YES];
}

- (void)submit {
    
    if (self.verifyCode.text.length == 0){
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"验证码不能为空"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    if (self.password.text.length < 6 || self.password.text.length > 15) {
        [MBProgressHUD showError:@"密码应在6~15位之间"];
        self.password.text = @"";
        return ;
    }
    
    NSString *str2 = [self.areaCodeField.text stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    __weak __typeof(self)weakSelf = self;
    
    [self showHudInView:self.view hint:@"绑定中..."];
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"new_password_hash"] = self.password.text;
    paras[@"cellphone"] = self.cellphone.text;
    
    [FKL_DataService requestURL:[NSString url_bindingPhoneAndPassword_withUser_id:User_ID Zone:str2 Code:self.verifyCode.text] parameters:paras withType:@"PATCH" format:@"JSON" complete:^(id result) {
        [self hideHud];
        if ([result[@"code"] integerValue] == 200) {
            ProfileUser *user = [[ProfileUser alloc]init];
            user.cellphone = self.cellphone.text;
            [XDAccountTool save:user];
            [MBProgressHUD showSuccess:@"绑定成功"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } else {
            [weakSelf.view makeToast:result[@"message"] duration:2.0 position:CSToastPositionCenter];
        }
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideHud];
        [weakSelf.view makeToast:error.localizedDescription duration:2.0 position:CSToastPositionCenter];
    }];
    
}

- (void)isShowPassword:(UIButton *)btn {
    btn.selected = !btn.selected;
    [self.password setSecureTextEntry:!btn.selected];
}

- (void)sendCode {
    
    NSString *msg;
    if ([self.cellphone.text isEqualToString:@""]||(self.cellphone.text == nil)) {
        msg = @"手机号码不能为空";
    }
    if (msg.length !=0) {
        UIAlertView  *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        [alert show];
        return;
    }
    if (![FormatValidate validateMobile:self.cellphone.text]) {
        UIAlertView  *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"手机号格式不正确" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        [alert show];
        return;
    }
    
    [FKL_DataService requestURL:[NSString url_validateIsRegister_withPhone:self.cellphone.text] parameters:nil withType:@"GET" format:@"JSON" complete:^(id result) {
        if ([result[@"code"] integerValue] == 200) {
            
            [self performSelector:@selector(countClick) withObject:nil];
            
            NSString *str2 = [self.areaCodeField.text stringByReplacingOccurrencesOfString:@"+" withString:@""];
            NSLog(@"%@",str2);
            
            self.getCodeMethod = SMSGetCodeMethodSMS;
            //带自定义模版
            [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.cellphone.text zone:str2 template:SMS_template result:^(NSError *error) {
                if (!error) {
                    NSLog(@"获取验证码成功");
                } else {
                    NSLog(@"错误信息：%@",error);
                    UIAlertView  *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"%@",[[error.userInfo objectForKey:@"description"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
                    [alert show];
                    return;
                }
            }];
            
        } else {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"该手机号已被其他用户绑定,请绑定其他手机号"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"发生错误，请稍后重试"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    }];
}

-(void)countClick
{
    self.codeBtn.enabled =NO;
    _count = 60;
    [_codeBtn setTitle:@"60秒" forState:UIControlStateDisabled];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
}

-(void)timerFired:(NSTimer *)timer
{
    if (_count !=1) {
        _count -=1;
        [_codeBtn setTitle:[NSString stringWithFormat:@"%ld秒",_count] forState:UIControlStateDisabled];
    }
    else
    {
        [timer invalidate];
        _codeBtn.enabled = YES;
        [_codeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
    }
    
    
    if (_count == 30)
    {
        if (self.getCodeMethod == SMSGetCodeMethodSMS) {
            
            if (_voiceCallMsgLabel.hidden)
            {
                _voiceCallMsgLabel.hidden = NO;
            }
            
            if (_voiceCallButton.hidden)
            {
                _voiceCallButton.hidden = NO;
            }
        }
        
    }
}

- (void)areaSelected {
    XD_WeakSelf
    SMSSDKUIZonesViewController *vc = [[SMSSDKUIZonesViewController alloc] initWithResult:^(BOOL cancel, NSString *zone, NSString *countryName) {
        XD_StrongSelf
        if (!cancel && zone && countryName)
        {
            self.areaCodeField.text = zone;
        }
    }];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

#pragma mark - 发送语言验证码
- (void)tryVoiceCall {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"确定后将致电您的手机号，语音播报验证码。如不希望被来电打扰请使用短信验证码。"
                                                    message:[NSString stringWithFormat:@"%@: %@ %@",@"我们将发送验证码短信到这个号码",self.areaCodeField.text, self.cellphone.text]
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
    [alert show];
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView cancelButtonIndex] != buttonIndex)
    {
        NSString *str2 = [self.areaCodeField.text stringByReplacingOccurrencesOfString:@"+" withString:@""];
        //带自定义模版
        [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodVoice phoneNumber:self.cellphone.text zone:str2 template:SMS_template result:^(NSError *error) {
             if (error)
             {
//                 NSString *messageStr = [NSString stringWithFormat:@"%zidescription",error.code];
                 NSString *messageStr = [NSString stringWithFormat:@"%@",[[error.userInfo objectForKey:@"description"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                 UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"发送失败"
                                                                 message:messageStr
                                                                delegate:nil
                                                       cancelButtonTitle:@"确定"
                                                       otherButtonTitles:nil, nil];
                 [alert show];
             }
             
         }];
        
    }
    
}

@end
