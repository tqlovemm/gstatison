//
//  XDWomanSeekDetailCell.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/11/17.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDWomanSeekDetailCell.h"
#import "XDWSeekDetailInfoView.h"
#import "XDSeekLevelView.h"
#import "XDSeekLabelView.h"
#import "XDSeekPayView.h"
#import "XDWomanSeekModel.h"

@interface XDWomanSeekDetailCell ()

@property (nonatomic, strong) XDWSeekDetailInfoView *basicInfoView;

@property (nonatomic, strong) XDSeekLevelView *certView;

@property (nonatomic, strong) XDSeekLabelView *basicView;

@property (nonatomic, strong) XDSeekLabelView *likeTypeView;

@property (nonatomic, strong) XDSeekPayView *payView;

@end

@implementation XDWomanSeekDetailCell

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
    XDWSeekDetailInfoView *basicInfoView = [[XDWSeekDetailInfoView alloc] init];
    [self.contentView addSubview:basicInfoView];
    self.basicInfoView = basicInfoView;
    
    XDSeekLevelView *certView = [[XDSeekLevelView alloc] init];
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

- (void)setUser:(XDWomanSeekModel *)user {
    _user = user;
    
    self.basicInfoView.user = user;
    self.certView.level = user.vip;
    self.basicView.title = @"基本资料";
    self.basicView.tags = user.mark;
    self.likeTypeView.title = @"喜欢类型";
    self.likeTypeView.tags = user.like_type;
    
    self.payView.price = user.worth;
    
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    // 1、创建Cell
    static NSString *identifier = @"XDWomanSeekDetailCellID";
    XDWomanSeekDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[XDWomanSeekDetailCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    // 3、返回Cell
    return cell;
}
@end
