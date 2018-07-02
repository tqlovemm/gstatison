//
//  XDFlopNodataView.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/7/5.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDFlopNodataView.h"

@interface XDFlopNodataView ()

/** 错误界面的父视图*/
@property (nonatomic, strong) UIView *errorSuperView;

@property (weak, nonatomic) UIButton *errorImgBtn;

@property (weak, nonatomic) UILabel *errorTitle;

@property (weak, nonatomic) UILabel *errorSubTitle;

@property (weak, nonatomic) UILabel *errorDes;

@end

@implementation XDFlopNodataView

+ (instancetype)errorViewWithSuperView:(UIView *)errorSuperView Frame:(CGRect)frame {
    
    XDFlopNodataView *errorView = [[XDFlopNodataView alloc] initWithFrame:frame];
    errorView.errorSuperView = errorSuperView;
    
    errorView.backgroundColor = GlobalBGColor;
    
    UILabel *errorTitle = [[UILabel alloc] init];
    errorTitle.textColor = RGB(65, 65, 65);
    errorTitle.font = kPingFangBoldFont(18);
    errorTitle.textAlignment = NSTextAlignmentCenter;
    [errorView addSubview:errorTitle];
    errorView.errorTitle = errorTitle;
    
    UILabel *errorSubTitle = [[UILabel alloc] init];
    errorSubTitle.textColor = RGB(65, 65, 65);
    errorSubTitle.font = kPingFangLightFont(14);
    errorSubTitle.textAlignment = NSTextAlignmentCenter;
    [errorView addSubview:errorSubTitle];
    errorView.errorSubTitle = errorSubTitle;
    
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.image = [UIImage imageNamed:@"error_noflopdata"];
    [errorView addSubview:imgView];
    
    UIButton *errorImgBtn = [[UIButton alloc] init];
    [errorImgBtn addTarget:errorView action:@selector(errorImgBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [errorView addSubview:errorImgBtn];
    errorView.errorImgBtn = errorImgBtn;
    
    UILabel *content = [[UILabel alloc] init];
    content.textColor = RGB(170, 170, 170);
    content.font = kPingFangRegularFont(14);
    content.textAlignment = NSTextAlignmentCenter;
    [errorView addSubview:content];
    errorView.errorDes = content;
    
    
    WEAKSELF
    [errorTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).with.offset(35);
        make.centerX.equalTo(weakSelf);
    }];
    
    [errorSubTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(errorTitle.mas_bottom).with.offset(0);
        make.centerX.equalTo(errorTitle.mas_centerX);
    }];
    
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(84, 79));
        make.top.equalTo(errorSubTitle.mas_bottom).with.offset(35);
        make.centerX.equalTo(errorTitle.mas_centerX);
    }];
    
    [errorImgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(188, 50));
        make.top.equalTo(imgView.mas_bottom).with.offset(35);
        make.centerX.equalTo(imgView.mas_centerX);
    }];
    
    [content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(errorImgBtn.mas_bottom).offset(0);
        make.left.equalTo(weakSelf).with.offset(0);
        make.right.equalTo(weakSelf).with.offset(0);
        make.height.mas_equalTo(17);
    }];
    
    [errorView.layer setMasksToBounds:YES];
    [errorView.layer setCornerRadius:10.0f];
    errorView.layer.shouldRasterize = YES; // 缓存圆角，不必每次都渲染圆角，增加流畅度
    errorView.layer.rasterizationScale = [[UIScreen mainScreen] scale]; // 缓存规模
    
    CGFloat scaleBackgroud = 245.0f / 255.0f;
    errorView.backgroundColor = [UIColor colorWithRed:scaleBackgroud green:scaleBackgroud blue:scaleBackgroud alpha:1];
    
    CGFloat scaleBorder = 176.0f / 255.0f;
    [errorView.layer setBorderWidth:.45];
    [errorView.layer setBorderColor:[UIColor colorWithRed:scaleBorder green:scaleBorder blue:scaleBorder alpha:1].CGColor];
    
    return errorView;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UITapGestureRecognizer *singleRecognizer;
    
    singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapFrom)];
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    
    [self addGestureRecognizer:singleRecognizer];
    self.backgroundColor = GlobalBGColor;
    
    self.errorTitle.textColor = [UIColor grayColor];
    self.errorSubTitle.textColor = [UIColor lightGrayColor];
}

