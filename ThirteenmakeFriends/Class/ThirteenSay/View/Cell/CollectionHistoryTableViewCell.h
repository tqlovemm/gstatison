//
//  CollectionHistoryTableViewCell.h
//  ThirteenmakeFriends
//
//  Created by iOS on 23/5/17.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionHistoryModel.h"
#import "ICEAvatar.h"

@class CollectionHistoryTableViewCell;
typedef void (^ClickBlock)(CollectionHistoryTableViewCell *self);
@interface CollectionHistoryTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet ICEAvatar *avatarView;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (nonatomic, strong) CollectionHistoryModel *model;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UIButton *btnPraise;
@property (weak, nonatomic) IBOutlet UIImageView *imgPraise;

@property (nonatomic, copy)ClickBlock clickBlock;
- (IBAction)didPressedToPraise:(UIButton *)sender;

/**
 点赞动画
 */
- (void)didPressedToStartPriseAnimation;
@end
