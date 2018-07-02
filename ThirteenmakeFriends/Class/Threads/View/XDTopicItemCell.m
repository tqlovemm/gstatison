//
//  XDTopicItemCell.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/10/27.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDTopicItemCell.h"
#import "XDPostTopModel.h"

@interface XDTopicItemCell ()

@property (nonatomic, strong) UIImageView *imagView;

//@property (nonatomic, strong) UILabel *tipLabel;

@end

@implementation XDTopicItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupSubViews];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setupSubViews {
    self.backgroundColor = DefaultColor_BG_gray;
    
    self.imagView = [[UIImageView alloc] init];
    self.imagView.contentMode = UIViewContentModeScaleAspectFill;
    self.imagView.clipsToBounds = YES;
    [self.contentView addSubview:self.imagView];
    
//    self.tipLabel = [[UILabel alloc] init];
//    self.tipLabel.textColor = [UIColor whiteColor];
//    self.tipLabel.font = kPingFangRegularFont(18);
//    self.tipLabel.textAlignment = NSTextAlignmentCenter;
//    self.tipLabel.numberOfLines = 0;
//    [self.contentView addSubview:self.tipLabel];
    
    XD_WeakSelf
    [self.imagView mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 214));
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
    
//    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        XD_StrongSelf
//        make.center.mas_equalTo(self.imagView.center);
//    }];
}

- (void)setTagModel:(XDAcitivityModel *)tagModel {
    _tagModel = tagModel;
    
//    self.tipLabel.text = tagModel.tagName;
    [self.imagView sd_setImageWithURL:[NSURL URLWithString:tagModel.img] placeholderImage:[UIImage imageNamed:@"ThirteenSay_ ADPlaceHolder"]];
}

#pragma mark - 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"XDTopicItemCellID";
    XDTopicItemCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[XDTopicItemCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    return cell;
}

@end
