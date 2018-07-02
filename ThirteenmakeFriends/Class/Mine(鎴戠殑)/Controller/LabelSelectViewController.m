//
//  LabelSelectViewController.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 16/5/17.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import "LabelSelectViewController.h"
#import "XQSelectMenuView.h"
#import "NSString+HXAddtions.h"
#import "MBProgressHUD+Add.h"
#import "ProfileUser.h"

@interface LabelSelectViewController ()<XQSelectMenuViewDelegate>

@property (nonatomic, weak) XQSelectMenuView *selectView;

@property (nonatomic, strong) NSMutableArray *unSelectLabelArray;

@end

@implementation LabelSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    XQSelectMenuView *selectView = [[XQSelectMenuView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, SCREEN_WIDTH,SCREEN_HEIGHT - NavigationBar_Height - kStatusBarHeight) andLabelColor:self.labelColor];
    [self.view addSubview:selectView];
    self.selectView = selectView;
    
    [self filterData];
    
    [self setupNavBar];
    
    // 未选择
    selectView.mainDatasource = self.unSelectLabelArray;
    // 已选择
    if ([self.title isEqualToString:kmyLabel]) {
        selectView.accessoryDatasource = self.user.mark;
    } else if ([self.title isEqualToString:kseekLabel]) {
        selectView.accessoryDatasource = self.user.make_friend;
    } else if ([self.title isEqualToString:@"兴趣爱好"]) {
        selectView.accessoryDatasource = self.user.hobby;
    } else {
        NSLog(@"标签选择超出范围    ");
        selectView.accessoryDatasource = nil;
    }
    
    selectView.mainTitle = @"未选标签:";
    selectView.accessoryTitle = kmyLabel;
    
    selectView.autoHeight = YES;
    
    selectView.delegate = self;
    
    self.selectView = selectView;
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
    
    UIButton *saveButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton setTitleColor:NormalNavBtnColor forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithCustomView:saveButton];
//    [self.navigationItem setRightBarButtonItem:saveItem];
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, saveItem];
    
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)save {
    NSString *jsonStr = [NSString jsonStringWithArray:self.selectView.accessoryDataArray];
    
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    if ([self.title isEqualToString:kmyLabel]) {
        paras[@"mark"] = jsonStr;
    } else if ([self.title isEqualToString:kseekLabel]) {
        paras[@"make_friend"] = jsonStr;
    } else if ([self.title isEqualToString:@"兴趣爱好"]) {
        paras[@"hobby"] = jsonStr;
    } else {
        NSLog(@"标签选择超出范围    ");
    }
    
    // 公钥加密
    NSString *encryWithPublicKeyStr = [RSAUtil encryptString:[NSString stringWithFormat:@"%@",User_ID] publicKey:kRSA_Public_key];
    
    [FKL_DataService requestURL:[NSString url_changeLabelInfo_withNumber:self.user.thirteen_platform_number] parameters:paras headerKey:@"sign" headerValue:encryWithPublicKeyStr withType:@"PATCH" format:@"JSON" complete:^(id result) {
    
        if ([result[@"code"] integerValue] == 200) {
            [MBProgressHUD showSuccess:@"更改成功！" toView:nil];
            if ([self.title isEqualToString:kmyLabel]) {
                self.user.mark = self.selectView.accessoryDataArray;
            } else if ([self.title isEqualToString:kseekLabel]) {
                self.user.make_friend = self.selectView.accessoryDataArray;
            } else if ([self.title isEqualToString:@"兴趣爱好"]) {
                self.user.hobby = self.selectView.accessoryDataArray;
            } else {
                NSLog(@"标签选择超出范围    ");
            }
            
            if ([self.delegate respondsToSelector:@selector(labelCountChanged)]) {
                [self.delegate labelCountChanged];
            }
            
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self.view makeToast:result[@"message"]
                        duration:2.0
                        position:CSToastPositionCenter];
        }
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        [self.view makeToast:error.localizedDescription
                    duration:2.0
                    position:CSToastPositionCenter];
    }];
}

- (void)cancel {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)seleteMenuDidChangeHeight{
    NSLog(@"高度改变了");
}
/**
 *  为未选择标签的数组赋值
 */
- (void)filterData {
    NSPredicate *thePredicate = nil;
    if ([self.title isEqualToString:kmyLabel]) {
        thePredicate = [NSPredicate predicateWithFormat:@"NOT (SELF in %@)", self.user.mark];
    } else if ([self.title isEqualToString:kseekLabel]) {
        thePredicate = [NSPredicate predicateWithFormat:@"NOT (SELF in %@)", self.user.make_friend];
    } else if ([self.title isEqualToString:@"兴趣爱好"]) {
        thePredicate = [NSPredicate predicateWithFormat:@"NOT (SELF in %@)", self.user.hobby];
    } else {
        NSLog(@"标签选择超出范围    ");
    }
    self.unSelectLabelArray = [NSMutableArray array];
    self.unSelectLabelArray = [NSMutableArray arrayWithArray:self.allLabelArray];
    [self.unSelectLabelArray filterUsingPredicate:thePredicate];
}

@end
