//
//  XDActivityCenterCell.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2018/1/10.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDActivityCenterCell : UITableViewCell

@property (nonatomic, copy) NSString *img_Name;

#pragma mark - 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
