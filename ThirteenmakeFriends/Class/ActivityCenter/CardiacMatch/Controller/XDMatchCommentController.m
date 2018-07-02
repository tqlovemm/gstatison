//
//  XDMatchCommentController.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/12/20.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDMatchCommentController.h"
#import "UICollectionViewLeftAlignedLayout.h"
#import "XDLabelSelectCell.h"
#import "XDSelectModel.h"
#import "CWStarRateView.h"
//#import "HMTextView.h"
#import "XDMatchRecordModel.h"

@interface XDMatchCommentController ()
<UICollectionViewDataSource,UICollectionViewDelegate,CWStarRateViewDelegate>

@property (nonatomic, strong) UICollectionViewLeftAlignedLayout *layout;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *unUsingArray;
@property (nonatomic ,strong) NSMutableArray *usingArray;
@property (nonatomic ,strong) NSArray *allArray;
@property (assign, nonatomic) BOOL needUpdate;

@property (nonatomic, strong) NSMutableArray *selectArray;

//! 头像
@property (nonatomic, weak) UIImageView *iconView;
//! 昵称
@property (nonatomic, weak) UILabel *nameLabel;
//! 性别
@property (nonatomic, weak) UIImageView *sexView;
//! 地址
@property (nonatomic, weak) UILabel *addressLabel;
//! 其他信息
@property (nonatomic, weak) UILabel *infoLabel;
//! 星星
@property (nonatomic, strong) CWStarRateView *starRateView;
//! 星星描述 （1.很差 2.较差 3.还行 4.不错 5.很棒）
@property (nonatomic, weak) UILabel *starRateLabel;
//! 星星描述 (多选标签提示)
@property (nonatomic, weak) UILabel *hintLabel;

//! 文字评价
//@property (nonatomic, weak) HMTextView *textView;

//! 提交
@property (nonatomic, weak) UIButton *sendBtn;

@end

@implementation XDMatchCommentController

- (NSMutableArray *)usingArray {
    if (_usingArray == nil) {
        _usingArray = [NSMutableArray array];
    }
    return _usingArray;
}

- (NSMutableArray *)unUsingArray {
    if (_unUsingArray == nil) {
        _unUsingArray = [NSMutableArray array];
    }
    return _unUsingArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self setEdgesForExtendedLayout:UIRectEdgeAll];
    [self setupForDismissKeyboard];
    
    self.title = @"标签选择";
    self.view.backgroundColor = [UIColor whiteColor];
    [self configViews];
    
    [self getLabelInfo];
    
}

- (void)reloadDataSource {
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:self.user.avatar] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    self.nameLabel.text = self.user.nickname;
    self.sexView.image = self.user.sex ? [UIImage imageNamed:@"post_woman"] : [UIImage imageNamed:@"post_man"];
    self.infoLabel.text = [NSString stringWithFormat:@"%ld岁 · %ldcm · %ldkg",self.user.age,self.user.height,self.user.weight];
    self.addressLabel.text = [NSString stringWithFormat:@"工作生活在：%@",self.user.area];
}

- (void)configViews {
    self.layout = [[UICollectionViewLeftAlignedLayout alloc] init];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:self.layout];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    self.collectionView.delegate             = self;
    self.collectionView.dataSource           = self;
    self.collectionView.contentSize          = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[XDLabelSelectCell class] forCellWithReuseIdentifier:labelSelectCellID];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
}

#pragma mark - layout
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.allArray.count;
}

#pragma mark -
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView performBatchUpdates:^{
        XDSelectModel *md = self.selectArray[indexPath.item];
        md.isSelected = !md.isSelected;
        [collectionView reloadItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        _needUpdate = YES;
    }];
}

#pragma mark -
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    UIEdgeInsets inset = UIEdgeInsetsMake(10, 10, 10, 10);
    return inset;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *str = self.allArray[indexPath.item];
    CGSize size = CGSizeMake([self getWidthWithStr:str] + 20, 30);
    return size;
}

