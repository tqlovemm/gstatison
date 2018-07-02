//
//  XDPostCommentView.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 17/4/19.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDPostCommentView.h"
#import "XDPostModel.h"
#import "MLLinkLabel.h"
//#import "XDOtherViewController.h"

@interface XDPostCommentView ()<MLLinkLabelDelegate>

@property (nonatomic, strong) NSArray *commentItemsArray;

@property (nonatomic, strong) NSMutableArray *commentLabelsArray;

@end

@implementation XDPostCommentView

- (void)setCommentItemsArray:(NSArray *)commentItemsArray
{
    _commentItemsArray = commentItemsArray;
    
    long needsToAddCount = self.commentItemsArray.count;
    _commentLabelsArray = nil;
    for (int i = 0; i < needsToAddCount; i++) {
        MLLinkLabel *label = [MLLinkLabel new];
        UIColor *highLightColor = RGB(120, 116, 180);
        //        label.linkTextAttributes = @{NSForegroundColorAttributeName : highLightColor};
        label.linkTextAttributes = @{NSForegroundColorAttributeName : highLightColor , NSFontAttributeName : [UIFont boldSystemFontOfSize:13]};
        label.textColor = RGB(68, 68, 68);
        label.font = k13Font;
        label.delegate = self;
        label.numberOfLines = 0;
        [self addSubview:label];
        [self.commentLabelsArray addObject:label];
    }
    
    for (int i = 0; i < commentItemsArray.count; i++) {
        XDPostCommentItemModel *model = commentItemsArray[i];
        MLLinkLabel *label = self.commentLabelsArray[i];
        if (!model.attributedContent) {
            model.attributedContent = [self generateAttributedStringWithCommentItemModel:model];
        }
        label.attributedText = model.attributedContent;
    }
}

- (NSMutableArray *)commentLabelsArray
{
    if (!_commentLabelsArray) {
        _commentLabelsArray = [NSMutableArray new];
    }
    return _commentLabelsArray;
}

- (void)setupWithCommentItemsArray:(NSArray *)commentItemsArray
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.commentLabelsArray removeAllObjects];
    self.commentItemsArray = commentItemsArray;
    
    UIView *lastTopView = nil;
    CGFloat lastTopHeight = 0;
    
    for (int i = 0; i < self.commentItemsArray.count; i++) {
        XDPostCommentItemModel *commentModel = self.commentItemsArray[i];
        UILabel *label = (UILabel *)self.commentLabelsArray[i];
        label.hidden = NO;
        
        NSString *text = commentModel.firstName;
        if (commentModel.secondName.length) {
            text = [text stringByAppendingString:[NSString stringWithFormat:@"回复%@", commentModel.secondName]];
        }
        text = [text stringByAppendingString:[NSString stringWithFormat:@"：%@", commentModel.comment]];
        CGFloat contentLabelY = lastTopHeight;
        CGFloat contentLabelX = 0;
        //        CGSize contentLabelSize = [text sizeWithFont:k13Font maxW:SCREEN_WIDTH - 2 * postCellBorder];
        CGSize contentLabelSize = [text sizeWithFont:[UIFont boldSystemFontOfSize:13] maxW:SCREEN_WIDTH - 2 * postCellBorder];
        label.frame = CGRectMake(contentLabelX, contentLabelY, contentLabelSize.width, contentLabelSize.height);
        lastTopHeight = lastTopHeight + contentLabelSize.height + 5;
        lastTopView = label;
    }
    
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}

#pragma mark - private actions

- (NSMutableAttributedString *)generateAttributedStringWithCommentItemModel:(XDPostCommentItemModel *)model
{
    NSString *text = model.firstName;
    if (model.secondName.length) {
        text = [text stringByAppendingString:[NSString stringWithFormat:@"回复%@", model.secondName]];
    }
    if (text == nil) { // 解决firstName为空
        text = model.first_id;
    }
    text = [text stringByAppendingString:[NSString stringWithFormat:@"：%@", model.comment]];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:text];
//    [attString setAttributes:@{NSLinkAttributeName : [NSString stringWithFormat:@"%@", model.first_id]} range:[text rangeOfString:model.firstName]];
    // 解决firstName为空
    [attString setAttributes:@{NSLinkAttributeName : [NSString stringWithFormat:@"%@", model.first_id]} range:model.firstName == nil ? [text rangeOfString:model.first_id] : [text rangeOfString:model.firstName]];
    if (model.secondName) {
        [attString setAttributes:@{NSLinkAttributeName : [NSString stringWithFormat:@"%@", model.second_id]} range:[text rangeOfString:model.secondName]];
    }
    return attString;
}

#pragma mark - MLLinkLabelDelegate

- (void)didClickLink:(MLLink *)link linkText:(NSString *)linkText linkLabel:(MLLinkLabel *)linkLabel
{
    NSLog(@"%@", link.linkValue);
    UITabBarController *tabBar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav = tabBar.selectedViewController;
    
//    XDOtherViewController *personVC = [[XDOtherViewController alloc] init];
//    personVC.user_id = link.linkValue;
//    [nav pushViewController:personVC animated:YES];
}

@end
