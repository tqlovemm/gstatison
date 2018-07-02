
//
//  XDNewSavemeScreenController.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2018/1/10.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import "XDNewSavemeScreenController.h"
#import "STPickerSingle.h"
#import "XDPickerAreaView.h"

#import "HMCommonGroup.h"
#import "HMCommonItem.h"
#import "HMCommonCell.h"
#import "HMCommonLabelItem.h"
#import "HMCommonSwitchItem.h"
#import "XDAreaModel.h"

@interface XDNewSavemeScreenController ()<STPickerSingleDelegate,XDPickerAreaViewDelegate>
/** 地区数组 */
@property (nonatomic ,strong) NSMutableArray *areasArray;
/** 性别数组 */
@property (nonatomic ,strong) NSArray *sexArray;

@property (nonatomic, strong) HMCommonLabelItem *areaItem;
@property (nonatomic, strong) HMCommonLabelItem *sexItem;
@property (nonatomic, strong) HMCommonSwitchItem *isSelfItem;

@end

@implementation XDNewSavemeScreenController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.sexArray = @[@"不限",@"男",@"女"];
    [self setupNavBar];
    [self setupAreaInfo];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.contentInset = UIEdgeInsetsMake(NavigationBar_Height, 0, 0, 0);
    [self setupGroups];
}

- (void)setupNavBar {
    
    self.title = @"救我筛选";
    
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
        self.downButtonClicked(self.areaID, self.areaName, self.sex, self.is_self);
    }
}

/**
 *  初始化模型数据
 */
- (void)setupGroups
{
    [self setupGroup1];
}


- (void)setupGroup1
{
    // 1.创建组
    HMCommonGroup *group = [HMCommonGroup group];
    [self.groups addObject:group];
    
    XD_WeakSelf
    group.header = @"您喜欢的类型？";
    // 2.设置组的所有行数据
    HMCommonLabelItem *area = [HMCommonLabelItem itemWithTitle:@"地区" icon:nil];
    area.text = self.areaName ? self.areaName : @"不限";
    area.operation = ^{
        XD_StrongSelf
        if (self.areasArray.count == 0) {
            [self.view makeToast:@"觅约地区信息获取失败，请重试"
                        duration:2.0
                        position:CSToastPositionCenter];
            [self setupAreaInfo];
            return ;
        }
        
        XDPickerAreaView *areaView = [[XDPickerAreaView alloc] initWithArrayData:self.areasArray delegate:self];
        [areaView show];
    };
    
    HMCommonLabelItem *sex = [HMCommonLabelItem itemWithTitle:@"性别" icon:nil];
    sex.text = self.sex ? [self.sex isEqualToString:@"1"] ? @"女" : @"男" : @"不限";
    sex.operation = ^{
        XD_StrongSelf
        STPickerSingle *single = [[STPickerSingle alloc]init];
        [single setArrayData:(NSMutableArray *)self.sexArray];
        [single setTitle:@"请选择性别"];
        [single setTitleUnit:@""];
        [single setDelegate:self];
        [single show];
    };
    
    HMCommonSwitchItem *isSelf = [HMCommonSwitchItem itemWithTitle:@"本人发布"];
    isSelf.switchValueChanged = ^(BOOL switchIsOn) {
        XD_StrongSelf
        self.is_self = switchIsOn;
        self.sex = nil;
        self.sexItem.text = @"不限";
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:1 inSection:0],nil] withRowAnimation:UITableViewRowAnimationNone];
    };
    isSelf.switchIsOn = self.is_self;
    
    group.items = @[area,sex,isSelf];
    
    self.areaItem = area;
    self.sexItem = sex;
    self.isSelfItem = isSelf;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return postCellBorder;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48;
}

#pragma mark - 获取地区信息
/**
 *  获取地区信息
 */
- (void)setupAreaInfo {
    // 救我
    [FKL_DataService requestURL:[NSString url_getNewSavemeScreeningArea] parameters:nil withType:@"GET" format:@"JSON" complete:^(id result) {
        if ([result[@"code"] integerValue] == 200) {
            self.areasArray = [NSMutableArray array];
            NSArray *areaArr = [XDAreaModel objectArrayWithKeyValuesArray:result[@"data"]];
            XDAreaModel *areaModel = [[XDAreaModel alloc] init];
            areaModel.area = @"不限";
            NSMutableArray *newAreaArr = [NSMutableArray arrayWithArray:areaArr];
            [newAreaArr insertObject:areaModel atIndex:0];
            for (XDAreaModel *area in newAreaArr) {
                NSMutableArray *childArray = [NSMutableArray arrayWithArray:area.children];
                XDAreaChildrenModel *children = [[XDAreaChildrenModel alloc] init];
                children.area = @"不限";
                [childArray insertObject:children atIndex:0];
                area.children = childArray;
                [self.areasArray addObject:area];
            }
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

#pragma mark - STPickerSingleDelegate
- (void)pickerSingle:(STPickerSingle *)pickerSingle selectedTitle:(NSString *)selectedTitle
{
    NSString *text = [NSString stringWithFormat:@"%@", selectedTitle];
    
    self.sexItem.text = text;
    NSUInteger index = [self.sexArray indexOfObject:text];
    if (index > 0) {
        NSString *sexText = [self.sexArray objectAtIndex:index];
        self.sex = [sexText isEqualToString:@"女"] ? @"1" : @"0";
        self.isSelfItem.switchIsOn = NO;
        self.is_self = NO;
    } else {
        self.sex = nil;
    }
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:1 inSection:0],[NSIndexPath indexPathForRow:2 inSection:0],nil] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - XDPickerAreaViewDelegate
- (void)pickerArea:(XDPickerAreaView *)pickerArea province:(NSString *)province city:(NSString *)city areeID:(NSString *)areeID {
    NSString *text = @"";
    if (city.length > 0 && ![city isEqualToString:@"不限"]) {
        text = [NSString stringWithFormat:@"%@", city];
    } else {
        text = [NSString stringWithFormat:@"%@", province];
    }
    
    self.areaItem.text = text;
    self.areaID = areeID;
    self.areaName = text;
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:0],nil] withRowAnimation:UITableViewRowAnimationNone];
}

@end
