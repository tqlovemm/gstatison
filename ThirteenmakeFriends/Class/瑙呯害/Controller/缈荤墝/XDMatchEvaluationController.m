//
//  XDMatchEvaluationController.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 17/1/10.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//  对已匹配的人进行评价

#import "XDMatchEvaluationController.h"
#import "Masonry.h"
#import "CWStarRateView.h"
#import "XDTagLIst.h"
//#import "HMTextView.h"
#import "ShiSanUser.h"
#import "UIImageView+WebCache.h"
#import "NSString+Age.h"
#import "XDEvaluationModel.h"
#import "MJExtension.h"

#define cornerRadiusView(View, Radius) \
\
[View.layer setCornerRadius:(Radius)];           \
[View.layer setMasksToBounds:YES]

@interface XDMatchEvaluationController ()<CWStarRateViewDelegate>

//! 头像
@property (nonatomic, weak) UIImageView *iconView;
//! 昵称
@property (nonatomic, weak) UILabel *nameLabel;
//! 性别
@property (nonatomic, weak) UIImageView *sexView;
//! 地址
@property (nonatomic, weak) UILabel *addressLabel;
//! 年龄
@property (nonatomic, weak) UILabel *ageLabel;
//! 星星
@property (nonatomic, strong) CWStarRateView *starRateView;
//! 星星描述 （1.很差 2.较差 3.还行 4.不错 5.很棒）
@property (nonatomic, weak) UILabel *starRateLabel;
//! 星星描述 (多选标签提示)
@property (nonatomic, weak) UILabel *hintLabel;

//! 文字评价
//@property (nonatomic, weak) HMTextView *textView;

@property (strong, nonatomic) ShiSanUser * user;


//! 提交
@property (nonatomic, weak) UIButton *sendBtn;

@property (strong, nonatomic) NSArray * labsArray;

/**
 选中的标签
 */
@property (strong, nonatomic) NSArray * selectLabsArray;


@property (strong, nonatomic) UIScrollView *popView;

/**
 *  是否正在切换键盘
 */
@property (nonatomic, assign, getter = isChangingKeyboard) BOOL changingKeyboard;

@end

@implementation XDMatchEvaluationController

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
//    [self showHudInView:self.view hint:@"正在加载中..."];
    
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"id"] = self.user_id;
    // 公钥加密
    NSString *encryWithPublicKeyStr = [RSAUtil encryptString:[NSString stringWithFormat:@"%@",self.user_id] publicKey:kRSA_Public_key];
    [FKL_DataService requestURL:[NSString url_getEvaluatePersonInfo] parameters:paras headerKey:@"sign" headerValue:encryWithPublicKeyStr withType:@"GET" format:@"JSON" complete:^(id result) {
        if ([result[@"code"] integerValue] == 200) {
            NSArray *labelArr = [XDEvaluationModel objectArrayWithKeyValuesArray:result[@"data"][@"label"]];
            self.user = [ShiSanUser objectWithKeyValues:result[@"data"][@"userInfo"]];
            NSMutableArray *labs = [NSMutableArray array];
            for (XDEvaluationModel *model in labelArr) {
                [labs addObject:model.label];
            }
            self.labsArray = labs;
            [self setupSubviews];
        } else {
            [self setupErrorSubviews];
            [self.view makeToast:result[@"message"]
                        duration:2.0
                        position:CSToastPositionCenter];

        }
        
//        [self hideHud];
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
//        [self hideHud];
        [self.view makeToast:error.localizedDescription
                    duration:2.0
                    position:CSToastPositionCenter];
        [self setupErrorSubviews];
    }];
}

