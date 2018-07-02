//
//  XDNewSavemeRecordCell.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2018/1/10.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import "XDNewSavemeRecordCell.h"
#import "XDNewSaveMeInfoView.h"
#import "XDSaveMeModel.h"

@interface XDNewSavemeRecordCell ()

@property (nonatomic, weak) XDNewSaveMeInfoView *infoView;

@end

@implementation XDNewSavemeRecordCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupSubviews];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)setupSubviews
{
    self.backgroundColor = [UIColor clearColor];
    
    XDNewSaveMeInfoView *infoView = [[XDNewSaveMeInfoView alloc] init];
    infoView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:infoView];
    self.infoView = infoView;
    
    XD_WeakSelf
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.left.right.top.bottom.mas_equalTo(self.contentView);
    }];
}

- (void)setModel:(XDSaveMeModel *)model {
    _model = model;
    
    self.infoView.model = model;
}

#pragma mark - 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"XDNewSavemeRecordCellID";
    XDNewSavemeRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[XDNewSavemeRecordCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    return cell;
}
@end
