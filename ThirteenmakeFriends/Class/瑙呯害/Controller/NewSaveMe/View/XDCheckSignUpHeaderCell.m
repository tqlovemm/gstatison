//
//  XDCheckSignUpHeaderCell.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2018/1/9.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import "XDCheckSignUpHeaderCell.h"
#import "XDNewSaveMeInfoView.h"
#import "XDNewSaveMeBottomView.h"
#import "XDSaveMeModel.h"

@interface XDCheckSignUpHeaderCell ()

@property (nonatomic, weak) XDNewSaveMeInfoView *infoView;

@property (nonatomic, weak) UIView *bottomView;

@end

@implementation XDCheckSignUpHeaderCell

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
    
    XDNewSaveMeInfoView *infoView = [[XDNewSaveMeInfoView alloc] init];
    infoView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:infoView];
    self.infoView = infoView;
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = DefaultColor_BG_gray;
    [self.contentView addSubview:bottomView];
    self.bottomView = bottomView;
    
    XD_WeakSelf
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.left.right.top.mas_equalTo(self.contentView);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.left.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(5);
        make.top.mas_equalTo(self.infoView.mas_bottom);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
}

- (void)setModel:(XDSaveMeModel *)model {
    _model = model;
    
    self.infoView.model = model;
}

#pragma mark - 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"XDCheckSignUpHeaderCellID";
    XDCheckSignUpHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[XDCheckSignUpHeaderCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    return cell;
}
@end
