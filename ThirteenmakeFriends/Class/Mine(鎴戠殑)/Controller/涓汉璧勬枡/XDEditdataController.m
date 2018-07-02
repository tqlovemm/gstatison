//
//  XDEditdataController.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 16/8/24.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import "XDEditdataController.h"
#import "XDSixPhotoView.h"
#import "XDBasicInfoCell.h"
#import "XDOtherInfoCell.h"
#import "XDSelectLabelCell.h"
#import "ProfileUser.h"

#import "XDBasicDataController.h"
#import "LabelSelectViewController.h"
#import "XDLabelSelectController.h"
#import "XDMatchTendencyController.h"
#import "MBProgressHUD+MJ.h"
#import "MJExtension.h"

#import "STPickerSingle.h"
#import "NSString+HXAddtions.h"
#import "XDAccountTool.h"

#import "XDMembersAreaController.h"
#import "XDAreaModel.h"
#import "XDQRcoderController.h"
#import "XDEditInfoModel.h"

#import "XDPickerAreaView.h"

@interface XDEditdataController ()<XDSixPhotoViewDelegate,UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate,STPickerSingleDelegate,XDPickerAreaViewDelegate,LabelSelectViewControllerDelegate,XDBasicDataControllerDelegate,XDLabelSelectControllerDelegate>

/** 替换图片的位置 */
@property (nonatomic, assign) int imgTag;
/** 打开相册类型 */
@property (nonatomic, assign) int openType;

//! 六宫格
@property(strong, nonatomic) XDSixPhotoView *sixPhotoView;

@property (nonatomic ,weak) UITableView *tableView;

@property(strong, nonatomic) ProfileUser *user;

@property(strong, nonatomic) XDLabelItemFrameModel *myLabF;

@property(strong, nonatomic) XDLabelItemFrameModel *seekLabF;

@property(strong, nonatomic) XDLabelItemFrameModel *hobbyLabF;

//! 个人标签
@property (strong, nonatomic) NSArray *myLabelArray;
//! 交友要求
@property (strong, nonatomic) NSArray *friendRequestArray;
//! 兴趣爱好
@property (strong, nonatomic) NSArray *hobbyArray;

//! 地点
@property (nonatomic, weak) UITextField *areaField;
//! 情感状态
@property (nonatomic, weak) UITextField *statusField;
//! 身高
@property (nonatomic, weak) UITextField *heightField;
//! 体重
@property (nonatomic, weak) UITextField *weightField;
//! 个人签名
@property (nonatomic, weak) UITextField *signField;

/** 学历 */
@property (nonatomic, weak) UITextField *highSchoolField;
/** 职业 */
@property (nonatomic, weak) UITextField *professionalField;
/** 收入 */
@property (nonatomic, weak) UITextField *incomeField;
/** 匹配倾向 */
@property (nonatomic, weak) UITextField *tendencyField;

/** 情感状态 */
@property (nonatomic, strong) NSArray *statusArray;
/** 学历 */
@property (nonatomic, strong) NSArray *educationArray;
/** 收入 */
@property (nonatomic, strong) NSArray *incomeArray;

/** 地区数组 */
@property (nonatomic, strong) NSMutableArray *areaArray;

/** 情感状态 */
@property (nonatomic, strong) STPickerSingle *emotionSingle;
/** 学历 */
@property (nonatomic, strong) STPickerSingle *educationSingle;
/** 收入 */
@property (nonatomic, strong) STPickerSingle *incomeSingle;
/** 旋转地区的areaID */
@property (nonatomic, copy) NSString *selectAreaID;

@end

@implementation XDEditdataController

- (NSArray *)statusArray {
    if (_statusArray == nil) {
        _statusArray = @[@"单身",@"有男/女朋友",@"已婚",@"保密"];
    }
    
    return _statusArray;
}

- (NSArray *)educationArray {
    if (_educationArray == nil) {
        _educationArray = @[@"初中及以下",@"高中",@"大专",@"本科",@"研究生",@"博士及以上"];
    }
    
    return _educationArray;
}

- (NSArray *)incomeArray {
    if (_incomeArray == nil) {
        _incomeArray = @[@"10万以下",@"10-20万",@"20-50万",@"50-100万",@"100-500万",@"500万以上"];
    }
    
    return _incomeArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setEdgesForExtendedLayout:UIRectEdgeAll];
    self.view.backgroundColor = HEXCOLOR(0xf0f0f2);
    [self setupNavBar];
    [self setupProfileInfo];
    [self setupForDismissKeyboard];
}

