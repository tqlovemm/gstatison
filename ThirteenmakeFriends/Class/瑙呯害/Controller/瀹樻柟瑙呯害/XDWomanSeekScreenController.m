//
//  XDWomanSeekScreenController.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/11/17.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDWomanSeekScreenController.h"
#import "HMCommonGroup.h"
#import "HMCommonItem.h"
#import "HMCommonCell.h"
#import "HMCommonArrowItem.h"
#import "HMCommonLabelItem.h"
#import "STPickerSingle.h"
#import "XDAreaModel.h"

@interface XDWomanSeekScreenController ()<STPickerSingleDelegate>

@property (nonatomic ,weak) HMCommonLabelItem *area;

/** 地区数组 */
@property (nonatomic, strong) NSArray *areaArray;
/** 地区名数组 */
@property (nonatomic, strong) NSMutableArray *areaNameArray;

@end

@implementation XDWomanSeekScreenController

- (void)setAreaModel:(XDAreaModel *)areaModel {
    _areaModel = areaModel;
    if (areaModel) {
        _areaModel = areaModel;
    }
    else {
        _areaModel = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"条件筛选";
    
    [self setupNavBar];
    // 初始化模型数据
    [self setupGroups];
    
    [self setupAreaInfo];
}

/**
 *  获取地区信息
 */
- (void)setupAreaInfo {
    
    [XDRequestHttpTool request_getSeekAreaInfo_withParameters:nil complete:^(id result) {
        if ([result[@"code"] integerValue] == 200) {
            NSArray *areaArray = [XDAreaModel objectArrayWithKeyValuesArray:result[@"data"]];
            NSMutableArray *areaArr = [NSMutableArray array];
            [areaArr addObject:@"不限"];
            self.areaArray = areaArray;
            for (XDAreaModel *area in areaArray) {
                [areaArr addObject:area.area];
            }
            self.areaNameArray = areaArr;
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
    
    group.header = @"精确筛选";
    __weak typeof(self) weakSelf = self;
    // 2.设置组的所有行数据
    // 地区
    HMCommonLabelItem *area = [HMCommonLabelItem itemWithTitle:@"地区" icon:@"nil"];
    if (_areaModel) {
        area.text = _areaModel.area;
    } else {
        area.text = @"不限";
    }
    
    area.operation = ^{
        
        if (weakSelf.areaArray.count == 0) {
            [self.view makeToast:@"翻牌地区信息获取失败，请重试"
                        duration:2.0
                        position:CSToastPositionCenter];
            [self setupAreaInfo];
            return ;
        }
        
        STPickerSingle *single = [[STPickerSingle alloc]init];
        [single setArrayData:(NSMutableArray *)weakSelf.areaNameArray];
        [single setTitle:@"请选择地区"];
        [single setTitleUnit:@""];
        [single setDelegate:weakSelf];
        [single show];
    };
    
    group.items = @[area];
    self.area = area;
}

- (void)setupNavBar {
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [leftBtn setTitleColor:NormalNavBtnColor forState:UIControlStateNormal];
    leftBtn.frame = CGRectMake(0, 0, 44, 44);
    
    leftBtn.adjustsImageWhenHighlighted = NO;
    [leftBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftNegativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
    // leftNegativeSpacer为占位符
    leftNegativeSpacer.width = -10;
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItems = @[leftNegativeSpacer, leftItem];
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitleColor:NormalNavBtnColor forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItems = @[leftNegativeSpacer, rightItem];
}

- (void)send {
    XDAreaModel *areaModel = nil;
    if ([self.area.text isEqualToString:@"不限"]) {
        areaModel = nil;
    } else {
        NSUInteger index = [self.areaNameArray indexOfObject:self.area.text];
        areaModel = ((XDAreaModel *)[self.areaArray objectAtIndex:index - 1]);
    }
    
    XD_WeakSelf
    if (self.downButtonClicked) {
        XD_StrongSelf
        self.downButtonClicked(areaModel);
    }

    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)cancel {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - STPickerSingleDelegate
- (void)pickerSingle:(STPickerSingle *)pickerSingle selectedTitle:(NSString *)selectedTitle
{
    NSString *text = [NSString stringWithFormat:@"%@", selectedTitle];
    self.area.text = text;
    
    [self.tableView reloadData];
}

#pragma mark - tableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 64;
    } else {
        return 10;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

@end
