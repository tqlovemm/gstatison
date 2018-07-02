//
//  XHPaggingNavbar.h
//  XHTwitterPagging
//
//  Created by 曾 宪华 on 14-6-20.
//  Copyright (c) 2014年 曾宪华 QQ群: (142557668) QQ:543413507  Gmail:xhzengAIB@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTPaggingNavbar : UIView

/**
 *  显示在导航条上的title集合
 */
@property (nonatomic, strong) NSArray *titles;

/**
 *  当前页码
 */
@property (nonatomic, assign) NSInteger currentPage;

/**
 *  设置navBar的Button正常时的颜色
 */
@property (nonatomic, strong) UIColor *navBarButtonNormalColor;

/**
 *  设置navBar的Button选中时的颜色
 */
@property (nonatomic, strong) UIColor *navBarButtonSelectedColor;

/**
 *  设置navBar的Button下划线选中时的颜色
 */
@property (nonatomic, strong) UIColor *navBarButtonLineViewColor;

/**
 *  外部设置滑动页面的距离
 */
@property (nonatomic, assign) CGPoint contentOffset;

@property (nonatomic, copy) void (^didChangedIndex)(NSInteger index);

/**
 *  设置title集合数据源后，进行reload的方法
 */
- (void)reloadData;
/**
 *  获取到顶部视图个数
 */
- (id)initWithFrame:(CGRect)frame withNumber:(NSInteger) pageCount  withTitles:(NSArray *)titles NormalColor:(UIColor *)normalColor SelectedColor:(UIColor *)selectedColor;

@end
