//
//  XDPersonLabelCell.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/12/20.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDPersonLabelCell.h"
#import "XDSeekLabelView.h"
#import "ShiSanUser.h"

@interface XDPersonLabelCell ()

@property (nonatomic, strong) XDSeekLabelView *basicView;

@property (nonatomic, strong) XDSeekLabelView *likeTypeView;

@property (nonatomic, strong) XDSeekLabelView *hobbyView;

@end

@implementation XDPersonLabelCell

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
    XDSeekLabelView *basicView = [[XDSeekLabelView alloc] init];
    [self.contentView addSubview:basicView];
    self.basicView = basicView;
    
    XDSeekLabelView *likeTypeView = [[XDSeekLabelView alloc] init];
    [self.contentView addSubview:likeTypeView];
    self.likeTypeView = likeTypeView;
    
    XDSeekLabelView *hobbyView = [[XDSeekLabelView alloc] init];
    [self.contentView addSubview:hobbyView];
    self.hobbyView = hobbyView;
    
    XD_WeakSelf
    [self.basicView mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.left.right.top.mas_equalTo(self.contentView);
    }];
    
    [self.likeTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.top.mas_equalTo(self.basicView.mas_bottom);
        make.left.right.mas_equalTo(self.contentView);
    }];
    
    [self.hobbyView mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.top.mas_equalTo(self.likeTypeView.mas_bottom);
        make.left.right.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView);
    }];
}

- (void)setUser:(ShiSanUser *)user {
    _user = user;
    
    self.basicView.title = @"他的标签";
    self.basicView.tags = user.mark;
    
    self.likeTypeView.title = @"喜欢类型";
    self.likeTypeView.tags = user.make_friend;
    
    self.hobbyView.title = @"兴趣爱好";
    self.hobbyView.tags = user.hobby;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    // 1、创建Cell
    static NSString *identifier = @"XDPersonLabelCellID";
    XDPersonLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[XDPersonLabelCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    // 3、返回Cell
    return cell;
}

@end
