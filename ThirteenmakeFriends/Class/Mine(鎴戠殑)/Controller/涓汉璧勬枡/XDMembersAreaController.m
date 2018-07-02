//
//  XDMembersAreaController.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/7/31.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//  入会地区

#import "XDMembersAreaController.h"
#import "HMCommonLabelItem.h"
#import "HMCommonGroup.h"
#import "HMCommonCell.h"

#import "XDMembersAreaFooterView.h"
#import "ProfileUser.h"
#import "XDAccountTool.h"
#import "XDPickerAreaView.h"
#import "XDAreaModel.h"

@interface XDMembersAreaController ()<XDPickerAreaViewDelegate>

/** 地区数组 */
@property (nonatomic, strong) NSMutableArray *areaArray;

@end

@implementation XDMembersAreaController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"入会地区";
    
    [self setupGroups];
    
    [self setupTableFooterView];
}

/**
 *  初始化模型数据
 */
- (void)setupGroups
{
    [self setupGroup1];
}

- (void)setupGroup1 {
    ProfileUser *user = [XDAccountTool account];
    
    HMCommonGroup *group = [HMCommonGroup group];
    [self.groups addObject:group];
    
    group.header = @"入会地区";
    
    HMCommonLabelItem *area1 = [HMCommonLabelItem itemWithTitle:user.area_one icon:@"nil"];
    XD_WeakSelf
    area1.operation = ^{
        XD_StrongSelf
        [self getAreaList];
    };
    area1.text = @"主地区";
    HMCommonLabelItem *area2 = [HMCommonLabelItem itemWithTitle:user.area_two icon:@"nil"];
    area2.text = @"副地区";
    HMCommonLabelItem *area3 = [HMCommonLabelItem itemWithTitle:user.area_three icon:@"nil"];
    area3.text = @"副地区";
    if (user.area_three.length > 0 && user.area_two.length > 0 && user.area_one.length > 0) {
//        HMCommonLabelItem *area1 = [HMCommonLabelItem itemWithTitle:user.area_one icon:@"nil"];
//        area1.text = @"主地区";
//        HMCommonLabelItem *area2 = [HMCommonLabelItem itemWithTitle:user.area_two icon:@"nil"];
//        area2.text = @"副地区";
//        HMCommonLabelItem *area3 = [HMCommonLabelItem itemWithTitle:user.area_three icon:@"nil"];
//        area3.text = @"副地区";
        group.items = @[area1,area2,area3];
    } else if (user.area_two.length > 0 && user.area_one.length > 0) {
//        HMCommonLabelItem *area1 = [HMCommonLabelItem itemWithTitle:user.area_one icon:@"nil"];
//        area1.text = @"主地区";
//        HMCommonLabelItem *area2 = [HMCommonLabelItem itemWithTitle:user.area_two icon:@"nil"];
//        area2.text = @"副地区";
        group.items = @[area1,area2];
    } else if (user.area_one.length > 0) {
//        HMCommonLabelItem *area1 = [HMCommonLabelItem itemWithTitle:user.area_one icon:@"nil"];
//        area1.text = @"主地区";
        group.items = @[area1];
    }
}

#pragma mark - 获取地址
- (void)getAreaList {
    [self showHudInView:self.view hint:@""];
    
    self.areaArray = [NSMutableArray array];
    
    [FKL_DataService requestURL:[NSString url_getAreaList] parameters:nil withType:@"GET" format:@"JSON" complete:^(id result) {
        [self hideHud];
        if ([result[@"code"] integerValue] == 200) {
            self.areaArray = [NSMutableArray arrayWithArray:[XDAreaModel objectArrayWithKeyValuesArray:result[@"data"]]];
            
            [self.view endEditing:YES];
            
            XDPickerAreaView *areaView = [[XDPickerAreaView alloc] initWithArrayData:self.areaArray delegate:self];
            [areaView show];
            
        } else {
            [self.view makeToast:result[@"message"] duration:2.0 position:CSToastPositionCenter];
        }
        
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideHud];
        [self.view makeToast:error.localizedDescription duration:2.0 position:CSToastPositionCenter];
    }];
}

#pragma mark - XDPickerAreaView delegate
- (void)pickerArea:(XDPickerAreaView *)pickerArea province:(NSString *)province city:(NSString *)city areeID:(NSString *)areeID {
    NSString *text = @"";
    if (city.length > 0) {
        text = [NSString stringWithFormat:@"%@ %@", province,city];
    } else {
        text = [NSString stringWithFormat:@"%@", province];
    }
    if (self.areaSelectViewClickedBlock) {
        self.areaSelectViewClickedBlock(text, areeID);
    }
}

#pragma mark - tableFooterView
- (void)setupTableFooterView {
    XDMembersAreaFooterView *footerView = [[XDMembersAreaFooterView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 130)];
    
    self.tableView.tableFooterView = footerView;
}

@end
