//
//  XDThreadReportController.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 16/9/30.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import "XDThreadReportController.h"
#import "HMCommonGroup.h"
#import "HMCommonItem.h"
#import "HMCommonCell.h"
#import "MBProgressHUD+MJ.h"
#import "XDReportPostModel.h"
#import "MJExtension.h"

@interface XDThreadReportController ()
{
    NSIndexPath *selectedIndexPath;
    
}

@property (strong, nonatomic) UIView *footerView;
@property (copy, nonatomic) NSString *selectTitle;

@property (strong, nonatomic) NSArray * reportsArray;

@end

@implementation XDThreadReportController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"举报";
    
    self.tableView.tableFooterView = self.footerView;
    
    // 初始化模型数据
    [self requestData];
}

- (void)requestData {
    
    [self showHudInView:self.view hint:@"加载中..."];
    
    [FKL_DataService requestURL:[NSString url_getThreadReportchioce] parameters:nil withType:@"GET" format:@"JSON" complete:^(id result) {
        [self hideHud];
        if ([result[@"code"] integerValue] == 200) {
            self.reportsArray = [XDReportPostModel objectArrayWithKeyValuesArray:result[@"data"]];
            // 1.创建组
            HMCommonGroup *group = [HMCommonGroup group];
            [self.groups addObject:group];
            
            group.header = @"请选择举报原因";
            
            NSMutableArray *mutableArray = [NSMutableArray array];
            for (XDReportPostModel *reportModel in self.reportsArray) {
                
                HMCommonItem *item = [HMCommonItem itemWithTitle:reportModel.content icon:@""];
                [mutableArray addObject:item];
            }
            
            group.items = mutableArray;
            
            [self.tableView reloadData];
            
        } else {
            [self.view makeToast:result[@"message"] duration:2.0 position:CSToastPositionCenter];
        }
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideHud];
        NSLog(@"%@",error);
        [self.view makeToast:error.localizedDescription duration:2.0 position:CSToastPositionCenter];
    }];
}

- (void)setupGroups {
    [self setupGroup1];
}

- (void)setupGroup1
{
    // 1.创建组
    HMCommonGroup *group = [HMCommonGroup group];
    [self.groups addObject:group];
    
    group.header = @"请选择举报原因";
    // 2.设置组的所有行数据
    HMCommonItem *porn = [HMCommonItem itemWithTitle:@"色情低俗" icon:@""];
    HMCommonItem *political = [HMCommonItem itemWithTitle:@"政治敏感" icon:@""];
    HMCommonItem *illegal = [HMCommonItem itemWithTitle:@"违法" icon:@""];
    HMCommonItem *adv = [HMCommonItem itemWithTitle:@"广告" icon:@""];
    HMCommonItem *virus = [HMCommonItem itemWithTitle:@"病毒木马" icon:@""];
    HMCommonItem *other = [HMCommonItem itemWithTitle:@"其他" icon:@""];
    
    group.items = @[porn,political,illegal,adv,virus,other];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *precell = [tableView cellForRowAtIndexPath:selectedIndexPath];
    precell.accessoryType = UITableViewCellAccessoryNone;
    UITableViewCell *nowCell = [tableView cellForRowAtIndexPath:indexPath];
    nowCell.accessoryType = UITableViewCellAccessoryCheckmark;
    selectedIndexPath = indexPath;
    
    self.selectTitle = nowCell.textLabel.text;
}

- (UIView *)footerView
{
    if (_footerView == nil) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
        _footerView.backgroundColor = [UIColor clearColor];
        
        UIButton *logoutButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, _footerView.frame.size.width - 20, 45)];
        [logoutButton setBackgroundColor:[UIColor whiteColor]];
        NSString *logoutButtonTitle = @"提交";
        
        [logoutButton setTitle:logoutButtonTitle forState:UIControlStateNormal];
        [logoutButton setTitleColor:BtnThemeColor forState:UIControlStateNormal];
        [logoutButton addTarget:self action:@selector(reportAction) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:logoutButton];
    }
    
    return _footerView;
}

- (void)reportAction {
    
    if (self.selectTitle == nil || [self.selectTitle isEqualToString:@""]) {
        [MBProgressHUD showError:@"请选择举报的内容"];
        return;
    }
    
    [self showHudInView:self.view hint:@"举报中..."];
    
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"user_id"] = self.user_id;
    paras[@"wid"] = self.thread_id;
    paras[@"report_id"] = @([[self.reportsArray objectAtIndex:selectedIndexPath.row] report_id]);
    
    // 公钥加密
    NSString *encryWithPublicKeyStr = [RSAUtil encryptString:[NSString stringWithFormat:@"%@",User_ID] publicKey:kRSA_Public_key];
    [FKL_DataService requestURL:[NSString url_postThreadReport] parameters:paras headerKey:@"sign" headerValue:encryWithPublicKeyStr withType:@"POST" format:@"JSON" complete:^(id result) {
        [self hideHud];
        if ([result[@"code"] integerValue] == 200) {
            [MBProgressHUD showSuccess:@"举报成功" toView:nil];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self.view makeToast:result[@"message"] duration:2.0 position:CSToastPositionCenter];
        }
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideHud];
        NSLog(@"%@",error);
        [self.view makeToast:error.localizedDescription duration:2.0 position:CSToastPositionCenter];
    }];
}

@end
