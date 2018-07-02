//
//  XDSeekRecordFrame.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 16/6/30.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import "XDSeekRecordFrame.h"
#import "XDSeekRecord.h"

#define kFont12 [UIFont systemFontOfSize:12.0f]
#define kFont14 [UIFont systemFontOfSize:14.0f]

@implementation XDSeekRecordFrame

- (void)setRecord:(XDSeekRecord *)record {
    _record = record;
    
    CGFloat girlHeadIconWH = 75;
    CGFloat girlHeadIconX = postCellBorder;
    CGFloat girlHeadIconY = postCellBorder;
    _girlHeadIconFrame = CGRectMake(girlHeadIconX, girlHeadIconY, girlHeadIconWH, girlHeadIconWH);
    
    CGFloat girlNumX = postCellBorder + CGRectGetMaxX(_girlHeadIconFrame);
    CGFloat girlNumY = girlHeadIconY;
    CGSize girlNumSize = [record.number sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:14.0f] andMaxSize:CGSizeMake(80, 25)];
    _girlNumFrame = (CGRect) {{girlNumX,girlNumY} ,girlNumSize};
    
    CGFloat costRecordX = postCellBorder * 0.5 + CGRectGetMaxX(_girlNumFrame);
    CGFloat costRecordY = girlHeadIconY;
    
    NSString *costRecordStr = nil;
    if (record.status == 10) { // 觅约等待中
        costRecordStr = [NSString stringWithFormat:@"冻结%ld%@",record.coin,coin_name];
    } else if (record.status == 11) { // 觅约成功
        costRecordStr = [NSString stringWithFormat:@"扣除%ld%@",record.coin,coin_name];
    } else if (record.status == 12) { // 觅约失败
        costRecordStr = [NSString stringWithFormat:@"返回%ld%@",record.coin,coin_name];
    } else {
        costRecordStr = [NSString stringWithFormat:@"未知操作"];
    }
    CGSize costRecordSize = [costRecordStr sizeWithFont:kFont14];
    _costRecordFrame = (CGRect) {{costRecordX,costRecordY} ,costRecordSize};
    
    CGFloat seekStateX = postCellBorder * 0.5 + CGRectGetMaxX(_costRecordFrame);
    CGFloat seekStateY = girlHeadIconY;
    NSString *seekState = nil;
    if (record.status == 10) { // 觅约等待中
        seekState = [NSString stringWithFormat:@"等待中"];
    } else if (record.status == 11) { // 觅约成功
        seekState = [NSString stringWithFormat:@"成功"];
    } else if (record.status == 12) { // 觅约失败
        seekState = [NSString stringWithFormat:@"失败"];
    } else {
        seekState = [NSString stringWithFormat:@"未知操作"];
    }
    
    CGSize seekStateSize = [seekState sizeWithFont:kFont14];
    _seekStateFrame = (CGRect) {{seekStateX,seekStateY} ,seekStateSize};
    
    CGFloat girlLabX = girlNumX;
    CGFloat girlLabY = CGRectGetMaxY(_girlNumFrame) + postCellBorder;
    CGSize girlLabSize = [record.mark sizeWithFont:kFont12];
    _girlLabFrame = (CGRect) {{girlLabX,girlLabY} ,girlLabSize};
    
    CGFloat datingRequireX = girlLabX;
    CGFloat datingRequireY = CGRectGetMaxY(_girlLabFrame) + postCellBorder;
    CGSize datingRequireSize = [record.require sizeWithFont:kFont12];
    _datingRequireFrame = (CGRect) {{datingRequireX,datingRequireY} ,datingRequireSize};
    
    _cellHeight = MAX(CGRectGetMaxY(_datingRequireFrame), CGRectGetMaxY(_girlHeadIconFrame)) + postCellBorder;
}

@end
