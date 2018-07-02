//
//  XDPersonOtherInfoCell.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 16/12/14.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import "XDPersonOtherInfoCell.h"

@interface XDPersonOtherInfoCell ()

//! 标题
@property (nonatomic, weak) UILabel *titleLab;
//! 内容
@property (nonatomic, weak) UILabel *textField;

@end

@implementation XDPersonOtherInfoCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"XDPersonOtherInfoCellID";
    XDPersonOtherInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[XDPersonOtherInfoCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        // 标题
        UILabel *titleLab = [[UILabel alloc]init];
        titleLab.font = k14Font;
        titleLab.textColor = [UIColor grayColor];
        titleLab.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:titleLab];
        self.titleLab = titleLab;
        titleLab.frame = CGRectMake(15, 0, 70, 48);
        
        // 内容
        UILabel *textField = [[UILabel alloc]init];
        textField.font = k14Font;
        textField.textColor = RGB(65, 65, 65);
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
    } else {
        self.textField.text = placeholder;
    }
}

@end
