/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import <UIKit/UIKit.h>

typedef enum{
    ApplyStyleFriend            = 0,
    ApplyStyleGroupInvitation,
    ApplyStyleJoinGroup,
}ApplyStyle;

@interface ApplyViewController : UITableViewController
{
    NSMutableArray *_dataSource;
    // 申请与通知
    NSMutableArray *_undealedData;
}

@property (strong, nonatomic, readonly) NSMutableArray *dataSource;
// 申请与通知（未处理的数组）
@property (strong, nonatomic, readonly) NSMutableArray *undealedData;

+ (instancetype)shareController;

- (void)addNewApply:(NSDictionary *)dictionary;

- (void)loadDataSourceFromLocalDB;

- (void)clear;


/**
 addNewApply方法后执行
 */
- (void)reloadUI;
@end
