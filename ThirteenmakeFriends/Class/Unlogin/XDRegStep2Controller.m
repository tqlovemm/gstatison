//
//  XDRegStep2Controller.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/12/1.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDRegStep2Controller.h"
#import "MBProgressHUD+Add.h"
#import "STPickerSingle.h"
#import "STPickerDate.h"
#import "NSCalendar+ST.h"
#import "ShiSanUser.h"
#import "FormatValidate.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD+Text.h"

// 头像昵称
#import "UserProfileManager.h"
#import "XDAccountTool.h"
#import "ProfileUser.h"
#import "MJExtension.h"
#import "TOCropViewController.h"
#import "XDLocalHtmlViewController.h"
#import "UIView+XDGradientColor.h"
#import "PooCodeView.h"
#import "DefineKeyChain.h"
#define TextColor [UIColor whiteColor]

@interface XDRegStep2Controller ()<STPickerSingleDelegate,UITextFieldDelegate,UIAlertViewDelegate,STPickerDateDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,TOCropViewControllerDelegate>
{
    NSString *_sexStr;
    NSString *_avatarImageStr;
    BOOL isOpendCamera;
}

@property (weak, nonatomic) UIImageView *headIcon;
@property (weak, nonatomic) UITextField *nicknameField;
@property (weak, nonatomic) UITextField *birthTextField;
@property (weak, nonatomic) UITextField *sexField;
@property (nonatomic, strong) PooCodeView *pooCodeView;
@property (weak, nonatomic) UITextField *pooCode;
//! 性别数组
@property (nonatomic, strong) NSMutableArray *sexArray;
@property (strong, nonatomic) UIButton *regBtn;
@property (assign,nonatomic)NSInteger   index;//一个设备注册账号成功的次数
/**  用户协议 */
@property(nonatomic,strong) UILabel * agreeLabel;

@property (strong, nonatomic) STPickerSingle *sexSingle;
//存入kechian中
@property (strong,nonatomic) NSMutableDictionary *saveInfomation;
@end

@implementation XDRegStep2Controller

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

-(NSMutableArray *)sexArray {
    if (_sexArray == nil) {
        _sexArray = [NSMutableArray arrayWithObjects:@"男",@"女", nil];
    }
    return _sexArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:RGB(24, 22, 20)] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName:kPingFangRegularFont(18)}];
    //去除 navigationBar 底部的细线
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    self.title = @"完善资料";
    
    _index = 1;
    
    self.saveInfomation = [NSMutableDictionary dictionary];
    
    [self setupForDismissKeyboard];
    
    [self setupSubViews];
    
    [self setupNavigationBar];
}

