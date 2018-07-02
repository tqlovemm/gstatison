//
//  XDEditInfoModel.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/12/21.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XDEditInfoModel : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *text;

@property (nonatomic, copy) NSString *placeholder;
/** 可选类型 1.必填 2.选填 0.不显示 */
@property (nonatomic, assign) NSInteger optionalType;

@end
