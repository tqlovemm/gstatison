//
//  XDmemberItemCell.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/7/17.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDmemberItemCell.h"
#import "XDCardModel.h"
#import "UIImageView+WebCache.h"

@interface XDmemberItemCell ()

/** 图片 */
@property (nonatomic, weak) UIImageView *shipsIconView;
/** 标题 */
@property (nonatomic, weak) UILabel *shipsTitleLabel;
/** 描述 */
@property (nonatomic, weak) UILabel *shipscontentLabel;
/** 私人标识 */
@property (nonatomic, weak) UIImageView *privateView;
@end

@implementation XDmemberItemCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        // 创建cell内部子控件
        [self setupSubViews];
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        // 创建cell内部子控件
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = kPingFangRegularFont(14);
    titleLabel.textColor = RGB(65, 65, 65);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:titleLabel];
    self.shipsTitleLabel = titleLabel;
    
    UILabel *shipscontentLabel = [[UILabel alloc]init];
    shipscontentLabel.font = kPingFangRegularFont(10);
    shipscontentLabel.textColor = RGB(155, 155, 155);
    shipscontentLabel.textAlignment = NSTextAlignmentCenter;
    shipscontentLabel.backgroundColor = [UIColor clearColor];
    shipscontentLabel.numberOfLines = 0;
    [self.contentView addSubview:shipscontentLabel];
    self.shipscontentLabel = shipscontentLabel;
    
    UIImageView *shipsIconView = [[UIImageView alloc] init];
    [self.contentView addSubview:shipsIconView];
    self.shipsIconView = shipsIconView;
    
    UIImageView *privateView = [[UIImageView alloc] init];
    [self.contentView addSubview:privateView];
    self.privateView = privateView;
    
    WEAKSELF
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf);
    }];
    
    [shipsIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(titleLabel.mas_top).with.offset(-1);
        make.centerX.mas_equalTo(titleLabel.centerX);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [shipscontentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(titleLabel.centerX);
        make.top.equalTo(titleLabel.mas_bottom).with.offset(1);
        make.width.lessThanOrEqualTo(@(weakSelf.width - 10));
        make.height.mas_lessThanOrEqualTo(weakSelf.height / 2.0 - 10);
    }];
    
    [privateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
}

- (void)setShipModel:(XDMemberShipModel *)shipModel {
    _shipModel = shipModel;
    
    self.shipsTitleLabel.text = shipModel.authName;
    self.shipscontentLabel.text = shipModel.authContent;
    
    if (shipModel.is_have != 0) {
        [self.shipsIconView sd_setImageWithURL:[NSURL URLWithString:shipModel.rightsIcon] placeholderImage:[UIImage imageNamed:@"square_image_placeholder"]];
        self.shipsTitleLabel.textColor = RGB(65, 65, 65);
        self.shipscontentLabel.textColor = RGB(155, 155, 155);
    } else {
        [self.shipsIconView sd_setImageWithURL:[NSURL URLWithString:shipModel.noRightsIcon] placeholderImage:[UIImage imageNamed:@"square_image_placeholder"]];
        self.shipsTitleLabel.textColor = RGB(170, 170, 170);
        self.shipscontentLabel.textColor = RGB(230, 230, 230);
    }
    
    if (shipModel.is_private != 0) {
        [self.privateView sd_setImageWithURL:[NSURL URLWithString:shipModel.privateIcon]];
        self.privateView.hidden = NO;
    } else {
        [self.privateView sd_setImageWithURL:[NSURL URLWithString:shipModel.privateIcon]];
        self.privateView.hidden = YES;
    }
}
@end
