//
//  XDNewSaveMeInfoView.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2018/1/8.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import "XDNewSaveMeInfoView.h"
#import "XDSaveMeModel.h"
#import "XDNewSavemePhotoView.h"

//#import "XDOtherViewController.h"

@interface XDNewSaveMeInfoView ()

/** 头像 */
@property (nonatomic, weak) UIImageView *iconView;
/** 性别 */
@property (nonatomic, weak) UIImageView *sexView;
/** 昵称 */
@property (nonatomic, weak) UILabel *nickenameLabel;

/** 会员或已认证 */
@property (nonatomic, weak) UIImageView *vipView;
/** 发布来源 */
@property (nonatomic, weak) UIImageView *sourceView;
/** 置顶 */
@property (nonatomic, weak) UIImageView *topView;

/** 发布时间 */
@property (nonatomic, weak) UILabel *startTimeLabel;
/** lineView */
@property (nonatomic, weak) UIView *lineView;
/** 结束时间 */
@property (nonatomic, weak) UILabel *endTimeLabel;
/** 活动 */
@property (nonatomic, weak) UILabel *activityLabel;
/** 地区 */
@property (nonatomic, weak) UILabel *areeLabel;
/** 描述内容 */
@property (nonatomic, weak) UILabel *desLabel;
/** 图片view */
@property (nonatomic, weak) XDNewSavemePhotoView *photoView;


@end

@implementation XDNewSaveMeInfoView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    self.backgroundColor = [UIColor whiteColor];
    
    UIImageView *iconView = [UIImageView new];
    iconView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headIconBtnClicked:)];
    [iconView addGestureRecognizer:tap];
    [self addSubview:iconView];
    self.iconView = iconView;
    
    UIImageView *sexView = [UIImageView new];
    [self addSubview:sexView];
    self.sexView = sexView;
    
    UILabel *nickenameLabel = [[UILabel alloc] init];
    nickenameLabel.textColor = RGB(20, 19, 19);
    nickenameLabel.font = kPingFangRegularFont(13);
    [self addSubview:nickenameLabel];
    self.nickenameLabel = nickenameLabel;
    
    UIImageView *vipView = [UIImageView new];
    [self addSubview:vipView];
    self.vipView = vipView;
    
    UIImageView *sourceView = [UIImageView new];
    [self addSubview:sourceView];
    self.sourceView = sourceView;
    
    UIImageView *topView = [UIImageView new];
    [self addSubview:topView];
    self.topView = topView;
    
    UILabel *startTimeLabel = [[UILabel alloc] init];
    startTimeLabel.textColor = RGB(119, 119, 119);
    startTimeLabel.font = kPingFangRegularFont(11);
    [self addSubview:startTimeLabel];
    self.startTimeLabel = startTimeLabel;
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = RGB(230, 230, 230);
    [self addSubview:lineView];
    self.lineView = lineView;
    
    UILabel *activityLabel = [[UILabel alloc] init];
    activityLabel.textColor = RGB(68, 63, 77);
    activityLabel.font = kPingFangBoldFont(14);
    [self addSubview:activityLabel];
    self.activityLabel = activityLabel;
    
    UILabel *areeLabel = [[UILabel alloc] init];
    areeLabel.textColor = RGB(68, 63, 77);
    areeLabel.font = kPingFangBoldFont(14);
    [self addSubview:areeLabel];
    self.areeLabel = areeLabel;
    
    UILabel *endTimeLabel = [[UILabel alloc] init];
    endTimeLabel.textColor = ThemeColor1;
    endTimeLabel.font = kPingFangBoldFont(14);
    [self addSubview:endTimeLabel];
    self.endTimeLabel = endTimeLabel;
    
    UILabel *desLabel = [[UILabel alloc] init];
    desLabel.numberOfLines = 0;
    desLabel.textColor = RGB(51, 51, 51);
    desLabel.font = kPingFangRegularFont(13);
    [self addSubview:desLabel];
    self.desLabel = desLabel;
    
    XDNewSavemePhotoView *photoView = [[XDNewSavemePhotoView alloc] init];
    [self addSubview:photoView];
    self.photoView = photoView;
    
}

