//
//  XDUMSharedView.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/7/18.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDUMSharedView.h"

#define ViewHeight 180 //界面下部分享界面(包括取消)的高度

@interface XDUMSharedView ()

@property (nonatomic, strong, nullable) UIView *viewBG;

@property (nonatomic, strong, nullable) UILabel *titleLab;

@property (nonatomic, strong, nullable) UIView *viewShare;   // 分享界面

@property (nonatomic, strong, nullable) UIButton *btnCancel; // 取消按钮

@end

@implementation XDUMSharedView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self createBaseView];
        [self updateUI];
    }
    return self;
}

- (void)createBaseView {
    self.bounds          = [UIScreen mainScreen].bounds;
    self.backgroundColor = RGBA(0, 0, 0, 102.0/255);
    [self.layer setOpaque:0.0];
    
    [self addSubview:self.viewBG];
    [self.titleLab class];
    [self.btnCancel class];
    [self.viewShare class];
    [self addTarget:self action:@selector(didPressedToRemove) forControlEvents:UIControlEventTouchUpInside];
    
    [self createShareView];
}

- (void)updateUI {
}



#pragma mark - --- getters 属性 ---
- (UIView *)viewBG {
    if (!_viewBG) {
        _viewBG                 = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, ViewHeight)];
        _viewBG.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _viewBG;
}

-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]init];
        _titleLab.text = @"分享到站外";
        _titleLab.textColor = RGB(51, 51, 51);
        _titleLab.font = k12Font;
        [_viewBG addSubview:_titleLab];
        [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_viewBG.mas_top).offset(10);
            make.leading.mas_equalTo(_viewBG.mas_leading).offset(10);
            make.trailing.mas_equalTo(_viewBG.mas_trailing);
            make.height.mas_equalTo(17);
        }];
    }
    return _titleLab;
}

- (UIView *)viewShare {
    if (!_viewShare) {
        _viewShare                 = [[UIView alloc]init];
        _viewShare.backgroundColor = [UIColor clearColor];
        [_viewBG addSubview:_viewShare];
        [_viewShare mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_titleLab.mas_bottom);
            make.leading.and.trailing.mas_equalTo(_viewBG);
            make.height.mas_equalTo(108);
        }];
    }
    return _viewShare;
}

- (UIButton *)btnCancel {
    if (!_btnCancel) {
        _btnCancel                 = [[UIButton alloc]init];
        _btnCancel.backgroundColor = [UIColor whiteColor];
        [_btnCancel setTitle:@"取消" forState:UIControlStateNormal];
        [_btnCancel setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
        [_viewBG addSubview:_btnCancel];
        [_btnCancel addTarget:self action:@selector(didPressedToRemove) forControlEvents:UIControlEventTouchUpInside];
        [_btnCancel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(_viewBG.mas_leading);
            make.trailing.mas_equalTo(_viewBG.mas_trailing);
            make.bottom.mas_equalTo(_viewBG.mas_bottom);
            make.height.mas_equalTo(44);
        }];
    }
    return _btnCancel;
}

#pragma mark - p-method

- (void)createShareView {
    NSMutableArray *arr        = [[NSMutableArray alloc]initWithCapacity:0];
    NSMutableArray *imgNameArr = [[NSMutableArray alloc]initWithCapacity:0];
    NSMutableArray *nameArr    = [[NSMutableArray alloc]initWithCapacity:0];
    
    if ([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatSession] && [[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatTimeLine]) {
        [arr addObject:@(UMSocialPlatformType_WechatSession)];
        [arr addObject:@(UMSocialPlatformType_WechatTimeLine)];
        [imgNameArr addObject:@"invalidName"];
        [imgNameArr addObject:@"invalidName-1"];
        [nameArr addObject:@"微信"];
        [nameArr addObject:@"朋友圈"];
    }
    [arr addObject:@(UMSocialPlatformType_Sina)];
    [imgNameArr addObject:@"invalidName-2"];
    [nameArr addObject:@"微博"];
   
    if ([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_QQ] && [[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_Qzone]) {
        [arr addObject:@(UMSocialPlatformType_QQ)];
        [arr addObject:@(UMSocialPlatformType_Qzone)];
        [imgNameArr addObject:@"invalidName-3"];
        [imgNameArr addObject:@"invalidName-4"];
        [nameArr addObject:@"QQ好友"];
        [nameArr addObject:@"QQ空间"];
    }
//    [arr addObject:@(UMSocialPlatformType_QQ)];
//    [arr addObject:@(UMSocialPlatformType_Qzone)];
 
    
//    [imgNameArr addObject:@"share_qq"];
//    [imgNameArr addObject:@"share_qqzone"];

    
#pragma mark 复制链接
    [arr addObject:@(UMSocialPlatformType_UserDefine_Begin)];
    [imgNameArr addObject:@"invalidName-5"];
    [nameArr addObject:@"复制链接"];
    for (int i = 0 ; i<arr.count; i++) {
        UIView *view = [[UIView alloc]init];
        [self.viewShare addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(i * SCREEN_WIDTH / (double)arr.count);
            make.top.mas_equalTo(self.viewShare.mas_top);
            make.height.mas_equalTo(self.viewShare.mas_height);
            make.width.mas_equalTo(SCREEN_WIDTH / (double)arr.count);
        }];
        
        UIImageView *imgShare = [[UIImageView alloc]init];
        imgShare.image        = ImageViewName(F(@"%@", imgNameArr[i]));
        [imgShare setContentMode:UIViewContentModeScaleAspectFit];
        [view addSubview:imgShare];
        [imgShare mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(view);
            make.top.mas_equalTo(20);
            make.size.mas_equalTo(CGSizeMake(44, 44));
        }];
        
        UILabel *lab      = [[UILabel alloc]init];
        lab.text          = nameArr[i];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = RGB(119, 119, 119);
        lab.font = kPingFangLightFont(12);
        [view addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(imgShare);
            make.top.mas_equalTo(imgShare.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(48, 20));
        }];
        
        
        UIButton *btn = [[UIButton alloc]init];
        btn.tag       = i;
        [btn addTarget:self action:@selector(didPressedToClickButton:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(view);
        }];
    }
}