- (void)setupProfileInfo {
    
    self.user = [XDAccountTool account];
    [self xdd_setupTableView];
    [self initPhotoView];
    
    [self setupLabelFrame];
    // 获取标签信息
    [self getMyLabelData];
    
    [self.tableView reloadData];
}

- (void)setupNavBar {
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -12;
    
    UIBarButtonItem *leftNegativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
    // leftNegativeSpacer为占位符
    leftNegativeSpacer.width = -10;
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBtn setTitle:@"保存" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(saveBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitleColor:NormalNavBtnColor forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    rightBtn.userInteractionEnabled = NO;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItems = @[leftNegativeSpacer, rightItem];
    
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        rightBtn.userInteractionEnabled = YES;
    });
}

- (void)setupLabelFrame {
    ProfileUser *user = [XDAccountTool account];
    
    XDLabelItemModel *myLab = [[XDLabelItemModel alloc] init];
    myLab.color = RGB(240, 239, 245);
    myLab.markArray = user.mark;
    
    XDLabelItemFrameModel *myLabF = [[XDLabelItemFrameModel alloc]init];
    myLabF.itemModel = myLab;
    self.myLabF = myLabF;
    
    XDLabelItemModel *seekLab = [[XDLabelItemModel alloc] init];
    seekLab.color = RGB(240, 239, 245);
    seekLab.markArray = user.make_friend;
    
    XDLabelItemFrameModel *seekLabF = [[XDLabelItemFrameModel alloc]init];
    seekLabF.itemModel = seekLab;
    self.seekLabF = seekLabF;
    
    XDLabelItemModel *hobbyLab = [[XDLabelItemModel alloc] init];
    hobbyLab.color = RGB(240, 239, 245);
    hobbyLab.markArray = user.hobby;
    
    XDLabelItemFrameModel *hobbyLabF = [[XDLabelItemFrameModel alloc]init];
    hobbyLabF.itemModel = hobbyLab;
    self.hobbyLabF = hobbyLabF;
}

-(void)initPhotoView
{
    NSArray *array = self.user.photos;
    
    NSMutableArray *imgArray = [[NSMutableArray alloc]init];
    
    for(NSString *temp in array)
    {
        [imgArray addObject:temp];
    }
    _sixPhotoView = [[XDSixPhotoView alloc]initWithData:imgArray];
    _sixPhotoView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH);
    _sixPhotoView.delegate = self;
    self.tableView.tableHeaderView = _sixPhotoView;
}

- (void)xdd_setupTableView {
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT - NavigationBar_Height) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = HEXCOLOR(0xf0f0f2);
    tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

