//
//  XddItemModelFrame.h
//  xdd-布局
//
//  Created by jifeng on 16/2/16.
//  Copyright © 2016年 jifeng. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XddItemModel.h"

#define kTitleLabFont  [UIFont systemFontOfSize:16]

#define kMarkLabFont  [UIFont systemFontOfSize:14]

@interface XddItemModelFrame : NSObject

@property (nonatomic, strong) XddItemModel *itemModel;

@property (nonatomic, assign) CGRect titleLabFrame;

@property (nonatomic, assign) CGRect marksViewFrame;

@property (nonatomic, strong) NSMutableArray *labsFrameArr;

@property (nonatomic, assign) CGFloat cellHeight;

@end
