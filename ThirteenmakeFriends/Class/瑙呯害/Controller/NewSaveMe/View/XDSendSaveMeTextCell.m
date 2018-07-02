//
//  XDSendSaveMeTextCell.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2018/1/6.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import "XDSendSaveMeTextCell.h"
#import "UIPlaceHolderTextView.h"

@interface XDSendSaveMeTextCell ()<UITextViewDelegate>

@end

@implementation XDSendSaveMeTextCell

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
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 5)];
    lineView.backgroundColor = DefaultColor_BG_gray;
    [self.contentView addSubview:lineView];
    
    UIPlaceHolderTextView *text = [[UIPlaceHolderTextView alloc]initWithFrame:CGRectMake(10, 10, self.frame.size.width - 23, self.frame.size.height - 20)];
    text.placeholder            = @"填写你所期待的要求";
    text.strLimitNum            = @"100";
    text.txtView.font           = [UIFont systemFontOfSize:14];
    text.limitNumLabel.font     = [UIFont systemFontOfSize:14];
    text.txtView.returnKeyType = UIReturnKeyDone;
    text.txtView.delegate = self;
    [self addSubview:text];
    self.textView = text;
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
