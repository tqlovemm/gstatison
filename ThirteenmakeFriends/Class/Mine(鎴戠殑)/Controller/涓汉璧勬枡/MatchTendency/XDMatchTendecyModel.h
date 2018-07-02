//
//  XDMatchTendecyModel.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/12/22.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XDMatchTendecyModel : NSObject

/** 1.都可以接受 2.只接受同省市 3.只接受异地 */
@property (nonatomic, assign) NSInteger accept_area;
/** 1.都可以 2.只接受比自己大的 3.只接受比自己小的 */
@property (nonatomic, assign) NSInteger accept_age;
/** 1.偏保守 2.看感觉 3.偏开放 */
@property (nonatomic, assign) NSInteger accept_sex;

@property (nonatomic, copy) NSString *hope_cp_like;

@end
