//
//  XDGiftMenuView.h
//  ThirteenmakeFriends
//
//  Created by 空谷凌虚 on 2018/5/9.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XDGiftItemModel;

typedef void(^SendGiftMenuGiftsBlock) (XDGiftItemModel *giftItemModel);

@interface XDGiftMenuView : UIView

@property (nonatomic, strong) NSArray *giftArr;

@property (nonatomic, weak) UIButton *giveBtn;

@property(nonatomic,copy)SendGiftMenuGiftsBlock         giftsBlock;

@property(nonatomic,copy)void (^hideGiftMenuViewBlock)(void);

@end
