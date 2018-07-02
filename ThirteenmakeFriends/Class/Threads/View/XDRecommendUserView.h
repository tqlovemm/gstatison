//
//  XDRecommendUserView.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/10/24.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, rankTypeRX_ML) {
    rankTypeRX,
    rankTypeML,
};
@class XDRecommendPersonModel,XDRankListModel;


@interface XDRecommendUserView : UIView


@property (nonatomic, strong) NSArray<XDRankListModel *> *usersArray;


@property(nonatomic,assign)rankTypeRX_ML rankType;

@end