- (CGFloat)getWidthWithStr:(NSString *)text
{
    CGFloat width = [text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 40) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]} context:nil].size.width;
    return width;
}
#pragma mmark -
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XDLabelSelectCell *cell;
    if (indexPath.section == 0) {
        cell  = [collectionView dequeueReusableCellWithReuseIdentifier:labelSelectCellID forIndexPath:indexPath];
        XDSelectModel *md = self.selectArray[indexPath.item];
        cell.titleLabel.text = self.allArray[indexPath.item];
        if (md.isSelected) {
            cell.titleLabel.textColor = RGB(119, 119, 119);
            cell.titleLabel.backgroundColor = RGB(240, 239, 245);
            cell.layer.borderColor = RGB(240, 239, 245).CGColor;
        } else {
            cell.titleLabel.textColor = RGB(170, 170, 170);
            cell.titleLabel.backgroundColor = [UIColor clearColor];
            cell.layer.borderColor = RGB(222, 222, 222).CGColor;
        }
        
    } else if (indexPath.section == 1){
        cell  = [collectionView dequeueReusableCellWithReuseIdentifier:labelSelectCellID forIndexPath:indexPath];
        cell.titleLabel.text = self.allArray[indexPath.item];
        cell.titleLabel.textColor = HEXCOLOR(0x888888);
        cell.layer.borderColor = HEXCOLOR(0xdcdcdc).CGColor;
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    CGFloat height;
    if (section == 0 ) {
        height = 250;
    } else {
        height = 45;
    }
    return CGSizeMake(collectionView.frame.size.width, height);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(collectionView.frame.size.width, 200);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath ];
        view.backgroundColor = [UIColor whiteColor];
        for (UIView *subView in view.subviews) {
            [subView removeFromSuperview];
        }
        if (indexPath.section == 0) {
            // 个人信息容器
            UIView *personInfoView = [[UIView alloc] init];
            [view addSubview:personInfoView];
            
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
            
            // 其他信息
            UILabel *infoLabel = [[UILabel alloc]init];
            infoLabel.font = k12Font;
            infoLabel.textColor = RGB(119, 119, 119);
            infoLabel.backgroundColor = [UIColor clearColor];
            [personInfoView addSubview:infoLabel];
            self.infoLabel = infoLabel;
            
            // lineView
            UIView *lineView = [[UIView alloc]init];
            lineView.backgroundColor = RGB(230, 230, 230);
            [personInfoView addSubview:lineView];
            
            XD_WeakSelf
            // 布局
            [personInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
                XD_StrongSelf
                make.left.mas_equalTo(self);
                make.top.mas_equalTo(0);
                make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 120));
            }];
            
            [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
                XD_StrongSelf
                make.size.mas_equalTo(CGSizeMake(70, 70));
                make.right.mas_equalTo(self.view.mas_centerX).offset(-20);
                make.top.mas_equalTo(23);
            }];
            self.iconView.layer.cornerRadius = 35;
            self.iconView.layer.masksToBounds = YES;
            
            [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                XD_StrongSelf
                make.centerY.mas_equalTo(self.iconView);
                make.left.mas_equalTo(self.iconView.mas_right).offset(10);
            }];
            
            [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                XD_StrongSelf
                make.bottom.mas_equalTo(self.infoLabel.mas_top).offset(-4);
                make.left.mas_equalTo(self.infoLabel);
                make.width.lessThanOrEqualTo(@120);
            }];
            
            [self.sexView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(nameLabel.mas_top);
                make.left.mas_equalTo(nameLabel.mas_right).mas_offset(5);
                make.size.mas_equalTo(CGSizeMake(14, 14));
            }];
            
            [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.infoLabel.mas_bottom).offset(4);
                make.left.mas_equalTo(self.infoLabel);
            }];
            
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                XD_StrongSelf
                make.top.mas_equalTo(self.iconView.mas_bottom).offset(16);
                make.left.mas_equalTo(20);
                make.right.mas_equalTo(-20);
                make.height.mas_equalTo(1);
            }];
            
            // 评星容器
            UIView *starRateContentView = [[UIView alloc] init];
            [view addSubview:starRateContentView];
            
            UILabel *starRateLabel = [[UILabel alloc]init];
            starRateLabel.font = k14Font;
            starRateLabel.backgroundColor = [UIColor clearColor];
            starRateLabel.textColor = RGB(245, 166, 35);
            [starRateContentView addSubview:starRateLabel];
            self.starRateLabel = starRateLabel;
            
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
            
            UILabel *starRateDesLabel = [[UILabel alloc] init];
            starRateDesLabel.textColor = RGB(170, 170, 170);
            starRateDesLabel.font = kPingFangRegularFont(12);
            starRateDesLabel.text = self.user.sex ? @"给她添加标签" : @"给他添加标签";
            [view addSubview:starRateDesLabel];
            
            [starRateDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(starRateContentView.mas_bottom).offset(20);
                make.centerX.mas_equalTo(starRateContentView);
            }];
            
            [self reloadDataSource];
        }
        return view;
    } else {
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath ];
        view.backgroundColor = [UIColor whiteColor];
        for (UIView *subView in view.subviews) {
            [subView removeFromSuperview];
        }
        if (indexPath.section == 0) {
//            // 文字评价
//            HMTextView *textView = [[HMTextView alloc]init];
//            textView.placehoder = @"写下你对他/她的评价";
//            textView.font = k14Font;
//            textView.backgroundColor = [UIColor whiteColor];
//            textView.layer.borderColor = RGB(170, 170, 170).CGColor;
//            textView.layer.borderWidth = 0.5;
//            textView.layer.cornerRadius = 3;
//            textView.layer.masksToBounds = YES;
//            textView.textColor = [UIColor grayColor];
//
//            [view addSubview:textView];
//            self.textView = textView;
            
            // 文字评价
            UIButton *sendBtn           = [[UIButton alloc]init];
            sendBtn.titleLabel.font = kPingFangRegularFont(14);
            [sendBtn setTitle:@"确认提交" forState:UIControlStateNormal];
            [sendBtn setBackgroundColor:[UIColor whiteColor]];
            sendBtn.layer.cornerRadius = 20;
            sendBtn.layer.shadowRadius = 3;
            sendBtn.layer.shadowOffset = CGSizeMake(0, 1);
            sendBtn.layer.shadowOpacity = 0.8;
            sendBtn.layer.shadowColor = RGBA(0, 0, 0, 0.17).CGColor;
            [sendBtn setTitleColor:ThemeColor1 forState:UIControlStateNormal];
            [sendBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
            [sendBtn addTarget:self action:@selector(sendBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:sendBtn];
            self.sendBtn = sendBtn;
            
            // 布局
//            [textView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.top.mas_equalTo(10);
//                make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 64, 85));
//                make.centerX.mas_equalTo(view.mas_centerX);
//            }];
//
//            [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.top.mas_equalTo(textView.mas_bottom).mas_offset(34);
//                make.size.mas_equalTo(CGSizeMake(188, 40));
//                make.centerX.mas_equalTo(view.mas_centerX);
//            }];
        }
        return view;
    }
}

