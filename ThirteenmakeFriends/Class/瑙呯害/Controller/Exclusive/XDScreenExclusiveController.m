//
//  XDScreenExclusiveController.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/9/6.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDScreenExclusiveController.h"
#import "XDScreenHeaderView.h"
#import "XDSeekScreenCell.h"
#import "XDAreaModel.h"
#import "STPickerSingle.h"

@interface XDScreenExclusiveController ()<UITableViewDelegate,UITableViewDataSource,STPickerSingleDelegate>
/** tableView */
@property (nonatomic ,weak) UITableView *tableView;
/** 地区名数组 */
@property (nonatomic ,strong) NSArray *areaNameArray;

@end

@implementation XDScreenExclusiveController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self xdd_setupTableView];
    [self setupTableHeaderView];
    [self setupNavBar];
    [self setupAreaInfo];
}

- (void)setupNavBar {
    
    self.title = @"专属筛选";
    
    UIBarButtonItem *leftNegativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    backButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [backButton setTitle:@"取消" forState:UIControlStateNormal];
    [backButton setTitleColor:NormalNavBtnColor forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    leftNegativeSpacer.width = -12;
    self.navigationItem.leftBarButtonItems = @[leftNegativeSpacer, backItem];
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitleColor:NormalNavBtnColor forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItems = @[leftNegativeSpacer, rightItem];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)send {
    [self.navigationController popViewControllerAnimated:YES];
    if (self.downButtonClicked) {
        self.downButtonClicked(self.areaModel);
    }
}

#pragma mark - 获取地区信息
/**
 *  获取地区信息
 */
- (void)setupAreaInfo {
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"area"] = @"1";
    [FKL_DataService requestURL:[NSString url_getExclusiveRegionInfo] parameters:paras withType:@"GET" format:@"JSON" complete:^(id result) {
        NSLog(@"%@",result);
        NSMutableArray *arr = [NSMutableArray arrayWithArray:result];
        [arr insertObject:@"不限" atIndex:0];
        self.areaNameArray = arr;
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        [self.view makeToast:error.localizedDescription
                    duration:2.0
                    position:CSToastPositionCenter];
    }];
}

#pragma mark - 创建tableview相关控件
/**
 *  创建tableview
 */
- (void)xdd_setupTableView {
    // 今日觅约
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.rowHeight = 60;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

- (void)setupTableHeaderView {
    XDScreenHeaderView *headerView = [[XDScreenHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 125)];
    self.tableView.tableHeaderView = headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 1、创建Cell
    XDSeekScreenCell *cell = [XDSeekScreenCell cellWithTableView:tableView];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.desLabel.text = self.areaModel ? self.areaModel : @"不限";
    // 3、返回Cell
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.areaNameArray.count == 0) {
        [self.view makeToast:@"觅约地区信息获取失败，请重试"
                    duration:2.0
                    position:CSToastPositionCenter];
        [self setupAreaInfo];
        return ;
    }
    
    STPickerSingle *single = [[STPickerSingle alloc]init];
    [single setArrayData:(NSMutableArray *)self.areaNameArray];
    [single setTitle:@"请选择地区"];
    [single setTitleUnit:@""];
    [single setDelegate:self];
    [single show];
}

#pragma mark - STPickerSingleDelegate
- (void)pickerSingle:(STPickerSingle *)pickerSingle selectedTitle:(NSString *)selectedTitle
{
    NSString *text = [NSString stringWithFormat:@"%@", selectedTitle];
    
    NSUInteger index = [self.areaNameArray indexOfObject:text];
    
    if (index > 0) {
        self.areaModel = [self.areaNameArray objectAtIndex:index];
    } else {
        self.areaModel = nil;
    }
    
    [self.tableView reloadData];
}

@end
