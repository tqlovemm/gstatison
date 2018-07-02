//
//  XDBasicInfoCell.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 16/8/24.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProfileUser;

@interface XDBasicInfoCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (strong, nonatomic) ProfileUser * user;

@property (assign, nonatomic) CGFloat cellHeight;

@end