- (void)setupErrorSubviews {
    //中间弹框的view
    UIScrollView *popView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT)];
    popView.backgroundColor = [UIColor whiteColor];
    self.popView = popView;
    [self.view addSubview:popView];
    
    UIButton *exitBtn = [UIButton new];
    [popView addSubview:exitBtn];
    
    [exitBtn setImage:[UIImage imageNamed:@"exitButton"] forState:UIControlStateNormal];
    [exitBtn addTarget:self action:@selector(exitButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [exitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(22);
        make.top.mas_equalTo(35);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
}

- (void)setupSubviews {
    
    __weak __typeof__(self) weakSelf = self;
    // 滚动容器
    UIScrollView *popView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT)];
    popView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:popView];
    self.popView = popView;
    
    UIButton *exitBtn = [UIButton new];
    [popView addSubview:exitBtn];
    
    [exitBtn setImage:[UIImage imageNamed:@"exitButton"] forState:UIControlStateNormal];
    [exitBtn addTarget:self action:@selector(exitButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 个人信息容器
    UIView *personInfoView = [[UIView alloc] init];
    [popView addSubview:personInfoView];
    
    UIImageView *headIcon = [[UIImageView alloc] init];
    [personInfoView addSubview:headIcon];
    self.iconView = headIcon;
    
    // 昵称
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.font = k14Font;
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = RGB(65, 65, 65);
    [personInfoView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    UIImageView *sexView =[[UIImageView alloc] init];
    [personInfoView addSubview:sexView];
    self.sexView = sexView;
    
    // 地址
    UILabel *addressLabel = [[UILabel alloc]init];
    addressLabel.font = k12Font;
    addressLabel.textColor = RGB(119, 119, 119);
    addressLabel.backgroundColor = [UIColor clearColor];
    [personInfoView addSubview:addressLabel];
    self.addressLabel = addressLabel;
    
    // 年龄
    UILabel *ageLabel = [[UILabel alloc]init];
    ageLabel.font = k12Font;
    ageLabel.textColor = RGB(119, 119, 119);
    ageLabel.backgroundColor = [UIColor clearColor];
    [personInfoView addSubview:ageLabel];
    self.ageLabel = ageLabel;
    
    // lineView
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = RGB(230, 230, 230);
    [personInfoView addSubview:lineView];
    
    // 水平lineView
    UIView *hLineView = [[UIView alloc]init];
    hLineView.backgroundColor = RGB(230, 230, 230);
    [personInfoView addSubview:hLineView];
    
    [headIcon sd_setImageWithURL:[NSURL URLWithString:self.user.avatar] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    nameLabel.text = self.user.nickname.length > 0 ? self.user.nickname : self.user.username;
    sexView.image = [self.user.sex isEqualToString:@"1"] ? [UIImage imageNamed:@"icon_selectedwomen"] : [UIImage imageNamed:@"icon_selectedman"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    dateFormatter.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    NSDate *ageDate = [dateFormatter dateFromString:self.user.birthdate];
    
    NSString *age = [NSString fromDateToAge:ageDate];
    ageLabel.text = age;
    addressLabel.text = self.user.area_one;
    
    // 布局
    [personInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf);
        make.top.mas_equalTo(exitBtn.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 120));
    }];
    
    [exitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(22);
        make.top.mas_equalTo(35);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    
    [headIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(70, 70));
        make.right.mas_equalTo(-weakSelf.view.centerX);
        make.top.mas_equalTo(30);
    }];
    cornerRadiusView(headIcon, 35);
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headIcon.mas_top).mas_offset(18);
        make.left.mas_equalTo(headIcon.mas_right).mas_offset(10);
//        CGSize nameSize = [nameLabel.text sizeWithFont:nameLabel.font];
//        make.size.mas_equalTo(nameSize);
        make.width.lessThanOrEqualTo(@120);
    }];
    
    [sexView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(nameLabel.mas_top);
        make.left.mas_equalTo(nameLabel.mas_right).mas_offset(5);
        make.size.mas_equalTo(CGSizeMake(14, 14));
    }];
    
    [ageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.nameLabel.mas_bottom).mas_offset(6);
        make.left.mas_equalTo(nameLabel);
//        CGSize ageSize = [ageLabel.text sizeWithFont:ageLabel.font];
//        make.size.mas_equalTo(ageSize);
        
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.ageLabel).mas_offset(3);
        make.left.mas_equalTo(weakSelf.ageLabel.mas_right).mas_offset(6);
        make.size.mas_equalTo(CGSizeMake(1, 10));
    }];
    
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.ageLabel);
        make.left.mas_equalTo(lineView.mas_right).mas_offset(5);
    }];
    
    [hLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(personInfoView);
        make.bottom.mas_equalTo(personInfoView.mas_bottom).mas_offset(-0.5);
        make.size.mas_equalTo(CGSizeMake(self.view.width - 40, 0.5));
    }];
    
    
    // 评星容器
    UIView *starRateContentView = [[UIView alloc] init];
    [popView addSubview:starRateContentView];
    
    UILabel *starRateLabel = [[UILabel alloc]init];
    starRateLabel.font = k14Font;
    starRateLabel.backgroundColor = [UIColor clearColor];
    starRateLabel.textColor = RGB(245, 166, 35);
    [starRateContentView addSubview:starRateLabel];
    self.starRateLabel = starRateLabel;
    