#pragma mark -TableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 6;
    } else if (section == 2) {
        return 1;
    } else if (section == 3) {
        return 1;
    } else if (section == 4) {
        return 1;
    } else if (section == 5) {
        return 4;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 创建cell
    if (indexPath.section == 0) {
        XDBasicInfoCell *basicInfocell = [XDBasicInfoCell cellWithTableView:tableView];
        
        basicInfocell.user = self.user;
        return basicInfocell;
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            XDOtherInfoCell *otherInfocell = [XDOtherInfoCell cellWithTableView:tableView reusableCellWithIdentifier:@"XDEeditDataCell_area"];
            XDEditInfoModel *infoModel = [[XDEditInfoModel alloc] init];
            infoModel.title = @"地点";
            infoModel.placeholder = @"添加你的地址";
            infoModel.optionalType = 1;
            infoModel.text = self.areaField ? self.areaField.text : self.user.area_one;
            otherInfocell.infoModel = infoModel;
            
            self.areaField = otherInfocell.textField;
            self.areaField.delegate = self;
            return otherInfocell;
        } else if (indexPath.row == 1) {
            XDOtherInfoCell *otherInfocell = [XDOtherInfoCell cellWithTableView:tableView reusableCellWithIdentifier:@"XDEeditDataCell_emotion_status"];
            
            XDEditInfoModel *infoModel = [[XDEditInfoModel alloc] init];
            infoModel.title = @"情感状态";
            infoModel.placeholder = @"添加你的情感状态";
            infoModel.optionalType = 2;
            infoModel.text = self.statusField ? self.statusField.text : self.user.is_marry;
            otherInfocell.infoModel = infoModel;
            
            self.statusField = otherInfocell.textField;
            self.statusField.delegate = self;
            return otherInfocell;
        } else if (indexPath.row == 2) {
            XDOtherInfoCell *otherInfocell = [XDOtherInfoCell cellWithTableView:tableView reusableCellWithIdentifier:@"XDEeditDataCell_height"];
            
            XDEditInfoModel *infoModel = [[XDEditInfoModel alloc] init];
            infoModel.title = @"身高";
            infoModel.placeholder = @"添加你的身高";
            infoModel.optionalType = 1;
            if (self.heightField) {
                if ([self.heightField.text containsString:@"cm"]) {
                    infoModel.text = self.heightField.text;
                } else {
                    infoModel.text = [NSString stringWithFormat:@"%@cm",self.heightField.text];
                }
            } else {
                infoModel.text = [NSString stringWithFormat:@"%@cm",self.user.height];
            }
            otherInfocell.infoModel = infoModel;
            
            self.heightField = otherInfocell.textField;
            self.heightField.delegate = self;
            self.heightField.keyboardType = UIKeyboardTypeNumberPad;
            
            UILabel *rightLab = [[UILabel alloc]init];
            rightLab.font = k16Font;
            rightLab.textColor = HEXCOLOR(0x999999);
            rightLab.text = @"cm";
            rightLab.size = [rightLab.text sizeWithFont:k16Font];
            self.heightField.rightView = rightLab;
            self.heightField.rightViewMode = UITextFieldViewModeWhileEditing;

            return otherInfocell;
        } else if (indexPath.row == 3) {
            XDOtherInfoCell *otherInfocell = [XDOtherInfoCell cellWithTableView:tableView reusableCellWithIdentifier:@"XDEeditDataCell_weight"];
            
            XDEditInfoModel *infoModel = [[XDEditInfoModel alloc] init];
            infoModel.title = @"体重";
            infoModel.placeholder = @"添加你的体重";
            infoModel.optionalType = 1;
            if (self.weightField) {
                if ([self.weightField.text containsString:@"kg"]) {
                    infoModel.text = self.weightField.text;
                } else {
                    infoModel.text = [NSString stringWithFormat:@"%@kg",self.weightField.text];
                }
            } else {
                infoModel.text = [NSString stringWithFormat:@"%@kg",self.user.weight];
            }
            otherInfocell.infoModel = infoModel;
            
            self.weightField = otherInfocell.textField;
            self.weightField.delegate = self;
            self.weightField.keyboardType = UIKeyboardTypeNumberPad;
            
            UILabel *rightLab = [[UILabel alloc]init];
            rightLab.font = k16Font;
            rightLab.textColor = HEXCOLOR(0x999999);
            rightLab.text = @"kg";
            rightLab.size = [rightLab.text sizeWithFont:k16Font];
            self.weightField.rightView = rightLab;
            self.weightField.rightViewMode = UITextFieldViewModeWhileEditing;
            return otherInfocell;
        } else if (indexPath.row == 4) {
            XDOtherInfoCell *otherInfocell = [XDOtherInfoCell cellWithTableView:tableView reusableCellWithIdentifier:@"XDEeditDataCell_signature"];
            
            XDEditInfoModel *infoModel = [[XDEditInfoModel alloc] init];
            infoModel.title = @"个人签名";
            infoModel.placeholder = @"添加你的个人签名";
            infoModel.optionalType = 2;
            infoModel.text = self.signField ? self.signField.text : self.user.signature;
            otherInfocell.infoModel = infoModel;
            
            self.signField = otherInfocell.textField;
            return otherInfocell;
        } else {
            XDOtherInfoCell *otherInfocell = [XDOtherInfoCell cellWithTableView:tableView reusableCellWithIdentifier:@"XDEeditDataCell_wechat"];
            
            XDEditInfoModel *infoModel = [[XDEditInfoModel alloc] init];
            infoModel.title = @"我的微信号";
            infoModel.optionalType = 0;
            otherInfocell.infoModel = infoModel;
            return otherInfocell;
        }
        
    } else if (indexPath.section == 2) {
        
        XDSelectLabelCell *myLabCell = [XDSelectLabelCell cellWithTableView:tableView];
        myLabCell.itemModelFrame = self.myLabF;
        
        return myLabCell;
    } else if (indexPath.section == 3) {
        
        XDSelectLabelCell *seekLabCell = [XDSelectLabelCell cellWithTableView:tableView];
        seekLabCell.itemModelFrame = self.seekLabF;
        
        return seekLabCell;
    } else if (indexPath.section == 4) {
        
        XDSelectLabelCell *hobbyLabCell = [XDSelectLabelCell cellWithTableView:tableView];
        hobbyLabCell.itemModelFrame = self.hobbyLabF;
        
        return hobbyLabCell;
    } else if (indexPath.section == 5) {
        if (indexPath.row == 0) {
            XDOtherInfoCell *otherInfocell = [XDOtherInfoCell cellWithTableView:tableView reusableCellWithIdentifier:@"XDEeditDataCell_education"];
            XDEditInfoModel *infoModel = [[XDEditInfoModel alloc] init];
            infoModel.title = @"学历";
            infoModel.placeholder = @"选择你的学历";
            infoModel.optionalType = 2;
            infoModel.text = self.highSchoolField ? self.highSchoolField.text : [self.user getHighestEducation];
            otherInfocell.infoModel = infoModel;
            
            self.highSchoolField = otherInfocell.textField;
            self.highSchoolField.delegate = self;
            return otherInfocell;
        } else if (indexPath.row == 1) {
            XDOtherInfoCell *otherInfocell = [XDOtherInfoCell cellWithTableView:tableView reusableCellWithIdentifier:@"XDEeditDataCell_job"];
            XDEditInfoModel *infoModel = [[XDEditInfoModel alloc] init];
            infoModel.title = @"职业";
            infoModel.placeholder = @"填写你的职业";
            infoModel.optionalType = 2;
            infoModel.text = self.professionalField ? self.professionalField.text : self.user.job;
            otherInfocell.infoModel = infoModel;
            
            self.professionalField = otherInfocell.textField;
            self.professionalField.delegate = self;
            return otherInfocell;
        } else if (indexPath.row == 2) {
            XDOtherInfoCell *otherInfocell = [XDOtherInfoCell cellWithTableView:tableView reusableCellWithIdentifier:@"XDEeditDataCell_income"];
            XDEditInfoModel *infoModel = [[XDEditInfoModel alloc] init];
            infoModel.title = @"收入";
            infoModel.placeholder = @"选择你的收入";
            infoModel.optionalType = 2;
            infoModel.text = self.incomeField ? self.incomeField.text : [self.user getPersonIncome];
            otherInfocell.infoModel = infoModel;
            
            self.incomeField = otherInfocell.textField;
            self.incomeField.delegate = self;
            return otherInfocell;
        } else {
            XDOtherInfoCell *otherInfocell = [XDOtherInfoCell cellWithTableView:tableView reusableCellWithIdentifier:@"XDEeditDataCell_match_direction"];
            
            XDEditInfoModel *infoModel = [[XDEditInfoModel alloc] init];
            infoModel.title = @"匹配倾向";
            infoModel.optionalType = 1;
            otherInfocell.infoModel = infoModel;
            return otherInfocell;
        }
        
    } else {
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        XDBasicDataController *basicData = [[XDBasicDataController alloc] init];
        basicData.delegate = self;
        [self.navigationController pushViewController:basicData animated:YES];
    } else if (indexPath.section == 1) {
        if (indexPath.row == 5) {
            XDQRcoderController *codeVC = [[XDQRcoderController alloc] init];
            codeVC.weichat = self.user.wechat;
            codeVC.qrCoder = self.user.weima;
            [self.navigationController pushViewController:codeVC animated:YES];
        } else {
            XDOtherInfoCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            [cell.textField becomeFirstResponder];
        }
    } else if (indexPath.section == 2) { // 我的标签
//        LabelSelectViewController *hobbyVC = [[LabelSelectViewController alloc]init];
//        hobbyVC.delegate = self;
//        hobbyVC.title = kmyLabel;
//        hobbyVC.allLabelArray = self.myLabelArray;
//        hobbyVC.user = [[ProfileUser alloc] init];
//        hobbyVC.labelColor = HEXCOLOR(0xa5b2f2);
//        [self.navigationController pushViewController:hobbyVC animated:YES];
        
        NSMutableArray *usingArr = [NSMutableArray arrayWithArray:self.user.mark];
        NSArray *allArr = self.myLabelArray;
        
        XDLabelSelectController *slectVC = [[XDLabelSelectController alloc] initWithColumnArray:usingArr allCloumn:allArr];
        slectVC.delegate = self;
        slectVC.title = kmyLabel;
        [self.navigationController pushViewController:slectVC animated:YES];
    } else if (indexPath.section == 3) { // 觅约标签
//        LabelSelectViewController *hobbyVC = [[LabelSelectViewController alloc]init];
//        hobbyVC.title = kseekLabel;
//        hobbyVC.delegate = self;
//        hobbyVC.allLabelArray = self.friendRequestArray;
//        hobbyVC.user = [[ProfileUser alloc] init];
//        hobbyVC.labelColor = HEXCOLOR(0xf09cb5);
//        [self.navigationController pushViewController:hobbyVC animated:YES];
        NSMutableArray *usingArr = [NSMutableArray arrayWithArray:self.user.make_friend];
        NSArray *allArr = self.friendRequestArray;
        
        XDLabelSelectController *slectVC = [[XDLabelSelectController alloc] initWithColumnArray:usingArr allCloumn:allArr];
        slectVC.delegate = self;
        slectVC.title = kseekLabel;
        [self.navigationController pushViewController:slectVC animated:YES];
    } else if (indexPath.section == 4) { // 觅约标签
//        LabelSelectViewController *hobbyVC = [[LabelSelectViewController alloc]init];
//        hobbyVC.title = @"兴趣爱好";
//        hobbyVC.delegate = self;
//        hobbyVC.allLabelArray = self.hobbyArray;
//        hobbyVC.user = [[ProfileUser alloc] init];
//        hobbyVC.labelColor = HEXCOLOR(0xf09cb5);
//        [self.navigationController pushViewController:hobbyVC animated:YES];
        
        NSMutableArray *usingArr = [NSMutableArray arrayWithArray:self.user.hobby];
        NSArray *allArr = self.hobbyArray;
        
        XDLabelSelectController *slectVC = [[XDLabelSelectController alloc] initWithColumnArray:usingArr allCloumn:allArr];
        slectVC.delegate = self;
        slectVC.title = @"兴趣爱好";
        [self.navigationController pushViewController:slectVC animated:YES];
    } else {
        if (indexPath.row == 3) {
            if (self.user.area_one.length == 0) {
                [self.view makeToast:@"请先填写并保存地址" duration:2.0 position:CSToastPositionCenter];
                return;
            }
            if (self.user.birthdate.length == 0) {
                [self.view makeToast:@"请先填写并保存出生日期" duration:2.0 position:CSToastPositionCenter];
                return;
            }
            XDMatchTendencyController *codeVC = [[XDMatchTendencyController alloc] init];
            [self.navigationController pushViewController:codeVC animated:YES];
        } else {
            XDOtherInfoCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            [cell.textField becomeFirstResponder];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 80;
    } else if (indexPath.section == 1) {
        return 48;
    } else if (indexPath.section == 2) {
        return self.myLabF.cellHeight;
    } else if (indexPath.section == 3) {
        return self.seekLabF.cellHeight ;
    } else if (indexPath.section == 4) {
        return self.hobbyLabF.cellHeight ;
    } else if (indexPath.section == 5) {
        return 48;
    } else {
        return 0;
    }
}

