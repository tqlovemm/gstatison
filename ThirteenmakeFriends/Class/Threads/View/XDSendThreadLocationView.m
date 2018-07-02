//
//  XDSendThreadLocationView.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 16/9/26.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import "XDSendThreadLocationView.h"
#import "Masonry.h"

@interface XDSendThreadLocationView ()

@property (nonatomic ,strong) UIImageView *loctionView;

@property (nonatomic ,strong) UILabel *locationLabel;

@property (nonatomic ,strong) UIImageView *upLine;

@property (nonatomic ,strong) UIImageView *underLine;

@property (nonatomic ,strong) UIImageView *arrowView;

@end

@implementation XDSendThreadLocationView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubViews];
    }
    
    return self;
}

- (UIImageView *)underLine {
    if (_underLine == nil) {
        _underLine = [[UIImageView alloc]init];
        _underLine.image = [UIImage imageNamed:@"underLine"];
    }
    return _underLine;
}

- (UIImageView *)upLine {
    if (_upLine == nil) {
        _upLine = [[UIImageView alloc]init];
        _upLine.image = [UIImage imageNamed:@"underLine"];
    }
    return _upLine;
}

- (UIImageView *)loctionView {
    if (_loctionView == nil) {
        _loctionView = [[UIImageView alloc]init];
        _loctionView.image = [UIImage imageNamed:@"send_location"];
    }
    return _loctionView;
}

- (UIImageView *)arrowView {
    if (_arrowView == nil) {
        _arrowView = [[UIImageView alloc]init];
        _arrowView.image = [UIImage imageNamed:@"common_icon_arrow"];
    }
    return _arrowView;
}

- (UILabel *)locationLabel {
    if (_locationLabel == nil) {
        _locationLabel = [[UILabel alloc] init];
        _locationLabel.font = [UIFont systemFontOfSize:13];
        _locationLabel.text = @"所在位置";
        _locationLabel.textColor = RGB(68, 68, 68);
    }
    return _locationLabel;
}

- (void)setupSubViews {
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.underLine];
    [self addSubview:self.upLine];
    [self addSubview:self.loctionView];
    [self addSubview:self.arrowView];
    [self addSubview:self.locationLabel];
    
    [self.upLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.top.mas_equalTo(self.mas_top);
        make.height.mas_equalTo(@1);
    }];
    
    [self.underLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.bottom.mas_equalTo(self.mas_bottom).with.offset(0);
        make.height.mas_equalTo(@1);
    }];
    
    [self.loctionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).with.offset(10);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [self.locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.loctionView.mas_right).with.offset(5);
        make.right.mas_equalTo(self.mas_right).with.offset(-80);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(self.height - 10);
    }];
    
    [self.arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).with.offset(-10);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
}

- (void)setAddress:(NSString *)address {
    _address = address;
    if (!address) {
        self.locationLabel.text = @"所在位置";
    } else {
        self.locationLabel.text = address;
    }
}
@end
