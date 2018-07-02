//
//  XDNewSaveMeBottomView.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2018/1/8.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import "XDNewSaveMeBottomView.h"
#import "XDSaveMeModel.h"

@interface XDNewSaveMeBottomView ()

/** 报名 */
@property (nonatomic, weak) UIButton *signUpBtn;
/** 查看报名 */
@property (nonatomic, weak) UIButton *viewBtn;

@property (nonatomic, weak) UIView *lineView;
@property (nonatomic, weak) UIView *vLineView;

@end

@implementation XDNewSaveMeBottomView

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
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = RGB(230, 230, 230);
    [self addSubview:lineView];
    self.lineView = lineView;
    
    UIView *vLineView = [[UIView alloc] init];
    vLineView.backgroundColor = RGB(230, 230, 230);
    [self addSubview:vLineView];
    self.vLineView = vLineView;
    
    UIButton *signUpBtn = [[UIButton alloc] init];
    [signUpBtn setTitle:@"我要报名" forState:UIControlStateNormal];
    signUpBtn.titleLabel.font = kPingFangRegularFont(14);
    [signUpBtn setTitleColor:ThemeColor1 forState:UIControlStateNormal];
    [signUpBtn setTitleColor:DefaultColor_BG_gray forState:UIControlStateHighlighted];
    [signUpBtn addTarget:self action:@selector(signUpClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:signUpBtn];
    self.signUpBtn = signUpBtn;
    
    UIButton *viewBtn = [[UIButton alloc] init];
    [viewBtn setTitle:@"查看报名" forState:UIControlStateNormal];
    viewBtn.titleLabel.font = kPingFangRegularFont(14);
    [viewBtn setTitleColor:RGB(119, 119, 119) forState:UIControlStateNormal];
    [viewBtn setTitleColor:DefaultColor_BG_gray forState:UIControlStateHighlighted];
    [viewBtn addTarget:self action:@selector(viewBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:viewBtn];
    self.viewBtn = viewBtn;
    
    XD_WeakSelf
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.signUpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.lineView.mas_bottom);
        make.right.mas_equalTo(self.viewBtn.mas_left);
        make.height.mas_equalTo(49.5);
        make.width.mas_equalTo(self.viewBtn);
    }];
    
    [self.viewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.left.mas_equalTo(self.signUpBtn.mas_right);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.lineView.mas_bottom);
        make.height.mas_equalTo(49.5);
        make.width.mas_equalTo(self.signUpBtn);
    }];
    
    [self.vLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.center.mas_equalTo(self);
        make.height.mas_equalTo(22);
        make.width.mas_equalTo(1);
    }];
}

- (void)setModel:(XDSaveMeModel *)model {
    if (model.is_self != 0) {
        [self.signUpBtn setTitle:@"结束报名" forState:UIControlStateNormal];
    } else {
        [self.signUpBtn setTitle:@"我要报名" forState:UIControlStateNormal];
    }
    
    if (model.signupCount > 0) {
        [self.viewBtn setTitle:[NSString stringWithFormat:@"查看报名(%ld)",model.signupCount] forState:UIControlStateNormal];
    } else {
        [self.viewBtn setTitle:@"查看报名" forState:UIControlStateNormal];
    }
}

- (void)signUpClicked:(UIButton *)btn {
    if (self.signUpBtnClicked) {
        self.signUpBtnClicked(self.model);
    }
}

- (void)viewBtnClicked:(UIButton *)btn {
    if (self.viewBtnClicked) {
        self.viewBtnClicked(self.model);
    }
}

@end
