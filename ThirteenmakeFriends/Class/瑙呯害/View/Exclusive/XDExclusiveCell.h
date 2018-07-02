//
//  XDExclusiveCell.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/9/6.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ExclusiveModel;

@protocol XDSeekCellDelegate <NSObject>

- (void)recommendButtonClicked:(UIButton *)recommendBtn andSeek:(ExclusiveModel *)seek;

@end

@interface XDExclusiveCell : UITableViewCell

@property (strong, nonatomic) ExclusiveModel * seekModel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (weak, nonatomic) id<XDSeekCellDelegate> delegate;

@end
