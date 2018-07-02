//
//  ApplyListViewController.h
//  ThirteenmakeFriends
//
//  Created by 空谷凌虚 on 2018/5/21.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApplyListViewController : UITableViewController
{
    NSMutableArray *_dataSource;
    // 申请与通知
    NSMutableArray *_undealedData;
}
+ (instancetype)shareController;

@property (strong, nonatomic, readonly) NSMutableArray *dataSource;

// 申请与通知（未处理的数组）
@property (strong, nonatomic, readonly) NSMutableArray *undealedData;

@end
