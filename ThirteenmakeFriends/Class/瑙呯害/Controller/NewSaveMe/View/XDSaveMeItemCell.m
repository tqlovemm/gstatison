//
//  XDSaveMeItemCell.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2018/1/5.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import "XDSaveMeItemCell.h"
#import "XDNewSaveMeInfoView.h"
#import "XDNewSaveMeBottomView.h"
#import "XDSaveMeModel.h"

@interface XDSaveMeItemCell ()

@property (nonatomic, weak) XDNewSaveMeInfoView *infoView;

@property (nonatomic, weak) XDNewSaveMeBottomView *bottomView;

@end

@implementation XDSaveMeItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupSubviews];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)setupSubviews
{
    self.backgroundColor = [UIColor clearColor];
    
    UIView *contView = [[UIView alloc] init];
    contView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:contView];
    
    XDNewSaveMeInfoView *infoView = [[XDNewSaveMeInfoView alloc] init];
    infoView.backgroundColor = [UIColor whiteColor];
    [contView addSubview:infoView];
    self.infoView = infoView;
    
    XDNewSaveMeBottomView *bottomView = [[XDNewSaveMeBottomView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    [contView addSubview:bottomView];
    self.bottomView = bottomView;
    
    XD_WeakSelf
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(contView);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.left.right.mas_equalTo(contView);
        make.height.mas_equalTo(50);
        make.top.mas_equalTo(self.infoView.mas_bottom);
        make.bottom.mas_equalTo(contView);
    }];
    
    [contView mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.left.mas_equalTo(8);
        make.right.mas_equalTo(-8);
        make.top.mas_equalTo(3);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-3);
    }];
    
    bottomView.signUpBtnClicked = ^(XDSaveMeModel *model) {
        XD_StrongSelf
        if (self.signUpBtnClicked) {
            self.signUpBtnClicked(self.model);
        }
    };
    bottomView.viewBtnClicked = ^(XDSaveMeModel *model) {
        XD_StrongSelf
        if (self.viewBtnClicked) {
            self.viewBtnClicked(self.model);
        }
    };
}

- (void)setModel:(XDSaveMeModel *)model {
    _model = model;
    
    self.infoView.model = model;
    self.bottomView.model = model;
}

#pragma mark - 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"XDSaveMeItemCellID";
    XDSaveMeItemCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[XDSaveMeItemCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    return cell;
}

@end
