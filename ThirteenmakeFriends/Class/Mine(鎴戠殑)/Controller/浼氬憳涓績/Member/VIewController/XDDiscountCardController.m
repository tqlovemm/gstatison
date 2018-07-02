//
//  XDDiscountCardController.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/7/18.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDDiscountCardController.h"
#import "XDCardPackageCell.h"
#import "XDVoucherModel.h"
#import "MJExtension.h"

@interface XDDiscountCardController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,weak) UITableView *tableView;

@property (nonatomic ,strong) NSMutableArray *cardsArray;

@end

@implementation XDDiscountCardController

- (NSMutableArray *)cardsArray {
    if (!_cardsArray) {
        _cardsArray = [NSMutableArray array];
    }
    return _cardsArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //获取测试数据
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Voucher" ofType:@"json"];
    NSData *subShopData = [NSData dataWithContentsOfFile:path];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:subShopData options:NSJSONReadingMutableContainers error:nil];
    self.cardsArray = [NSMutableArray arrayWithArray:[XDVoucherModel objectArrayWithKeyValuesArray:dic[@"items"]]];
    
    [self setupTableView];
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH,SCREEN_HEIGHT - NavigationBar_Height) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = RGB(240, 239, 245);
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cardsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 创建cell
    XDCardPackageCell *cell = [XDCardPackageCell cellWithTableView:tableView];
    cell.voucherModel = self.cardsArray[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 114;
}

@end
