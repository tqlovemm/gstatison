//
//  XDPersonPhotosCell.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 16/12/13.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShiSanUser;

@interface XDPersonPhotosCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (strong, nonatomic) ShiSanUser * user;

@end