#pragma mark - tableview 头尾
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.1;
    } else if (section == 1) {
        return 50;
    } else if (section == 2) {
        return 50;
    } else if (section == 3) {
        return 50;
    } else if (section == 4) {
        return 50;
    } else if (section == 5) {
        return 50;
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 5) {
        return 50;
    } else {
        return 0.1;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 50)];
    footerView.backgroundColor = [UIColor clearColor];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 300, 30)];
    lab.font = [UIFont systemFontOfSize:16];
    lab.textColor = HEXCOLOR(0x666666);
    [footerView addSubview:lab];
    
    if (section == 0) {
        return nil;
    } else if (section == 1) {
        lab.text = @"我的信息";
        return footerView;
    } else if (section == 2) {
        lab.text = kmyLabel;
        return footerView;
    } else if (section == 3) {
        lab.text = @"觅约标签";
        return footerView;
    } else if (section == 4) {
        lab.text = @"兴趣爱好";
        return footerView;
    } else if (section == 5) {
        lab.text = @"以下信息用于匹配，不对外开放";
        return footerView;
    } else {
        return nil;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (section == 5) {
        UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 50)];
        footerView.backgroundColor = [UIColor clearColor];
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 300, 30)];
        lab.font = [UIFont systemFontOfSize:16];
        lab.textColor = HEXCOLOR(0x666666);
        [footerView addSubview:lab];
        lab.text = @"提示：资料越详细匹配的成功率越高";
        return footerView;
    } else {
        return nil;
    }
}

