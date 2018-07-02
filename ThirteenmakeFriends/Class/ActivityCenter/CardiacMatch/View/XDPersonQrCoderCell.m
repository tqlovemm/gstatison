//
//  XDPersonQrCoderCell.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/12/20.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDPersonQrCoderCell.h"
#import "XDPhotoBrowser.h"

@interface XDPersonQrCoderCell ()

@property (nonatomic, strong) UILabel *weichatLabel;
@property (nonatomic, strong) UIImageView *weichatView;

@end

@implementation XDPersonQrCoderCell

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
    UILabel *weichatLabel = [[UILabel alloc] init];
    weichatLabel.font = kPingFangRegularFont(16);
    weichatLabel.textColor = RGB(65, 65, 65);
    weichatLabel.text = @"微信二维码";
    [self.contentView addSubview:weichatLabel];
    self.weichatLabel = weichatLabel;
    
    UIImageView *weichatView = [[UIImageView alloc] init];
    weichatView.contentMode = UIViewContentModeScaleAspectFill;
    weichatView.clipsToBounds = YES;
    [self.contentView addSubview:weichatView];
    self.weichatView = weichatView;
    
    self.weichatView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(weichatViewTaped:)];
    [self.weichatView addGestureRecognizer:tap];
    
    XD_WeakSelf
    [self.weichatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.top.mas_equalTo(self.contentView).offset(30);
        make.left.mas_equalTo(self.contentView).offset(10);
    }];
    
    [self.weichatView mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.top.mas_equalTo(self.weichatLabel.mas_bottom).offset(20);
        make.centerX.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(180, 240));
        make.bottom.mas_equalTo(self.contentView);
    }];
}

- (void)setWeichat:(NSString *)weichat {
    _weichat = weichat;
    [self.weichatView sd_setImageWithURL:[NSURL URLWithString:weichat] placeholderImage:[UIImage imageNamed:@"square_image_placeholder"]];
}

- (void)weichatViewTaped:(UITapGestureRecognizer *)tap {
    [[XDPhotoBrowser defaultManager] showBrowserWithImages:@[self.weichat] andCurrentIndex:0 fromImageContainer:tap.view];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    // 1、创建Cell
    static NSString *identifier = @"XDPersonQrCoderCellID";
    XDPersonQrCoderCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[XDPersonQrCoderCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    // 3、返回Cell
    return cell;
}

@end
