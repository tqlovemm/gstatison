//
//  PostMessageCollectionViewCell.m
//  ThirteenmakeFriends
//
//  Created by iOS on 23/3/17.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "PostMessageCollectionViewCell.h"
#import "UIPlaceHolderTextView.h"
@interface PostMessageCollectionViewCell ()<UITextViewDelegate>
@end
@implementation PostMessageCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initCellSubviews];
        
        [self layoutCellSubviews];
    }
    return self;
}

- (void)initCellSubviews {
    UIPlaceHolderTextView *text = [[UIPlaceHolderTextView alloc]initWithFrame:CGRectMake(10, 10, self.frame.size.width - 20, self.frame.size.height - 20)];
    text.placeholder            = @"这里添加文字，请勿发布色情、政治等违反国家法律规定的内容，违者将封号处理";
    text.strLimitNum            = @"100";
    text.txtView.font           = [UIFont systemFontOfSize:14];
    text.limitNumLabel.font     = [UIFont systemFontOfSize:14];
    text.txtView.returnKeyType = UIReturnKeyDone;
    text.txtView.delegate = self;
    [self addSubview:text];
    self.text = text;
}

- (void)layoutCellSubviews {
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [textView resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}

@end
