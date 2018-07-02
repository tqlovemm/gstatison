//
//  XDMessageCategoryCell.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2018/1/25.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import "XDMessageCategoryCell.h"
#import "XDMsgCategoryModel.h"

@interface XDMessageCategoryCell()

//! 图标
@property (nonatomic, weak) UIImageView *iconView;
//! 标题
@property (nonatomic, weak) UILabel *titleLabel;
//! 内容
@property (nonatomic, weak) UILabel *contentLabel;
//! 创建时间
@property (nonatomic, weak) UILabel *timeLabel;
//! 是否已读
@property (nonatomic, weak) UILabel *badgeLabel;

@end

@implementation XDMessageCategoryCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    // 创建cell
    static NSString *ID = @"XDMessageCategoryCellID";
    XDMessageCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if(cell == nil)
    {
        cell = [[XDMessageCategoryCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        // 取消cell选中背景
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // 创建cell内部子控件
        [self xdd_setupSubViews];
    }
    return self;
}

- (void)xdd_setupSubViews {
    // 头像
    UIImageView *iconView = [[UIImageView alloc]init];
    [self.contentView addSubview:iconView];
    self.iconView = iconView;
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = postNameFont;
    titleLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    // 内容
    UILabel *contentLabel = [[UILabel alloc]init];
    contentLabel.font = postContentFont;
    contentLabel.textColor = RGB(135, 135, 135);
    contentLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:contentLabel];
    self.contentLabel = contentLabel;
    
    // 时间
    UILabel *timeLabel = [[UILabel alloc]init];
    timeLabel.font = postContentFont;
    timeLabel.textColor = RGB(39, 39, 39);
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    UILabel *badge = [[UILabel alloc] init];
    badge.translatesAutoresizingMaskIntoConstraints = NO;
    badge.textAlignment = NSTextAlignmentCenter;
    badge.textColor = [UIColor whiteColor];
    badge.backgroundColor = [UIColor redColor];
    badge.font = [UIFont boldSystemFontOfSize:11];;
    badge.hidden = YES;
    badge.layer.cornerRadius = 7.5;
    badge.clipsToBounds = YES;
    [self.contentView addSubview:badge];
    self.badgeLabel = badge;
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(45, 45));
        make.top.left.mas_equalTo(10);
        make.bottom.mas_equalTo(self.contentView).offset(-10);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconView);
        make.left.mas_equalTo(self.iconView.mas_right).offset(10);
        make.right.mas_equalTo(-110);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.titleLabel.mas_bottom);
        make.right.mas_equalTo(-10);
        make.width.mas_lessThanOrEqualTo(100);
    }];
    
    [self.badgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.iconView.mas_right).offset(5);
        make.centerY.mas_equalTo(self.iconView.mas_top).offset(5);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(self.titleLabel);
        make.right.mas_equalTo(-5);
    }];
}

- (void)setModel:(XDMsgCategoryModel *)model {
    _model = model;
    
    self.titleLabel.text = model.entry_name;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.entry_image_url] placeholderImage:[UIImage imageNamed:@"square_image_placeholder"]];
    self.contentLabel.text = model.latest_news.msg_description;
    self.timeLabel.text = [model.latest_news getMessageTimeWithCreate_at:model.latest_news.created_at];
    
    if (model.unread_count > 0) {
        self.badgeLabel.text = [NSString stringWithFormat:@"%ld",(long)model.unread_count];
        if (model.unread_count > 99) {
            self.badgeLabel.text = @"N+";
        }
        self.badgeLabel.hidden = NO;
    } else {
        self.badgeLabel.text = nil;
        self.badgeLabel.hidden = YES;
    }
}

@end
