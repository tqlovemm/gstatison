//
//  XDPersonOtherInfoCell.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 16/12/14.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDPersonOtherInfoCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (assign, nonatomic) CGFloat cellHeight;

- (void)cellWithTitle:(NSString *)title andContent:(NSString *)content andPlaceholder:(NSString *)placeholder;

@end
