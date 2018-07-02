//
//  XDRankListViewController.h
//  ThirteenmakeFriends
//
//  Created by 空谷凌虚 on 2018/5/22.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSUInteger, rankType) {
    rankRX_Week  = 0,
    rankRX_Month ,
    rankML_Week  ,
    rankML_Month ,
};
@interface XDRankListViewController : BaseViewController

@property(nonatomic,assign) rankType rankType;

@end
