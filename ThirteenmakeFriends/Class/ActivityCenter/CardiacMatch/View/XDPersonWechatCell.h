//
//  XDPersonWechatCell.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/12/20.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDPersonWechatCell : UITableViewCell

@property (nonatomic, copy) NSString *weichat;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
