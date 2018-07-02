//
//  XDPhotoCell.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 16/8/29.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDPhotoCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (strong, nonatomic) NSArray * photos;

+ (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
