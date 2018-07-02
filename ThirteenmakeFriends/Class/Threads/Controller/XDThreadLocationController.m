//
//  XDThreadLocationController.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 16/9/27.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import "XDThreadLocationController.h"
#import "XDThreadLocation.h"
#import <CoreLocation/CoreLocation.h>

@interface XDThreadLocationController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSIndexPath *selectedIndexPath;
}

@property (nonatomic ,strong) NSArray *areaArray;

@property (nonatomic ,weak) UITableView *tableView;

@end

@implementation XDThreadLocationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"所在位置";
    
    [self setupNavbar];
    
    [self xdd_setupTableView];
    
    [self isOpenLocation];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self locationing];
}

- (void)isOpenLocation {
    
    // 判断定位服务是否可用，非常有用
    if (![[XDThreadLocation sharedInstance] locationAvailable]) {
        [self dumpAlert];
    }
}

- (void)dumpAlert {
    if (iOS10) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"此应用的定位功能可能没有打开，您可以在“设置”中为此应用开启定位" delegate:self cancelButtonTitle:@"好" otherButtonTitles:@"设置", nil];
        [alert show];
    }
}

- (void)setupNavbar {
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    backButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [backButton setTitle:@"取消" forState:UIControlStateNormal];
    [backButton setTitleColor:NormalNavBtnColor forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -10;
    self.navigationItem.leftBarButtonItems = @[negativeSpacer, backItem];
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)locationing {
    
    /**
     判断定位是否成功，成功则获取数据，否则重新定位
     */
    if ([[XDThreadLocation sharedInstance] locationAvailable]) {
    } else {
        XDThreadLocation *loc = [[XDThreadLocation alloc] init];
        [loc start];
        loc.locationOperation = ^{
            [self.tableView reloadData];
        };
    }
    
}

- (void)xdd_setupTableView {
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT - NavigationBar_Height) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = RGB(226, 226, 226);
    tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 创建cell
    static NSString *ID = @"XDSendThreadLocationCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    
    if (indexPath.row == 0) {
        cell.textLabel.textColor = HEXCOLOR(0xa5b2f2);
        cell.textLabel.text = @"不显示位置";
        if (!self.locArea) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    } else {
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.text = [[XDThreadLocation sharedInstance] city];
        if (self.locArea) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *precell = [tableView cellForRowAtIndexPath:selectedIndexPath];
    precell.accessoryType = UITableViewCellAccessoryNone;
    UITableViewCell *nowCell = [tableView cellForRowAtIndexPath:indexPath];
    nowCell.accessoryType = UITableViewCellAccessoryCheckmark;
    selectedIndexPath = indexPath;
    if (indexPath.row == 1) {
        [self didSelctedLocation:[[XDThreadLocation sharedInstance] city]];
    } else if (indexPath.row == 0) {
        // 查询到定位地区在数组里的位置
        [self didSelctedLocation:nil];
    }
}
- (void)didSelctedLocation:(NSString *)loc {
    if ([self.delegate respondsToSelector:@selector(areaPickerController:didSelectLocation:)]) {
        [self.delegate areaPickerController:self didSelectLocation:loc];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        [self gotoAppSettings];
    }
}

#pragma mark - 跳转到应用设置
- (void)gotoAppSettings {

}

@end
