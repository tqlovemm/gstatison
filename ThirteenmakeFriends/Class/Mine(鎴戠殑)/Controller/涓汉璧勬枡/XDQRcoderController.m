//
//  XDQRcoderController.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/11/17.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDQRcoderController.h"
#import "XDQrcoderCell.h"

@interface XDQRcoderController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,weak) UITableView *tableView;

@end

@implementation XDQRcoderController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的微信号";
    
    [self xdd_setupTableView];
    [self setupNavigationItem];
    [self setupForDismissKeyboard];
}

- (void)setupNavigationItem {
    UIButton *editButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    editButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [editButton setTitle:@"保存" forState:UIControlStateNormal];
    [editButton setTitleColor:NormalNavBtnColor forState:UIControlStateNormal];
    [editButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [editButton addTarget:self action:@selector(savePushOptions) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:editButton];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -5;
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, backItem];
}

- (void)xdd_setupTableView {
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT - NavigationBar_Height) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = HEXCOLOR(0xf0f0f2);
    tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

#pragma mark -TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XDQrcoderCell *cell = [XDQrcoderCell cellWithTableView:tableView];
    cell.qrCoder = self.qrCoder;
    cell.weichat = self.weichat;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewAutomaticDimension;
}

#pragma mark - 保存微信号和二维码
- (void)savePushOptions {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SaveWeichatMessage" object:nil];
}

@end