//    CWStarRateView *starRateView = [[CWStarRateView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_textLabel.frame) + kViewSpace, SCREEN_WIDTH - 20, 40) numberOfStars:5];
    CWStarRateView *starRateView = [[CWStarRateView alloc] initWithFrame:CGRectMake(0, 0, 35 * 5, 35)];
    starRateView.scorePercent = 1.0;
    starRateView.allowIncompleteStar = NO;
    starRateView.hasAnimation = YES;
    starRateView.delegate = self;
    [starRateContentView addSubview:starRateView];
    self.starRateView = starRateView;
    
    starRateLabel.text = @"很棒";
    
    // 布局
    [starRateContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(personInfoView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 80));
    }];
    
    [starRateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(17);
        make.centerX.mas_equalTo(starRateContentView.centerX);
    }];
    
    [starRateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(35 * 5, 35));
        make.top.mas_equalTo(starRateLabel.mas_bottom).mas_offset(10);
        make.centerX.mas_equalTo(starRateContentView.centerX);
    }];
    
    // 标签选择，多选
    UIView *labelSelectContentView = [[UIView alloc] init];
    [popView addSubview:labelSelectContentView];
    
    UILabel *hintLabel = [[UILabel alloc]init];
    hintLabel.font = k12Font;
    hintLabel.backgroundColor = [UIColor clearColor];
    hintLabel.textColor = RGB(170, 170, 170);
    [labelSelectContentView addSubview:hintLabel];
    self.hintLabel = hintLabel;
    
    XDTagLIst *tagList = [[XDTagLIst alloc] initWithTags:self.labsArray];
    tagList.frame = CGRectMake(20, 80, 300, 200);
    tagList.font = k12Font;
    tagList.multiLine = YES;
    tagList.multiSelect = YES;
    tagList.allowNoSelection = YES;
    tagList.vertSpacing = 6;
    tagList.horiSpacing = 12;
    tagList.textColor = RGB(170, 170, 170);
    tagList.selectedTextColor = RGB(245, 166, 35);
    tagList.tagBackgroundColor = RGB(170, 170, 170);
    tagList.selectedTagBackgroundColor = RGB(245, 166, 35);
    tagList.tagCornerRadius = 14;
//    tagList.tagEdge = UIEdgeInsetsMake(8, 8, 8, 8);
    tagList.tagEdge = UIEdgeInsetsMake(6, 12, 6, 12);
    [tagList addTarget:self action:@selector(selectedTagsChanged:) forControlEvents:UIControlEventValueChanged];
    [labelSelectContentView addSubview:tagList];
    
    hintLabel.text = @"给他添加标签";
    
    // 布局
    [labelSelectContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(starRateContentView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 200));
    }];
    
    [hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.centerX.mas_equalTo(labelSelectContentView.centerX);
    }];
    
    [tagList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 40, 150));
        make.top.mas_equalTo(hintLabel.mas_bottom).mas_offset(13);
        make.centerX.mas_equalTo(labelSelectContentView.centerX);
    }];
    
    // 文字评价