- (void)setModel:(XDSaveMeModel *)model {
    _model = model;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    self.nickenameLabel.text = model.nickname;
    self.sexView.image = [UIImage imageNamed:model.sex ? @"post_woman" : @"post_man"];
    
    if (model.vip != 0) {
        self.vipView.image = [UIImage imageNamed:model.sex != 0 ? @"girl_yirenzheng" : @"square_vips"];
    } else {
        self.vipView.image = nil;
    }
    
    self.sourceView.image = [UIImage imageNamed:model.type != 0 ? @"official_release" : nil];
    self.topView.image = [UIImage imageNamed:model.is_top != 0 ? @"is_top" : nil];
    
    self.startTimeLabel.text = [NSString stringWithFormat:@"发布于 %@",[model stringDatewithInterval:model.created_at]];
    self.endTimeLabel.text = [NSString stringWithFormat:@"截止时间:%@",[model stringDatewithEndInterval:model.end_time]];
    self.areeLabel.text = model.area_one;
    self.activityLabel.text = model.activity_type;
    self.desLabel.text = model.hope_require;
    self.photoView.pic_urls = model.photos;
    
    [self setSubViewsLayout];
}

- (void)setSubViewsLayout {
    self.iconView.layer.cornerRadius = 20;
    self.iconView.layer.masksToBounds = YES;
    XD_WeakSelf
    [self.iconView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(22);
        make.left.mas_equalTo(8);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [self.nickenameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.top.mas_equalTo(self.iconView.mas_top).offset(4);
        make.left.mas_equalTo(self.iconView.mas_right).offset(10);
        make.width.lessThanOrEqualTo(@(200));
    }];
    
    [self.sexView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.nickenameLabel);
        make.left.mas_equalTo(self.nickenameLabel.mas_right).offset(2);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    
    [self.vipView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.model.vip != 0) {
            if (self.model.sex != 0) {
                make.size.mas_equalTo(CGSizeMake(52, 16));
            } else {
                make.size.mas_equalTo(CGSizeMake(16, 16));
            }
            make.left.mas_equalTo(self.sexView.mas_right).offset(3);
        } else {
            make.size.mas_equalTo(CGSizeMake(0, 0));
            make.left.mas_equalTo(self.sexView.mas_right);
        }
        make.centerY.mas_equalTo(self.sexView);
    }];
    
    [self.sourceView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.model.type != 0) {
            make.size.mas_equalTo(CGSizeMake(49, 14));
            make.left.mas_equalTo(self.vipView.mas_right).offset(3);
        } else {
            make.size.mas_equalTo(CGSizeMake(0, 0));
            make.left.mas_equalTo(self.vipView.mas_right);
        }
        make.centerY.mas_equalTo(self.sexView);
    }];
    
    [self.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.model.is_top != 0) {
            make.size.mas_equalTo(CGSizeMake(33, 14));
            make.left.mas_equalTo(self.sourceView.mas_right).offset(3);
        } else {
            make.size.mas_equalTo(CGSizeMake(0, 0));
            make.left.mas_equalTo(self.sourceView.mas_right);
        }
        make.centerY.mas_equalTo(self.sexView);
    }];
    
    [self.startTimeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.top.mas_equalTo(self.nickenameLabel.mas_bottom).offset(2);
        make.left.mas_equalTo(self.nickenameLabel);
    }];
    
    [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.left.mas_equalTo(self.startTimeLabel.mas_left);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(self.startTimeLabel.mas_bottom).offset(3);
    }];
    
    [self.activityLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.top.mas_equalTo(self.iconView.mas_bottom).offset(25);
        make.left.mas_equalTo(self.iconView.mas_left);
        
        make.height.mas_equalTo(20);
    }];
    
    [self.areeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.top.mas_equalTo(self.activityLabel);
        make.left.mas_equalTo(self.activityLabel.mas_right).offset(12);
    }];
    
    [self.endTimeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.top.mas_equalTo(self.areeLabel);
        make.left.mas_equalTo(self.areeLabel.mas_right).offset(12);
        make.right.lessThanOrEqualTo(self.mas_right).offset(-5);
    }];
    
    // 设置优先级 (活动类型与活动地点优先级高于截止时间)
    [self.activityLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.areeLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    
    [self.endTimeLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    
    [self.desLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.top.mas_equalTo(self.activityLabel.mas_bottom).offset(8);
        make.left.mas_equalTo(self.activityLabel.mas_left);
        make.right.mas_equalTo(-11);
    }];
    
    [self.photoView mas_updateConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.top.mas_equalTo(self.desLabel.mas_bottom).offset(20);
        make.left.mas_equalTo(self.activityLabel.mas_left);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(86);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-15);
    }];
}

/**
 *  头像点击
 */
- (void)headIconBtnClicked:(UITapGestureRecognizer *)recognizer {
    
    UITabBarController *tabBar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav = tabBar.selectedViewController;
    
//    XDOtherViewController *personVC = [[XDOtherViewController alloc] init];
//    personVC.user_id = [NSString stringWithFormat:@"%ld",self.model.user_id];
//    [nav pushViewController:personVC animated:YES];
}

@end
