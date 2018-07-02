//
//  XDSeekRecordCell.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 16/6/30.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XDSeekRecordFrame;

@interface XDSeekRecordCell : UITableViewCell


@property (strong, nonatomic) XDSeekRecordFrame * recordFrame;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
