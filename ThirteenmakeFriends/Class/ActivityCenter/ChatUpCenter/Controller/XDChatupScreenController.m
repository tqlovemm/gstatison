//
//  XDChatupScreenController.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2018/1/12.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import "XDChatupScreenController.h"
#import "XDScreenHeaderView.h"
#import "XDSeekScreenCell.h"
#import "XDAreaModel.h"
#import "STPickerSingle.h"
#import "XDMultiPickerView.h"

@interface XDChatupScreenController ()<UITableViewDelegate,UITableViewDataSource,STPickerSingleDelegate>
/** tableView */
@property (nonatomic ,weak) UITableView *tableView;

/** 地区数组 */
@property (nonatomic ,strong) NSArray *areaArray;
/** 地区名数组 */
@property (nonatomic ,strong) NSArray *areaNameArray;
/** 性别数组 */
@property (nonatomic ,strong) NSArray *sexArray;
/** 会员/已认证数组 */
@property (nonatomic ,strong) NSArray *vipArray;
/** 开始年龄数组 */
@property (nonatomic ,strong) NSArray *starAgeArray;
/** 截止年龄数组 */
@property (nonatomic ,strong) NSArray *endAgeArray;

@property (nonatomic, strong) STPickerSingle *areaSingle;
@property (nonatomic, strong) STPickerSingle *sexSingle;
@property (nonatomic, strong) STPickerSingle *vipSingle;

@end

@implementation XDChatupScreenController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"广场筛选";
    
    self.sexArray = @[@"不限", @"男", @"女"];
    self.vipArray = @[@"不限", @"会员/已认证"];
    
    
    [self xdd_setupTableView];
    [self setupTableHeaderView];
    [self setupNavBar];
    [self setupAreaInfo];
}

- (void)setupNavBar {
    
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
        self.downButtonClicked(self.areaModel, self.startAge, self.endAge, self.sex, self.is_vip);
    }
}

#pragma mark - 获取地区信息
/**
 *  获取地区信息
 */
- (void)setupAreaInfo {
    
    [self showHudInView:self.view hint:nil];
    
    // 公钥加密
    NSString *encryWithPublicKeyStr = [RSAUtil encryptString:[NSString stringWithFormat:@"%@",User_ID] publicKey:kRSA_Public_key];
    [FKL_DataService requestURL:[NSString url_getSendNewSaveme_info] parameters:nil headerKey:@"sign" headerValue:encryWithPublicKeyStr withType:@"GET" format:@"JSON" complete:^(id result) {
        [self hideHud];
        if ([result[@"code"] integerValue] == 200) {
            self.areaArray = [NSMutableArray arrayWithArray:[XDAreaModel objectArrayWithKeyValuesArray:result[@"data"][@"area_list"]]];
            NSMutableArray *areaArr = [NSMutableArray array];
            [areaArr addObject:@"不限"];
            for (XDAreaModel *area in self.areaArray) {
                [areaArr addObject:area.area];
            }
            self.areaNameArray = areaArr;
        } else {
            [self.view makeToast:result[@"message"]
                        duration:2.0
                        position:CSToastPositionCenter];
        }
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideHud];
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
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 1、创建Cell
    XDSeekScreenCell *cell = [XDSeekScreenCell cellWithTableView:tableView];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    switch (indexPath.row) {
        case 0:
            cell.tipLabel.text = @"性别";
//            cell.desLabel.text = self.sex ? self.sex : @"不限";
            cell.desLabel.text = self.sex ? [self.sex isEqualToString:@"1"] ? @"女" : @"男" : @"不限";
            break;
        case 1:
            cell.tipLabel.text = @"年龄";
            cell.desLabel.text = self.startAge ? [NSString stringWithFormat:@"%@ ~ %@",self.startAge,self.endAge] : @"不限";
            break;
        case 2:
            cell.tipLabel.text = @"地区";
            cell.desLabel.text = self.areaModel ? self.areaModel.area : @"不限";
            break;
        case 3:
            cell.tipLabel.text = @"其他";
            cell.desLabel.text = self.is_vip ? @"会员/已认证" : @"不限";
            break;
            
        default:
            break;
    }
    // 3、返回Cell
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        STPickerSingle *single = [[STPickerSingle alloc]init];
        [single setArrayData:[NSMutableArray arrayWithArray:self.sexArray]];
        [single setTitle:@"请选择性别"];
        [single setTitleUnit:@""];
        [single setDelegate:self];
        [single show];
        self.sexSingle = single;
    } else if (indexPath.row == 1) {
        NSMutableArray *ageArray = [NSMutableArray array];
        for (int index = 18; index < 60; index++) {
            NSMutableArray *secondArray = [NSMutableArray array];
            for (int i = index + 1; i <= 60; i++) {
                [secondArray addObject:[NSString stringWithFormat:@"%d",i]];
            }
            
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",index],@"state",secondArray,@"cities", nil];
            [ageArray addObject:dic];
        }
        
        XDMultiPickerView *pickerView = [[XDMultiPickerView alloc] initWithArrayData:ageArray delegate:self];
        [pickerView show];
    } else if (indexPath.row == 2) {
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
        self.areaSingle = single;
    } else {
        STPickerSingle *single = [[STPickerSingle alloc]init];
        [single setArrayData:[NSMutableArray arrayWithArray:self.vipArray]];
        [single setTitle:@"请选择会员/已认证"];
        [single setTitleUnit:@""];
        [single setDelegate:self];
        [single show];
        self.vipSingle = single;
    }
}

#pragma mark - STPickerSingleDelegate
- (void)pickerSingle:(STPickerSingle *)pickerSingle selectedTitle:(NSString *)selectedTitle
{
    NSString *text = [NSString stringWithFormat:@"%@", selectedTitle];
    
    if ([pickerSingle isEqual:self.sexSingle]) {
        NSUInteger index = [self.sexArray indexOfObject:text];
        
        if (index > 0) {
            self.sex = index == 2 ? @"1" : @"0";
        } else {
            self.sex = nil;
        }
    } else if ([pickerSingle isEqual:self.areaSingle]) {
        NSUInteger index = [self.areaNameArray indexOfObject:text];
        
        if (index > 0) {
            self.areaModel = [self.areaArray objectAtIndex:index-1];
        } else {
            self.areaModel = nil;
        }
    } else {
        NSUInteger index = [self.vipArray indexOfObject:text];
        
        if (index > 0) {
            self.is_vip = @"1";
        } else {
            self.is_vip = nil;
        }
    }
    
    [self.tableView reloadData];
}

#pragma mark - XDMultiPickerViewDelegate
- (void)pickerMultiView:(XDMultiPickerView *)pickerMultiView selectedStart:(NSString *)atartAge selectedEnd:(NSString *)endAge {
    self.startAge = atartAge;
    self.endAge = endAge;
    
    [self.tableView reloadData];
}

@end