#pragma mark - 标签
/**
 *  获取标签信息
 */
- (void)getMyLabelData {
    XD_WeakSelf
    [XDRequestHttpTool request_mymarkInfo_withParameters:nil complete:^(id result) {
        XD_StrongSelf
        if ([result[@"code"] integerValue] == 200) {
            self.myLabelArray = result[@"data"][@"personTags"];
            self.friendRequestArray = result[@"data"][@"likeTypeTags"];
            self.hobbyArray = result[@"data"][@"hobbyTags"];
        } else {
            [self.view makeToast:result[@"message"] duration:2.0 position:CSToastPositionCenter];
        }
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        XD_StrongSelf
        [self.view makeToast:error.localizedDescription duration:2.0 position:CSToastPositionCenter];
    }];
}

#pragma mark - 六宫格代理
-(void)OnAddPhotoPress
{
    XD_WeakSelf
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"请上传个人真实照片" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *addAction = [UIAlertAction actionWithTitle:@"添加" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        XD_StrongSelf
        self.openType = 10;
        // 打开相册
        [self openAlbum];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [controller dismissViewControllerAnimated:YES completion:nil];
    }];
    [controller addAction:addAction];
    [controller addAction:cancelAction];
    [self presentViewController:controller animated:YES completion:nil];
}