- (void)handleSingleTapFrom {
    if ([self.delegate respondsToSelector:@selector(errorViewTapedErrorView:)]) {
        [self.delegate errorViewTapedErrorView:self];
    }
}

- (void)setErrorType:(NSString *)errorType {
    _errorType = errorType;
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"点击右下角"];
    // 创建图片图片附件
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.image = [UIImage imageNamed:@"flop_history"];
    attach.bounds = CGRectMake(0, -8, 26, 26);
    NSAttributedString *attachString = [NSAttributedString attributedStringWithAttachment:attach];
    
    [string appendAttributedString:attachString];
    [string appendAttributedString:[[NSAttributedString alloc] initWithString:@"查看翻牌记录"]];
    
    /** 错误类型
     *  1.flop_error_today_limit       达到今日限制
     *  2.flop_error_nodata            暂无翻牌内容
     *  3.flop_error_localArea_nodata  本地区暂无数据
     *  4.flop_error_unauthorized     未认证
     */
    
    //1.达到今日限制
    NSString *today_limit_img = @"contact_kefu";
    NSString *today_limit_title = @"今日翻牌次数已用完";
    NSAttributedString *today_limit_subtitle = string;
    NSString *today_limit_des = @"获得更多帅哥信息";
    
    //2.暂无翻牌内容
    NSString *nodata_img = @"contact_kefu";
    NSString *nodata_title = @"您的翻牌次数已用完";
    NSAttributedString *nodata_subtitle = string;
    NSString *nodata_des = @"获得更多帅哥信息";
    
    //3.本地区暂无数据
    NSString *localArea_nodata_img = @"contact_kefu";
    NSString *localArea_nodata_title = @"本地区男生已全部显示";
    NSAttributedString *localArea_nodata_subtitle = [[NSAttributedString alloc] initWithString:@"可以选择其他地区继续翻牌"];
    NSString *localArea_nodata_des = @"获得更多帅哥信息";
    
    //4.未认证
    NSString *unauthorized_img = @"shiping_auth";
    NSString *unauthorized_title = @"今日翻牌次数已用完";
    NSAttributedString *unauthorized_subtitle = [[NSAttributedString alloc] initWithString:@"通过认证获得更多翻牌次数"];
    NSString *unauthorized_des = @"获得更多翻牌次数";
    
    if ([errorType isEqualToString:@"flop_error_today_limit"]) {
        [self viewForErrorWithImg:today_limit_img Title:today_limit_title SubTitle:today_limit_subtitle Des:today_limit_des];
        
    }else if ([errorType isEqualToString:@"flop_error_nodata"]){
        [self viewForErrorWithImg:nodata_img Title:nodata_title SubTitle:nodata_subtitle Des:nodata_des];
        
    }else if ([errorType isEqualToString:@"flop_error_localArea_nodata"]){
        [self viewForErrorWithImg:localArea_nodata_img Title:localArea_nodata_title SubTitle:localArea_nodata_subtitle Des:localArea_nodata_des];
        
    }else if ([errorType isEqualToString:@"flop_error_unauthorized"]){
        [self viewForErrorWithImg:unauthorized_img Title:unauthorized_title  SubTitle:unauthorized_subtitle Des:unauthorized_des];
        
    }
}

