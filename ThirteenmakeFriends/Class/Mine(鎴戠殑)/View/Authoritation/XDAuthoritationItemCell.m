//
//  XDAuthoritationItemCell.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/11/10.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDAuthoritationItemCell.h"
#import "XDAuthoritationView.h"
#import "XDAnthoritationModel.h"

@interface XDAuthoritationItemCell ()

/** 内容view */
@property (nonatomic, strong) XDAuthoritationView *itemView;

@end

@implementation XDAuthoritationItemCell

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
    
    self.backgroundColor = [UIColor clearColor];
    
    XDAuthoritationView *itemView = [[XDAuthoritationView alloc] init];
    [self.contentView addSubview:itemView];
    self.itemView = itemView;
    
    [self.itemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
//        make.height.mas_equalTo(110);
        make.bottom.mas_equalTo(self.contentView);
    }];
}

- (void)setModel:(XDAnthoritationModel *)model {
    _model = model;
    
    self.itemView.model = model;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    // 1、创建Cell
    static NSString *identifier = @"XDAuthoritationItemCellID";
    XDAuthoritationItemCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[XDAuthoritationItemCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    // 3、返回Cell
    return cell;
}

@end
