//
//  XDWSeekRecordCell.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/11/17.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XDSeekRecordFrame;

@interface XDWSeekRecordCell : UITableViewCell

@property (strong, nonatomic) XDSeekRecordFrame * recordFrame;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
