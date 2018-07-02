//
//  XDCheckBoxController.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/12/22.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDCheckBoxController.h"
#import "SZQuestionCell.h"
#import "SZQuestionOptionCell.h"
#import "UIView+XDGradientColor.h"

@interface XDCheckBoxController ()

@property (nonatomic, assign) CGFloat titleWidth;
@property (nonatomic, assign) CGFloat OptionWidth;
@property (nonatomic, assign) BOOL complete;
@property (nonatomic, strong) NSArray *tempArray;
@property (nonatomic, strong) NSMutableArray *arrayM;
@property (nonatomic, strong) SZConfigure *configure;

@end

@implementation XDCheckBoxController

- (instancetype)initWithItem:(SZQuestionItem *)questionItem {
    
    SZConfigure *configure = [[SZConfigure alloc] init];
    return [self initWithItem:questionItem andConfigure:configure];
}

- (instancetype)initWithItem:(SZQuestionItem *)questionItem andConfigure:(SZConfigure *)configure {
    
    self = [super init];
    
    if (self) {
        self.sourceArray = questionItem.ItemQuestionArray;
        if (configure != nil) self.configure = configure;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.canEdit = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 56)];
    self.tableView.tableHeaderView = headerView;
    UILabel *matchLabel = [[UILabel alloc] init];
    matchLabel.textColor = [UIColor colorWithWhite:65.0f / 255.0f alpha:1.0f];
    matchLabel.font = [UIFont systemFontOfSize:16];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"匹配倾向(必填）"];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:170.0f / 255.0f alpha:1.0f] range:NSMakeRange(4, 4)];
    matchLabel.attributedText = attributedString;
    [headerView addSubview:matchLabel];
    
    [matchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(25);
    }];
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 180)];
    self.tableView.tableFooterView = footView;
    
    UIButton *submitBtn = [[UIButton alloc] init];
    submitBtn.titleLabel.font = kPingFangRegularFont(14);
    [submitBtn setTitle:@"完成" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    submitBtn.layer.cornerRadius = 20;
    submitBtn.layer.masksToBounds = YES;
    [submitBtn addTarget:self action:@selector(sendFinished:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:submitBtn];
    
    submitBtn.size = CGSizeMake(188, 40);
    submitBtn.y = 100;
    submitBtn.centerX = footView.centerX;
    [submitBtn setShadowBackgroundColor];
}

- (void)sendFinished:(UIButton *)btn {
    if (self.clickFinishedBtn) {
        self.clickFinishedBtn(btn);
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.titleWidth = self.view.frame.size.width - self.configure.titleSideMargin * 2;
    self.OptionWidth = self.view.frame.size.width - self.configure.optionSideMargin * 2 - self.configure.buttonSize - 5;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)isComplete {
    
    [self getResult];
    return self.complete;
}

- (NSArray *)resultArray {
    
    [self getResult];
    return self.tempArray;
}

- (void)getResult {
    
    [self.view endEditing:YES];
    BOOL complete          = true;
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSDictionary *dict in self.sourceArray) {
        
        if ([dict[@"type"] integerValue] == SZQuestionOpenQuestion) {
            NSString *str = dict[@"marked"];
            complete      = (str.length > 0) && complete;
            [arrayM addObject:str.length ? str : @""];
        }
        else {
            NSArray *array = dict[@"marked"];
            complete       = ([array containsObject:@"YES"] || [array containsObject:@"yes"] || [array containsObject:@(1)] || [array containsObject:@"1"]) && complete;
            [arrayM addObject:array];
        }
    }
    self.complete   = complete;
    self.tempArray  = arrayM.copy;
}

- (void)setCanEdit:(BOOL)canEdit {
    
    _canEdit = canEdit;
    [self.tableView reloadData];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self.view endEditing:YES];
}

#pragma mark - UITableViewdatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.sourceArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dict = self.sourceArray[indexPath.row];
    SZQuestionCell *cell = [[SZQuestionCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                 reuseIdentifier:@"questionCellIdentifier"
                                                         andDict:dict
                                                  andQuestionNum:indexPath.row + 1
                                                        andWidth:self.view.frame.size.width
                                                    andConfigure:self.configure];
    __weak typeof(self) weakSelf = self;
    cell.selectOptionBack = ^(NSInteger index, NSDictionary *dict, BOOL refresh) {
        [weakSelf.arrayM replaceObjectAtIndex:index withObject:dict];
        weakSelf.sourceArray = weakSelf.arrayM.copy;
        if (refresh) {
            NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:0];
            [weakSelf.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
        }
    };
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.userInteractionEnabled = self.canEdit;
    return cell;
}

#pragma mark - UITableViewdelegate

/**
 *  返回各个Cell的高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat topDistance = (indexPath.row == 0 ? self.configure.topDistance : 0);
    NSDictionary *dict = self.sourceArray[indexPath.row];
    
    if ([dict[@"type"] intValue] == SZQuestionOpenQuestion) {
        
        CGFloat title_height = [SZQuestionItem heightForString:dict[@"title"]
                                                         width:self.titleWidth
                                                      fontSize:self.configure.titleFont
                                                 oneLineHeight:self.configure.oneLineHeight];
        if (self.configure.answerFrameFixedHeight && self.configure.answerFrameUseTextView == YES) {
            return title_height + self.configure.answerFrameFixedHeight + 10 + topDistance;
        }
        if ([dict[@"marked"] length] > 0) {
            CGFloat answer_width = self.view.frame.size.width - self.configure.optionSideMargin * 2;
            CGFloat answer_height = [SZQuestionItem heightForString:dict[@"marked"] width:answer_width - 10 fontSize:self.configure.optionFont oneLineHeight:self.configure.oneLineHeight];
            if (self.configure.answerFrameLimitHeight && answer_height > self.configure.answerFrameLimitHeight && self.configure.answerFrameUseTextView == YES) {
                return title_height + self.configure.answerFrameLimitHeight + 10 + topDistance;
            }
            return title_height + answer_height + 10 + topDistance;
        }
        return title_height + self.configure.oneLineHeight + topDistance;
    }
    else {
        
        CGFloat title_height = [SZQuestionItem heightForString:dict[@"title"]
                                                         width:self.titleWidth
                                                      fontSize:self.configure.titleFont
                                                 oneLineHeight:self.configure.oneLineHeight];
        CGFloat option_height = 0;
        for (NSString *str in dict[@"option"]) {
            NSString *optionString = [NSString stringWithFormat:@"M、%@", str];
            option_height += [SZQuestionItem heightForString:optionString width:self.OptionWidth fontSize:self.configure.optionFont oneLineHeight:self.configure.oneLineHeight];
        }
        return title_height + option_height + topDistance;
    }
}

#pragma mark - 懒加载

- (NSMutableArray *)arrayM {
    
    if (_arrayM == nil) {
        _arrayM = [[NSMutableArray alloc] initWithArray:self.sourceArray];
    }
    return _arrayM;
}

@end
