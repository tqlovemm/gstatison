//
//  XDPayView.h
//  MeiziIntro
//
//  Created by Xudongdong on 16/7/27.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XDPayViewDelegate <NSObject>

- (void)entryPayMoney:(NSInteger )money andPlatform:(NSString *)platform;

@end

@interface XDPayView : UIView

@property (assign, nonatomic) NSInteger totalPrice;

- (void)startAnim;

@property (weak, nonatomic) id<XDPayViewDelegate> delegate;
@end
