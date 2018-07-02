//
//  XDNewSavemeRecordCell.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2018/1/10.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XDSaveMeModel;

@interface XDNewSavemeRecordCell : UITableViewCell

@property (nonatomic, strong) XDSaveMeModel *model;

#pragma mark - 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