- (void)setupNavigationBar {
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"gray_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -12;
    self.navigationItem.leftBarButtonItems = @[negativeSpacer, backItem];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setupSubViews {
    
    // 背景图
    UIImageView *backgroundImage = [[UIImageView alloc]init];
    backgroundImage.image = [UIImage imageNamed:@"login_bg"];
    [self.view addSubview:backgroundImage];
    [backgroundImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    UIScrollView *contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationBar_Height)];
    contentView.bounces = NO;
    [self.view addSubview:contentView];
    
    if (@available(iOS 11.0, *)) {
        contentView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    //头像
    UIImageView *logoImage = [[UIImageView alloc]init];
    logoImage.image = [UIImage imageNamed:@"add_user_avatar"];
    logoImage.layer.cornerRadius = 5.0f;
    logoImage.layer.masksToBounds = YES;
    logoImage.size = CGSizeMake(73, 73);
    logoImage.centerX = self.view.width / 2.0;
    logoImage.y = 30;
    logoImage.userInteractionEnabled = YES;
    [contentView addSubview:logoImage];
    self.headIcon = logoImage;
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headIconClicked)];
    tapGr.cancelsTouchesInView = NO;
    [self.headIcon addGestureRecognizer:tapGr];
    
    UITextField *nicknameField = [[UITextField alloc] init];
    nicknameField.frame = CGRectMake(30, CGRectGetMaxY(logoImage.frame) + 33, self.view.frame.size.width - 60, 45);
    nicknameField.placeholder= @"请输入昵称";
    [nicknameField setValue:ThemeColor8 forKeyPath:@"_placeholderLabel.textColor"];
    nicknameField.textColor = TextColor;
    nicknameField.font = kPingFangRegularFont(16);
    nicknameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    nicknameField.textAlignment = NSTextAlignmentLeft;
    nicknameField.keyboardType = UIKeyboardTypeDefault;
    nicknameField.backgroundColor = [UIColor clearColor];
    
    [contentView addSubview:nicknameField];
    self.nicknameField = nicknameField;
    
    UIView *lineView1 = [[UIView alloc] init];
    lineView1.backgroundColor = RGB(42, 42, 42);
    lineView1.frame = CGRectMake(self.nicknameField.x, CGRectGetMaxY(self.nicknameField.frame), self.nicknameField.width, 1);
    [contentView addSubview:lineView1];
    
    UITextField *sexField = [[UITextField alloc] init];
    sexField.frame = CGRectMake(30, CGRectGetMaxY(nicknameField.frame) + 10, self.view.frame.size.width - 60, 45);
    sexField.placeholder= @"请选择性别";
    [sexField setValue:ThemeColor8 forKeyPath:@"_placeholderLabel.textColor"];
    sexField.textColor = TextColor;
    sexField.font = kPingFangRegularFont(16);
    sexField.textAlignment = NSTextAlignmentLeft;
    sexField.backgroundColor = [UIColor clearColor];
    sexField.delegate = self;
    [contentView addSubview:sexField];
    self.sexField = sexField;
    
    UIView *lineView2 = [[UIView alloc] init];
    lineView2.backgroundColor = RGB(42, 42, 42);
    lineView2.frame = CGRectMake(self.sexField.x, CGRectGetMaxY(self.sexField.frame), self.sexField.width, 1);
    [contentView addSubview:lineView2];
    
    UITextField *birthTextField = [[UITextField alloc] init];
    birthTextField.frame = CGRectMake(30, CGRectGetMaxY(sexField.frame) + 10, self.view.frame.size.width - 60, 45);
    birthTextField.placeholder = @"请选择出生日期";
    [birthTextField setValue:ThemeColor8 forKeyPath:@"_placeholderLabel.textColor"];
    birthTextField.textColor = TextColor;
    birthTextField.font = kPingFangRegularFont(16);
    birthTextField.textAlignment = NSTextAlignmentLeft;
    birthTextField.backgroundColor = [UIColor clearColor];
    birthTextField.delegate = self;
    [contentView addSubview:birthTextField];
    self.birthTextField = birthTextField;
    
    UIView *lineView3 = [[UIView alloc] init];
    lineView3.backgroundColor = RGB(42, 42, 42);
    lineView3.frame = CGRectMake(self.birthTextField.x, CGRectGetMaxY(self.birthTextField.frame), self.birthTextField.width, 1);
    [contentView addSubview:lineView3];
    
//    _pooCodeView = [[PooCodeView alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(birthTextField.frame) + 10, 120, 45) andChangeArray:nil];
//    _pooCodeView.textSize = 25;
//    _pooCodeView.textColor = ThemeColor1;
//    [contentView addSubview:_pooCodeView];
//    UITextField *poocode = [[UITextField alloc] init];
//    poocode.frame = CGRectMake(CGRectGetMaxX(_pooCodeView.frame)+10, CGRectGetMaxY(birthTextField.frame)+15, self.view.frame.size.width - 120, 45);
//    poocode.placeholder = @"请输入左侧验证码";
//    [poocode setValue:ThemeColor8 forKeyPath:@"_placeholderLabel.textColor"];
//    poocode.textColor = TextColor;
//    poocode.font = kPingFangRegularFont(16);
//    poocode.textAlignment = NSTextAlignmentLeft;
//    poocode.backgroundColor = [UIColor clearColor];
//    poocode.delegate = self;
//    [contentView addSubview:poocode];
//    self.pooCode = poocode;
//    UIView *lineView = [[UIView alloc] init];
//    lineView.backgroundColor = RGB(240, 239, 245);
//    lineView.frame = CGRectMake(self.pooCodeView.x, CGRectGetMaxY(self.pooCode.frame), self.birthTextField.width, 1);
//    [contentView addSubview:lineView3];
    
