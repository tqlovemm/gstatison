//
//  XDOtherInfoCell.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 16/8/24.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import "XDOtherInfoCell.h"
#import "XDEditInfoModel.h"

@interface XDOtherInfoCell ()

//! 标题
@property (nonatomic, weak) UILabel *titleLab;
//! 填写提示
@property (nonatomic, weak) UILabel *desLabel;

@end

@implementation XDOtherInfoCell

+ (instancetype)cellWithTableView:(UITableView *)tableView reusableCellWithIdentifier:(NSString *)identifier
{
//    static NSString *ID = @"XDOtherInfoCellID";
    XDOtherInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[XDOtherInfoCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        // 标题
        UILabel *titleLab = [[UILabel alloc]init];
        titleLab.font = k16Font;
        titleLab.textColor = HEXCOLOR(0x101010);
        titleLab.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:titleLab];
        self.titleLab = titleLab;
//        titleLab.frame = CGRectMake(10, 0, 125, 48);
        
        UILabel *desLabel = [[UILabel alloc]init];
        desLabel.font = k12Font;
        desLabel.textColor = HEXCOLOR(0x999999);
        desLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:desLabel];
        self.desLabel = desLabel;
//        desLabel.frame = CGRectMake(10, 0, 125, 48);
        
        // 内容
        UITextField *textField = [[UITextField alloc]init];
        textField.font = k16Font;
        textField.textColor = HEXCOLOR(0x101010);
        textField.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:textField];
        self.textField = textField;
//        textField.frame = CGRectMake(CGRectGetMaxX(titleLab.frame), 0, SCREEN_WIDTH - 135 - 48, 48);
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = HEXCOLOR(0xf0f0f2);
        [self.contentView addSubview:lineView];
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        XD_WeakSelf
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            XD_StrongSelf
            make.left.mas_equalTo(10);
            make.centerY.mas_equalTo(self.contentView);
        }];
        
        [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            XD_StrongSelf
            make.left.mas_equalTo(self.titleLab.mas_right).offset(2);
            make.centerY.mas_equalTo(self.contentView);
        }];
        
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            XD_StrongSelf
            make.left.mas_equalTo(self.contentView.mas_left).offset(125);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
            make.centerY.mas_equalTo(self.contentView);
            make.height.mas_equalTo(48);
        }];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            XD_StrongSelf
            make.bottom.left.right.mas_equalTo(self.contentView);
            make.height.mas_equalTo(1);
        }];
    }
    return self;
}

- (void)cellWithTitle:(NSString *)title andContent:(NSString *)content andPlaceholder:(NSString *)placeholder {
    self.titleLab.text = title;
    self.desLabel.text = @"(选填)";
    
    self.textField.text = content;
    self.textField.placeholder = placeholder;
    self.textField.enabled = content;
}

- (void)setInfoModel:(XDEditInfoModel *)infoModel {
    _infoModel = infoModel;
    
    self.titleLab.text = infoModel.title;
    if (infoModel.optionalType == 1) {
        self.desLabel.text = @"(必填)";
    } else if (infoModel.optionalType == 2) {
        self.desLabel.text = @"(选填)";
    } else {
        self.desLabel.text = @"";
    }
    self.textField.text = infoModel.text;
    self.textField.placeholder = infoModel.placeholder;
    self.textField.hidden = !infoModel.placeholder;
}

@end
