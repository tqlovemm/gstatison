//
//  ThirteenWithVideoCellTableViewCell.h
//  ThirteenmakeFriends
//
//  Created by iOS on 15/5/17.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICEAvatar.h"
#import "ThirteenSayArticlesModel.h"
@class ThirteenWithVideoCellTableViewCell;

typedef enum : NSUInteger {
    Praise,
    Collection,
    Share,
} CellClickEvent;

typedef void (^clickEvent)(CellClickEvent event, ThirteenWithVideoCellTableViewCell *self);

@interface ThirteenWithVideoCellTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgPraise;
@property (weak, nonatomic) IBOutlet UILabel *lblPraise;
@property (nonatomic, copy) clickEvent didPressedEvent;
@property (weak, nonatomic) IBOutlet ICEAvatar *avatarView;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UIImageView *imgLevel;
@property (weak, nonatomic) IBOutlet UIImageView *imgVideo;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblMessage;
@property (weak, nonatomic) IBOutlet UIButton *btnPraise;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UIImageView *imgCollect;
@property (weak, nonatomic) IBOutlet UIImageView *imgShare;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnReply;
@property (weak, nonatomic) IBOutlet UIImageView *imgType;
@property (weak, nonatomic) IBOutlet UIImageView *imgPlay;
@property (weak, nonatomic) IBOutlet UIButton *btnShare;
@property (weak, nonatomic) IBOutlet UILabel *lblOriginal;

- (IBAction)didPressedToPrise:(UIButton *)sender;
- (IBAction)didPressedToCollect:(UIButton *)sender;
- (IBAction)didPressedToShare:(UIButton *)sender;

@property (nonatomic, strong) ThirteenSayArticlesModel *model;

/**
 点赞动画
 */
- (void)didPressedToStartPriseAnimationIncreasePraiseNum:(BOOL)increase ;

/**
 收藏动画
 */
- (void)didPressedToStartCollectionAnimation;
@end