//    UILabel* areaCodeField = [[UILabel alloc] init];
//    areaCodeField.text = @"注：*性别一旦选择后便不可更改";
//    areaCodeField.textColor = [UIColor whiteColor]; //RGB(186, 186, 186)
//    areaCodeField.font = [UIFont fontWithName:@"Helvetica" size:12];
//    areaCodeField.size = [areaCodeField.text sizeWithFont:[UIFont fontWithName:@"Helvetica" size:12]];
//    areaCodeField.y = CGRectGetMaxY(birthTextField.frame) + 15;
//    areaCodeField.x = birthTextField.x;
//    [contentView addSubview:areaCodeField];
    
    _agreeLabel = [[UILabel alloc] init];
    _agreeLabel.frame = CGRectMake(30, CGRectGetMaxY(lineView3.frame) + 15, self.view.frame.size.width - 60, 25);
    _agreeLabel.textAlignment = NSTextAlignmentCenter;
    _agreeLabel.textColor = TextColor;
    _agreeLabel.font = kPingFangRegularFont(12);
    
    NSMutableAttributedString *searchStr = [[NSMutableAttributedString alloc] initWithString:@"注册即表示同意"];
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"《G station用户协议》" attributes:@{NSForegroundColorAttributeName:[UIColor
                                                                                                                        whiteColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:12]                                                                             }];
    [searchStr appendAttributedString:str];
    _agreeLabel.attributedText = searchStr;
    [contentView addSubview:_agreeLabel];
    _agreeLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(agreeViewClicked)];
    [_agreeLabel addGestureRecognizer:tap];
    
    UIButton * submitBtn = [[UIButton alloc] init];
    [submitBtn setTitle:@"完成" forState:UIControlStateNormal];
    submitBtn.layer.cornerRadius = 20;
    submitBtn.layer.shadowRadius = 3;
    submitBtn.titleLabel.font = kPingFangRegularFont(16);
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    submitBtn.layer.cornerRadius = 24;
    submitBtn.layer.masksToBounds = YES;
    [submitBtn addTarget:self action:@selector(doRegister:) forControlEvents:UIControlEventTouchUpInside];
    submitBtn.backgroundColor = RGB(91,76,48);
    //    submitBtn.size = CGSizeMake(SCREEN_WIDTH - 75, 45);
    //    submitBtn.y = CGRectGetMaxY(_pooCodeView.frame) + 30;
    //    submitBtn.centerX = birthTextField.centerX;
    [contentView addSubview:submitBtn];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_agreeLabel.mas_bottom).offset(30);
        make.left.equalTo(contentView).offset(30)
        ;
        make.width.equalTo(contentView).offset(-60);
        make.height.equalTo(@45);
    }];
    //    [submitBtn setShadowBackgroundColor];
    
    contentView.contentSize = CGSizeMake(SCREEN_WIDTH, MAX(SCREEN_HEIGHT, CGRectGetMaxY(submitBtn.frame) + 50));
}

- (void)doRegister:(UIButton *)sender {
    
        if (![self isEmpty]) {
            //隐藏键盘
            [self.view endEditing:YES];
            
            
            if (![FormatValidate validateLetterAndNumber:self.cellPhone]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"用户名只能输入英文和数字的组合"
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
                
                [alert show];
                
                return;
            }
            
            int result1 = [_pooCodeView.changeString compare:_pooCode.text options:NSCaseInsensitiveSearch];
            
            if ((_pooCodeView.changeString.length == _pooCode.text.length ) && (result1 == 0)) {
                NSString *sexStr = @"1";
                if ([_sexField.text isEqualToString:@"男"]) {
                    sexStr = @"1";
                } else if ([_sexField.text isEqualToString:@"女"]) {
                    sexStr = @"2";
                }
                
                NSDictionary *dict = @{@"出生年份" : [self.birthTextField.text substringWithRange:NSMakeRange(0, 4)],@"性别" : [sexStr isEqualToString:@"1"] ? @"男" : @"女"};
                [MobClick event:@"register" attributes:dict];
                
                NSMutableDictionary *paras = [NSMutableDictionary dictionary];
                paras[@"cellphone"] = self.cellPhone;
                paras[@"zone"] = self.zone;
                paras[@"code"] = self.verificationCode;
                paras[@"username"] = self.nicknameField.text;
                paras[@"avatar"] = _avatarImageStr;
                paras[@"password_hash"] = self.password;
                paras[@"sex"] = sexStr;
                paras[@"birthday"] = _birthTextField.text;
                paras[@"client_id"] = [GeTuiSdk clientId];
                paras[@"invite_code"] = self.inviteCode;
                
                [self showHudInView:self.view hint:@"注册登录中..."];
                
                [XDRequestHttpTool request_register_withParameters:paras complete:^(id result) {
                    if ([result[@"code"] intValue] == 200) {
                        
                        ProfileUser *user = [ProfileUser objectWithKeyValues:result[@"data"]];
                        [XDAccountTool save:user];
                        
                        // 保存用户信息
                        [self saveLoginMessage:result];
                        // 账号统计
//                        [MobClick profileSignInWithPUID:[NSString stringWithFormat:@"%@",result[@"data"][@"id"]]];
                        // 头像昵称
                        [UserProfileManager saveInfo:result[@"data"][@"cellphone"] imgUrl:result[@"data"][@"avatar"] nickName:result[@"data"][@"username"]];
       
                        // 发送登录通知
                        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@(YES)];
                        
                       
                        // 登录
//                        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//                        NSString *hxpassword = [ud objectForKey:HuangXingPwd];
//                        [self loginWithUsername:User_Name password:hxpassword];
//                        _index++;
//                        if (_index > 3) {
//                            int value = arc4random() % 999999;
//                            NSString *ValueString = [NSString stringWithFormat:@"%d", value];
//                            [self.saveInfomation setObject:ValueString forKey:@"KEY_IDENT"];
//                            [DefineKeyChain save:@"KEY_INFORMATION" data:self.saveInfomation];
//                        }
                    } else {
                        [self.view makeToast:result[@"message"] duration:2.0 position:CSToastPositionCenter];
                    }
                    
                    [self hideHud];
                } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
                    NSLog(@"%@",error);
                    [self hideHud];
                    [self.view makeToast:error.localizedDescription duration:2.0 position:CSToastPositionCenter];
                }];
            }
        }
}

