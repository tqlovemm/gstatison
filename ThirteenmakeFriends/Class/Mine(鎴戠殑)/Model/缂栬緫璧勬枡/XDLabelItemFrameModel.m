//
//  XDLabelItemFrameModel.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 16/8/24.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import "XDLabelItemFrameModel.h"


#define kMarginLR 10

#define kMarginUD 10

#define kMarginLabs 10

@implementation XDLabelItemFrameModel

- (void)setItemModel:(XDLabelItemModel *)itemModel {
    _itemModel = itemModel;
    
    // 屏幕宽度
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    
    CGFloat marksViewW = screenW - kMarginLabs * 3;
    
    self.labsFrameArr = [NSMutableArray array];
    CGRect lastLabF = CGRectZero;
    CGFloat labX = 0;
    CGFloat labY = 0;
    for (int i = 0; i < itemModel.markArray.count; i++) {
        CGFloat lastMaxW = marksViewW - labX - kMarginLR;
        
        NSString *markString = [itemModel.markArray[i] stringByAppendingString:@"    "];
        
        CGSize labSize = [markString sizeWithFont:kMarkLabFont maxW:(marksViewW - kMarginLR)];
        if (lastMaxW < labSize.width) {
            // 换行
            labX = 0;
            labY = CGRectGetMaxY(lastLabF) + kMarginLabs;
        }
        
        CGRect labF = CGRectMake(labX, labY, labSize.width, 30);
        
        [self.labsFrameArr addObject:[NSValue valueWithCGRect:labF]];
        
        lastLabF = labF;
        
        labX = CGRectGetMaxX(labF) + kMarginLabs;
    }
    
    
    NSValue *lastValue =  [self.labsFrameArr lastObject];
    CGRect lastF = [lastValue CGRectValue];
    
    CGFloat marksViewX = kMarginLabs;
    CGFloat marksViewH = CGRectGetMaxY(lastF);
    self.marksViewFrame = CGRectMake(marksViewX, kMarginUD, marksViewW, marksViewH);
    
    if (self.labsFrameArr.count == 0) {
        self.cellHeight = 44;
    } else {
        self.cellHeight = CGRectGetMaxY(self.marksViewFrame) + kMarginUD;
    }
}

@end