-(void)OnDeletePhotoPress : (NSInteger)tag
{
    XD_WeakSelf
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"请上传个人真实照片" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *replaceAction = [UIAlertAction actionWithTitle:@"替换" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        XD_StrongSelf
        
        self.openType = 11;
        // 打开相册
        [self openAlbum];
        self.imgTag = (int)tag;
    }];
    [controller addAction:replaceAction];
    
    if([[_sixPhotoView getNewOrder] count] > 1)
    {
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            XD_StrongSelf
            [self.sixPhotoView deleteImage:(int)tag];
            
        }];
        [controller addAction:deleteAction];
    }
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [controller dismissViewControllerAnimated:YES completion:nil];
    }];
    [controller addAction:cancelAction];
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark - 打开相册
- (void)openAlbum {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) return;
    
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    // 接管控制状态栏的外观
    ipc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    ipc.navigationBar.translucent = NO;
    ipc.allowsEditing = YES;
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // 1.取出选中的图片
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    if (_openType == 11) {
        [_sixPhotoView replaceImage:image tag:self.imgTag];
    } else if (_openType == 10) {
        [_sixPhotoView addImage:image];
    }
}

#pragma mark - 保存
- (void)saveBtnClicked:(UIButton *)btn {
    // 关闭键盘
    [self.view endEditing:YES];
    
    [self sendEditData];
    
}

/**
 *  编辑资料
 */
