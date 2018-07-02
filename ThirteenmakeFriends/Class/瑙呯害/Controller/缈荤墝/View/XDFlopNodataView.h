//
//  XDFlopNodataView.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/7/5.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XDFlopNodataView;

@protocol XDFlopNodataViewDelegate <NSObject>

@optional

/**
 *  错误按钮点击的操作
 */
- (void)errorViewWithErrorBtnClicked:(UIButton *)errotBtn ErrorView:(XDFlopNodataView *)errorView;

/**
 *  添加错误提示界面之后的操作
 */
- (void)errorViewAddErrorView:(XDFlopNodataView *)errorView;

/**
 *  移除错误提示界面之后的操作
 */
- (void)errorViewRemoveErrorView:(XDFlopNodataView *)errorView;


@required
/**
 *  点击提示界面
 */
- (void)errorViewTapedErrorView:(XDFlopNodataView *)errorView;

@end

@interface XDFlopNodataView : UIView

/** 错误类型
 *  1.flop_error_today_limit       达到今日限制
 *  2.flop_error_nodata            暂无翻牌内容
 *  3.flop_error_localArea_nodata  本地区暂无数据
 *  4.flop_error_unauthorized      未认证
 */
@property (nonatomic, copy) NSString *errorType;

+ (instancetype)errorViewWithSuperView:(UIView *)errorSuperView Frame:(CGRect)frame;

@property(assign, nonatomic) id<XDFlopNodataViewDelegate> delegate;

/**
 *  添加错误视图
 */
- (XDFlopNodataView *)addErrorViewWithType:(NSString *)type;

/**
 *  移除错误视图
 */
- (XDFlopNodataView *)removeErrorView;

@end
