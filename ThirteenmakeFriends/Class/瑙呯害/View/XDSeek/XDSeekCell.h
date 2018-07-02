//
//  XDSeekCell.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/9/1.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Seek;

@protocol XDSeekCellDelegate <NSObject>

- (void)recommendButtonClicked:(UIButton *)recommendBtn andSeek:(Seek *)seek;

@end

@interface XDSeekCell : UITableViewCell

@property (strong, nonatomic) Seek * seekModel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (weak, nonatomic) id<XDSeekCellDelegate> delegate;

@end
