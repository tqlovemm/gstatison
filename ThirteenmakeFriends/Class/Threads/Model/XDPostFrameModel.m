//
//  XDPostFrameModel.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 17/3/23.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDPostFrameModel.h"
#import "MJExtension.h"
#import "XDPostModel.h"
#import "XDPhotoModel.h"
#import "XDPostPhotoView.h"

#define margin 10

CGFloat maxpostContentLabelHeight = 0; // 根据具体font而定

@implementation XDPostFrameModel
MJCodingImplementation

- (void)setModel:(XDPostModel *)model {
    _model = model;
    
    CGFloat iconViewWH = 40;
    CGFloat iconViewX = margin;
    CGFloat iconViewY = margin;
    _iconViewF = CGRectMake(iconViewX, iconViewY, iconViewWH, iconViewWH);
    
    CGFloat nameLabelX = nameLabelX = CGRectGetMaxX(_iconViewF) + margin;
    CGFloat nameLabelY = iconViewY + 4;
    CGSize nameLabelSize = [model.nickname sizeWithFont:k13Font andMaxSize:CGSizeMake(120, 16)];
    _nameLabelF = (CGRect){{nameLabelX,nameLabelY},nameLabelSize};
    
    CGFloat sexViewX = CGRectGetMaxX(_nameLabelF) + 5;
    CGFloat sexViewY = nameLabelY;
    CGFloat sexViewWH = 16;
    
    if (model.sex == 1 || model.sex == 0) {
        _sexViewF = CGRectMake(sexViewX, sexViewY, sexViewWH, sexViewWH);
    } else {
        _sexViewF = CGRectMake(sexViewX, sexViewY, 0, 0);
    }
    
    if (model.sex == 1) {
        if (model.is_renzheng == 1) {
            CGFloat vipViewX = CGRectGetMaxX(_sexViewF) + 5;
            CGFloat vipViewY = sexViewY;
            CGFloat vipViewH = 16;
            CGFloat vipViewW = 52;
            _memberViewF = CGRectMake(vipViewX, vipViewY, vipViewW, vipViewH);
        } else {
            _memberViewF = CGRectMake(CGRectGetMaxX(_sexViewF), sexViewY, 0, 0);
        }
    } else {
        if (model.groupid > 1) {// 会员等级判断
            CGFloat vipViewX = CGRectGetMaxX(_sexViewF) + 5;
            CGFloat vipViewY = sexViewY;
            CGFloat vipViewWH = 16;
            _memberViewF = CGRectMake(vipViewX, vipViewY, vipViewWH, vipViewWH);
        } else {
            _memberViewF = CGRectMake(CGRectGetMaxX(_sexViewF), sexViewY, 0, 0);
        }
    }
    
    CGFloat topViewW = 33;
    CGFloat topViewH = 14;
    CGFloat topViewX = CGRectGetMaxX(_memberViewF) + 5;
    CGFloat topViewY = sexViewY + 2;
    _isTopViewF = CGRectMake(topViewX, topViewY, topViewW, topViewH);
    
    if (model.address.length > 0) {
        CGFloat addressViewX = nameLabelX - 2;
        CGFloat addressViewY = CGRectGetMaxY(_nameLabelF) + 5;
        CGFloat addressViewWH = 14;
        _locationViewF = CGRectMake(addressViewX, addressViewY, addressViewWH, addressViewWH);
        
        CGSize addressLabelSize = [model.address sizeWithFont:[UIFont systemFontOfSize:10]];
        CGFloat addressLabelX = CGRectGetMaxX(_locationViewF);
        CGFloat addressLabelY = addressViewY + 2;
        _locationLabelF = (CGRect){{addressLabelX,addressLabelY},addressLabelSize};
        
        CGFloat timeViewWH = 10;
        CGFloat timeViewX = CGRectGetMaxX(_locationLabelF) + 8;
        CGFloat timeViewY = addressLabelY + 1.5;
        _timeViewF = CGRectMake(timeViewX, timeViewY, timeViewWH, timeViewWH);
        
        CGFloat timeLabelY = addressLabelY;
        CGSize timeLabelSize = [model.created_at sizeWithFont:[UIFont systemFontOfSize:10.0f]];
        CGFloat timeLabelX = CGRectGetMaxX(_timeViewF) + 2;
        _timeLabelF = (CGRect){{timeLabelX,timeLabelY},timeLabelSize};
    } else {
        CGFloat addressViewX = nameLabelX - 2;
        CGFloat addressViewY = CGRectGetMaxY(_nameLabelF) + 5;
        CGSize addressViewSize = CGSizeMake(0, 0);
        _locationViewF = (CGRect){{addressViewX,addressViewY},addressViewSize};
        
        CGFloat addressLabelX = CGRectGetMaxX(_locationViewF);
        CGFloat addressLabelY = addressViewY + 3;
        CGSize addressLabelSize = CGSizeMake(0, 0);
        _locationLabelF = (CGRect){{addressLabelX,addressLabelY},addressLabelSize};
        
        CGFloat timeViewWH = 10;
        CGFloat timeViewX = nameLabelX - 2;
        CGFloat timeViewY = addressLabelY + 1.5;
        _timeViewF = CGRectMake(timeViewX, timeViewY, timeViewWH, timeViewWH);
        
        CGFloat timeLabelY = addressLabelY;
        CGSize timeLabelSize = [model.created_at sizeWithFont:[UIFont systemFontOfSize:10.0f]];
        CGFloat timeLabelX = CGRectGetMaxX(_timeViewF) + 2;
        _timeLabelF = (CGRect){{timeLabelX,timeLabelY},timeLabelSize};
    }
    
//    CGFloat otherBtnY = CGRectGetMaxY(_nameLabelF);
    CGFloat otherBtnY = nameLabelY;
    CGFloat otherBtnW = 30;
    CGFloat otherBtnH = 20;
    CGFloat otherBtnX = SCREEN_WIDTH - otherBtnW - margin;
    _otherBtnF = CGRectMake(otherBtnX, otherBtnY, otherBtnW, otherBtnH);
    
    CGFloat attentionViewW = 0;
    CGFloat attentionViewH = 0;
    if (!model.follow) {
        attentionViewW = 54;
        attentionViewH = 20;
    }
    CGFloat attentionViewX = otherBtnX - attentionViewW - 5;
    _attentionViewF = CGRectMake(attentionViewX, otherBtnY, attentionViewW, attentionViewH);
    
    if (maxpostContentLabelHeight == 0) {
        maxpostContentLabelHeight = 20 * 3;
    }
    // 文字内容
    CGFloat contentLabelY = model.content.length == 0 ? CGRectGetMaxY(_iconViewF) : CGRectGetMaxY(_iconViewF) + 10;
    CGFloat contentLabelX = margin;
    CGSize contentLabelSize = CGSizeZero;
    
    // 隐藏展开全文
    NSString *content = model.content;
    
    CGFloat moreBtnX = contentLabelX;
    CGFloat moreBtnY = 0;
    CGSize moreBtnSize = [@"全文" sizeWithFont:k14Font];
    if (model.shouldShowMoreButton) { // 如果文字高度超过60
        if (model.isOpening) { // 如果需要展开
            contentLabelSize = [content sizeWithFont:k14Font maxW:SCREEN_WIDTH - postCellBorder * 2];
            _contentLabelF = (CGRect){{contentLabelX,contentLabelY},contentLabelSize};
        } else {
            contentLabelSize = [content sizeWithFont:k14Font andMaxSize:CGSizeMake(SCREEN_WIDTH - postCellBorder * 2, maxpostContentLabelHeight)];
            _contentLabelF = (CGRect){{contentLabelX,contentLabelY},contentLabelSize};
        }
        
        moreBtnY = CGRectGetMaxY(_contentLabelF);
        _isMoreButtonF = CGRectMake(moreBtnX, moreBtnY, moreBtnSize.width, moreBtnSize.height);
    } else {
        if (content.length > 0) {
            contentLabelSize = [content sizeWithFont:k14Font maxW:SCREEN_WIDTH - postCellBorder * 2];
        }
        _contentLabelF = (CGRect){{contentLabelX,contentLabelY},contentLabelSize};
        moreBtnY = CGRectGetMaxY(_contentLabelF);
        _isMoreButtonF = CGRectMake(moreBtnX, moreBtnY, 0, 0);
    }
    
    CGFloat picViewX = margin;
    CGFloat picViewY = model.imgItemsArray.count == 0 ? CGRectGetMaxY(_isMoreButtonF) : CGRectGetMaxY(_isMoreButtonF) + 10;
    CGSize picSize = [XDPostPhotoView sizeWithPhotos:model.imgItemsArray];
    _picViewF = (CGRect){{picViewX,picViewY},picSize};
    
    CGFloat topicViewW = SCREEN_WIDTH;
    CGFloat topicViewH = 44;
    CGFloat topicViewX = 0;
    CGFloat topicViewY = 0;
    if (model.tag.length > 0) {
        topicViewH = 44;
        topicViewY = CGRectGetMaxY(_picViewF);
    } else {
        topicViewH = 0;
        topicViewY = CGRectGetMaxY(_picViewF) + 10;
    }
    _topViewF = CGRectMake(topicViewX, topicViewY, topicViewW, topicViewH);
    
    CGFloat btnY = CGRectGetMaxY(_topViewF);
    
    CGFloat commentBtnW = 56;
    CGFloat commentBtnH = 29;
    CGFloat commentBtnX = SCREEN_WIDTH - margin - commentBtnW;
    CGFloat commentBtnY = btnY;
    _commentBtnF = CGRectMake(commentBtnX, commentBtnY, commentBtnW, commentBtnH);
    
    CGFloat praiseButtonX = CGRectGetMinX(_commentBtnF) - margin - commentBtnW;
    CGFloat praiseButtonY = btnY;
    _praiseBtnF = CGRectMake(praiseButtonX, praiseButtonY, commentBtnW, commentBtnH);
    
    
    CGFloat praiseViewW = praiseButtonX;
    CGFloat praiseViewH = 0;
    CGFloat praiseViewX = 0;
    CGFloat praiseViewY = praiseButtonY;
    if (model.likeCount > 0) {
        praiseViewH = 36;
    }
    _praiseViewF = CGRectMake(praiseViewX, praiseViewY, praiseViewW, praiseViewH);
    
    CGFloat commentViewY = CGRectGetMaxY(_praiseBtnF) + 10;
    CGFloat commentViewX = postCellBorder;
    CGSize commentViewSize = CGSizeZero;
    
    if (model.commentItemsArray.count > 0) {
        CGFloat lastTopHeight = 0;
        for (XDPostCommentItemModel *commentModel in model.commentItemsArray) {
            NSString *str = (NSString *)[self generateAttributedStringWithCommentItemModel:commentModel];
            CGSize commentLabelSize = [str sizeWithFont:[UIFont boldSystemFontOfSize:13] maxW:SCREEN_WIDTH - 2 * postCellBorder];
            lastTopHeight = commentLabelSize.height + lastTopHeight + 5;
        }
        
        _commentViewF = CGRectMake(commentViewX, commentViewY, SCREEN_WIDTH - 2 * postCellBorder, lastTopHeight);
        
        CGFloat allcommentsX = commentViewX;
        CGFloat allcommentsY = CGRectGetMaxY(_commentViewF);
        if (model.commentCount > model.commentItemsArray.count) {
            CGSize allcommentsSize = [@"查看所有留言..." sizeWithFont:k13Font];
            _allCommentsF = CGRectMake(allcommentsX, allcommentsY, allcommentsSize.width, allcommentsSize.height);
            
            _cellHeight = CGRectGetMaxY(_allCommentsF) + 10;
        } else {
            _allCommentsF = CGRectMake(allcommentsX, allcommentsY, 0, 0);
            _cellHeight = CGRectGetMaxY(_commentViewF) + 10;
        }
    } else {
        commentViewY = CGRectGetMaxY(_praiseBtnF);
        _commentViewF = (CGRect){{commentViewX,commentViewY},commentViewSize};
        _cellHeight = CGRectGetMaxY(_commentViewF) + 15; // 无评论时
    }
}

- (NSInteger)columnCountWithNum:(NSInteger)count
{
    NSUInteger i = 0;
    if (count % 3 == 0)
    {
        i = count / 3;
    }
    else
    {
        i = count / 3 + 1;
    }
    return i;
}

#pragma mark - private actions

- (NSString *)generateAttributedStringWithCommentItemModel:(XDPostCommentItemModel *)model
{
    NSString *text = model.firstName;
    if (model.secondName.length) {
        text = [text stringByAppendingString:[NSString stringWithFormat:@"回复%@", model.secondName]];
    }
    if (text == nil) { // 解决firstName为空
        text = model.first_id;
    }
    text = [text stringByAppendingString:[NSString stringWithFormat:@"：%@", model.comment]];
    return text;
}

@end
