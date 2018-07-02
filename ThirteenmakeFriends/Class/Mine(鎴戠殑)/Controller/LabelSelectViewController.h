//
//  LabelSelectViewController.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 16/5/17.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import "BaseViewController.h"
@class ProfileUser;

@protocol LabelSelectViewControllerDelegate <NSObject>

- (void)labelCountChanged;

@end

@interface LabelSelectViewController : BaseViewController

/**
 *  存放所有标签的数组
 */
@property (strong, nonatomic) NSArray * allLabelArray;

/**
 *  存放所有已选择标签的数组
 */
@property (strong, nonatomic) ProfileUser * user;

@property (weak, nonatomic) id<LabelSelectViewControllerDelegate> delegate;

@property (strong, nonatomic) UIColor * labelColor;

@end
