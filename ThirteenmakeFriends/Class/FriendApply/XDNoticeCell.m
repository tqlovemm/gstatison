//
//  XDNoticeCell.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 17/3/22.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDNoticeCell.h"

@interface XDNoticeCell ()
{
    UILabel *_timeLabel;
    UILabel *_unreadLabel;
    UILabel *_detailLabel;
    UIView *_lineView;
}


@end

@implementation XDNoticeCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat cellWidth = [UIScreen mainScreen].bounds.size.width;
        // Initialization code
        //        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(cellWidth - 80, 7, 80, 16)];
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(cellWidth - 90, 13, 80, 16)];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.textColor = RGB(155, 155, 155);
        [self.contentView addSubview:_timeLabel];
        
        //        _unreadLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, 20, 20)];
        _unreadLabel = [[UILabel alloc] initWithFrame:CGRectMake(cellWidth - 30, CGRectGetMaxY(_timeLabel.frame) + 5, 20, 20)];
        _unreadLabel.backgroundColor = RGB(235, 99, 145);
        _unreadLabel.textColor = [UIColor whiteColor];
        
        _unreadLabel.textAlignment = NSTextAlignmentCenter;
        _unreadLabel.font = [UIFont systemFontOfSize:11];
        _unreadLabel.layer.cornerRadius = 10;
        _unreadLabel.clipsToBounds = YES;
        [self.contentView addSubview:_unreadLabel];
        
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 36, cellWidth - 110, 20)];
        _detailLabel.backgroundColor = [UIColor clearColor];
        _detailLabel.font = k13Font;
        _detailLabel.textColor = RGB(159, 159, 159);
        [self.contentView addSubview:_detailLabel];
        
        self.textLabel.backgroundColor = [UIColor clearColor];
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(70, 0, cellWidth - 70, 0.5)];
        _lineView.backgroundColor = RGB(230, 230, 230);
        [self.contentView addSubview:_lineView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (![_unreadLabel isHidden]) {
        _unreadLabel.backgroundColor = RGB(235, 99, 145);
    }
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    if (![_unreadLabel isHidden]) {
        _unreadLabel.backgroundColor = RGB(235, 99, 145);
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGRect frame = self.imageView.frame;
    
    self.imageView.image = _placeholderImage;
    
    self.imageView.frame = CGRectMake(10, 10, 40, 40);
    self.imageView.clipsToBounds = YES;
    self.imageView.layer.cornerRadius = self.imageView.width / 2.0;
    
    self.textLabel.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame) + 10, 10, 175, 20);
    self.textLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    self.textLabel.textColor = RGB(65, 65, 65);
    
    self.textLabel.text = self.name;
    _detailLabel.text = _detailMsg;
    _timeLabel.text = _time;
    if (_unreadCount > 0) {
        if (_unreadCount < 9) {
            _unreadLabel.font = [UIFont systemFontOfSize:13];
        }else if(_unreadCount > 9 && _unreadCount < 99){
            _unreadLabel.font = [UIFont systemFontOfSize:12];
        }else{
            _unreadLabel.font = [UIFont systemFontOfSize:10];
        }
        [_unreadLabel setHidden:NO];
        [self.contentView bringSubviewToFront:_unreadLabel];
        _unreadLabel.text = [NSString stringWithFormat:@"%ld",(long)_unreadCount];
    }else{
        [_unreadLabel setHidden:YES];
    }
    
    frame = _lineView.frame;
    frame.origin.y = self.contentView.frame.size.height - 0.5;
    _lineView.frame = frame;
}

+(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"XDNoticeCellID";
    XDNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[XDNoticeCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    return cell;
}

@end
