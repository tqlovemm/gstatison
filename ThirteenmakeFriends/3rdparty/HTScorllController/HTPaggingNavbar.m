//
//  XHPaggingNavbar.m
//  XHTwitterPagging
//
//  Created by 曾 宪华 on 14-6-20.
//  Copyright (c) 2014年 曾宪华 QQ群: (142557668) QQ:543413507  Gmail:xhzengAIB@gmail.com. All rights reserved.
//

#import "HTPaggingNavbar.h"
#import "UIView+LSAdditions.h"

#define kXHiPad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

#define kXHLabelBaseTag 1000

#define kXHRadie 3.2

/** 4px线条*/
#define SINGLE_LINE_WH_MULTIPLE       (4 / [UIScreen mainScreen].scale)

@interface HTPaggingNavbar () {
    CGFloat _mainScreenWidth;
    
    UIView *_rightView;
    NSMutableArray *_btnList;
    NSInteger sumCount;
}

@property (nonatomic, weak) UIView *buttonLineView;
/**
 *  分页指示器
 */

@end

@implementation HTPaggingNavbar

#pragma mark - DataSource

- (void)reloadData {
    if (!self.titles.count) {
        return;
    }
}

- (UIColor *)navBarButtonNormalColor {
    if (_navBarButtonNormalColor == nil) {
        return [UIColor whiteColor];
    }
    return _navBarButtonNormalColor;
}

- (UIColor *)navBarButtonSelectedColor {
    if (_navBarButtonSelectedColor == nil) {
        return [UIColor yellowColor];
    }
    return _navBarButtonSelectedColor;
}

- (UIColor *)navBarButtonLineViewColor {
    if (_navBarButtonLineViewColor == nil) {
        return [UIColor whiteColor];
    }
    return _navBarButtonLineViewColor;
}

#pragma mark - Propertys
- (void)setCurrentPage:(NSInteger)currentPage {
    _currentPage = currentPage;
    
    [_btnList enumerateObjectsUsingBlock:^(UIButton *sBtton, NSUInteger idx, BOOL *stop) {
        if (_currentPage == idx) {
//            [self addButtonLineViewWithFrame:CGRectMake(sBtton.origin.x, (CGRectGetMaxY(sBtton.frame)), (self.width/sumCount), SINGLE_LINE_WH_MULTIPLE)];
            
            // 设置横线宽度
            CGFloat btnX = [sBtton.titleLabel convertPoint:sBtton.titleLabel.origin toView:_rightView].x - sBtton.titleLabel.x;
            [self addButtonLineViewWithFrame:CGRectMake(btnX, (CGRectGetMaxY(sBtton.frame)), sBtton.titleLabel.width, SINGLE_LINE_WH_MULTIPLE)];
            [sBtton setTitleColor:self.navBarButtonSelectedColor forState:UIControlStateNormal];
        }else{
            [sBtton setTitleColor:self.navBarButtonNormalColor forState:UIControlStateNormal];
        }
    }];  
}

- (void)setContentOffset:(CGPoint)contentOffset {
//    _contentOffset = contentOffset;
//    CGFloat xOffset = contentOffset.x;
//    CGFloat normalWidth = CGRectGetWidth([[UIScreen mainScreen] bounds]);
//    CGFloat xLine = (xOffset/normalWidth)*PageWidth;
//    [UIView animateWithDuration:0.15 animations:^{
////        _bgLineView.left = xLine;
//    } completion:^(BOOL finished) {
//        
//    }];
}

#pragma mark - Life Cycle

- (id)initWithFrame:(CGRect)frame withNumber:(NSInteger) pageCount  withTitles:(NSArray *)titles NormalColor:(UIColor *)normalColor SelectedColor:(UIColor *)selectedColor {
    self = [super initWithFrame:frame];
    if (self) {
        self.navBarButtonNormalColor = normalColor;
        self.navBarButtonSelectedColor = selectedColor;
        sumCount = pageCount;
        _titles = [[NSArray alloc] initWithArray:titles];
        // Initialization code
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _mainScreenWidth = [[UIScreen mainScreen] bounds].size.width;
        _rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width-2, 31)];
        _rightView.backgroundColor = [UIColor clearColor];
        [self addSubview:_rightView];
        [self createButtonView];
    }
    return self;
}

- (void)dealloc {
}
-(void)createButtonView
{
    _btnList = [NSMutableArray array];
    for (int i = 0; i<sumCount; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i*(self.width/sumCount), 0, (self.width/sumCount), 31);
        button.tag = i + 100;
        [button setTitle:_titles[i] forState:UIControlStateNormal];
        [button setTitleColor:self.navBarButtonNormalColor forState:UIControlStateNormal];
        [button setTitleColor:self.navBarButtonNormalColor forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(didClickHeadButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
        
        [_rightView addSubview:button];
        [_btnList addObject:button];
        
        if (i == 0) {
//            [self addButtonLineViewWithFrame:CGRectMake(button.origin.x, (CGRectGetMaxY(button.frame)), (self.width/sumCount), SINGLE_LINE_WH_MULTIPLE)];
            // 设置横线宽度
            CGFloat btnW = [button.titleLabel.text sizeWithFont:[UIFont systemFontOfSize:17.0]].width;
            CGFloat btnX = (button.width - btnW) / 2.0;
            [self addButtonLineViewWithFrame:CGRectMake(btnX, (CGRectGetMaxY(button.frame)), btnW, SINGLE_LINE_WH_MULTIPLE)];
             [button setTitleColor:self.navBarButtonSelectedColor forState:UIControlStateNormal];
             [button setTitleColor:self.navBarButtonSelectedColor forState:UIControlStateHighlighted];
        }
    }
}
-(void)didClickHeadButtonAction:(UIButton *)sender
{
    self.didChangedIndex(sender.tag - 100);
}

- (void)addButtonLineViewWithFrame:(CGRect)frame {
    [self.buttonLineView removeFromSuperview];
    self.buttonLineView = nil;
    
    UIView *buttonLineView = [[UIView alloc] initWithFrame:frame];
    [_rightView addSubview:buttonLineView];
    
    self.buttonLineView = buttonLineView;
    
    buttonLineView.backgroundColor = [UIColor blackColor];
}

@end
