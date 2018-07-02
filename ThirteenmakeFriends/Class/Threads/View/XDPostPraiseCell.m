//
//  XDPostPraiseCell.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 17/5/15.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDPostPraiseCell.h"
#import "UIImageView+WebCache.h"
#import "XDPostPraiseFrameModel.h"
#import "XDPostPraiseModel.h"

@interface XDPostPraiseCell ()

//! 头像
@property (nonatomic, weak) UIImageView *iconView;
//! 昵称
@property (nonatomic, weak) UILabel *nameLabel;
//! 年龄
@property (nonatomic, weak) UILabel *ageLabel;
//! 正文
@property (nonatomic, weak) UILabel *contentLabel;

@end

@implementation XDPostPraiseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupSubViews];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setupSubViews {
    // 头像
    UIImageView *iconView = [[UIImageView alloc]init];
    [self addSubview:iconView];
    self.iconView = iconView;
    
    // 昵称
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.font = k14Font;
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = RGB(62, 62, 62);
    [self addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    // 年龄
    UILabel *ageLabel = [[UILabel alloc]init];
    ageLabel.font = k13Font;
    ageLabel.textColor = RGB(62, 62, 62);
    ageLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:ageLabel];
    self.ageLabel = ageLabel;
    
    // 正文
    UILabel *contentLabel = [[UILabel alloc]init];
    contentLabel.font = k13Font;
    contentLabel.textColor = RGB(62, 62, 62);
    contentLabel.backgroundColor = [UIColor clearColor];
    contentLabel.numberOfLines = 0;
    [self addSubview:contentLabel];
    self.contentLabel = contentLabel;
}

- (void)setPraiseFrameModel:(XDPostPraiseFrameModel *)praiseFrameModel {
    _praiseFrameModel = praiseFrameModel;
    
    XDPostPraiseModel *praiseModel = praiseFrameModel.praiseModel;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:praiseModel.avatar] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    self.iconView.frame = praiseFrameModel.iconViewF;
    self.iconView.layer.cornerRadius = self.iconView.width/2.0;
    self.iconView.layer.masksToBounds = YES;
    
    self.nameLabel.text = praiseModel.nickname;
    self.nameLabel.frame = praiseFrameModel.nameLabelF;
    
    self.ageLabel.text = praiseModel.age == 0 ? [NSString stringWithFormat:@"%@ %ldcm/%ldkg",praiseModel.address,praiseModel.height,praiseModel.weight] : [NSString stringWithFormat:@"%@ %ld岁 %ldcm/%ldkg",praiseModel.address,praiseModel.age,praiseModel.height,praiseModel.weight];
    self.ageLabel.frame = praiseFrameModel.ageLabelF;
    
    self.contentLabel.text = [NSString stringWithFormat:@"%ld条动态",praiseModel.thread_count];
    self.contentLabel.frame = praiseFrameModel.contentLabelF;
}

#pragma mark - 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"XDPostPraiseCellID";
    XDPostPraiseCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[XDPostPraiseCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    return cell;
}

@end
