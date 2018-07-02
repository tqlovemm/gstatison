//
//  XDLabelListView.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/9/5.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDLabelListView.h"

#define kMinSpacing 8.0

@interface XDLabelListView ()

@property (nonatomic, strong) NSMutableArray *mutableTags;

@property (nonatomic, strong) UIView  *scrollLayer;
@property (nonatomic, strong) NSMutableArray *tagLayerArray;

@property (nonatomic, assign) CGPoint        lastPoint;
@property (nonatomic, assign) CGPoint        startPoint;
@property (nonatomic, assign) BOOL		     isClick;

@end

@implementation XDLabelListView

- (instancetype)initWithTags:(NSArray *)tags{
    if (self = [super init]) {
        self.mutableTags = [tags mutableCopy];
        [self commonInit];
    }
    return self;
}

- (instancetype)init{
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit{
    self.font                       = [UIFont systemFontOfSize:17];
    self.textColor                  = [UIColor blackColor];
    self.selectedTextColor          = [UIColor blackColor];
    self.tagBackgroundColor         = [UIColor clearColor];
    self.selectedTagBackgroundColor = [UIColor clearColor];
    self.multiLine                  = NO;
    self.multiSelect                = NO;
    self.allowNoSelection           = NO;
    self.scrollBounce               = NO;
    self.horiSpacing                = 8;
    self.backgroundColor            = [UIColor clearColor];
}

- (CGFloat)horiSpacing{
    if (_horiSpacing < kMinSpacing) {
        _horiSpacing = kMinSpacing;
    }
    return _horiSpacing;
}

- (CGFloat)vertSpacing{
    if (_vertSpacing < kMinSpacing) {
        _vertSpacing = kMinSpacing;
    }
    return _vertSpacing;
}

- (UIView *)scrollLayer{
    if (!_scrollLayer) {
        _scrollLayer = [[UIView alloc] init];
    }
    return _scrollLayer;
}

- (NSMutableArray *)mutableTags{
    if (!_mutableTags) {
        _mutableTags = [NSMutableArray array];
    }
    return _mutableTags;
}

- (NSMutableArray *)tagLayerArray{
    if (!_tagLayerArray) {
        _tagLayerArray = [NSMutableArray array];
    }
    return _tagLayerArray;
}

-(NSArray *)tags{
    return self.mutableTags;
}

- (void)setTags:(NSArray *)tags{
    for (UILabel *label in self.scrollLayer.subviews) {
        [label removeFromSuperview];
    }
    [self.mutableTags removeAllObjects];
    [self.mutableTags addObjectsFromArray:tags];
    [self removeDuplicateTags];
    [self setNeedsDisplay];
    
    self.scrollLayer.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.scrollLayer];
    [self.tagLayerArray removeAllObjects];
    
    XD_WeakSelf
    [self.scrollLayer mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.left.right.top.bottom.mas_equalTo(self);
    }];
    
    CGPoint curPos = CGPointZero;
    for (NSUInteger i = 0 ; i < self.mutableTags.count; i ++) {
        NSString *tag = self.mutableTags[i];
        CGSize textSize           = [self getTextSize:tag andFont:self.font];
        CGSize tagSize            = textSize;
        tagSize.width  += self.tagEdge.left + self.tagEdge.right;
        tagSize.height += self.tagEdge.top + self.tagEdge.bottom;
        if (self.multiLine) {
            if (curPos.x > 0 && curPos.x + tagSize.width > SCREEN_WIDTH - 20) {
                curPos.x = 0;
                curPos.y += tagSize.height + self.vertSpacing;
            }
        }
        UILabel *tagLayer         = [[UILabel alloc] init];
//        tagLayer.layer.borderWidth = 0.8;
        tagLayer.frame            =  CGRectMake(curPos.x, curPos.y, tagSize.width, tagSize.height);
        CATextLayer *textLayer    = [CATextLayer layer];
        textLayer.frame           = CGRectMake(self.tagEdge.left, self.tagEdge.top, textSize.width, textSize.height);
//        curPos.x += tagSize.width + self.horiSpacing;
        textLayer.font            = (__bridge CFTypeRef)self.font.fontName;
        textLayer.fontSize        = self.font.pointSize;
//        tagLayer.layer.borderColor = self.tagBackgroundColor.CGColor;
        tagLayer.backgroundColor = self.tagBackgroundColor;
        textLayer.foregroundColor = self.textColor.CGColor;
        textLayer.string          = tag;
        textLayer.contentsScale   = [UIScreen mainScreen].scale;
        if (self.tagCornerRadius > 0) {
            tagLayer.layer.masksToBounds = YES;
            tagLayer.layer.cornerRadius  = self.tagCornerRadius;
        }
        [self.tagLayerArray addObject:tagLayer];
        [tagLayer.layer addSublayer:textLayer];
        [self.scrollLayer addSubview:tagLayer];
        
        [tagLayer mas_makeConstraints:^(MASConstraintMaker *make) {
            XD_StrongSelf
            make.left.mas_equalTo(curPos.x);
            make.top.mas_equalTo(curPos.y);
            make.width.mas_equalTo(tagSize.width);
            make.height.mas_equalTo(tagSize.height);
            if (i == self.mutableTags.count - 1) {
                make.bottom.mas_equalTo(self.scrollLayer);
            }
        }];
        
//        if  (i == self.mutableTags.count - 1) {
//            
//            [self.scrollLayer mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.left.right.top.mas_equalTo(self);
//                make.bottom.mas_equalTo(tagLayer.mas_bottom);
//            }];
//        } else {
//            [tagLayer mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.mas_equalTo(curPos.x);
//                make.top.mas_equalTo(curPos.y);
//                make.width.mas_equalTo(tagSize.width);
//                make.height.mas_equalTo(tagSize.height);
//            }];
//        }
        curPos.x += tagSize.width + self.horiSpacing;
    }
}

