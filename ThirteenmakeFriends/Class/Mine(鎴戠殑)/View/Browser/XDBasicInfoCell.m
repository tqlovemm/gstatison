//
//  XDBasicInfoCell.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 16/8/24.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import "XDBasicInfoCell.h"
#import "ProfileUser.h"

@interface XDBasicInfoCell ()

//! 性别
@property (nonatomic, weak) UIImageView *sexView;
//! 昵称，年龄
@property (nonatomic, weak) UILabel *mainLabel;
//! 描述
@property (nonatomic, weak) UILabel *detailLabel;

@end

@implementation XDBasicInfoCell


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"XDBasicInfoCellID";
    XDBasicInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[XDBasicInfoCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
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
        // 性别
        UIImageView *sexView = [[UIImageView alloc]init];
        [self.contentView addSubview:sexView];
        sexView.userInteractionEnabled = YES;
        self.sexView = sexView;
        
        // 昵称，年龄
        UILabel *mainLabel = [[UILabel alloc]init];
        mainLabel.font = k16Font;
        mainLabel.textColor = HEXCOLOR(0x101010);
        mainLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:mainLabel];
        self.mainLabel = mainLabel;
        
        // 描述
        UILabel *detailLabel = [[UILabel alloc]init];
        detailLabel.font = k13Font;
        detailLabel.textColor = HEXCOLOR(0xbababa);
        detailLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:detailLabel];
        self.detailLabel = detailLabel;
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    }
    return self;
}

- (void)setUser:(ProfileUser *)user {
    _user = user;
    
    self.mainLabel.text = [NSString stringWithFormat:@"%@ , %@",user.nickname,[self getAgeFromBirthdate:user.birthdate]];
    CGSize mainSize = [self.mainLabel.text sizeWithFont:k16Font];
    self.mainLabel.frame = CGRectMake(10, 20, mainSize.width, mainSize.height);
    
    if ([self.user.sex isEqualToString:@"1"]) {
        self.sexView.image = [UIImage imageNamed:@"icon_selectedwomen"];
    } else if ([self.user.sex isEqualToString:@"0"]) {
        self.sexView.image = [UIImage imageNamed:@"icon_selectedman"];
    }
    self.sexView.frame = CGRectMake(CGRectGetMaxX(self.mainLabel.frame) + 10, CGRectGetMinY(self.mainLabel.frame), 16, 16);
    
    self.detailLabel.text = @"点击编辑更多信息";
    CGSize detailSize = [self.detailLabel.text sizeWithFont:k13Font];
    self.detailLabel.frame = CGRectMake(10, CGRectGetMaxY(self.mainLabel.frame) + 10, detailSize.width, detailSize.height);
    
    _cellHeight = CGRectGetMaxY(self.detailLabel.frame) + 15;
}

- (NSString *)getAgeFromBirthdate:(NSString *)birthdate {
    //计算年龄
    NSString *birth = birthdate;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //生日
    NSDate *birthDay = [dateFormatter dateFromString:birth];
    //当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    NSDate *currentDate = [dateFormatter dateFromString:currentDateStr];
    NSLog(@"currentDate %@ birthDay %@",currentDateStr,birth);
    NSTimeInterval time=[currentDate timeIntervalSinceDate:birthDay];
    uint age = ((uint)time)/(3600*24*365);
    NSLog(@"year %d",age);
    
    return [NSString stringWithFormat:@"%d",age];
}

@end