- (void)sendEditData {
    NSLog(@"保存资料");
    
    [self showHudInView:self.navigationController.view hint:@"保存中..."];
    
    NSArray *imgArr = [_sixPhotoView getNewOrder];
    
    NSMutableString *imageStr = [NSMutableString string];
    for (int i = 0; i < imgArr.count; i ++) {
        UIImage *image = imgArr[i];
        NSData *data = [image wxImageSize:image];
        
        NSString *dataStr = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
        
        [imageStr appendString:dataStr];
        if (i != (imgArr.count - 1)) {
            [imageStr appendString:@"&"];
        }
    }
    
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    
    if (self.selectAreaID) {
        paras[@"area_one"] = self.selectAreaID;
    } else {
        paras[@"area_one"] = nil;
    }
    
    paras[@"img_url"] = imageStr;
    paras[@"height"] = [self.heightField.text stringByReplacingOccurrencesOfString:@"cm" withString:@""];
    paras[@"weight"] = [self.weightField.text stringByReplacingOccurrencesOfString:@"kg" withString:@""];
    paras[@"signature"] = self.signField.text;
    if (self.statusField.text.length > 0) {
        NSInteger marry_select = [self.statusArray indexOfObject:self.statusField.text];
        paras[@"marry"] = [NSString stringWithFormat:@"%ld",marry_select];
    }
    if (self.highSchoolField.text.length > 0) {
        NSInteger education_select = [self.educationArray indexOfObject:self.highSchoolField.text];
        paras[@"education"] = [NSString stringWithFormat:@"%ld",education_select + 1];
    }
    if (self.incomeField.text.length > 0) {
        NSInteger income_select = [self.incomeArray indexOfObject:self.incomeField.text];
        paras[@"annual_salary"] = [NSString stringWithFormat:@"%ld",income_select + 1];
    }
    paras[@"job"] = self.professionalField.text;
    
    // 公钥加密
    NSString *encryWithPublicKeyStr = [RSAUtil encryptString:[NSString stringWithFormat:@"%@",User_ID] publicKey:kRSA_Public_key];
    ProfileUser *user = [[ProfileUser alloc] init];
    
    XD_WeakSelf
    [FKL_DataService requestURL:[NSString url_editPersonInfo_withNumber:user.thirteen_platform_number] parameters:paras headerKey:@"sign" headerValue:encryWithPublicKeyStr withType:@"PATCH" format:@"JSON" complete:^(id result) {
        XD_StrongSelf
        [self hideHud];
        if ([result[@"code"] intValue] == 200) {
            [MBProgressHUD showSuccess:@"保存成功"];
            
            self.user.photos = result[@"data"];
            self.user.area_one = self.areaField.text;
            self.user.height = [self.heightField.text stringByReplacingOccurrencesOfString:@"cm" withString:@""];
            self.user.weight = [self.weightField.text stringByReplacingOccurrencesOfString:@"kg" withString:@""];
            self.user.signature = self.signField.text;
            self.user.is_marry = self.statusField.text;
            
            [XDAccountTool save:self.user];
            
            [self.navigationController popViewControllerAnimated:YES];
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self.view makeToast:result[@"message"] duration:2.0 position:CSToastPositionCenter];
        }
        
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        XD_StrongSelf
        [self.view makeToast:error.localizedDescription duration:2.0 position:CSToastPositionCenter];
        [self hideHud];
    }];
}

#pragma mark - UITextFieldDelegate 
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if ([textField isEqual:self.areaField]) {
        [self.view endEditing:YES];
        if (self.user.area_one.length > 0) {
            XDMembersAreaController *areaVC = [[XDMembersAreaController alloc] init];
            areaVC.areaSelectViewClickedBlock = ^(NSString *areaStr, NSString *areaID) {
                self.areaField.text = areaStr;
                self.selectAreaID = areaID;
            };
            [self.navigationController pushViewController:areaVC animated:YES];
            
        } else {
            [self getAreaList];
        }
        return NO;
    } else if ([textField isEqual:self.statusField]) {
        [self.view endEditing:YES];
        STPickerSingle *single = [[STPickerSingle alloc]init];
        [single setArrayData:(NSMutableArray *)self.statusArray];
        [single setTitle:@"请选择情感状态"];
        [single setTitleUnit:@""];
        [single setDelegate:self];
        [single show];
        self.emotionSingle = single;
        return NO;
    } else if ([textField isEqual:self.highSchoolField]) {
        [self.view endEditing:YES];
        STPickerSingle *single = [[STPickerSingle alloc]init];
        [single setArrayData:(NSMutableArray *)self.educationArray];
        [single setTitle:@"请选择你的学历"];
        [single setTitleUnit:@""];
        [single setDelegate:self];
        [single show];
        self.educationSingle = single;
        return NO;
    } else if ([textField isEqual:self.incomeField]) {
        [self.view endEditing:YES];
        STPickerSingle *single = [[STPickerSingle alloc]init];
        [single setArrayData:(NSMutableArray *)self.incomeArray];
        [single setTitle:@"请选择你的收入"];
        [single setTitleUnit:@""];
        [single setDelegate:self];
        [single show];
        self.incomeSingle = single;
        return NO;
    } else if ([textField isEqual:self.heightField]){
        self.heightField.text = [self.heightField.text stringByReplacingOccurrencesOfString:@"cm" withString:@""];
        return YES;
    } else if ([textField isEqual:self.weightField]){
        self.weightField.text = [self.weightField.text stringByReplacingOccurrencesOfString:@"kg" withString:@""];
        return YES;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([textField isEqual:self.heightField]){
        self.heightField.text = [self.heightField.text stringByAppendingString:@"cm"];
    } else if ([textField isEqual:self.weightField]){
        self.weightField.text = [self.weightField.text stringByAppendingString:@"kg"];
    }
}

