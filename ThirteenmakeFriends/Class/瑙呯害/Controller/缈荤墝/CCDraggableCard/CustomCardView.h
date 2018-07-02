//
//  CustomCardView.h
//  CCDraggableCard-Master
//
//  Created by jzzx on 16/7/9.
//  Copyright © 2016年 Zechen Liu. All rights reserved.
//

#import "CCDraggableCardView.h"
@class ShiSanUser;

@interface CustomCardView : CCDraggableCardView

- (void)installData:(ShiSanUser *)user;


#pragma mark - 新增(增加喜欢不喜欢遮罩)

- (void)likeViewWithAlpha:(CGFloat )alpha;

- (void)dislikeViewWithAlpha:(CGFloat )alpha;

@end
