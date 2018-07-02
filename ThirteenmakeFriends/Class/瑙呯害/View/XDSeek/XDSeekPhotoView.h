//
//  XDSeekPhotoView.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/9/1.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDSeekPhotoView : UIView

@property (nonatomic, copy) NSString *photo;
@property (nonatomic, assign) NSInteger photoCount;
@property (nonatomic, assign) BOOL is_limited;

/**
 支付
 */
@property (copy, nonatomic) void (^recommendButtonClicked)(UIButton *btn);
@end
