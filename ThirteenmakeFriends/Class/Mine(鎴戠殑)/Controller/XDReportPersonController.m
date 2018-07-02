
//
//  XDReportPersonController.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 16/7/8.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import "XDReportPersonController.h"
#import "HMCommonGroup.h"
#import "HMCommonItem.h"
#import "HMCommonCell.h"
#import "MBProgressHUD+MJ.h"

@interface XDReportPersonController ()
{
    NSIndexPath *selectedIndexPath;

}

@property (strong, nonatomic) UIView *footerView;
@property (copy, nonatomic) NSString *selectTitle;

@end

@implementation XDReportPersonController

- (void)viewDidLoad {
    [super viewDidLoad];
    ;
    self.navigationItem.title = @"举报";
    
    // 初始化模型数据
    [self setupGroups];
    
    self.tableView.tableFooterView = self.footerView;
}

- (void)setupGroups {
    [self setupGroup1];
}

- (void)setupGroup1
{
    // 1.创建组
    HMCommonGroup *group = [HMCommonGroup group];
    [self.groups addObject:group];
    
    group.header = @"请告诉我们该用户哪个模块违规了";
    // 2.设置组的所有行数据
    // 聊天
    HMCommonItem *chat = [HMCommonItem itemWithTitle:@"聊天" icon:@"nil"];
    
    // 资料
    HMCommonItem *data = [HMCommonItem itemWithTitle:@"资料" icon:@"nil"];
    
    // 动态
    HMCommonItem *thread = [HMCommonItem itemWithTitle:@"动态" icon:@"nil"];
    
    // 其他
    HMCommonItem *other = [HMCommonItem itemWithTitle:@"其他" icon:@"nil"];
    
    group.items = @[chat,data,thread,other];
    
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
    if (self.user) {
        [self reportOnePerson];
    } else if (self.number) {
        [self reportNumber];
    } else {
        [MBProgressHUD showError:@"发送错误，请重试"];
    }
    
}

/**
 *  举报平台用户
 */
- (void)reportOnePerson {
    NSLog(@"举报 类型：%@，举报人%@，被举报人-%@",self.selectTitle,User_ID,self.user.user_id);
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"type"] = self.selectTitle;
    paras[@"plaintiff_id"] = User_ID;
    paras[@"defendant_id"] = self.user.user_id;
    
    [XDRequestHttpTool request_complaintsPersonWithParameters:paras complete:^(id result) {
        if ([result[@"code"] integerValue] == 200) {
            [MBProgressHUD showSuccess:@"感谢您的举报，我们会尽快核实"];
        } else {
            [MBProgressHUD showError:@"举报失败，请稍后再试"];
        }
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
    
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *  举报翻牌觅约
 */
- (void)reportNumber {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD showSuccess:@"感谢您的举报，我们会尽快核实"];
        [self.navigationController popViewControllerAnimated:YES];
    });
}
@end
