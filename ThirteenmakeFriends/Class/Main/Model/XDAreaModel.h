//
//  XDAreaModel.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/8/8.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XDAreaChildrenModel;

@interface XDAreaModel : NSObject

/** 地区ID */
@property (copy, nonatomic) NSString * areaID;

/** 地区 */
@property (copy, nonatomic) NSString * area;

@property (nonatomic, strong) NSArray<XDAreaChildrenModel *> *children;

@end

@interface XDAreaChildrenModel : NSObject

/** 地区ID */
@property (copy, nonatomic) NSString * areaID;

/** 地区 */
@property (copy, nonatomic) NSString * area;

/** 父地区ID */
@property (nonatomic, copy) NSString *fatherID;

@end
