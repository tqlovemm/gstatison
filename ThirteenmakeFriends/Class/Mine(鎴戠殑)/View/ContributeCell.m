//
//  ContributeCell.m
//  ThirteenmakeFriends
//
//  Created by 空谷凌虚 on 2018/5/9.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import "ContributeCell.h"

@interface ContributeCell ()


@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIImageView *sexImgView;



@end

@implementation ContributeCell

- (void)awakeFromNib {
    [super awakeFromNib];
 
    self.iconImgView.layer.cornerRadius = 20;
    self.iconImgView.layer.masksToBounds = YES;
//    self.iconImgView.layer.borderWidth = 1;
//    self.iconImgView.layer.borderColor = RGB(97, 60, 187).CGColor;
//    self.iconImgView.layer.shadowColor = RGB(97, 60, 187).CGColor;
//    self.iconImgView.layer.shadowOffset = CGSizeMake(3, 3);
//    self.iconImgView.layer.shadowOpacity = 0.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(instancetype)cellWithTableView:(UITableView *)tableview{
    static NSString *identifier = @"ContributeCell";
    ContributeCell *cell = [tableview dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        [tableview registerNib:[UINib nibWithNibName:@"ContributeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:identifier];
        cell = [tableview dequeueReusableCellWithIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)setRankRM:(XDRankRxMlModel *)rankRM{
    _rankRM = rankRM;
    
//    self.rankingLab.text = rankRM.nickname;
    self.rankingLab.textColor = RGB(119, 119, 119);
    
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:rankRM.avatar] placeholderImage:[UIImage imageNamed:@"square_image_placeholder"]];
    self.sexImgView.image = [UIImage imageNamed:rankRM.sex==0?@"male":@"group9"];
    self.nameLab.text = rankRM.nickname;
    self.nameLab.textColor = RGB(51, 51, 51);
    
    self.amountLab.text = [NSString stringWithFormat:@"%ld",rankRM.diamonds];
    self.addInfoLab.textColor = RGB(154, 154, 154);
}

-(void)setRankType:(int)rankType{
    _rankType = rankType;
    
    UIColor *lcolor = RGB(232,63,120);
    if (rankType ==0 || rankType == 1) { //任性榜
        self.amountLab.textColor = RGB(97, 60, 187);
        self.addInfoLab.text = @"消费钻石";
        lcolor =  RGB(71,40,147);
    }else  if (rankType ==2 || rankType == 3){
        self.amountLab.textColor = RGB(232, 63, 120);
        self.addInfoLab.text = @"获得魅力";
    }
    
    self.iconImgView.layer.cornerRadius = 20.f;
    self.iconImgView.layer.masksToBounds = YES;
    CALayer *subLayer=[CALayer layer];
    CGRect fixframe = self.iconImgView.frame;
    subLayer.frame= fixframe;
    subLayer.cornerRadius= self.iconImgView.width/2.0;
    subLayer.backgroundColor= lcolor.CGColor;
    subLayer.masksToBounds=NO;
    subLayer.shadowColor = lcolor.CGColor;
    subLayer.shadowOffset = CGSizeMake(3,3);
    subLayer.shadowOpacity = 0.5;
//    subLayer.shadowRadius = 4;
    [self.contentView.layer insertSublayer:subLayer below:self.iconImgView.layer];
    
}
@end