#pragma mark - network
//- (void)sendBtnClicked:(UIButton *)btn {
//    
//    if (self.textView.text.length == 0) {
//        [self.view makeToast:@"请写下你对他/她的评价" duration:2.0 position:CSToastPositionCenter];
//        return;
//    }
//    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
//    paras[@"to_user_id"] = @(self.user.puser_id);
//    paras[@"star_count"]      = [NSString stringWithFormat:@"%d",(int)(self.starRateView.scorePercent * 5)];      // 星级(最大5)
//    paras[@"content"] = self.textView.text;
//    
//    NSString * str = @"";
//    for (int index = 0; index < self.selectArray.count; index++) {
//        XDSelectModel *model = self.selectArray[index];
//        if (model.isSelected) {
//            str = [str stringByAppendingString:[NSString stringWithFormat:@"%@&",[self.allArray objectAtIndex:index]]];
//        }
//        if (index == self.selectArray.count - 1) {
//            if (str.length == 0) {
//                [self.view makeToast:@"请给他/她添加标签" duration:2.0 position:CSToastPositionCenter];
//                return;
//            }
//            str = [str stringByReplacingCharactersInRange:NSMakeRange(str.length - 1, 1) withString:@""];
//            paras[@"mark"] = str;
//        }
//    }
//    
//    // 公钥加密
//    NSString *encryWithPublicKeyStr = [RSAUtil encryptString:[NSString stringWithFormat:@"%ld",self.user.cuser_id] publicKey:kRSA_Public_key];
//    [FKL_DataService requestURL:[NSString url_comment_match_person] parameters:paras headerKey:@"sign" headerValue:encryWithPublicKeyStr withType:@"POST" format:@"JSON" complete:^(id result) {
//        if ([result[@"code"] integerValue] == 200) {
//            if (self.hasevaluated) {
//                self.hasevaluated(self.starRateLabel.text);
//            }
//            [self.navigationController popViewControllerAnimated:YES];
//        } else {
//            [self.view makeToast:result[@"message"]
//                        duration:2.0
//                        position:CSToastPositionCenter];
//            
//        }
//        [self.collectionView reloadData];
//        
//        [self hideHud];
//    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
//        [self hideHud];
//        [self.view makeToast:error.localizedDescription
//                    duration:2.0
//                    position:CSToastPositionCenter];
//    }];
//}

- (void)getLabelInfo {
    [self showHudInView:self.view hint:@"正在加载中..."];
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"sex"] = @(self.user.sex);
    // 公钥加密
    NSString *encryWithPublicKeyStr = [RSAUtil encryptString:[NSString stringWithFormat:@"%ld",self.user.cuser_id] publicKey:kRSA_Public_key];
    [FKL_DataService requestURL:[NSString url_getMatch_comment_labelInfo] parameters:paras headerKey:@"sign" headerValue:encryWithPublicKeyStr withType:@"GET" format:@"JSON" complete:^(id result) {
        if ([result[@"code"] integerValue] == 200) {
            //            self.allArray = @[@"听音乐",@"运动",@"泡吧",@"看电影",@"健身",@"二次元",@"唱歌",@"逛街"];
            self.allArray = result[@"data"];
            self.selectArray = [NSMutableArray array];
            for (int i = 0; i < self.allArray.count ; i++) {
                XDSelectModel *md = [[XDSelectModel alloc]init];
                md.isSelected = NO;
                
                [self.selectArray addObject:md];
            }
        } else {
            [self.view makeToast:result[@"message"]
                        duration:2.0
                        position:CSToastPositionCenter];
            
        }
        [self.collectionView reloadData];
        
        [self hideHud];
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideHud];
        [self.view makeToast:error.localizedDescription
                    duration:2.0
                    position:CSToastPositionCenter];
    }];
}

#pragma mark - CWStarRateViewDelegate
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

@end
