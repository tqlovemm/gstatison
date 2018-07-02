//
//  XDExclusiveDetailCell.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/9/6.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDExclusiveDetailCell.h"
#import "XDExclusiveBasicInfoView.h"
#import "XDSeekCertView.h"
#import "XDSeekLabelView.h"
#import "XDSeekPayView.h"
#import "ExclusiveModel.h"

@interface XDExclusiveDetailCell ()

@property (nonatomic, strong) XDExclusiveBasicInfoView *basicInfoView;

@property (nonatomic, strong) XDSeekCertView *certView;

@property (nonatomic, strong) XDSeekLabelView *basicView;

@property (nonatomic, strong) XDSeekLabelView *likeTypeView;

@property (nonatomic, strong) XDSeekPayView *payView;

@end

@implementation XDExclusiveDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 取消cell选中背景
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // 创建cell内部子控件
        [self setupSubViews];
    }
    return self;
}

/**
 *  创建cell内部子控件
 */
- (void)setupSubViews {
    
    XD_WeakSelf
    XDExclusiveBasicInfoView *basicInfoView = [[XDExclusiveBasicInfoView alloc] init];
    [self.contentView addSubview:basicInfoView];
    self.basicInfoView = basicInfoView;
    
    XDSeekCertView *certView = [[XDSeekCertView alloc] init];
    [self.contentView addSubview:certView];
    self.certView = certView;
    
    XDSeekLabelView *basicView = [[XDSeekLabelView alloc] init];
    [self.contentView addSubview:basicView];
    self.basicView = basicView;
    
    XDSeekLabelView *likeTypeView = [[XDSeekLabelView alloc] init];
    [self.contentView addSubview:likeTypeView];
    self.likeTypeView = likeTypeView;
    
    XDSeekPayView *payView = [[XDSeekPayView alloc] init];
    payView.payButtonClicked = ^(UIButton *btn) {
        XD_StrongSelf
        if (self.payButtonClicked) {
            self.payButtonClicked(btn);
        }
    };
    
    [self.contentView addSubview:payView];
    self.payView = payView;
    
    [self.basicInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.top.left.right.mas_equalTo(self.contentView);
    }];
    
    [self.certView mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.top.mas_equalTo(self.basicInfoView.mas_bottom);
        make.left.right.mas_equalTo(self.contentView);
    }];
    
    [self.basicView mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.top.mas_equalTo(self.certView.mas_bottom);
        make.left.right.mas_equalTo(self.contentView);
    }];
    
    [self.likeTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.top.mas_equalTo(self.basicView.mas_bottom);
        make.left.right.mas_equalTo(self.contentView);
    }];
    
    [self.payView mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.top.mas_equalTo(self.likeTypeView.mas_bottom);
        make.left.right.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView);
    }];
}

- (void)setSeekModel:(ExclusiveModel *)seekModel {
    _seekModel = seekModel;
    
    self.basicInfoView.seekModel = seekModel;
    self.certView.isCert = [seekModel.authenticate isEqualToString:@"已认证"] ? YES : NO;
    self.basicView.title = @"背景资料";
    self.basicView.tags = seekModel.p_info;
    self.likeTypeView.title = @"喜欢类型";
    self.likeTypeView.tags = seekModel.h_info;
    
    self.payView.price = [seekModel.coin integerValue];
    self.payView.is_limited = seekModel.is_limited;
    
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    // 1、创建Cell
    static NSString *identifier = @"XDExclusiveDetailCellID";
    XDExclusiveDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[XDExclusiveDetailCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    // 3、返回Cell
    return cell;
}

@end
