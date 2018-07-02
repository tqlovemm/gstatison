//
//  XDMatchPersonCell.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/12/19.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShiSanUser;

@interface XDMatchPersonCell : UITableViewCell

@property (nonatomic, strong) ShiSanUser *user;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
