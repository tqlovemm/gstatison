//
//  XDMatchTendencyController.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/12/21.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDMatchTendencyController.h"
#import "XDCheckBoxController.h"
#import "MBProgressHUD+MJ.h"

@interface XDMatchTendencyController ()

@property (nonatomic, strong) SZQuestionItem *item;
/** 题目标题 */
@property (nonatomic, strong) NSArray *titleArray;
/** 题目内容 */
@property (nonatomic, strong) NSArray *optionArray;
/** 题目类型 */
@property (nonatomic, strong) NSArray *typeArray;
/** 答案 */
@property (nonatomic, strong) NSArray *resultArray;

@property (nonatomic, strong) XDCheckBoxController *checkBox;

@property (nonatomic, assign, getter=isFirstFill) BOOL firstFill;

@end

@implementation XDMatchTendencyController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setEdgesForExtendedLayout:UIRectEdgeAll];
    self.title = @"匹配倾向";
    
    [self requestData];
}

#pragma mark - 获取数据
- (void)requestData {
    // 公钥加密
    NSString *encryWithPublicKeyStr = [RSAUtil encryptString:[NSString stringWithFormat:@"%@",User_ID] publicKey:kRSA_Public_key];
    [FKL_DataService requestURL:[NSString url_getMatch_Tendency] parameters:nil headerKey:@"sign" headerValue:encryWithPublicKeyStr withType:@"GET" format:@"JSON" complete:^(id result) {
        
        if ([result[@"code"] integerValue] == 200) {
//            if ([[result[@"data"] class] isKindOfClass:[NSNull class]]) {
            if ([result[@"data"] isEqual:[NSNull null]]) {
                self.firstFill = YES;
                self.resultArray = [NSArray arrayWithObjects:@[@YES, @NO, @NO], @[@YES, @NO, @NO], @[@YES, @NO, @NO], @"能聊得来就行", nil];
            } else {
                self.firstFill = NO;
                NSMutableArray *array1 = [NSMutableArray arrayWithObjects:@NO, @NO, @NO, nil];
                NSMutableArray *array2 = [NSMutableArray arrayWithObjects:@NO, @NO, @NO, nil];
                NSMutableArray *array3 = [NSMutableArray arrayWithObjects:@NO, @NO, @NO, nil];
                [array1 replaceObjectAtIndex:[result[@"data"][@"accept_area"] integerValue] - 1 withObject:@YES];
                [array2 replaceObjectAtIndex:[result[@"data"][@"accept_age"] integerValue] - 1 withObject:@YES];
                [array3 replaceObjectAtIndex:[result[@"data"][@"accept_sex"] integerValue] - 1 withObject:@YES];
                
                self.resultArray = [NSArray arrayWithObjects:array1, array2, array3, [NSString stringWithFormat:@"%@",result[@"data"][@"hope_cp_like"]], nil];
            }
            
            self.titleArray = [NSArray arrayWithObjects:@"1.可以接受怎样的区域范围（接受异地匹配率会更高哦）", @"2.可以接受怎样的年龄匹配", @"3.怎么看待sex，可以接受到哪种程度？",@"4.希望ta是什么样的", nil];
            self.optionArray = [NSArray arrayWithObjects:@[@"都可以接受", @"只接受同省", @"只接受异地"], @[@"都可以接受", @"只可以接受比自己大的", @"只可以接受比自己小的"], @[@"偏保守", @"看感觉", @"偏开放"], @[], nil];
            self.typeArray = @[@(1), @(1), @(1), @(3)];
//            self.resultArray = [NSArray arrayWithObjects:@[@"YES", @"NO", @"NO"], @[@"YES", @"NO", @"NO"], @[@"YES", @"NO", @"NO"], @"程序是我的第二生命，给了我梦想，给了我生活，给了我乐趣，所以程序你值得拥有", nil];
            self.item = [[SZQuestionItem alloc] initWithTitleArray:self.titleArray andOptionArray:self.optionArray andResultArray:self.resultArray andQuestonTypes:self.typeArray];
            
            // 右下
            SZConfigure *configure4 = [[SZConfigure alloc] init];
            configure4.titleFont = 14;
            configure4.optionFont = 14;
            configure4.oneLineHeight = 35;
            configure4.buttonSize = 15;
            configure4.titleTextColor = RGB(65, 65, 65);
            configure4.optionTextColor = RGB(65, 65, 65);
            configure4.checkedImage = @"match_red_select";
            configure4.unCheckedImage = @"match_red_off";
            configure4.answerFrameUseTextView = YES;
            configure4.answerFrameFixedHeight = 48;
            XDCheckBoxController *checkBox4 = [[XDCheckBoxController alloc] initWithItem:self.item andConfigure:configure4];
            checkBox4.tableView.bounces = NO;
            checkBox4.tableView.showsVerticalScrollIndicator = NO;
            [self addChildViewController:checkBox4];
            checkBox4.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            [self.view addSubview:checkBox4.view];
            self.checkBox = checkBox4;
            XD_WeakSelf
            checkBox4.clickFinishedBtn = ^(UIButton *btn) {
                XD_StrongSelf
                [self uploadMatchTendency:self.checkBox.resultArray];
            };
        } else {
            [self.view makeToast:result[@"message"]
                        duration:2.0
                        position:CSToastPositionCenter];
        }
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        [self.view makeToast:error.localizedDescription
                    duration:2.0
                    position:CSToastPositionCenter];
    }];
    
}

- (void)uploadMatchTendency:(NSArray *)resultArray {
    NSString *str = [resultArray lastObject];
    if (str.length < 1) {
        [self.view makeToast:@"请填写对ta的要求" duration:2.0 position:CSToastPositionCenter];
        return;
    }
    
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"accept_area"] = @([[resultArray objectAtIndex:0] indexOfObject:[NSNumber numberWithBool:YES]] + 1);
    paras[@"accept_age"] = @([[resultArray objectAtIndex:1] indexOfObject:[NSNumber numberWithBool:YES]] + 1);
    paras[@"accept_sex"] = @([[resultArray objectAtIndex:2] indexOfObject:[NSNumber numberWithBool:YES]] + 1);
    paras[@"hope_cp_like"] = str;
    
    // 公钥加密
    NSString *encryWithPublicKeyStr = [RSAUtil encryptString:[NSString stringWithFormat:@"%@",User_ID] publicKey:kRSA_Public_key];
    [FKL_DataService requestURL:[NSString url_saveMatch_Tendency_withFirst:self.isFirstFill] parameters:paras headerKey:@"sign" headerValue:encryWithPublicKeyStr withType:self.isFirstFill ? @"POST" : @"PATCH" format:@"JSON" complete:^(id result) {
        
        if ([result[@"code"] integerValue] == 200) {
            [MBProgressHUD showSuccess:@"保存成功"];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self.view makeToast:result[@"message"]
                        duration:2.0
                        position:CSToastPositionCenter];
        }
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        [self.view makeToast:error.localizedDescription
                    duration:2.0
                    position:CSToastPositionCenter];
    }];
}

@end
