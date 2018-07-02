//
//  XDIntroduceCell.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/9/11.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDIntroduceCell.h"
#import "XDIntroduceModel.h"

@interface XDIntroduceCell ()

/** 标题 */
@property (nonatomic, strong) UILabel *titleLabel;

/** 描述 */
@property (nonatomic, strong) UILabel *desLabel;

/** 分割线 */
@property (nonatomic, strong) UIView *lineView;
@end

@implementation XDIntroduceCell

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
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = RGB(65, 65, 65);
    titleLabel.font = kPingFangRegularFont(24);
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UILabel *desLabel = [[UILabel alloc] init];
    desLabel.textColor = RGB(65, 65, 65);
    desLabel.font = kPingFangRegularFont(14);
    desLabel.numberOfLines = 0;
    [self.contentView addSubview:desLabel];
    self.desLabel = desLabel;
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = RGB(230, 230, 230);
    [self.contentView addSubview:lineView];
    self.lineView = lineView;
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.top.mas_equalTo(29);
    }];
    
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.left.mas_equalTo(self.titleLabel.mas_left);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(20);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.left.mas_equalTo(18);
        make.right.mas_equalTo(-18);
        make.top.mas_equalTo(self.desLabel.mas_bottom).offset(12);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(self.contentView);
    }];
}

- (void)setIntroModel:(XDIntroduceModel *)introModel {
    _introModel = introModel;
    
    self.titleLabel.text = introModel.title;
    self.desLabel.text = introModel.des;
}

- (void)setLineViewHidden:(BOOL)hidden {
    self.lineView.hidden = hidden;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    // 1、创建Cell
    static NSString *identifier = @"XDIntroduceCellID";
    XDIntroduceCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[XDIntroduceCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    // 3、返回Cell
    return cell;
}

@end
