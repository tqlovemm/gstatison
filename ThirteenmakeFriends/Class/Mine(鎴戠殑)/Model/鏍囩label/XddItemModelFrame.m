//
//  XddItemModelFrame.m
//  xdd-布局
//
//  Created by jifeng on 16/2/16.
//  Copyright © 2016年 jifeng. All rights reserved.
//

#import "XddItemModelFrame.h"

#import "NSString+Extension.h"
#import "UIView+Extension.h"

#define kMarginLR 8

#define kMarginUD 10

#define kMarginLabs 5

@implementation XddItemModelFrame

- (void)setItemModel:(XddItemModel *)itemModel {
    _itemModel = itemModel;
    
    // 屏幕宽度
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    
    CGSize titleLabSize = [itemModel.title sizeWithFont:kTitleLabFont];
    self.titleLabFrame = CGRectMake(kMarginLR + 6, kMarginUD, titleLabSize.width, titleLabSize.height);
    
    CGFloat marksViewW = screenW - CGRectGetMaxX(self.titleLabFrame) - kMarginLabs;
    
    self.labsFrameArr = [NSMutableArray array];
    CGRect lastLabF = CGRectZero;
    CGFloat labX = 0;
    CGFloat labY = 0;
    for (int i = 0; i < itemModel.markArray.count; i++) {
        CGFloat lastMaxW = marksViewW - labX - kMarginLR;
        
        NSString *markString = [itemModel.markArray[i] stringByAppendingString:@"  "];
        
        CGSize labSize = [markString sizeWithFont:kMarkLabFont maxW:(marksViewW - kMarginLR)];
        if (lastMaxW < labSize.width) {
            // 换行
            labX = 0;
            labY = CGRectGetMaxY(lastLabF) + kMarginLabs;
        }
        
        CGRect labF = CGRectMake(labX, labY, labSize.width, 20);
        
        [self.labsFrameArr addObject:[NSValue valueWithCGRect:labF]];
        
        lastLabF = labF;
        
        labX = CGRectGetMaxX(labF) + kMarginLabs;
    }
    
    
    NSValue *lastValue =  [self.labsFrameArr lastObject];
    CGRect lastF = [lastValue CGRectValue];
    
    CGFloat marksViewX = CGRectGetMaxX(self.titleLabFrame) + kMarginLabs;
    CGFloat marksViewH = CGRectGetMaxY(lastF);
    self.marksViewFrame = CGRectMake(marksViewX, kMarginUD, marksViewW, marksViewH);
    
    self.cellHeight = CGRectGetMaxY(self.marksViewFrame) + kMarginUD;
}

@end