//判断账号和密码是否为空
- (BOOL)isEmpty{
    
    BOOL ret = NO;
    NSString *sexStr = _sexField.text;
    NSString *avatar = _avatarImageStr;
    NSString *nickname = self.nicknameField.text;
    NSString *birthdate = self.birthTextField.text;
    
    if (sexStr.length == 0 || avatar.length == 0 || nickname.length == 0 || birthdate.length == 0) {
        ret = YES;
        [EMAlertView showAlertWithTitle:nil
                                message:@"所有信息不能为空"
                        completionBlock:nil
                      cancelButtonTitle:NSLocalizedString(@"ok", @"OK")
                      otherButtonTitles:nil];
    }
    return ret;
}

#pragma  mark - TextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (textField == _sexField) {
        [self.view endEditing:YES];
        STPickerSingle *single = [[STPickerSingle alloc]init];
        [single setArrayData:self.sexArray];
        [single setTitle:@"请选择性别"];
        [single setTitleUnit:@""];
        [single setDelegate:self];
        [single show];
        self.sexSingle = single;
        return NO;
    } else if ([textField isEqual:self.birthTextField]) {
        [self.view endEditing:YES];
        STPickerDate *datePicker = [[STPickerDate alloc]initWithDelegate:self];
        [datePicker show];
        return NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField endEditing:YES];
    return YES;
}

- (void)saveLoginMessage:(NSDictionary *)result {
    // 将数据全部存储到NSUserDefaults中
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:[NSString stringWithFormat:@"%@",result[@"data"][@"user_id"]] forKey:LoginUserID];
    [ud setObject:result[@"data"][@"username"] forKey:LoginName];
    [ud setObject:result[@"data"][@"sex"] forKey:LoginSex];
    [ud setObject:result[@"data"][@"avatar"] forKey:LoginAvatar];
    [ud setObject:result[@"data"][@"none"] forKey:HuangXingPwd];
    
    // 这里建议同步存储到磁盘中，但是不是必须的
    [ud synchronize];
}

- (void)pickerSingle:(STPickerSingle *)pickerSingle selectedTitle:(NSString *)selectedTitle
{
    if ([pickerSingle isEqual:self.sexSingle]) {
        NSString *text = [NSString stringWithFormat:@"%@", selectedTitle];
        _sexStr = text;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"性别一经选择后无法更改,是否确定"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定",nil];
        
        [alert show];
    }
}

- (void)pickerDate:(STPickerDate *)pickerDate year:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
{
    NSString *text = [NSString stringWithFormat:@"%04ld-%02ld-%02ld", year, month, day];
    
    NSInteger nowYear = [NSCalendar currentYear];
    if ((nowYear - year) < 18) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告"
                                                        message:@"本应用仅供18周岁以上成人使用"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        
        [alert show];
        return ;
    }
    self.birthTextField.text = text;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([alertView cancelButtonIndex] != buttonIndex) {
        self.sexField.text = _sexStr;
    }
}

