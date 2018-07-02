//
//  XQSelectMenuView.h
//  上下级菜单选择器
//
//  Created by 徐强 on 15/11/2.
//  Copyright © 2015年 xuqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XQSelectMenuViewDelegate <NSObject>

@optional
- (void)seleteMenuDidChangeHeight;

@end

@interface XQSelectMenuView : UIView

@property (nonatomic, copy) NSString *mainTitle;
@property (nonatomic, copy) NSString *accessoryTitle;

@property (nonatomic, strong) NSArray *mainDatasource;
@property (nonatomic, strong) NSArray *accessoryDatasource;

/**
 *  主数组
 */
@property (nonatomic, strong) NSMutableArray *mainDataArray;
/**
 *  选中数组
 */
@property (nonatomic, strong) NSMutableArray *accessoryDataArray;


/****  自动高度  ****/
@property (nonatomic, assign) BOOL autoHeight;

@property (nonatomic, weak) id <XQSelectMenuViewDelegate> delegate;

@property (strong, nonatomic) UIColor * labelColor;

- (instancetype)initWithFrame:(CGRect)frame andLabelColor:(UIColor *)color;

@end
