//
//  XDLabelItemFrameModel.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 16/8/24.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XDLabelItemModel.h"

#define kMarkLabFont  [UIFont systemFontOfSize:13]

@interface XDLabelItemFrameModel : NSObject

@property (nonatomic, strong) XDLabelItemModel *itemModel;

@property (nonatomic, assign) CGRect marksViewFrame;

@property (nonatomic, strong) NSMutableArray *labsFrameArr;

@property (nonatomic, assign) CGFloat cellHeight;

@end
