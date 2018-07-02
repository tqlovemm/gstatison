//
//  XDFlopEvaluationModel.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 17/1/12.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//  喜欢我的人与相互匹配的人的模型

#import <Foundation/Foundation.h>
@class ShiSanUser;

@interface XDFlopEvaluationModel : NSObject

/** 是否匹配（1.已匹配 2.已发送) */
@property (assign, nonatomic) NSInteger is_friend;

@property (strong, nonatomic) ShiSanUser * info;


@end
