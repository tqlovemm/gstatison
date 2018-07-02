//
//  XDPostHeaderView.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/10/20.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDPostHeaderView : UIView

- (void)setBanners:(NSArray *)bannersArray tdstars:(NSArray *)tdstarsArray activitise:(NSArray *)activitiesArray;

- (void)setRankWeekML:(NSArray *)ranklist;
- (void)setRankWeekRX:(NSArray *)ranklist;
@end