//    HMTextView *textView         = [[HMTextView alloc]init];
//    textView.placehoder          = @"对他进行评价...";
//    textView.font                = k14Font;
//    textView.backgroundColor     = [UIColor whiteColor];
//    textView.layer.borderColor   = RGB(170, 170, 170).CGColor;
//    textView.layer.borderWidth   = 1;
//    textView.layer.cornerRadius  = 4;
//    textView.layer.masksToBounds = YES;
//    textView.textColor           = RGB(170, 170, 170);
//    textView.contentInset        = UIEdgeInsetsMake(2, 6, 2, 6);
//    [popView addSubview:textView];
//    self.textView                = textView;
    
    // 文字评价
    UIButton *sendBtn           = [[UIButton alloc]init];
    sendBtn.titleLabel.font     = k14Font;
    sendBtn.backgroundColor     = [UIColor whiteColor];
    sendBtn.layer.borderColor   = RGB(65, 65, 65).CGColor;
    sendBtn.layer.borderWidth   = 1;
    sendBtn.layer.cornerRadius  = 8;
    sendBtn.layer.masksToBounds = YES;
    [sendBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sendBtn setTitleColor:RGB(65, 65, 65) forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [sendBtn addTarget:self action:@selector(sendBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [popView addSubview:sendBtn];
    self.sendBtn = sendBtn;
    
    // 布局
//    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(labelSelectContentView.mas_bottom);
//        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 64, 85));
//        make.centerX.mas_equalTo(labelSelectContentView.centerX);
//    }];
//
//    [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(textView.mas_bottom).mas_offset(34);
//        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 64, 48));
//        make.centerX.mas_equalTo(labelSelectContentView.centerX);
//    }];
    
    popView.contentSize = CGSizeMake(SCREEN_WIDTH, 667);
    
    [self closedKeyboard];
    
    // 监听键盘
    // 键盘的frame(位置)即将改变, 就会发出UIKeyboardWillChangeFrameNotification
    // 键盘即将弹出, 就会发出UIKeyboardWillShowNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    // 键盘即将隐藏, 就会发出UIKeyboardWillHideNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)exitButtonClick:(UIButton *)btn {
    NSArray *viewcontrollers=self.navigationController.viewControllers;
    if (viewcontrollers.count>1) {
        if ([viewcontrollers objectAtIndex:viewcontrollers.count-1]==self) {
            //push方式
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else{
        //present方式
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

/**
 关闭键盘
 */
- (void)closedKeyboard {
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.view endEditing:YES];
    
}
/**
 提交评价
 */
//- (void)sendBtnClicked:(UIButton *)btn {
//    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
//    
//    paras[@"created_id"] = User_ID; // 评论人id
//    paras[@"saveme_id"]  = self.saveme_id;  // 救火id
//    paras[@"to_userid"]  = self.user_id;  // 被评论人id
//    paras[@"content"]    = self.textView.text;    // 内容
//    paras[@"level"]      = [NSString stringWithFormat:@"%d",(int)(self.starRateView.scorePercent * 5)];      // 星级(最大5)
//    if (self.textView.text.length <= 0) {
//        [self.view makeToast:@"请填写评价"
//                    duration:2.0
//                    position:CSToastPositionCenter];
//        return;
//    }
//    if (self.selectLabsArray.count > 0) {
//        NSString * str = @"";
//        for (NSString *labelStr in self.selectLabsArray) {
//            str = [str stringByAppendingString:[NSString stringWithFormat:@"%@&",labelStr]];
//        }
//        str = [str stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@&",self.selectLabsArray.lastObject] withString:self.selectLabsArray.lastObject];
//        paras[@"label"] = str;      // 标签(例:小鲜肉,技术好,闷骚)
//    }
//    else {
//        [self.view makeToast:@"标签不能为空"
//                    duration:2.0
//                    position:CSToastPositionCenter];
//        return;
//    }
//    // 公钥加密
//    NSString *encryWithPublicKeyStr = [RSAUtil encryptString:[NSString stringWithFormat:@"%@",User_ID] publicKey:kRSA_Public_key];
//    [FKL_DataService requestURL:[NSString url_postEvaluatePersonInfo] parameters:paras headerKey:@"sign" headerValue:encryWithPublicKeyStr withType:@"POST" format:@"JSON" complete:^(id result) {
//        if ([result[@"code"] integerValue] == 200) {
//            NSArray *viewcontrollers=self.navigationController.viewControllers;
//            if (viewcontrollers.count>1) {
//                if ([viewcontrollers objectAtIndex:viewcontrollers.count-1]==self) {
//                    //push方式
//                    if (self.hasevaluated) {
//                        self.hasevaluated(self.starRateView.scorePercent * 5);
//                    }
//                    [self.navigationController popViewControllerAnimated:YES];
//                }
//            }
//            else{
//                //present方式
//                [self.navigationController dismissViewControllerAnimated:YES completion:^{
//                    if (self.hasevaluated) {
//                        self.hasevaluated(self.starRateView.scorePercent * 5);
//                    }
//                }];
//            }
//        } else {
//            [self.view makeToast:result[@"data"]
//                        duration:2.0
//                        position:CSToastPositionCenter];
//        }
//    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
//        [self.view makeToast:error.localizedDescription
//                    duration:2.0
//                    position:CSToastPositionCenter];
//        
//    }];
//}

- (void)starRateView:(CWStarRateView *)starRateView scroePercentDidChange:(CGFloat)newScorePercent {
    NSLog(@"%lf",newScorePercent);
    if (newScorePercent < 0.4) {
       self.starRateLabel.text = @"很差";
    } else if (newScorePercent < 0.6 && newScorePercent >= 0.4) {
       self.starRateLabel.text = @"较差";
    } else if (newScorePercent < 0.8 && newScorePercent >= 0.6) {
        self.starRateLabel.text = @"还行";
    } else if (newScorePercent < 1.0 && newScorePercent >= 0.8) {
        self.starRateLabel.text = @"不错";
    } else {
        self.starRateLabel.text = @"很棒";
    }
}

- (void)selectedTagsChanged:(XDTagLIst *)tagList{
    NSLog(@"selected: %@", tagList.selectedIndexSet);
    self.selectLabsArray = [self.labsArray objectsAtIndexes:tagList.selectedIndexSet];
}

#pragma mark - 键盘处理
/**
 *  键盘即将隐藏
 */
- (void)keyboardWillHide:(NSNotification *)note
{
    if (self.isChangingKeyboard) return;
    
    // 1.键盘弹出需要的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 2.动画
    [UIView animateWithDuration:duration animations:^{
        
        self.popView.transform = CGAffineTransformIdentity;
    }];
}

/**
 *  键盘即将弹出
 */
- (void)keyboardWillShow:(NSNotification *)note
{
    // 1.键盘弹出需要的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 2.动画
    [UIView animateWithDuration:duration animations:^{
        // 取出键盘高度
        CGRect keyboardF = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGFloat keyboardH = keyboardF.size.height;
        self.popView.transform = CGAffineTransformMakeTranslation(0, - keyboardH);
    }];
}

@end
