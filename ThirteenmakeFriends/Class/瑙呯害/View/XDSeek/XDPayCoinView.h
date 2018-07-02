//
//  XDPayCoinView.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/8/31.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    DateNotice,//约会
    SaveMeNotice//就我
} XDSeekPayType;

@protocol XDPayCoinViewDelegate <NSObject>
@optional
- (void)entryPay;

- (void)entryPayWithIndexPath:(NSIndexPath *)indexPath;

@end

@interface XDPayCoinView : UIView

@property (copy, nonatomic)   NSString * price;
@property (strong, nonatomic) NSIndexPath *cellIndex;
@property (nonatomic, assign) XDSeekPayType noticeType;

- (void)startAnim;

@property (weak, nonatomic) id<XDPayCoinViewDelegate> delegate;

@end
