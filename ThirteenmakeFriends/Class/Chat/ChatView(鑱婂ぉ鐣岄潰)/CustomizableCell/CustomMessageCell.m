//
//  CustomMessageCell.m
//  ChatDemo-UI3.0
//
//  Created by EaseMob on 15/8/26.
//  Copyright (c) 2015年 easemob.com. All rights reserved.
//

#import "CustomMessageCell.h"
#import "EMBubbleView+Gif.h"
#import "EMGifImage.h"
#import "UIImageView+HeadImage.h"

#import "EaseMob.h"

//BQMM集成
#import <BQMM/BQMM.h>
#import "EMBubbleView+MMText.h"
#import "MMTextView.h"

@interface CustomMessageCell ()

@end

@implementation CustomMessageCell

+ (void)initialize
{
    // UIAppearance Proxy Defaults
}

#pragma mark - IModelCell

- (BOOL)isCustomBubbleView:(id<IMessageModel>)model
{
    BOOL flag = NO;
    switch (model.bodyType) {
        case eMessageBodyType_Text:
        {
//            if ([model.message.ext objectForKey:@"em_emotion"]) {
//                flag = YES;
//            }
            //BQMM集成
            if ([model.mmExt objectForKey:@"em_emotion"]) {
                flag = YES;
            }
            else if ([model.mmExt[@"txt_msgType"] isEqualToString:@"emojitype"]) {
                flag = YES;
            }
            else if ([model.mmExt[@"txt_msgType"] isEqualToString:@"facetype"]) {
                flag = YES;
            }
        }
            break;
        default:
            break;
    }
    return flag;
}

- (void)setCustomModel:(id<IMessageModel>)model
{
//    if ([model.message.ext objectForKey:@"em_emotion"]) {
//        UIImage *image = [EMGifImage imageNamed:[model.message.ext objectForKey:@"em_emotion"]];
//        if (!image) {
//            image = model.image;
//            if (!image) {
//                image = [UIImage imageNamed:model.failImageName];
//            }
//        }
//        _bubbleView.imageView.image = image;
//        [self.avatarView imageWithUsername:model.nickname placeholderImage:nil];
//    }
    
    //BQMM集成
    if ([model.mmExt[@"txt_msgType"] isEqualToString:@"emojitype"]) {
//        [_bubbleView.textView setMmTextData:model.mmExt[@"msg_data"]];
        // 解决用户和客服会话内容不一致的bug
        if (![model.message.from isEqualToString:kServiceName]) {
            [_bubbleView.textView setMmTextData:model.mmExt[@"msg_data"]];
        }
        else {
//            _bubbleView.textView.text = model.text;
            _bubbleView.textView.attributedText = [[NSAttributedString alloc] initWithString:model.text];
            [_bubbleView.textView setURLAttributes];
            _bubbleView.textView.mmFont = _bubbleView.textView.mmFont;
        }
    }
    else if ([model.mmExt[@"txt_msgType"] isEqualToString:@"facetype"]) {
//        //大表情显示
//        self.bubbleView.imageView.image = [UIImage imageNamed:@"mm_emoji_loading"];
//        NSArray *codes = nil;
//        if (model.mmExt[@"msg_data"]) {
//            codes = @[model.mmExt[@"msg_data"][0][0]];
//        }
//        //兼容1.0之前（含）版本的消息格式
//        else {
//            codes = @[model.text];
//        }
//        __weak typeof(self) weakSelf = self;
//        [[MMEmotionCentre defaultCentre] fetchEmojisByType:MMFetchTypeBig codes:codes completionHandler:^(NSArray *emojis) {
//            if (emojis.count > 0) {
//                MMEmoji *emoji = emojis[0];
//                if ([weakSelf.model.mmExt[@"msg_data"][0][0] isEqualToString:emoji.emojiCode]) {
//                    weakSelf.bubbleView.imageView.image = emoji.emojiImage;
//                }
//            }
//            else {
//                weakSelf.bubbleView.imageView.image = [UIImage imageNamed:@"mm_emoji_error"];
//            }
//        }];
        
        // 解决用户和客服会话内容不一致的bug
        if (![model.message.from isEqualToString:kServiceName]) {
            //大表情显示
            self.bubbleView.imageView.image = [UIImage imageNamed:@"mm_emoji_loading"];
            NSArray *codes = nil;
            if (model.mmExt[@"msg_data"]) {
                codes = @[model.mmExt[@"msg_data"][0][0]];
            }
            //兼容1.0之前（含）版本的消息格式
            else {
                codes = @[model.text];
            }
            __weak typeof(self) weakSelf = self;
            [[MMEmotionCentre defaultCentre] fetchEmojisByType:MMFetchTypeBig codes:codes completionHandler:^(NSArray *emojis) {
                if (emojis.count > 0) {
                    MMEmoji *emoji = emojis[0];
                    if ([weakSelf.model.mmExt[@"msg_data"][0][0] isEqualToString:emoji.emojiCode]) {
                        weakSelf.bubbleView.imageView.image = emoji.emojiImage;
                    }
                }
                else {
                    weakSelf.bubbleView.imageView.image = [UIImage imageNamed:@"mm_emoji_error"];
                }
            }];
        }
        else {
//            _bubbleView.textView.text = model.text;
            _bubbleView.textView.attributedText = [[NSAttributedString alloc] initWithString:model.text];
            [_bubbleView.textView setURLAttributes];
            _bubbleView.textView.mmFont = _bubbleView.textView.mmFont;
        }
        
    }
    
    if (model.avatarURLPath) {
        [self.avatarView sd_setImageWithURL:[NSURL URLWithString:model.avatarURLPath] placeholderImage:model.avatarImage];
    } else {
        self.avatarView.image = model.avatarImage;
    }
}

