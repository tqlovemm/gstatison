//
//  XDSelectLabelCell.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 16/8/24.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import "XDSelectLabelCell.h"

@interface XDSelectLabelCell()

@property (nonatomic, weak) UIView *marksView;

@end

@implementation XDSelectLabelCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *marksView = [[UIView alloc] init];
        [self.contentView addSubview:marksView];
        self.marksView = marksView;
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    // 1、创建Cell
    static NSString *identifier = @"XDSelectLabelCellID";
    XDSelectLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[XDSelectLabelCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    // 3、返回Cell
    return cell;
}

- (void)setItemModelFrame:(XDLabelItemFrameModel *)itemModelFrame {
    _itemModelFrame = itemModelFrame;
    
    for(UIView *view in [self.marksView subviews])
    {
        [view removeFromSuperview];
    }
    
    XDLabelItemModel *itemModel = itemModelFrame.itemModel;
    
    self.marksView.frame = itemModelFrame.marksViewFrame;
    
    for (int i = 0; i < itemModelFrame.labsFrameArr.count; i ++) {
        NSValue *labValue = itemModelFrame.labsFrameArr[i];
        
        CGRect labF = [labValue CGRectValue];
        
        // 创建Lab
        UILabel *lab = [[UILabel alloc] init];
        lab.frame = labF;
        [self.marksView addSubview:lab];
        
        lab.text = itemModel.markArray[i];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.backgroundColor = itemModel.color;
        lab.font = kMarkLabFont;
        lab.textColor = RGB(119, 119, 119);
        lab.layer.cornerRadius = 5;
        lab.layer.masksToBounds = YES;
    }
}

@end