- (void)setErrorViewWithType:(NSString *)errorType{
    
    self.errorType = errorType;
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"点击右下角"];
    // 创建图片图片附件
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.image = [UIImage imageNamed:@"flop_history"];
    attach.bounds = CGRectMake(0, -8, 26, 26);
    NSAttributedString *attachString = [NSAttributedString attributedStringWithAttachment:attach];
    
    [string appendAttributedString:attachString];
    [string appendAttributedString:[[NSAttributedString alloc] initWithString:@"查看翻牌记录"]];
    
    /** 错误类型
     *  1.flop_error_today_limit       达到今日限制
     *  2.flop_error_nodata            暂无翻牌内容
     *  3.flop_error_localArea_nodata  本地区暂无数据
     *  4.flop_error_unauthorized     未认证
     */
    
    //1.达到今日限制
    NSString *today_limit_img = @"contact_kefu";
    NSString *today_limit_title = @"今日翻牌次数已用完";
    NSAttributedString *today_limit_subtitle = string;
    NSString *today_limit_des = @"获得更多帅哥信息";
    
    //2.暂无翻牌内容
    NSString *nodata_img = @"contact_kefu";
    NSString *nodata_title = @"您的翻牌次数已用完";
    NSAttributedString *nodata_subtitle = string;
    NSString *nodata_des = @"获得更多帅哥信息";
    
    //3.本地区暂无数据
    NSString *localArea_nodata_img = @"contact_kefu";
    NSString *localArea_nodata_title = @"本地区男生已全部显示";
    NSAttributedString *localArea_nodata_subtitle = [[NSAttributedString alloc] initWithString:@"可以选择其他地区继续翻牌"];
    NSString *localArea_nodata_des = @"获得更多帅哥信息";
    
    //4.未认证
    NSString *unauthorized_img = @"shiping_auth";
    NSString *unauthorized_title = @"今日翻牌次数已用完";
    NSAttributedString *unauthorized_subtitle = [[NSAttributedString alloc] initWithString:@"通过认证获得更多翻牌次数"];
    NSString *unauthorized_des = @"获得更多翻牌次数";
    
    if ([errorType isEqualToString:@"flop_error_today_limit"]) {
        [self viewForErrorWithImg:today_limit_img Title:today_limit_title SubTitle:today_limit_subtitle Des:today_limit_des];
        
    }else if ([errorType isEqualToString:@"flop_error_nodata"]){
        [self viewForErrorWithImg:nodata_img Title:nodata_title SubTitle:nodata_subtitle Des:nodata_des];
        
    }else if ([errorType isEqualToString:@"flop_error_localArea_nodata"]){
        [self viewForErrorWithImg:localArea_nodata_img Title:localArea_nodata_title SubTitle:localArea_nodata_subtitle Des:localArea_nodata_des];
        
    }else if ([errorType isEqualToString:@"flop_error_unauthorized"]){
        [self viewForErrorWithImg:unauthorized_img Title:unauthorized_title  SubTitle:unauthorized_subtitle Des:unauthorized_des];
        
    }
    
}

- (void)viewForErrorWithImg:(NSString *)img Title:(NSString *)title SubTitle:(NSAttributedString *)subTitle Des:(NSString *)des {
    
    [self.errorImgBtn setImage:[UIImage imageNamed:img] forState:UIControlStateNormal];
    
    self.errorTitle.text = title;
    
    self.errorSubTitle.attributedText = subTitle;
    
    self.errorDes.text = des;
}

// 添加错误视图
- (XDFlopNodataView *)addErrorViewWithType:(NSString *)type {
    self.errorType = type;
    if ([self.delegate respondsToSelector:@selector(errorViewAddErrorView:)]) {
        [self.delegate errorViewAddErrorView:self];
    }
    XDFlopNodataView *tempErrorView = [XDFlopNodataView errorViewWithSuperView:self.errorSuperView Frame:self.frame];
    tempErrorView.delegate = self.delegate;
//    [tempErrorView setErrorViewWithType:type];
    tempErrorView.errorType = type;
    [self.errorSuperView addSubview:tempErrorView];
    tempErrorView.errorSuperView = self.errorSuperView;
    
    [XDFlopNodataView errorViewRemove:self];
    return tempErrorView;
}

// 移除错误视图
- (XDFlopNodataView *)removeErrorView {
    if ([self.delegate respondsToSelector:@selector(errorViewRemoveErrorView:)]) {
        [self.delegate errorViewRemoveErrorView:self];
    }
    
    XDFlopNodataView *tempErrorView = [XDFlopNodataView errorViewWithSuperView:self.errorSuperView Frame:self.frame];
    tempErrorView.delegate = self.delegate;
    tempErrorView.errorSuperView = self.errorSuperView;
    
    [XDFlopNodataView errorViewRemove:self];
    return tempErrorView;
}

+ (void)errorViewRemove:(XDFlopNodataView *)selfView {
    [selfView removeFromSuperview];
    selfView = nil;
}

#pragma mark - 按钮点击
- (void)errorImgBtnClicked:(UIButton *)btn {
    
    if ([self.delegate respondsToSelector:@selector(errorViewWithErrorBtnClicked:ErrorView:)]) {
        [self.delegate errorViewWithErrorBtnClicked:btn ErrorView:self];
    }
}

@end
