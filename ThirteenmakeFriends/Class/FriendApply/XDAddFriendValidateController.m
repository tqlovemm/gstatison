
//
//  XDAddFriendValidateController.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 16/12/14.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import "XDAddFriendValidateController.h"
#import "ShiSanUser.h"

@interface XDAddFriendValidateController ()<UITextFieldDelegate>

@property (weak, nonatomic) UITextField *textField;


@end

@implementation XDAddFriendValidateController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"好友验证";
    self.view.backgroundColor = HEXCOLOR(0xefeff4);
    
    [self setupNavbar];
    
    UILabel *hintLabel = [[UILabel alloc] init];
    hintLabel.text = @"你需要发送验证申请，等对方通过";
    hintLabel.textColor = [UIColor grayColor];
    hintLabel.font = k13Font;
    [self.view addSubview:hintLabel];
    hintLabel.x = 15;
    hintLabel.y = 15;
    hintLabel.size = [hintLabel.text sizeWithFont:k13Font];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(hintLabel.frame) + 10, SCREEN_WIDTH, 44)];
    textField.backgroundColor = [UIColor whiteColor];
    textField.textColor = RGB(65, 65, 65);
    textField.font = k15Font;
    [self.view addSubview:textField];
    self.textField = textField;
    textField.clearButtonMode = UITextFieldViewModeAlways;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 0)];
    //设置显示模式为永远显示(默认不显示)
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.returnKeyType = UIReturnKeySend;
    textField.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.textField.text = [NSString stringWithFormat:@"我是%@",User_Name];
    [self.textField becomeFirstResponder];
}

- (void)setupNavbar {
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    backButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [backButton setTitle:@"取消" forState:UIControlStateNormal];
    [backButton setTitleColor:NormalNavBtnColor forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -10;
    self.navigationItem.leftBarButtonItems = @[negativeSpacer, backItem];
    
    UIBarButtonItem *leftNegativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
    // leftNegativeSpacer为占位符
    leftNegativeSpacer.width = -10;
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightBtn setTitle:@"发送" forState:UIControlStateNormal];
    [rightBtn setTitleColor:NormalNavBtnColor forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [rightBtn addTarget:self action:@selector(saveBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItems = @[leftNegativeSpacer, rightItem];
}

- (void)back:(UIButton *)btn {
    [self.textField resignFirstResponder];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveBtnClicked:(UIButton *)btn {
    
    [self.textField resignFirstResponder];
    [self addFriend];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.textField resignFirstResponder];
    [self addFriend];
    
    return YES;
    
}

- (void)addFriend {
    NSString *messageStr = @"";
    NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
    NSString *username = [loginInfo objectForKey:kSDKUsername];
    if (self.textField.text.length > 0) {
        messageStr = [NSString stringWithFormat:@"%@：%@", username, self.textField.text];
    }
    else{
        messageStr = [NSString stringWithFormat:@"%@ 邀请你为好友", username];
    }
    EMError *error;
    [[EaseMob sharedInstance].chatManager addBuddy:self.user.username message:messageStr error:&error];
    
    if (error) {
        [self showHint:@"发送申请失败，请重新操作"];
    }
    else{
        [self showHint:@"发送申请成功"];
    }
}

@end
