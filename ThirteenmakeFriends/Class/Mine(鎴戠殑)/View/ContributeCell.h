//
//  ContributeCell.h
//  ThirteenmakeFriends
//
//  Created by 空谷凌虚 on 2018/5/9.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XDRankRxMlModel.h"
#import "XDRankListViewController.h"
@interface ContributeCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableview;

@property(nonatomic,strong) XDRankRxMlModel *rankRM;

@property(nonatomic,assign) rankType rankType;

@property (weak, nonatomic) IBOutlet UILabel *rankingLab;
@property (weak, nonatomic) IBOutlet UILabel *amountLab;
@property (weak, nonatomic) IBOutlet UILabel *addInfoLab;

@end
