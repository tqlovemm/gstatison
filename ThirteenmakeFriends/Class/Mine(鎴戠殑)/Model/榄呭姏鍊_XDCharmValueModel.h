//
//  XDCharmValueModel.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 16/6/27.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XDCharmValueModel : NSObject
//! 会员等级
@property (nonatomic, copy) NSString *levels;
//! 等级名称
@property (nonatomic, copy) NSString *degree;
//! 外貌形象
@property (nonatomic, copy) NSString *appearance;
//! 言谈技巧
@property (nonatomic, copy) NSString *lan_skills;
//! 心动币
@property (nonatomic, copy) NSString *jiecao_coin;
//! 羞羞技能
@property (nonatomic, copy) NSString *sex_skills;
//! 用户粘度
@property (nonatomic, copy) NSString *viscosity;

@end
