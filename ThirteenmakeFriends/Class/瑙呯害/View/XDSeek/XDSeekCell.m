//
//  XDSeekCell.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/9/1.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDSeekCell.h"
#import "Seek.h"
#import "XDSeekPhotoView.h"
#import "XDSeekBasicInfoView.h"

@interface XDSeekCell ()

/** 背景 */
@property (nonatomic, strong) UIView *backView;

/** 图片view */
@property (nonatomic, strong) XDSeekPhotoView *topView;

/** 基本信息view */
@property (nonatomic, strong) XDSeekBasicInfoView *bottomView;

@end

@implementation XDSeekCell

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
    self.backgroundColor = RGB(240, 239, 245);
    
    XD_WeakSelf
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.cornerRadius = 2;
    backView.layer.shadowRadius = 4;
    backView.layer.shadowOffset = CGSizeMake(0, 2);
    backView.layer.shadowOpacity = 0.8;
    backView.layer.shadowColor = RGBA(175, 175, 175, 0.5).CGColor;
    [self.contentView addSubview:backView];
    self.backView = backView;
    
    XDSeekPhotoView *topView = [[XDSeekPhotoView alloc] init];
    topView.recommendButtonClicked = ^(UIButton *btn) {
        XD_StrongSelf
        if ([self.delegate respondsToSelector:@selector(recommendButtonClicked:andSeek:)]) {
            [self.delegate recommendButtonClicked:btn andSeek:self.seekModel];
        }
    };
    [backView addSubview:topView];
    self.topView = topView;
    
    XDSeekBasicInfoView *bottomView = [[XDSeekBasicInfoView alloc] init];
    [backView addSubview:bottomView];
    self.bottomView = bottomView;
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.top.mas_equalTo(self.contentView);
        make.left.mas_equalTo(8);
        make.right.mas_equalTo(-8);
        make.bottom.mas_equalTo(self.contentView).offset(-10);
    }];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.top.mas_equalTo(self.backView);
        make.centerX.mas_equalTo(self.backView.centerX);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 8 * 2, SCREEN_WIDTH - 8 * 2));
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.top.mas_equalTo(self.topView.mas_bottom);
        make.centerX.mas_equalTo(self.backView.centerX);
        make.width.mas_equalTo(SCREEN_WIDTH - 8 * 2);
        make.bottom.mas_equalTo(self.backView);
    }];
}

- (void)setSeekModel:(Seek *)seekModel {
    _seekModel = seekModel;
    
    self.topView.photoCount = seekModel.seekPicture.count;
    self.topView.photo = seekModel.girlHeadIcon;
    self.bottomView.seekModel = seekModel;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    // 1、创建Cell
    static NSString *identifier = @"XDSeekCellID";
    XDSeekCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[XDSeekCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    // 3、返回Cell
    return cell;
}

@end
