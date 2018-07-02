//
//  XddCell.m
//  xdd-布局
//
//  Created by jifeng on 16/2/16.
//  Copyright © 2016年 jifeng. All rights reserved.
//

#import "XddCell.h"

#import "UIView+Extension.h"

@interface XddCell()

@property (nonatomic, weak) UILabel *titleLab;

@property (nonatomic, weak) UIView *marksView;

@end

@implementation XddCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *titleLab = [[UILabel alloc] init];
        [self.contentView addSubview:titleLab];
        titleLab.textColor = [UIColor grayColor];
        self.titleLab = titleLab;
        
        titleLab.font = kTitleLabFont;
        
        UIView *marksView = [[UIView alloc] init];
        [self.contentView addSubview:marksView];
        self.marksView = marksView;
    }
    return self;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    // 1、创建Cell
    static NSString *identifier = @"XddCellID";
    XddCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[XddCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    // 3、返回Cell
    return cell;
}

- (void)setItemModelFrame:(XddItemModelFrame *)itemModelFrame {
    _itemModelFrame = itemModelFrame;
    
    XddItemModel *itemModel = itemModelFrame.itemModel;
    
    self.titleLab.frame = itemModelFrame.titleLabFrame;
    self.titleLab.text = itemModel.title;
    
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

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.titleLab.centerY = self.bounds.size.height * 0.5;
}

@end
