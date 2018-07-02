//
//  XDQrcoderCell.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/11/17.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDQrcoderCell : UITableViewCell

@property (nonatomic, copy) NSString *weichat;
@property (nonatomic, copy) NSString *qrCoder;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
