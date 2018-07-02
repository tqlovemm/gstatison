//
//  previewView.h
//  ThirteenmakeFriends
//
//  Created by jie.huang on 2018/4/12.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XDGiftItemModel;
typedef void(^PushTopUpBlock) (XDGiftItemModel *giftItemModel);
//typedef void(^SendGiftsBlock) (NSInteger);
@interface previewView : UIView

@property(nonatomic,copy)PushTopUpBlock         pushBlock;
//@property(nonatomic,copy)SendGiftsBlock         giftsBlock;

@property (nonatomic,strong) NSArray  *giftsArr;
@end
