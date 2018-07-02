//
//  XDSeekRecordCell.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 16/6/30.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import "XDSeekRecordCell.h"
#import "UIImageView+WebCache.h"
#import "XDSeekRecord.h"
#import "XDSeekRecordFrame.h"

#define kFont12 [UIFont systemFontOfSize:12.0f]
#define kFont14 [UIFont systemFontOfSize:14.0f]

@interface XDSeekRecordCell ()

//! 妹子编号
@property (nonatomic, weak) UILabel *girlNumLabel;
//! 妹子标签
@property (nonatomic, weak) UILabel *girlLabel;
//! 交友要求
@property (nonatomic, weak) UILabel *datingRequireLabel;
//! 妹子图片
@property (nonatomic, weak) UIImageView *iconView;

//! 花费记录
@property (nonatomic, weak) UILabel *costRecordLabel;
//! 花费状态
@property (nonatomic, weak) UILabel *costStateLabel;

@end

@implementation XDSeekRecordCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        // 创建cell内部子控件
        [self setupSubViews];
    }
    return self;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    // 1、创建Cell
    static NSString *identifier = @"XDSeekRecordCellID";
    XDSeekRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[XDSeekRecordCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    // 3、返回Cell
    return cell;
}

/**
 *  创建cell内部子控件
 */
- (void)setupSubViews {
    // 头像
    UIImageView *iconView = [[UIImageView alloc]init];
    [self.contentView addSubview:iconView];
    iconView.layer.cornerRadius = 5;
    iconView.layer.masksToBounds = YES;
    iconView.contentMode = UIViewContentModeScaleAspectFill;
    iconView.clipsToBounds = YES;
    self.iconView = iconView;
    
    // 妹子编号
    UILabel *girlNumLabel = [[UILabel alloc]init];
    girlNumLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0f];
    girlNumLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:girlNumLabel];
    self.girlNumLabel = girlNumLabel;
    
    // 妹子标签
    UILabel *girlLabel = [[UILabel alloc]init];
    girlLabel.font = kFont12;
    girlLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:girlLabel];
    self.girlLabel = girlLabel;
    
    // 交友请求
    UILabel *datingRequireLabel = [[UILabel alloc]init];
    datingRequireLabel.font = kFont12;
    datingRequireLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:datingRequireLabel];
    self.datingRequireLabel = datingRequireLabel;
    
    // 花费记录
    UILabel *costRecordLabel = [[UILabel alloc]init];
    costRecordLabel.font = kFont14;
    costRecordLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:costRecordLabel];
    self.costRecordLabel = costRecordLabel;
    
    // 花费状态
    UILabel *costStateLabel = [[UILabel alloc]init];
    costStateLabel.font = kFont14;
    costStateLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:costStateLabel];
    self.costStateLabel = costStateLabel;
}

- (void)setRecordFrame:(XDSeekRecordFrame *)recordFrame {
    _recordFrame = recordFrame;
    XDSeekRecord *record = recordFrame.record;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:record.avatar] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    self.iconView.frame = recordFrame.girlHeadIconFrame;
    
    self.girlNumLabel.text = record.number;
    self.girlNumLabel.frame = recordFrame.girlNumFrame;
    
    self.girlLabel.text = record.mark;
    self.girlLabel.frame = recordFrame.girlLabFrame;
    
    self.datingRequireLabel.text = record.require;
    self.datingRequireLabel.frame = recordFrame.datingRequireFrame;
    
    NSString *costRecordStr = nil;
    if (record.status == 10) { // 觅约等待中
        costRecordStr = [NSString stringWithFormat:@"冻结%ld%@",record.coin,coin_name];
    } else if (record.status == 11) { // 觅约成功
        costRecordStr = [NSString stringWithFormat:@"扣除%ld%@",record.coin,coin_name];
    } else if (record.status == 12) { // 觅约失败
        costRecordStr = [NSString stringWithFormat:@"返回%ld%@",record.coin,coin_name];
    } else {
        costRecordStr = [NSString stringWithFormat:@"未知操作"];
    }
    self.costRecordLabel.text = costRecordStr;
    self.costRecordLabel.frame = recordFrame.costRecordFrame;
    
    NSString *seekState = nil;
    if (record.status == 10) { // 觅约等待中
        seekState = [NSString stringWithFormat:@"成功"];
        [self.costStateLabel setTextColor:RGB(60, 179, 69)];
    } else if (record.status == 11) { // 觅约成功
        seekState = [NSString stringWithFormat:@"成功"];
        [self.costStateLabel setTextColor:RGB(60, 179, 69)];
    } else if (record.status == 12) { // 觅约失败
        seekState = [NSString stringWithFormat:@"失败"];
        [self.costStateLabel setTextColor:RGB(251, 0, 0)];
    } else {
        seekState = [NSString stringWithFormat:@"未知操作"];
        [self.costStateLabel setTextColor:RGB(251, 0, 0)];
    }
    self.costStateLabel.text = seekState;
    self.costStateLabel.frame = recordFrame.seekStateFrame;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
