//
//  XDSeekRecordFrame.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 16/6/30.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XDSeekRecord;

@interface XDSeekRecordFrame : NSObject

@property (strong, nonatomic) XDSeekRecord * record;

//! 妹子头像frame
@property (nonatomic, assign, readonly) CGRect girlHeadIconFrame;

//! 妹子编号frame
@property (nonatomic, assign, readonly) CGRect girlNumFrame;

//! 妹子标签frame
@property (nonatomic, assign, readonly) CGRect girlLabFrame;

//! 交友要求frame
@property (nonatomic, assign, readonly) CGRect datingRequireFrame;

//! 花费记录frame
@property (nonatomic, assign, readonly) CGRect costRecordFrame;

//! 觅约状态frame
@property (nonatomic, assign, readonly) CGRect seekStateFrame;

@property (nonatomic, assign, readonly) CGFloat cellHeight;

@end