/**
 点击按钮
 
 @param sender sender
 */
- (void)didPressedToClickButton:(UIButton *)sender {
    
    NSInteger type;
//    if ([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatSession] && [[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatTimeLine]) {
//        type = sender.tag;
//    }
//    else {
//        type = sender.tag+2;
//    }
    if ([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatSession] && [[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_QQ]) {
        type = sender.tag;
    } else if ([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatSession] && ![[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_QQ]) { // 只有微信
        if (sender.tag < 3) {
            type = sender.tag;
        } else {
            type = sender.tag + 2;//5
        }
    } else if (![[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatSession] && [[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_QQ]) { // 只有QQ
         type = sender.tag + 2;//2,3,4,5
    } else {
        type = sender.tag+2;
    }
    
    if (type == 0) {
        if ([self.delegate respondsToSelector:@selector(didSelectedToShare:)]) {
            [self.delegate didSelectedToShare:UMSocialPlatformType_WechatSession];
        }
    }
    else if (type == 1) {
        if ([self.delegate respondsToSelector:@selector(didSelectedToShare:)]) {
            [self.delegate didSelectedToShare:UMSocialPlatformType_WechatTimeLine];
        }
    } else if (type == 2) {
        if ([self.delegate respondsToSelector:@selector(didSelectedToShare:)]) {
            [self.delegate didSelectedToShare:UMSocialPlatformType_Sina];
        }
    }
    else if (type == 3){
        if ([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_QQ]) {
            if ([self.delegate respondsToSelector:@selector(didSelectedToShare:)]) {
                [self.delegate didSelectedToShare:UMSocialPlatformType_QQ];
            }
        } else {
            [myAppDelegate.window makeToast:@"请安装对应APP" duration:1 position:CSToastPositionCenter];
        }
    }
    else if (type == 4) {
        if ([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_Qzone]) {
            if ([self.delegate respondsToSelector:@selector(didSelectedToShare:)]) {
                [self.delegate didSelectedToShare:UMSocialPlatformType_Qzone];
            }
        } else {
            [myAppDelegate.window makeToast:@"请安装对应APP" duration:1 position:CSToastPositionCenter];
        }
    }
   else if (type == 5) {
        if ([self.delegate respondsToSelector:@selector(didSelectedToShare:)]) {
            [self.delegate didSelectedToShare:UMSocialPlatformType_UserDefine_Begin];
        }
    }
    
    [self didPressedToRemove];
}


/**
 显示
 */
- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self setCenter:[UIApplication sharedApplication].keyWindow.center];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
    
    CGRect frameBG   = self.viewBG.frame;
    frameBG.origin.y = frameBG.origin.y - ViewHeight;
    [self.layer setOpacity:0];
    
    [UIView animateWithDuration:0.33 animations:^{
        [self.layer setOpacity:1];
        self.viewBG.frame = frameBG;
    } completion:^(BOOL finished) {
    }];
}


/**
 移除
 */
- (void)didPressedToRemove {
    CGRect frameBG   = self.viewBG.frame;
    frameBG.origin.y = frameBG.origin.y + ViewHeight;
    
    [UIView animateWithDuration:0.33 animations:^{
        [self.layer setOpacity:0];
        self.viewBG.frame = frameBG;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
