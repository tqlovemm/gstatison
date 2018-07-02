//
//  XDAnnounceCell.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/7/25.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XDAnnounceFrameModel;

@interface XDAnnounceCell : UITableViewCell

@property (strong, nonatomic) XDAnnounceFrameModel * noticeFrame;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
