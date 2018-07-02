//
//  XDMyFlopHaremCell.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 17/1/12.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDMyFlopHaremCell.h"

@interface XDMyFlopHaremCell ()

@property (strong, nonatomic) UIView * imgsView;


@end

@implementation XDMyFlopHaremCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat cellWidth = [UIScreen mainScreen].bounds.size.width;
        // Initialization code
        
        _imgsView = [[UIView alloc] initWithFrame:CGRectMake(cellWidth - 90, 13, 80, 16)];
        _imgsView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_imgsView];
        
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.textLabel.font = k13Font;
        self.textLabel.textColor = RGB(65, 65, 65);
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(17, 20, 23, 23);
    self.textLabel.x = CGRectGetMaxX(self.imageView.frame) + 24;    
}

@end
