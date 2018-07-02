//
//  XDActivityCenterController.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2018/1/10.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import "XDActivityCenterController.h"
#import "XDMatchHomeController.h"
#import "XDChatupSquareController.h"
#import "XDActivityCenterCell.h"
#import "CYPromptCover.h"

@interface XDActivityCenterController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong) NSArray *dataArray;

@property (nonatomic ,weak) UITableView *tableView;

@end

@implementation XDActivityCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"活动中心";
    self.edgesForExtendedLayout = UIRectEdgeAll;
    
    self.dataArray = @[@"activityCenter_match",@"activityCenter_chatUp"];
    [self xdd_setupTableView];
    [self newbieGuide];
}

- (void)xdd_setupTableView {
    UITableView *tableView = [[UITableView alloc]init];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = RGB(240, 239, 245);
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 创建cell
    XDActivityCenterCell *cell = [XDActivityCenterCell cellWithTableView:tableView];
    cell.img_Name = self.dataArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    XDActivityCenterCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//
//    CATransform3D transform = CATransform3DIdentity;
//    transform = CATransform3DScale(transform, 1, 1, 1);//由小变大
//    cell.layer.transform = transform;
//
//    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
//        cell.layer.transform = CATransform3DScale(transform, 1.2, 1.2, 1);//由小变大
//    } completion:^(BOOL finished) {
//        if (finished) {
//            [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//                cell.layer.transform = CATransform3DIdentity;
//            } completion:^(BOOL finished) {
//                if (finished) {
//                    if (indexPath.row == 0) {
//                        XDMatchHomeController *matchVC = [[XDMatchHomeController alloc] init];
//                        [self.navigationController pushViewController:matchVC animated:YES];
//                    } else {
//                        XDChatupSquareController *squareVC = [[XDChatupSquareController alloc] init];
//                        [self.navigationController pushViewController:squareVC animated:YES];
//                    }
//                }
//            }];
//        }
//    }];
    
    if (indexPath.row == 0) {
        XDMatchHomeController *matchVC = [[XDMatchHomeController alloc] init];
        [self.navigationController pushViewController:matchVC animated:YES];
    } else {
        XDChatupSquareController *squareVC = [[XDChatupSquareController alloc] init];
        [self.navigationController pushViewController:squareVC animated:YES];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewAutomaticDimension;
}

#pragma mark - 新手引导
- (void)newbieGuide {
    
    if (!myAppDelegate.newVersion) {
        return;
    }
    
    CGFloat imgWidth = SCREEN_WIDTH - 12;
    CGFloat imgHeight = imgWidth * 198/371.0;
    
    CYPromptCoverViewQueue *queue = [[CYPromptCoverViewQueue alloc] init];
    
    CYPromptCoverView *cover0 = [[CYPromptCoverView alloc] initWithRevalView:nil layoutType:CYPromptCoverViewLayoutTypeDown];
    cover0.insetX = 0;
    cover0.insetY = 0;
    cover0.revealFrame = CGRectMake(6, 70, imgWidth, imgHeight);
    cover0.des = @"心动匹配";
    cover0.detailDes = @"大数据匹配\n每晚8点，一个最适合的Ta";
    
    CYPromptCoverView *cover1 = [[CYPromptCoverView alloc] initWithRevalView:nil layoutType:CYPromptCoverViewLayoutTypeUP];
    cover1.insetX = 0;
    cover1.insetY = 0;
    cover1.revealFrame = CGRectMake(6, 70 + imgHeight + 12, imgWidth, imgHeight);
    cover1.des = @"互撩广场";
    cover1.detailDes = @"在这里可以看到所有用户\n怎么撩 就看你的了";
    
    [queue addPromptCoverView:cover0];
    [queue addPromptCoverView:cover1];
    
    [queue showCoversInView:self.tabBarController.view];
}

@end
