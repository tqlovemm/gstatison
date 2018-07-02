//
//  OtherInfoFrame.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 16/3/4.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShiSanUser.h"

@interface OtherInfoFrame : NSObject

@property (strong, nonatomic) ShiSanUser * user;

//! 用户名
@property (nonatomic, assign, readonly) CGRect nameLabelF;

//! 年龄
@property (nonatomic, assign, readonly) CGRect ageLabelF;

//! 身高
@property (nonatomic, assign, readonly) CGRect heightLabelF;

//! 体重
@property (nonatomic, assign, readonly) CGRect weightLabelF;

//! 签名
@property (nonatomic, assign, readonly) CGRect signatureLabelF;

//! cellHeight
@property (nonatomic, assign, readonly) CGFloat cellHeight;

@end
