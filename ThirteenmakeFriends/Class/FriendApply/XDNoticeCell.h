//
//  XDNoticeCell.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 17/3/22.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDNoticeCell : UITableViewCell

@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, strong) UIImage *placeholderImage;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *detailMsg;
@property (nonatomic, strong) NSString *time;
@property (nonatomic) NSInteger unreadCount;

@property (assign, nonatomic) NSInteger conversationType;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+(CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
