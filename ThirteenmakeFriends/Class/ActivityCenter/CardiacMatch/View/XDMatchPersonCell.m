//
//  XDMatchPersonCell.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/12/19.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDMatchPersonCell.h"
#import "XDPersonBasicInfoView.h"
#import "XDSeekLabelView.h"
#import "ShiSanUser.h"

@interface XDMatchPersonCell ()

@property (nonatomic, weak) XDPersonBasicInfoView *infoView;

@property (nonatomic, weak) UIView *lineView;

@property (nonatomic, weak) UILabel *charmLabel;

//@property (nonatomic, strong) XDSeekLabelView *basicView;
//
//@property (nonatomic, strong) XDSeekLabelView *likeTypeView;
//
//@property (nonatomic, strong) XDSeekLabelView *hobbyView;

@end

@implementation XDMatchPersonCell

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
    XDPersonBasicInfoView *infoView = [[XDPersonBasicInfoView alloc] init];
    [self.contentView addSubview:infoView];
    self.infoView = infoView;
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = RGB(240, 239, 245);
    [self.contentView addSubview:lineView];
    self.lineView = lineView;
    
    UILabel *charmLabel = [[UILabel alloc] init];
    charmLabel.textColor = RGB(65, 65, 65);
    charmLabel.font = kPingFangRegularFont(16);
    [self.contentView addSubview:charmLabel];
    self.charmLabel = charmLabel;
    
//    XDSeekCertView *certView = [[XDSeekCertView alloc] init];
//    [self.contentView addSubview:certView];
//    self.certView = certView;
//    
//    XDSeekLabelView *basicView = [[XDSeekLabelView alloc] init];
//    [self.contentView addSubview:basicView];
//    self.basicView = basicView;
//
//    XDSeekLabelView *likeTypeView = [[XDSeekLabelView alloc] init];
//    [self.contentView addSubview:likeTypeView];
//    self.likeTypeView = likeTypeView;
//
//    XDSeekLabelView *hobbyView = [[XDSeekLabelView alloc] init];
//    [self.contentView addSubview:hobbyView];
//    self.hobbyView = hobbyView;
    
//    XDSeekPayView *payView = [[XDSeekPayView alloc] init];
//    payView.payButtonClicked = ^(UIButton *btn) {
//        XD_StrongSelf
//        if (self.payButtonClicked) {
//            self.payButtonClicked(btn);
//        }
//    };
//
//    [self.contentView addSubview:payView];
//    self.payView = payView;
    
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.top.left.right.mas_equalTo(self.contentView);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.top.mas_equalTo(self.infoView.mas_bottom);
        make.left.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(2);
    }];
    
    [self.charmLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.top.mas_equalTo(self.lineView.mas_bottom).offset(10);
        make.left.mas_equalTo(self.contentView).offset(10);
        make.bottom.mas_equalTo(self.contentView);
    }];
    
//    [self.basicView mas_makeConstraints:^(MASConstraintMaker *make) {
//        XD_StrongSelf
//        make.top.mas_equalTo(self.certView.mas_bottom);
//        make.left.right.mas_equalTo(self.contentView);
//    }];
//
//    [self.likeTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
//        XD_StrongSelf
//        make.top.mas_equalTo(self.basicView.mas_bottom);
//        make.left.right.mas_equalTo(self.contentView);
//    }];
//
//    [self.payView mas_makeConstraints:^(MASConstraintMaker *make) {
//        XD_StrongSelf
//        make.top.mas_equalTo(self.likeTypeView.mas_bottom);
//        make.left.right.mas_equalTo(self.contentView);
//        make.bottom.mas_equalTo(self.contentView);
//    }];
}

- (void)setUser:(ShiSanUser *)user {
    _user = user;
    self.infoView.user = user;
    self.charmLabel.text = [NSString stringWithFormat:@"魅力值：%@",user.glamorous];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    // 1、创建Cell
    static NSString *identifier = @"XDMatchPersonCellID";
    XDMatchPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[XDMatchPersonCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    // 3、返回Cell
    return cell;
}

@end
