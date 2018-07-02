//
//  XDPay.h
//  MeiziIntro
//
//  Created by Xudongdong on 16/7/27.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface XDPay : NSObject
/** 图标 */
@property (strong, nonatomic) UIImage * icon;
/** 机构名称 */
@property (copy, nonatomic) NSString * title;
/** 支付描述 */
@property (copy, nonatomic) NSString * des;

/** 状态量标识有无被打钩 */
@property (nonatomic, assign, getter = isChecked) BOOL checked;
@end
