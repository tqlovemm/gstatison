//
//  XDSeekLabelView.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/8/31.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDSeekLabelView.h"
#import "XDTagLIst.h"
#import "XDLabelListView.h"

@interface XDSeekLabelView ()
/** 标题 */
@property (nonatomic, strong) UILabel *titleLabel;

/** 标签 */
@property (nonatomic, strong) XDLabelListView *tagList;

/** 分割线 */
@property (nonatomic, strong) UIView *lineView;

@end

@implementation XDSeekLabelView

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
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = RGB(65, 65, 65);
    titleLabel.font = kPingFangBoldFont(16);
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    XDLabelListView *tagList = [[XDLabelListView alloc] init];
//    tagList.frame = CGRectMake(20, 80, 300, 200);
    tagList.font = k12Font;
    tagList.multiLine = YES;
    tagList.multiSelect = YES;
    tagList.allowNoSelection = YES;
    tagList.vertSpacing = 6;
    tagList.horiSpacing = 8;
    tagList.textColor = RGB(119, 119, 119);
//    tagList.selectedTextColor = RGB(245, 166, 35);
    tagList.tagBackgroundColor = RGB(240, 239, 245);
//    tagList.selectedTagBackgroundColor = RGB(245, 166, 35);
    tagList.tagCornerRadius = 2;
    tagList.tagEdge = UIEdgeInsetsMake(6, 8, 7, 8);
    [self addSubview:tagList];
    self.tagList = tagList;
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = RGB(230, 230, 230);
    [self addSubview:lineView];
    self.lineView = lineView;
}

- (void)setTags:(NSArray *)tags {
    _tags = tags;
    
    self.titleLabel.text = self.title;
    self.tagList.tags = tags;
    
    XD_WeakSelf
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(10);
    }];
    
    [self.tagList mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(20);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.top.mas_equalTo(self.tagList.mas_bottom).offset(20);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(self);
    }];
}

@end