- (void)setCustomBubbleView:(id<IMessageModel>)model
{
//    if ([model.message.ext objectForKey:@"em_emotion"]) {
//        [_bubbleView setupGifBubbleView];
//        
//        _bubbleView.imageView.image = [UIImage imageNamed:@"imageDownloadFail"];
//    }
    if ([model.mmExt objectForKey:@"em_emotion"]) {
        [_bubbleView setupGifBubbleView];
        
        _bubbleView.imageView.image = [UIImage imageNamed:model.failImageName];
    }
    else if ([model.mmExt[@"txt_msgType"] isEqualToString:@"emojitype"]) {
        [_bubbleView setupMMTextBubbleViewWithModel:model];
    }
    else if ([model.mmExt[@"txt_msgType"] isEqualToString:@"facetype"]) {
//        [_bubbleView setupGifBubbleView];
//        
//        _bubbleView.imageView.image = [UIImage imageNamed:model.failImageName];
        // 解决用户和客服会话内容不一致的bug
        if (![model.message.from isEqualToString:kServiceName]) {
            [_bubbleView setupGifBubbleView];
            
            _bubbleView.imageView.image = [UIImage imageNamed:model.failImageName];
        }
        else {
            [_bubbleView setupMMTextBubbleViewWithModel:model];
        }

    }
}

- (void)updateCustomBubbleViewMargin:(UIEdgeInsets)bubbleMargin model:(id<IMessageModel>)model
{
//    if ([model.message.ext objectForKey:@"em_emotion"]) {
//        [_bubbleView updateGifMargin:bubbleMargin];
//    }
    //BQMM集成
    if ([model.mmExt[@"txt_msgType"] isEqualToString:@"emojitype"]) {
        [_bubbleView updateMMTextMargin:bubbleMargin];
    }
    else if ([model.mmExt[@"txt_msgType"] isEqualToString:@"facetype"]) {
//        [_bubbleView updateGifMargin:bubbleMargin];
        // 解决用户和客服会话内容不一致的bug
        if (![model.message.from isEqualToString:kServiceName]) {
            [_bubbleView updateGifMargin:bubbleMargin];
        }
        else {
            [_bubbleView updateMMTextMargin:bubbleMargin];
        }
    }
}

+ (NSString *)cellIdentifierWithModel:(id<IMessageModel>)model
{
//    if ([model.message.ext objectForKey:@"em_emotion"]) {
//        return model.isSender?@"EaseMessageCellSendGif":@"EaseMessageCellRecvGif";
//    } else {
//        NSString *identifier = [EaseBaseMessageCell cellIdentifierWithModel:model];
//        return identifier;
//    }
    //BQMM集成
    if ([model.mmExt objectForKey:@"em_emotion"]) {
        return model.isSender?@"EaseMessageCellSendGif":@"EaseMessageCellRecvGif";
    }
    else if ([model.mmExt[@"txt_msgType"] isEqualToString:@"emojitype"]) {
        return model.isSender?@"EaseMessageCellSendMMText":@"EaseMessageCellRecvMMText";
    }
    else if ([model.mmExt[@"txt_msgType"] isEqualToString:@"facetype"]) {
//        return model.isSender?@"EaseMessageCellSendGif":@"EaseMessageCellRecvGif";
        // 解决用户和客服会话内容不一致的bug
        if (![model.message.from isEqualToString:kServiceName]) {
            return model.isSender?@"EaseMessageCellSendGif":@"EaseMessageCellRecvGif";
        }
        else {
            return model.isSender?@"EaseMessageCellSendMMText":@"EaseMessageCellRecvMMText";
        }
    }
    else {
        NSString *identifier = [EaseBaseMessageCell cellIdentifierWithModel:model];
        return identifier;
    }
}

+ (CGFloat)cellHeightWithModel:(id<IMessageModel>)model
{
//    if ([model.message.ext objectForKey:@"em_emotion"]) {
//        return 100;
//    } else {
//        CGFloat height = [EaseBaseMessageCell cellHeightWithModel:model];
//        return height;
//    }
    //BQMM集成
    if ([model.mmExt objectForKey:@"em_emotion"]) {
        return 100;
    }
    else if ([model.mmExt[@"txt_msgType"] isEqualToString:@"facetype"]) {
//        return kEMMessageImageSizeHeight;
        // 解决用户和客服会话内容不一致的bug
        if (![model.message.from isEqualToString:kServiceName]) {
            return kEMMessageImageSizeHeight;
        }
        else {
            CGFloat height = [EaseBaseMessageCell cellHeightWithModel:model];
            return height;
        }

    }
    else {
        CGFloat height = [EaseBaseMessageCell cellHeightWithModel:model];
        return height;
    }
}

- (void)customMessageCellClicked:(UITapGestureRecognizer *)tap {
    [_bubbleView.textView handleTap:tap];
}

@end
