//
//  XDXDBillingCell.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/8/28.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDXDBillingCell.h"
#import "XDBillingModel.h"
#import "XDBillingDiaModel.h"

@interface XDXDBillingCell ()
//! 时间
@property(strong,nonatomic)UILabel *dateLab;

//! 消费金额
@property(strong,nonatomic)UILabel *numberlab;
//! 类型
@property(strong,nonatomic)UILabel *typeLabel;
//! 描述
@property(strong,nonatomic)UILabel *desLabel;

@end

@implementation XDXDBillingCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubviews];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}

- (void)initSubviews {
    
    _typeLabel = [[UILabel alloc]init];
    _typeLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    _typeLabel.textColor = RGB(65, 65, 65);
    [self.contentView addSubview:_typeLabel];
    
    _dateLab = [[UILabel alloc]init];
    _dateLab.font = [UIFont systemFontOfSize:13];
    _dateLab.textColor = RGB(159, 159, 159);
    _dateLab.numberOfLines = 0;
    [self.contentView addSubview:_dateLab];
    
    _numberlab = [[UILabel alloc]init];
    _numberlab.font = [UIFont systemFontOfSize:13];
    _numberlab.textColor = RGB(14, 180, 0);
    _numberlab.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_numberlab];
    
    _desLabel = [[UILabel alloc]init];
    _desLabel.font = [UIFont systemFontOfSize:12];
    _desLabel.textColor = RGB(159, 159, 159);
    [self.contentView addSubview:_desLabel];
    
    XD_WeakSelf
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(10);
    }];
    
    [self.dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.left.mas_equalTo(self.typeLabel);
        make.top.mas_equalTo(self.typeLabel.mas_bottom).offset(10);
    }];
    
    [self.numberlab mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(self.typeLabel.mas_bottom);
    }];
    
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.right.mas_equalTo(self.numberlab.mas_right);
        make.top.mas_equalTo(self.numberlab.mas_bottom).offset(10);
    }];
}

- (void)setBillingModel:(XDBillingModel *)billingModel {
    _billingModel = billingModel;
    
    self.dateLab.text = billingModel.created_at;
    
    //心动币消费数量
    self.numberlab.text = billingModel.coin;
    self.typeLabel.text = billingModel.subject;
    
    self.desLabel.text = [NSString stringWithFormat:@"%ld",billingModel.balance];

}

-(void)setBillingDiaModel:(XDBillingDiaModel *)billingDiaModel{
    _billingDiaModel = billingDiaModel;
    self.dateLab.text = billingDiaModel.created_at;
    //心动币消费数量
    self.numberlab.text = billingDiaModel.diamonds;
    self.typeLabel.text = billingDiaModel.subject;
    
    self.desLabel.text = [NSString stringWithFormat:@"%ld",billingDiaModel.balance];
}
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    // 1、创建Cell
    static NSString *identifier = @"XDXDBillingCellID";
    XDXDBillingCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[XDXDBillingCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    // 3、返回Cell
    return cell;
}

@end
