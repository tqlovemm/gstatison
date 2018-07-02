//
//  XDSeekLabelCell.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 16/8/25.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import "XDSeekLabelCell.h"

@interface XDSeekLabelCell()

@property (nonatomic, weak) UIView *marksView;

@end

@implementation XDSeekLabelCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *marksView = [[UIView alloc] init];
        [self.contentView addSubview:marksView];
        self.marksView = marksView;
    }
    return self;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    // 1、创建Cell
    static NSString *identifier = @"XDSeekLabelCellID";
    XDSeekLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[XDSeekLabelCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
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
        lab.textColor = [UIColor whiteColor];
        lab.layer.cornerRadius = 5;
        lab.layer.masksToBounds = YES;
    }
}

@end
