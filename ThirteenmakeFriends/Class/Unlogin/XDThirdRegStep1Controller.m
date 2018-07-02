//
//  XDThirdRegStep1Controller.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/12/1.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDThirdRegStep1Controller.h"
#import "XDThirdRegStep2Controller.h"
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

#define TextColor RGB(19, 19, 19)

@interface XDThirdRegStep1Controller ()<STPickerSingleDelegate,UITextFieldDelegate,UIAlertViewDelegate,STPickerDateDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,TOCropViewControllerDelegate>
{
    NSString *_sexStr;
    NSString *_avatarImageStr;
    BOOL isOpendCamera;
}

@property (weak, nonatomic) UIImageView *headIcon;
@property (weak, nonatomic) UITextField *nicknameField;
@property (weak, nonatomic) UITextField *birthTextField;
@property (weak, nonatomic) UITextField *sexField;
//! 性别数组
@property (nonatomic, strong) NSMutableArray *sexArray;
@property (strong, nonatomic) UIButton *regBtn;

/**  用户协议 */
@property(nonatomic,strong) UILabel * agreeLabel;

@property (strong, nonatomic) STPickerSingle *sexSingle;

@property (strong, nonatomic) ShiSanUser * user;

@end

@implementation XDThirdRegStep1Controller

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (instancetype )initWithUser:(ShiSanUser *)user {
    
    self.user = user;
    return self;
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
    
    self.title = @"第三方登录";
    
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
    
    UILabel* areaCodeField = [[UILabel alloc] init];
    areaCodeField.text = @"注：*性别一旦选择后便不可更改";
    areaCodeField.textColor = [UIColor whiteColor]; //RGB(186, 186, 186)
    areaCodeField.font = [UIFont fontWithName:@"Helvetica" size:12];
    areaCodeField.size = [areaCodeField.text sizeWithFont:[UIFont fontWithName:@"Helvetica" size:12]];
    areaCodeField.y = CGRectGetMaxY(birthTextField.frame) + 15;
    areaCodeField.x = birthTextField.x;
    [contentView addSubview:areaCodeField];
    
    UIButton * submitBtn = [[UIButton alloc] init];
    [submitBtn setTitle:@"下一步" forState:UIControlStateNormal];
    submitBtn.titleLabel.font = kPingFangRegularFont(16);
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    submitBtn.layer.cornerRadius = 24;
    submitBtn.layer.masksToBounds = YES;
    [submitBtn addTarget:self action:@selector(nextStep:) forControlEvents:UIControlEventTouchUpInside];
    submitBtn.backgroundColor = RGB(91,76,48);
    submitBtn.size = CGSizeMake(SCREEN_WIDTH - 75, 45);
    submitBtn.y = CGRectGetMaxY(birthTextField.frame) + 30;
    submitBtn.centerX = birthTextField.centerX;
    [contentView addSubview:submitBtn];
//    [submitBtn setShadowBackgroundColor];
    
    _agreeLabel = [[UILabel alloc] init];
    _agreeLabel.frame = CGRectMake(30, CGRectGetMaxY(submitBtn.frame) + 10, self.view.frame.size.width - 60, 25);
    _agreeLabel.textAlignment = NSTextAlignmentCenter;
    _agreeLabel.textColor = TextColor;
    _agreeLabel.font = kPingFangRegularFont(12);
    
//    NSMutableAttributedString *searchStr = [[NSMutableAttributedString alloc] initWithString:@"注册即表示同意"];
//    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"《十三用户协议》" attributes:@{NSForegroundColorAttributeName:ThemeColor1, NSFontAttributeName:[UIFont boldSystemFontOfSize:14]                                                                             }];
//    [searchStr appendAttributedString:str];
//    _agreeLabel.attributedText = searchStr;
//    [contentView addSubview:_agreeLabel];
//    _agreeLabel.userInteractionEnabled = YES;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(agreeViewClicked)];
//    [_agreeLabel addGestureRecognizer:tap];
    
    contentView.contentSize = CGSizeMake(SCREEN_WIDTH, MAX(SCREEN_HEIGHT, CGRectGetMaxY(submitBtn.frame) + 50));
    
    [self.headIcon sd_setImageWithURL:[NSURL URLWithString:self.user.avatar] placeholderImage:[UIImage imageNamed:@"avatar_default"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (!error) {
            NSData *data = UIImageJPEGRepresentation(image, 1);
            
            NSString *imageStr = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
            _avatarImageStr = imageStr;
        }
    }];
    self.nicknameField.text = self.user.nickname;
    self.sexField.text = [self.user.sex isEqualToString:@"1"] ? @"男" : @"女";
    self.birthTextField.text = self.user.birthdate;
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
//    [self.nicknameField resignFirstResponder];
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"修改头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
    [sheet showInView:self.view];
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
        // 1.发帖子
        //        NSData *data = UIImageJPEGRepresentation(image, 0.000001);
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

#pragma mark - 下一步
- (void)nextStep:(UIButton *)btn {
    XDThirdRegStep2Controller *stepVC = [[XDThirdRegStep2Controller alloc] init];
    stepVC.avatar = _avatarImageStr;
    stepVC.nickName = self.nicknameField.text;
    stepVC.sex = self.sexField.text;
    stepVC.birthdate = self.birthTextField.text;
    stepVC.user = self.user;
    [self.navigationController pushViewController:stepVC animated:YES];
}

@end
