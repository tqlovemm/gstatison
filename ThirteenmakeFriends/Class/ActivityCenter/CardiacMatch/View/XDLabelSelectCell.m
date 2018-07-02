//
//  XDLabelSelectCell.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/12/20.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDLabelSelectCell.h"

NSString *const labelSelectCellID = @"XDLabelSelectCellID";

@implementation XDLabelSelectCell

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5;
        self.layer.borderWidth = 0.5;
        
        _titleLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_titleLabel];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.minimumScaleFactor = 0.8f;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _titleLabel.frame = CGRectMake(2, 0, self.contentView.frame.size.width - 4, self.contentView.frame.size.height);
}

@end