#pragma mark - STPickerSingleDelegate
- (void)pickerSingle:(STPickerSingle *)pickerSingle selectedTitle:(NSString *)selectedTitle
{
    if ([pickerSingle isEqual:self.emotionSingle]) {
        NSString *text = [NSString stringWithFormat:@"%@", selectedTitle];
        self.statusField.text = text;
    } else if ([pickerSingle isEqual:self.educationSingle]){
        NSString *text = [NSString stringWithFormat:@"%@", selectedTitle];
        self.highSchoolField.text = text;
    } else if ([pickerSingle isEqual:self.incomeSingle]){
        NSString *text = [NSString stringWithFormat:@"%@", selectedTitle];
        self.incomeField.text = text;
    }
}

#pragma mark - XDPickerAreaView delegate
- (void)pickerArea:(XDPickerAreaView *)pickerArea province:(NSString *)province city:(NSString *)city areeID:(NSString *)areeID {
    NSString *text = @"";
    if (city.length > 0) {
        text = [NSString stringWithFormat:@"%@ %@", province,city];
    } else {
        text = [NSString stringWithFormat:@"%@", province];
    }
    self.areaField.text = text;
    self.selectAreaID = areeID;
}

#pragma mark - LabelSelectViewControllerDelegate
- (void)labelCountChanged {
    
    [self setupLabelFrame];
    [self.tableView reloadData];
}

- (void)labelSelectDone:(NSString *)title usingArray:(NSArray *)usingArray {
    NSString *jsonStr = [NSString jsonStringWithArray:usingArray];
    
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    if ([title isEqualToString:kmyLabel]) {
        paras[@"mark"] = jsonStr;
    } else if ([title isEqualToString:kseekLabel]) {
        paras[@"make_friend"] = jsonStr;
    } else if ([title isEqualToString:@"兴趣爱好"]) {
        paras[@"hobby"] = jsonStr;
    } else {
        NSLog(@"标签选择超出范围    ");
        return;
    }
    
    // 公钥加密
    NSString *encryWithPublicKeyStr = [RSAUtil encryptString:[NSString stringWithFormat:@"%@",User_ID] publicKey:kRSA_Public_key];
    
    [FKL_DataService requestURL:[NSString url_changeLabelInfo_withNumber:self.user.thirteen_platform_number] parameters:paras headerKey:@"sign" headerValue:encryWithPublicKeyStr withType:@"PATCH" format:@"JSON" complete:^(id result) {
        
        if ([result[@"code"] integerValue] == 200) {
            [MBProgressHUD showSuccess:@"更改成功！" toView:nil];
            if ([title isEqualToString:kmyLabel]) {
                self.user.mark = usingArray;
            } else if ([title isEqualToString:kseekLabel]) {
                self.user.make_friend = usingArray;
            } else if ([title isEqualToString:@"兴趣爱好"]) {
                self.user.hobby = usingArray;
            } else {
                NSLog(@"标签选择超出范围    ");
            }
            [XDAccountTool save:self.user];
            
            [self setupLabelFrame];
            [self.tableView reloadData];
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

#pragma mark - XDBasicDataControllerDelegate

- (void)basicInfoChanged {
    [self.tableView reloadData];
}

#pragma mark - 获取地址
- (void)getAreaList {
    [self showHudInView:self.view hint:@""];
    
    self.areaArray = [NSMutableArray array];
    
    [FKL_DataService requestURL:[NSString url_getAreaList] parameters:nil withType:@"GET" format:@"JSON" complete:^(id result) {
        [self hideHud];
        if ([result[@"code"] integerValue] == 200) {
            self.areaArray = [NSMutableArray arrayWithArray:[XDAreaModel objectArrayWithKeyValuesArray:result[@"data"]]];
            
            [self.view endEditing:YES];
            
            XDPickerAreaView *areaView = [[XDPickerAreaView alloc] initWithArrayData:self.areaArray delegate:self];
            [areaView show];
            
        } else {
            [self.view makeToast:result[@"message"] duration:2.0 position:CSToastPositionCenter];
        }
        
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideHud];
        [self.view makeToast:error.localizedDescription duration:2.0 position:CSToastPositionCenter];
    }];
}

@end
