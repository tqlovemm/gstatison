//
//  XDCardItemView.h
//  MemberCardDemo
//
//  Created by Xudongdong on 2017/7/10.
//  Copyright © 2017年 Xudongdong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XDCardModel;

@interface XDCardItemView : UIView

@property (nonatomic, assign) BOOL is_status;
@property (nonatomic, strong) XDCardModel *cardModel;

@end
