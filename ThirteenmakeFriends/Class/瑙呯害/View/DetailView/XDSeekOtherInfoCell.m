//
//  XDSeekOtherInfoCell.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 16/8/25.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import "XDSeekOtherInfoCell.h"

@interface XDSeekOtherInfoCell ()

//! 标题
@property (nonatomic, weak) UILabel *titleLab;
//! 内容
@property (nonatomic, weak) UILabel *textField;

@end

@implementation XDSeekOtherInfoCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"XDSeekOtherInfoCellID";
    XDSeekOtherInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[XDSeekOtherInfoCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        // 标题
        UILabel *titleLab = [[UILabel alloc]init];
        titleLab.font = k16Font;
        titleLab.textColor = HEXCOLOR(0x999999);
        titleLab.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:titleLab];
        self.titleLab = titleLab;
        titleLab.frame = CGRectMake(10, 0, 125, 48);
        
        // 内容
        UILabel *textField = [[UILabel alloc]init];
        textField.font = k16Font;
        textField.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:textField];
        self.textField = textField;
        textField.frame = CGRectMake(CGRectGetMaxX(titleLab.frame), 0, SCREEN_WIDTH - 135, 48);
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 47, SCREEN_WIDTH, 1)];
        lineView.backgroundColor = HEXCOLOR(0xf0f0f2);
        [self.contentView addSubview:lineView];
        
    }
    return self;
}

- (void)cellWithTitle:(NSString *)title andContent:(NSString *)content andPlaceholder:(NSString *)placeholder {
    self.titleLab.text = title;

    if (content.length > 0) {
        self.textField.text = content;
        self.textField.textColor = HEXCOLOR(0x101010);
    } else {
        self.textField.text = placeholder;
        self.textField.textColor = HEXCOLOR(0xbababa);
    }
}

@end
