//
//  XDPostCommentCell.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 17/3/29.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDPostCommentCell.h"
#import "UIImageView+WebCache.h"
#import "XDPostModel.h"
//#import "XDOtherViewController.h"

@implementation XDPostCommentCell
{
    UIImageView *_iconView;
    UILabel *_firstNameLabel;
    UILabel *_commentLabel;
    UILabel *_timeLabel;
//    UIView *_lineView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupSubViews];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setupSubViews {
    
    _iconView = [UIImageView new];
    _iconView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headIconBtnClicked:)];
    [_iconView addGestureRecognizer:tap];
    
    _firstNameLabel = [UILabel new];
    _firstNameLabel.font = [UIFont boldSystemFontOfSize:14];
    _firstNameLabel.textColor = RGB(62, 62, 62);
    
    _commentLabel = [UILabel new];
    _commentLabel.font = [UIFont systemFontOfSize:12];
    _commentLabel.textColor = RGB(62, 62, 62);
    _commentLabel.numberOfLines = 0;
    _commentLabel.textAlignment = NSTextAlignmentLeft;
    
    _timeLabel = [UILabel new];
    _timeLabel.font = [UIFont systemFontOfSize:12];
    _timeLabel.textColor = RGB(190, 190, 190);
    _timeLabel.textAlignment = NSTextAlignmentRight;
    
//    _lineView = [[UIView alloc] init];
//    _lineView.backgroundColor = RGB(230, 230, 230);
    
    [self.contentView addSubview:_iconView];
    [self.contentView addSubview:_firstNameLabel];
    [self.contentView addSubview:_timeLabel];
    [self.contentView addSubview:_commentLabel];
//    [self.contentView addSubview:_lineView];
    
    _iconView.layer.cornerRadius = 23;
    _iconView.layer.masksToBounds = YES;
    
    XD_WeakSelf
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.mas_equalTo(12);
        make.size.mas_equalTo(CGSizeMake(46, 46));
    }];
    
    [_firstNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_iconView.mas_right).offset(10);
        make.top.mas_equalTo(15);
        make.width.mas_lessThanOrEqualTo(170);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
        make.top.mas_equalTo(_firstNameLabel.mas_top);
        make.width.mas_lessThanOrEqualTo(100);
    }];
    
    [_commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_firstNameLabel.mas_left);
        make.top.mas_equalTo(_firstNameLabel.mas_bottom).offset(5);
        make.width.mas_lessThanOrEqualTo(SCREEN_WIDTH - 46 - 12 - 20);
        make.bottom.mas_equalTo(self.contentView).offset(-15);
    }];
}

- (void)setCommentModel:(XDPostCommentItemModel *)commentModel {
    _commentModel = commentModel;
    
    [_iconView sd_setImageWithURL:[NSURL URLWithString:commentModel.firstUrl] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    _firstNameLabel.text = commentModel.firstName == nil ? commentModel.first_id : commentModel.firstName;
    _timeLabel.text = commentModel.created_at;
    _commentLabel.text = commentModel.secondName.length > 0 ? [NSString stringWithFormat:@"回复 %@:%@",commentModel.secondName,commentModel.comment] : commentModel.comment;
}

/**
 *  头像点击
 */
- (void)headIconBtnClicked:(UITapGestureRecognizer *)recognizer {
    
//    XDOtherViewController *otherVC = [[XDOtherViewController alloc] init];
//    otherVC.user_id = self.commentModel.first_id;
//    [self.navigationController pushViewController:otherVC animated:YES];
}

@end