- (CGSize)getTextSize: (id)text andFont: (UIFont *)font{
    if (!text) {
        return CGSizeZero;
    }
    NSString *str = nil;
    NSDictionary *attributes = nil;
    if ([text isKindOfClass: [NSString class]]) {
        str = text;
        attributes = @{NSFontAttributeName: font};
    }
    else if([text isKindOfClass:[NSAttributedString class]])
    {
        NSAttributedString *attrStr = (NSAttributedString *)text;
        str = attrStr.string;
        NSRange range;
        attributes = [attrStr attributesAtIndex:0 effectiveRange:&range];
    }
    if ([text respondsToSelector:@selector(sizeWithAttributes:)]) {
        return [str sizeWithAttributes: attributes];
    }
    else {
#pragma clang diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated"
        return [str sizeWithFont:font];
#pragma clang diagnostic pop
    }
}

- (void)removeDuplicateTags{
    if (self.allowsDuplicates) {
        return;
    }
    NSMutableArray *resultArray  = [NSMutableArray array];
    for (NSString *tag in self.mutableTags) {
        if (![resultArray containsObject:tag]) {
            [resultArray addObject:tag];
        }
    }
    self.mutableTags = resultArray;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self setNeedsDisplay];
}

- (void)setBounds:(CGRect)bounds{
    [super setBounds:bounds];
    [self setNeedsDisplay];
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    [self setNeedsDisplay];
}

//- (void)drawRect:(CGRect)rect{
//    self.scrollLayer.frame = rect;
//    self.scrollLayer.backgroundColor = [UIColor clearColor].CGColor;
//    
//    // 1. 填充背景
//    [self.backgroundColor setFill];
//    UIRectFill(self.bounds);
//    
//    // 2. 移除所有sublayers
//    self.scrollLayer.sublayers = nil;
//    self.layer.sublayers = nil;
//    
//    // 3. 添加scrollLayer
//    [self.layer addSublayer:self.scrollLayer];
//    
//    // 4. 添加textLayers
//    [self.tagLayerArray removeAllObjects];
//    CGPoint curPos = CGPointZero;
//    for (NSUInteger i = 0 ; i < self.mutableTags.count; i ++) {
//        NSString *tag = self.mutableTags[i];
//        CGSize textSize           = [self getTextSize:tag andFont:self.font];
//        CGSize tagSize            = textSize;
//        tagSize.width  += self.tagEdge.left + self.tagEdge.right;
//        tagSize.height += self.tagEdge.top + self.tagEdge.bottom;
//        if (self.multiLine) {
//            if (curPos.x > 0 && curPos.x + tagSize.width > rect.size.width) {
//                curPos.x = 0;
//                curPos.y += tagSize.height + self.vertSpacing;
//            }
//        }
//        CALayer *tagLayer         = [CALayer layer];
//        tagLayer.borderWidth = 0.8;
//        tagLayer.frame            =  CGRectMake(curPos.x, curPos.y, tagSize.width, tagSize.height);
//        CATextLayer *textLayer    = [CATextLayer layer];
//        textLayer.frame           = CGRectMake(self.tagEdge.left, self.tagEdge.top, textSize.width, textSize.height);
//        curPos.x += tagSize.width + self.horiSpacing;
//        textLayer.font            = (__bridge CFTypeRef)self.font.fontName;
//        textLayer.fontSize        = self.font.pointSize;
//        if ([self.mutableSelectedIndexSet containsIndex:i]) {
//            //            tagLayer.backgroundColor = self.selectedTagBackgroundColor.CGColor;
//            tagLayer.borderColor = self.selectedTagBackgroundColor.CGColor;
//            textLayer.foregroundColor = self.selectedTextColor.CGColor;
//        }
//        else{
//            //            tagLayer.backgroundColor = self.tagBackgroundColor.CGColor;
//            tagLayer.borderColor = self.tagBackgroundColor.CGColor;
//            textLayer.foregroundColor = self.textColor.CGColor;
//        }
//        textLayer.string          = tag;
//        textLayer.contentsScale   = [UIScreen mainScreen].scale;
//        if (self.tagCornerRadius > 0) {
//            tagLayer.masksToBounds = YES;
//            tagLayer.cornerRadius  = self.tagCornerRadius;
//        }
//        [self.tagLayerArray addObject:tagLayer];
//        [tagLayer addSublayer:textLayer];
//        [self.scrollLayer addSublayer:tagLayer];
//    }
//}
//
//- (CGSize)getTextSize: (id)text andFont: (UIFont *)font{
//    if (!text) {
//        return CGSizeZero;
//    }
//    NSString *str = nil;
//    NSDictionary *attributes = nil;
//    if ([text isKindOfClass: [NSString class]]) {
//        str = text;
//        attributes = @{NSFontAttributeName: font};
//    }
//    else if([text isKindOfClass:[NSAttributedString class]])
//    {
//        NSAttributedString *attrStr = (NSAttributedString *)text;
//        str = attrStr.string;
//        NSRange range;
//        attributes = [attrStr attributesAtIndex:0 effectiveRange:&range];
//    }
//    if ([text respondsToSelector:@selector(sizeWithAttributes:)]) {
//        return [str sizeWithAttributes: attributes];
//    }
//    else {
//#pragma clang diagnostic push
//#pragma GCC diagnostic ignored "-Wdeprecated"
//        return [str sizeWithFont:font];
//#pragma clang diagnostic pop
//    }
//}
@end