#pragma mark - 头像点击
- (void)headIconClicked {
    [self.nicknameField resignFirstResponder];
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"修改头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
    [sheet showInView:self.view];
}

#pragma mark - //点击登陆后的操作
- (void)loginWithUsername:(NSString *)username password:(NSString *)password
{
    //异步登陆账号
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:username
                                                        password:password
                                                      completion:
     ^(NSDictionary *loginInfo, EMError *error) {
         [self hideHud];
         if (loginInfo && !error) {
             //设置是否自动登录
             [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
             
             // 旧数据转换 (如果您的sdk是由2.1.2版本升级过来的，需要家这句话)
             [[EaseMob sharedInstance].chatManager importDataToNewDatabase];
             //获取数据库中数据
             [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
             
             //获取群组列表
             [[EaseMob sharedInstance].chatManager asyncFetchMyGroupsList];
             
             //发送自动登陆状态通知
             [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@([[[EaseMob sharedInstance] chatManager] isLoggedIn])];
             
             //保存最近一次登录用户名
             [self saveLastLoginUsername];
         }
         else
         {
             switch (error.errorCode)
             {
                 case EMErrorNotFound:
                     TTAlertNoTitle(error.description);
                     break;
                 case EMErrorNetworkNotConnected:
                     TTAlertNoTitle(NSLocalizedString(@"error.connectNetworkFail", @"No network connection!"));
                     break;
                 case EMErrorServerNotReachable:
                     TTAlertNoTitle(NSLocalizedString(@"error.connectServerFail", @"Connect to the server failed!"));
                     break;
                 case EMErrorServerAuthenticationFailure:
                     TTAlertNoTitle(error.description);
                     break;
                 case EMErrorServerTimeout:
                     TTAlertNoTitle(NSLocalizedString(@"error.connectServerTimeout", @"Connect to the server timed out!"));
                     break;
                 default:
                     TTAlertNoTitle(NSLocalizedString(@"login.fail", @"Login failure"));
                     break;
             }
         }
     } onQueue:nil];
}

#pragma  mark - private
- (void)saveLastLoginUsername
{
    NSString *username = [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:kSDKUsername];
    if (username && username.length > 0) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:username forKey:[NSString stringWithFormat:@"em_lastLogin_%@",kSDKUsername]];
        [ud synchronize];
    }
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        if (buttonIndex != actionSheet.cancelButtonIndex) {
            if (buttonIndex == actionSheet.firstOtherButtonIndex) {
                [self openCamera];
            } else if (buttonIndex == actionSheet.firstOtherButtonIndex + 1) {
                [self openAlbum];
            }
        }
    }
}

- (void)openAlbum {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) return;
    
    isOpendCamera = NO;
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    // 接管控制状态栏的外观
    ipc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    ipc.navigationBar.translucent = NO;
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //    ipc.allowsEditing = YES;
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];
    
}

- (void)openCamera {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) return;
    
    isOpendCamera = YES;
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];
}

#pragma mark - TOCropViewController Delegate
- (void)cropViewController:(TOCropViewController *)cropViewController didCropToCircularImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    
    [cropViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
    self.headIcon.image = image;
    
    if (image) {
        NSData *data = [image wxImageSize:image];
        
        NSString *imageStr = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
        _avatarImageStr = imageStr;
        
    }
}

- (void)cropViewController:(nonnull TOCropViewController *)cropViewController didFinishCancelled:(BOOL)cancelled {
    if (isOpendCamera) {
        [cropViewController.presentingViewController dismissViewControllerAnimated:NO completion:nil];
    } else {
        [cropViewController.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // 取出选中的图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    TOCropViewController *cropViewController = [[TOCropViewController alloc] initWithCroppingStyle:TOCropViewCroppingStyleCircular image:image];
    cropViewController.delegate = self;
    [picker pushViewController:cropViewController animated:YES];
}

#pragma mark - 用户协议
- (void)agreeViewClicked {
    XDLocalHtmlViewController *agreeVC = [XDLocalHtmlViewController localHtmlViewControllerWithHtmlTitle:@"用户协议" HtmlString:@"http://www.vcooline.com/app/materials/320540"];
    
    [self.navigationController pushViewController:agreeVC animated:YES];
}

@end
