//
//  XDLabelListView.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/9/5.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kDefaultDuration 1.0

@interface XDLabelListView : UIView <NSCoding>

@property (nonatomic, strong) UIFont         *font;                        // 字体
@property (nonatomic, strong) UIColor        *textColor;                   // 未选中时颜色
@property (nonatomic, strong) UIColor        *selectedTextColor;           // 选中时颜色
@property (nonatomic, strong) UIColor        *tagBackgroundColor;          // 未选中时背景色
@property (nonatomic, strong) UIColor        *selectedTagBackgroundColor;  // 选中时背景色
@property (nonatomic, assign) CGFloat        horiSpacing;                  // 标签水平间距
@property (nonatomic, assign) CGFloat        vertSpacing;                  // 标签垂直间距
@property (nonatomic, assign) UIEdgeInsets   tagEdge; // 文字与边框的距离
@property (nonatomic, assign) CGFloat        tagCornerRadius;
@property (nonatomic, assign) BOOL           multiLine;                    // 是否多行显示
@property (nonatomic, assign) BOOL           multiSelect;                  // 是否可多选
@property (nonatomic, assign) BOOL		     allowNoSelection;
@property (nonatomic, assign) BOOL		     scrollBounce;
@property (nonatomic, assign) BOOL           allowsDuplicates;

@property (nonatomic, strong) NSArray   *tags;

@end
