//
//  VerbPopView.h
//  ThirteenmakeFriends_myPuppet
//
//  Created by 谢超 on 2018/4/16.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VerbPopView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
-(void)verbPopViewShow;
-(void)verbPopViewHide;
@end
