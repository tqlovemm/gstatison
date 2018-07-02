//
//  NoticeMessageCell.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 16/4/21.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeFrame.h"

@protocol NoticeMessageCellDelegate <NSObject>

- (void)showMenu:(UITableViewCell *)cell;

- (void)deleteRow:(UITableViewCell *)cell;

@end

@interface NoticeMessageCell : UITableViewCell

@property (weak, nonatomic) id<NoticeMessageCellDelegate> delegate;

@property (strong, nonatomic) NoticeFrame * noticeFrame;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
