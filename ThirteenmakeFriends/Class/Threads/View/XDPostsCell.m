//
//  XDPostsCell.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 17/3/23.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDPostsCell.h"
#import "XDPostFrameModel.h"
#import "XDPostModel.h"
#import "XDPostCommentView.h"
#import "XDPostPhotoView.h"
#import "XDPostsTopicView.h"
#import "XDPostPraiseView.h"
#import "UIResponder+Router.h"
#import "UILabel+XDCopy.h"

NSString *const kRouterEventHeadIconViewTapEventName = @"kRouterEventHeadIconViewTapEventName";

const CGFloat postcontentLabelFontSize = 14;

@implementation XDPostsCell

{
    UIImageView *_iconView;
    UILabel *_nameLable;
    UILabel *_addressLabel;
    UIImageView *_addressView;
    UILabel *_contentLabel;
    UIImageView *_attentionView;
    XDPostPhotoView *_picView;
    XDPostsTopicView *_topicView;
    XDPostPraiseView *_praiseView;
    UILabel *_timeLabel;
    UIImageView *_timeView;
    UIButton *_moreButton;
    UILabel *_moreComment;
    UIButton *_praiseButton;
    UIButton *_commentButton;
    UIButton *_otherButton;
    UIImageView *_sexView;
    UIImageView *_vipView;
    XDPostCommentView *_commentView;
    UIView *_lineView;
    /** 置顶 */
    UIImageView *_isTopView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setup];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)setup
{
    _iconView = [UIImageView new];
    _iconView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headIconBtnClicked:)];
    [_iconView addGestureRecognizer:tap];
    [self.contentView addSubview:_iconView];
    
    _nameLable = [UILabel new];
    _nameLable.font = k13Font;
    _nameLable.textColor = RGB(65, 65, 65);
    [self.contentView addSubview:_nameLable];
    
    _attentionView = [[UIImageView alloc] init];
    _attentionView.userInteractionEnabled = YES;
    [self.contentView addSubview:_attentionView];
    UITapGestureRecognizer *attentionTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(attentionViewClicked:)];
    [_attentionView addGestureRecognizer:attentionTap];
    
    _sexView = [UIImageView new];
    [self.contentView addSubview:_sexView];
    
    _vipView = [UIImageView new];
    [self.contentView addSubview:_vipView];
    
    _isTopView = [UIImageView new];
    [self.contentView addSubview:_isTopView];
    
    _addressLabel = [[UILabel alloc] init];
    _addressLabel.font = [UIFont systemFontOfSize:10];
    _addressLabel.textColor = RGB(119, 119, 119);
    [self.contentView addSubview:_addressLabel];
    
    _addressView = [UIImageView new];
    _addressView.image = [UIImage imageNamed:@"send_location"];
    [self.contentView addSubview:_addressView];
    
    _contentLabel = [UILabel new];
    _contentLabel.isCopyable = YES;
    _contentLabel.font = [UIFont systemFontOfSize:postcontentLabelFontSize];
    _contentLabel.textColor = RGB(65, 65, 65);
    _contentLabel.numberOfLines = 0;
    
    [self.contentView addSubview:_contentLabel];
    
    _moreButton = [UIButton new];
    [_moreButton setTitle:@"全文" forState:UIControlStateNormal];
    [_moreButton setTitleColor:RGB(120, 116, 180) forState:UIControlStateNormal];
    [_moreButton addTarget:self action:@selector(moreButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    _moreButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_moreButton];
    
    _moreComment = [[UILabel alloc]init];
    _moreComment.text = @"查看所有留言...";
    _moreComment.textColor = HEXCOLOR(0xc3c3c3);
    _moreComment.font = k13Font;
    [self.contentView addSubview:_moreComment];
    
    _picView = [[XDPostPhotoView alloc] init];
    [self.contentView addSubview:_picView];
    
    _topicView = [[XDPostsTopicView alloc] init];
    [self.contentView addSubview:_topicView];
    
    _praiseView = [[XDPostPraiseView alloc] init];
    [self.contentView addSubview:_praiseView];
    
    _commentView = [XDPostCommentView new];
    [self.contentView addSubview:_commentView];
    
    _praiseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_praiseButton setImage:[UIImage imageNamed:@"post_unlike"] forState:UIControlStateNormal];
    [_praiseButton setImage:[UIImage imageNamed:@"post_like"] forState:UIControlStateSelected];
    [_praiseButton addTarget:self action:@selector(praiseButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_praiseButton];
    
    _commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_commentButton setImage:[UIImage imageNamed:@"thread_comment"] forState:UIControlStateNormal];
    [_commentButton setTitle:@"评论" forState:UIControlStateNormal];
    [_commentButton setTitleColor:RGB(194, 194, 194) forState:UIControlStateNormal];
    [_commentButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [_commentButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [_commentButton setBackgroundImage:[UIImage resizedImage:@"timeline_card_bottom_background_highlighted"] forState:UIControlStateHighlighted];
    [_commentButton addTarget:self action:@selector(commentButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    _commentButton.layer.cornerRadius = 2.0f;
    _commentButton.layer.borderWidth = 0.5;
    _commentButton.layer.borderColor = RGB(194, 194, 194).CGColor;
    _commentButton.layer.masksToBounds = YES;
    [self.contentView addSubview:_commentButton];
    
    _otherButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_otherButton setImage:[UIImage imageNamed:@"thread_more"] forState:UIControlStateNormal];
    [_otherButton addTarget:self action:@selector(otherButtonClicked) forControlEvents:UIControlEventTouchUpInside];
//    [_otherButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
//    [_otherButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
//    [_otherButton setBackgroundImage:[UIImage resizedImage:@"timeline_card_bottom_background_highlighted"] forState:UIControlStateHighlighted];
//    _otherButton.layer.cornerRadius = 2.0f;
//    _otherButton.layer.borderWidth = 0.5;
//    _otherButton.layer.borderColor = RGB(190, 190, 190).CGColor;
//    _otherButton.layer.masksToBounds = YES;
    [self.contentView addSubview:_otherButton];
    
    _timeLabel = [UILabel new];
    _timeLabel.textColor = RGB(119, 119, 119);
    _timeLabel.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:_timeLabel];
    
    _timeView = [UIImageView new];
    _timeView.image = [UIImage imageNamed:@"time_thread"];
    [self.contentView addSubview:_timeView];
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = RGB(240, 239, 245);
    [self addSubview:_lineView];

}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setPostFrameModel:(XDPostFrameModel *)postFrameModel {
    _postFrameModel = postFrameModel;
    
    XDPostModel *model = postFrameModel.model;
    
    [_commentView setupWithCommentItemsArray:model.commentItemsArray];
    
    [_iconView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    _nameLable.text = model.nickname;
    
    _attentionView.image = model.follow ? nil : [UIImage imageNamed:@"post_attention"];
    if (model.sex == 1) {
        _sexView.image = [UIImage imageNamed:@"post_woman"];
        _sexView.hidden = NO;
    } else if (model.sex == 0) {
        _sexView.image = [UIImage imageNamed:@"post_man"];
        _sexView.hidden = NO;
    } else {
        _sexView.hidden = YES;
    }
    if (model.sex == 1) {
        if (model.is_renzheng == 1) {
            _vipView.image = [UIImage imageNamed:@"girl_yirenzheng"];
        } else {
            _vipView.image = nil;
        }
    } else {
        if (model.groupid > 0) {// 会员等级判断
           _vipView.image = [UIImage imageNamed:@"square_vips"];
        } else {
            _vipView.image = nil;
        }
    }
    
    _isTopView.image = [UIImage imageNamed:@"is_top"];
    _isTopView.frame = postFrameModel.isTopViewF;
    if (model.is_top) {
        _isTopView.hidden = NO;
    } else {
        _isTopView.hidden = YES;
    }
    
    _addressLabel.text = model.address;
    _contentLabel.text = model.content;
    _picView.pic_urls = model.imgItemsArray;
    _topicView.topicStiing = model.tag;
    
    _praiseView.hidden = !model.likeCount;
    _praiseView.model = model;
    
    _praiseButton.selected = model.liked;
    [self setupBtn:_commentButton originalTitle:@"评论" count:(int)model.commentCount];
    
    
    // 隐藏展开全文
    if (model.shouldShowMoreButton) { // 如果文字高度超过60
        _moreButton.hidden = NO;
        if (model.isOpening) { // 如果需要展开
            [_moreButton setTitle:@"收起" forState:UIControlStateNormal];
        } else {
            [_moreButton setTitle:@"全文" forState:UIControlStateNormal];
        }
    } else {
        _moreButton.hidden = YES;
    }
    _moreButton.frame = postFrameModel.isMoreButtonF;
    
    if (model.commentCount > model.commentItemsArray.count) {
        _moreComment.hidden = NO;
    } else {
        _moreComment.hidden = YES;
    }
    _moreComment.frame = postFrameModel.allCommentsF;
    
    _topicView.hidden = model.tag.length == 0;
    
    _timeLabel.text = model.created_at;
    _commentView.frame = postFrameModel.commentViewF;
    _iconView.frame = postFrameModel.iconViewF;
    _nameLable.frame = postFrameModel.nameLabelF;
    _attentionView.frame = postFrameModel.attentionViewF;
    _addressLabel.frame = postFrameModel.locationLabelF;
    _addressView.frame = postFrameModel.locationViewF;
    _contentLabel.frame = postFrameModel.contentLabelF;
    _picView.frame = postFrameModel.picViewF;
    _praiseButton.frame = postFrameModel.praiseBtnF;
    _commentButton.frame = postFrameModel.commentBtnF;
    _otherButton.frame = postFrameModel.otherBtnF;
    _timeView.frame = postFrameModel.timeViewF;
    _timeLabel.frame = postFrameModel.timeLabelF;
    _sexView.frame = postFrameModel.sexViewF;
    _vipView.frame = postFrameModel.memberViewF;
    _topicView.frame = postFrameModel.topViewF;
    _praiseView.frame = postFrameModel.praiseViewF;
    _iconView.layer.cornerRadius = _iconView.width / 2.0;
    _iconView.layer.masksToBounds = YES;
    _lineView.frame = CGRectMake(0, postFrameModel.cellHeight - 5, SCREEN_WIDTH, 5);
}

- (void)moreButtonClicked {
    if (self.moreButtonClickedBlock) {
        self.moreButtonClickedBlock(self.indexPath);
    }
}

/**
 *  设置按钮的显示标题
 *
 *  @param btn           哪个按钮
 *  @param originalTitle 原始标题
 *  @param count         显示数字
 */
- (void)setupBtn:(UIButton *)btn originalTitle:(NSString *)originalTitle count:(int)count {
    if (count) {
        NSString * title = nil;
        if (count < 10000) {
            title = [NSString stringWithFormat:@"%d",count];
        } else {
            double countDouble = count / 10000.0;
            title = [NSString stringWithFormat:@"%.1f万",countDouble];
            title = [title stringByReplacingOccurrencesOfString:@".0" withString:@""];
        }
        [btn setTitle:title forState:UIControlStateNormal];
    }else {
        [btn setTitle:originalTitle forState:UIControlStateNormal];
    }
}

/**
 *  头像点击
 */
- (void)headIconBtnClicked:(UITapGestureRecognizer *)recognizer {
    [self routerEventWithName:kRouterEventHeadIconViewTapEventName userInfo:@{XDPostCellModelKey:self.postFrameModel.model,
      XDPostCellModelViewKey:recognizer.view}];
}

- (void)attentionViewClicked:(UITapGestureRecognizer *)recognizer {
    NSLog(@"关注被点击");
    if (self.attentionViewClickedBlock) {
        self.attentionViewClickedBlock((UIImageView *)recognizer.view);
    }
}

/**
 *  评论
 */
- (void)commentButtonClicked {
    
    NSLog(@"评论");
    if (self.commentButtonClickedBlock) {
        self.commentButtonClickedBlock();
    }
}

/**
 *  点赞
 */
- (void)praiseButtonClicked {
    
    NSLog(@"点赞");
    if (self.postFrameModel.model.isLiked) { // 已经点赞过了
        return;
    }

    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"user_id"] = User_ID;
    paras[@"thread_id"] = self.postFrameModel.model.wid;

    [XDRequestHttpTool request_thumbupThreadInfo_withParameters:paras complete:^(id result) {
        if (result[@"code"] == nil) { // 点赞成功

            self.postFrameModel.model = [XDPostModel objectWithKeyValues:result];

//            if (self.praiseButtonClickedBlock) {
//                self.praiseButtonClickedBlock();
//            }

            CAKeyframeAnimation * animation;
            animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
                animation.duration = 0.5;
            animation.removedOnCompletion = YES;
            animation.fillMode = kCAFillModeForwards;
            
            NSMutableArray *values = [NSMutableArray array];
            [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
            [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
            [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
            [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
            
            animation.values = values;
            [_praiseButton.layer addAnimation:animation forKey:nil];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:XDPostLikeNotification object:self.postFrameModel.model];
            });

        } else {
            UITabBarController *tabBar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            UINavigationController *nav = tabBar.selectedViewController;
            [nav.view makeToast:result[@"message"] duration:2.0 position:CSToastPositionCenter];
        }

        [self setupBtn:_praiseButton originalTitle:@"赞" count:(int)self.postFrameModel.model.likeCount];
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {

        UITabBarController *tabBar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        UINavigationController *nav = tabBar.selectedViewController;
        [nav.view makeToast:error.localizedDescription duration:2.0 position:CSToastPositionCenter];
    }];
}

- (void)otherButtonClicked {
    if (self.otherButtonClickedBlock) {
        self.otherButtonClickedBlock(self.indexPath);
    }
}

- (void)setAttentionVIewisHiddden:(BOOL)hidden {
    _attentionView.hidden = hidden;
}

#pragma mark - 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"XDPostsCellID";
    XDPostsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[XDPostsCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    return cell;
}


@end
