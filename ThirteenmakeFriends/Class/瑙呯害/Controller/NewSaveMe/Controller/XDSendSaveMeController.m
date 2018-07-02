//
//  XDSendSaveMeController.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2018/1/5.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import "XDSendSaveMeController.h"
#import "TZImagePickerController.h"

#import "XDCollectionViewFlowLayout.h"
#import "XDSendSaveMeInfoCell.h"
#import "XDSendSaveMeTextCell.h"
//#import "PostImageCollectionViewCell.h"
#import "XDSendSaveMeTipCell.h"
//#import "XDPhotoBrowser.h"
#import "ICEPhotoBrowser.h"
#import "STPickerSingle.h"
#import "ICEDatePicker.h"
#import "XDPickerAreaView.h"
#import "XDAreaModel.h"
#import "UIPlaceHolderTextView.h"
#import "XDPayCoinView.h"

#define CollectionCellPadding  10 //section 4 内的collection 上下左右间距都为10
#define ItemSpacing            0 //item间距
#define LineSpacing            10 //行间距

@interface XDSendSaveMeController ()<UICollectionViewDataSource,UICollectionViewDelegate,TZImagePickerControllerDelegate,STPickerSingleDelegate,ICEPickerDateDelegate,XDPickerAreaViewDelegate,XDPayCoinViewDelegate,XDCollectionViewDelegateFlowLayout>

@property (nonatomic, strong) XDCollectionViewFlowLayout *layout;
@property (strong, nonatomic) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *imagesArray;
@property (nonatomic, strong) NSMutableArray *assetsArray;

/** 地区数组 */
@property (nonatomic, strong) NSMutableArray *areaArray;
/** 活动数组 */
@property (nonatomic, strong) NSMutableArray *activityArray;
/** 截止时间 */
@property (nonatomic, assign) NSInteger end_time;
/** 截止时间str */
@property (nonatomic, copy) NSString *select_endTime;
/** 选中地区id */
@property (nonatomic, copy) NSString *select_AreaID;
/** 选中地区 */
@property (nonatomic, copy) NSString *select_Area;
/** 选中活动 */
@property (nonatomic, copy) NSString *select_activity;
/** 发布所需价格 */
@property (nonatomic, assign) NSInteger pay_coin;

@property (nonatomic, strong) TZImagePickerController *imagePickerVc;

/** 支付心动币view */
@property (nonatomic ,strong) XDPayCoinView *seekPayView;

@end

@implementation XDSendSaveMeController

- (NSMutableArray *)imagesArray{
    if (!_imagesArray) {
        _imagesArray = [NSMutableArray array];
    }
    return _imagesArray;
}

- (NSMutableArray *)assetsArray{
    if (!_assetsArray) {
        _assetsArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _assetsArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"发布救我";
    [self setupNavBar];
    [self configViews];
    [self setupAreaInfo];
    
    [self setupForDismissKeyboard];
}

/**
 *  设置导航条内容
 */
- (void)setupNavBar
{
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    [leftButton setTitleColor:NormalNavBtnColor forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -12;
    self.navigationItem.leftBarButtonItems = @[negativeSpacer, leftItem];
    
    UIButton *saveButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton setTitleColor:ThemeColor1 forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithCustomView:saveButton];
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, saveItem];
    
}

#pragma mark - Action
- (void)cancel:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doneAction:(UIButton *)sender {
    [self.view endEditing:YES];
    
    if (![self isEmpty]) {
        self.seekPayView            = [[XDPayCoinView alloc] initWithFrame:[[UIApplication sharedApplication].keyWindow bounds]];
        self.seekPayView.delegate   = self;
        self.seekPayView.price      = [NSString stringWithFormat:@"%ld",self.pay_coin];
        self.seekPayView.noticeType = SaveMeNotice;
        [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:self.seekPayView];
        [self.seekPayView startAnim];
    }
}

- (void)entryPay {
    
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"end_time"] = @(self.end_time);
    paras[@"area_one"] = self.select_AreaID;
    paras[@"activity_type"] = self.select_activity;
    
    XDSendSaveMeTextCell *cell = (XDSendSaveMeTextCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
    NSString *text = cell.textView.txtView.text;
    
    paras[@"hope_require"] = text;
    
    NSMutableString *imageStr = [NSMutableString string];
    
    for (UIImage *image in self.imagesArray) {
        NSData *data = [image wxImageSize:image];
        
        NSString *dataStr = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
        
        [imageStr appendString:dataStr];
        [imageStr appendString:@"&"];
    }
    if (self.imagesArray.count > 0) {
        NSUInteger location = [imageStr length]-1;
        NSRange range = NSMakeRange(location, 1);
        [imageStr replaceCharactersInRange:range withString:@""];
    }
    paras[@"photos"] = imageStr;
    // 公钥加密
    NSString *encryWithPublicKeyStr = [RSAUtil encryptString:[NSString stringWithFormat:@"%@",User_ID] publicKey:kRSA_Public_key];
    [FKL_DataService requestURL:[NSString url_SendNewSaveme] parameters:paras headerKey:@"sign" headerValue:encryWithPublicKeyStr withType:@"POST" format:@"JSON" complete:^(id result) {
        [self hideHud];
        if ([result[@"code"] integerValue] == 200) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:result[@"message"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            [self.view makeToast:result[@"message"]
                        duration:2.0
                        position:CSToastPositionCenter];
        }
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideHud];
        [self.view makeToast:error.localizedDescription
                    duration:2.0
                    position:CSToastPositionCenter];
    }];
}

//判断账号和密码是否为空
- (BOOL)isEmpty{
    
    BOOL ret = NO;
    NSString *select_activity = self.select_activity;
    NSString *select_AreaID = self.select_AreaID;
    NSInteger end_time = self.end_time;
    NSInteger img_count = self.imagesArray.count;
    
    XDSendSaveMeTextCell *cell = (XDSendSaveMeTextCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
    NSString *text = cell.textView.txtView.text;
    
    if (select_activity.length == 0 || select_AreaID.length == 0 || end_time == 0 || img_count == 0 || text.length == 0) {
        ret = YES;
        [self.view makeToast:@"所有信息均不能为空" duration:2.0 position:CSToastPositionCenter];
    }
    
    return ret;
}

#pragma mark - 获取活动信息
/**
 *  获取地区信息
 */
- (void)setupAreaInfo {
    
    [self showHudInView:self.view hint:nil];
    
    self.areaArray = [NSMutableArray array];
    self.activityArray = [NSMutableArray array];
    
    // 公钥加密
    NSString *encryWithPublicKeyStr = [RSAUtil encryptString:[NSString stringWithFormat:@"%@",User_ID] publicKey:kRSA_Public_key];
    [FKL_DataService requestURL:[NSString url_getSendNewSaveme_info] parameters:nil headerKey:@"sign" headerValue:encryWithPublicKeyStr withType:@"GET" format:@"JSON" complete:^(id result) {
        [self hideHud];
        if ([result[@"code"] integerValue] == 200) {
            self.areaArray = [NSMutableArray arrayWithArray:[XDAreaModel objectArrayWithKeyValuesArray:result[@"data"][@"area_list"]]];
            self.activityArray = [NSMutableArray arrayWithArray:result[@"data"][@"activity_type"]];
            self.pay_coin = [result[@"data"][@"coin"] integerValue];
        } else {
            [self.view makeToast:result[@"message"]
                        duration:2.0
                        position:CSToastPositionCenter];
        }
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideHud];
        [self.view makeToast:error.localizedDescription
                    duration:2.0
                    position:CSToastPositionCenter];
        
    }];
}

- (void)configViews {
    self.layout = [[XDCollectionViewFlowLayout alloc] init];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:self.layout];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    self.collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    self.collectionView.backgroundColor = DefaultColor_BG_gray;
    [self.collectionView registerClass:[XDSendSaveMeInfoCell class] forCellWithReuseIdentifier:@"XDSendSaveMeInfoCellID"];
    //文字框
    [self.collectionView registerClass:[XDSendSaveMeTextCell class] forCellWithReuseIdentifier:@"XDSendSaveMeTextCellID"];
    //图片框
    [self.collectionView registerNib:[UINib nibWithNibName:@"PostImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"PostImageCollectionViewCell"];
    //提示框
    [self.collectionView registerClass:[XDSendSaveMeTipCell class] forCellWithReuseIdentifier:@"XDSendSaveMeTipCellID"];
}

#pragma mark - layout
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 6;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count;
    switch (section) {
        case 0:
            count = 1;
            break;
        case 1:
            count = 1;
            break;
        case 2:
            count = 1;
            break;
        case 3:
            count = 1;
            break;
        case 4:
            if (self.imagesArray.count == 0) count = 1;
            else if (self.imagesArray.count == 3) count = 3;
            else count = self.imagesArray.count + 1;
            break;
        case 5:
            count = 1;
            break;
        default:
            count = 0;
            break;
    }
    return count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size;
    if (indexPath.section == 3) {
        size = CGSizeMake(SCREEN_WIDTH, 90);
    } else if (indexPath.section == 4) {
        size = CGSizeMake(90,90);
    } else if (indexPath.section == 5) {
        size = CGSizeMake(SCREEN_WIDTH, 30);
    }else {
        size = CGSizeMake(SCREEN_WIDTH, 50);
    }
    return size;
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 4) {
        return UIEdgeInsetsMake(CollectionCellPadding, CollectionCellPadding, CollectionCellPadding, CollectionCellPadding);
    }
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//行间距间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return LineSpacing;
}

//每个item之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    if (section == 4) {
        return 10;
    } else {
        return ItemSpacing;
    }
}

#pragma mmark -
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == 0) {
//        XDSendSaveMeInfoCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"XDSendSaveMeInfoCellID" forIndexPath:indexPath];
//        cell.nameLabel.text = @"选择活动";
//        cell.iconView.image = [UIImage imageNamed:@"new_saveme_activity"];
//        cell.contentLabel.text = self.select_activity ? self.select_activity : @"请选择活动类型";
//        return cell;
//
//    } else if (indexPath.section == 1){
//        XDSendSaveMeInfoCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"XDSendSaveMeInfoCellID" forIndexPath:indexPath];
//        cell.nameLabel.text = @"地点";
//        cell.iconView.image = [UIImage imageNamed:@"new_saveme_address"];
//        cell.contentLabel.text = self.select_AreaID ? self.select_Area : @"请选择地区";
//        return cell;
//    } else if (indexPath.section == 2){
//        XDSendSaveMeInfoCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"XDSendSaveMeInfoCellID" forIndexPath:indexPath];
//        cell.nameLabel.text = @"截止时间";
//        cell.iconView.image = [UIImage imageNamed:@"time_thread"];
//        cell.contentLabel.text = self.select_endTime ? self.select_endTime : @"请选择截止时间";
//        return cell;
//    } else if (indexPath.section == 3) {
//        XDSendSaveMeTextCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XDSendSaveMeTextCellID" forIndexPath:indexPath];
//        return cell;
//    } else if (indexPath.section == 4) {
//
//        PostImageCollect ionViewCell *cell = (PostImageCollectionViewCell *)[collectionView  dequeueReusableCellWithReuseIdentifier:@"PostImageCollectionViewCell" forIndexPath:indexPath];
//        cell.backgroundColor = [UIColor whiteColor];
//        cell.tag             = indexPath.row;
//
//        cell.imgViewPic.layer.masksToBounds  = YES;
//        cell.imgViewPic.layer.cornerRadius   = 5;
//
//        WEAKSELF
//        cell.cancleBlock = ^(){
//            [weakSelf.imagesArray removeObjectAtIndex:indexPath.row];
//            [weakSelf.assetsArray removeObjectAtIndex:indexPath.row];
//            [weakSelf.collectionView reloadData];
//        };
        
        //数据源为0 默认一个加号cell
        //数据源为3 无操作
//        if (self.imagesArray.count == 0)
//            [self changeCellStyle:cell withBool:YES AtIndexPath:indexPath];
//        else if(self.imagesArray.count == 3)
//            [self changeCellStyle:cell withBool:NO AtIndexPath:indexPath];
//        else {
            //数据源为其他的时候
            //等于个数的时候显示加号
            //不等于的时候显示图片
//            if (indexPath.row == self.imagesArray.count)
//                [self changeCellStyle:cell withBool:YES AtIndexPath:indexPath];
//            else
//                [self changeCellStyle:cell withBool:NO AtIndexPath:indexPath];
//        }
//        return cell;
//    } else if (indexPath.section == 5) {
//        XDSendSaveMeTipCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XDSendSaveMeTipCellID" forIndexPath:indexPath];
//        return cell;
//    }
//    return nil;
//}


#pragma mark - 设置每个secion背景色
- (UIColor *)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout backgroundColorForSection:(NSInteger)section {
    return [@[
              [UIColor whiteColor],
              [UIColor whiteColor],
              [UIColor whiteColor],
              [UIColor whiteColor],
              [UIColor whiteColor],
              [UIColor whiteColor]
              ] objectAtIndex:section];
}

#pragma mark - 点击某个item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
    if (indexPath.section == 4) {
        if (indexPath.row == self.imagesArray.count && self.imagesArray.count != 3) {
            //点击加号
            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:3 delegate:self];
            if (self.imagesArray.count != 0) {
                imagePickerVc.selectedAssets = self.assetsArray;
            }
            imagePickerVc.maxImagesCount            = 3;
            imagePickerVc.allowPickingVideo         = NO;
            imagePickerVc.allowTakePicture          = NO;
            imagePickerVc.doneBtnTitleStr           = @"确定";
            imagePickerVc.allowPickingImage         = YES;
            imagePickerVc.allowPickingOriginalPhoto = NO;
            imagePickerVc.isSelectOriginalPhoto     = YES;
            imagePickerVc.autoDismiss               = NO;
            self.imagePickerVc = imagePickerVc;
            XD_WeakSelf
            [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                XD_StrongSelf                
                [self.imagesArray removeAllObjects];
                [self.assetsArray removeAllObjects];
                [self.assetsArray addObjectsFromArray:assets];
                [self.imagesArray addObjectsFromArray:photos];
                
                [self.collectionView reloadData];
                [self.imagePickerVc dismissViewControllerAnimated:YES completion:nil];
                
            }];
            [imagePickerVc setImagePickerControllerDidCancelHandle:^{
                [self.imagePickerVc dismissViewControllerAnimated:YES completion:nil];
            }];
            [self presentViewController:imagePickerVc animated:YES completion:nil];
        }
        else {
//            PostImageCollectionViewCell *cell = (PostImageCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"PostImageCollectionViewCell" forIndexPath:indexPath];
//            [[XDPhotoBrowser defaultManager] showBrowserWithImages:self.imagesArray andCurrentIndex:indexPath.row fromImageContainer:cell];
            ICEPhotoBrowser *photoBrowser = [ICEPhotoBrowser defaultManager];
            photoBrowser.superVC = self;
            [photoBrowser showBrowserWithImages:self.imagesArray andCurrentIndex:indexPath.row];
            
        }
    } else if (indexPath.section == 0) {
        if (self.activityArray.count == 0) {
            [self.view makeToast:@"活动信息获取失败，请重试"
                        duration:2.0
                        position:CSToastPositionCenter];
            [self setupAreaInfo];
            return ;
        }
        
        STPickerSingle *single = [[STPickerSingle alloc]init];
        [single setArrayData:self.activityArray];
        [single setTitle:@"请选择性别"];
        [single setTitleUnit:@""];
        [single setDelegate:self];
        [single show];
        
    } else if (indexPath.section == 1) {
        if (self.areaArray.count == 0) {
            [self.view makeToast:@"地区信息获取失败，请重试"
                        duration:2.0
                        position:CSToastPositionCenter];
            [self setupAreaInfo];
            return ;
        }
        
        XDPickerAreaView *areaView = [[XDPickerAreaView alloc] initWithArrayData:self.areaArray delegate:self];
        [areaView show];
    } else if (indexPath.section == 2) {
        ICEDatePicker *picker = [[ICEDatePicker alloc]initWithDelegate:self];
        [picker show];
    }
}

#pragma mark - XDPickerAreaViewDelegate
- (void)pickerArea:(XDPickerAreaView *)pickerArea province:(NSString *)province city:(NSString *)city areeID:(NSString *)areeID {
    NSString *text = @"";
    if (city.length > 0) {
        text = [NSString stringWithFormat:@"%@ %@", province,city];
    } else {
        text = [NSString stringWithFormat:@"%@", province];
    }
    
    self.select_Area = text;
    self.select_AreaID = areeID;
    
    XDSendSaveMeInfoCell *cell = (XDSendSaveMeInfoCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    cell.contentLabel.text = text;
}

#pragma mark - ICEPickerDate-Delegate
- (void)pickerDate:(ICEDatePicker *)pickerDate withDate:(nonnull NSString *)strData WithTimeStamp:(nonnull NSString *)timeStamp {
    self.end_time = [timeStamp integerValue];
    self.select_endTime = strData;
    
    XDSendSaveMeInfoCell *cell = (XDSendSaveMeInfoCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    cell.contentLabel.text = strData;
}

#pragma mark - STPickerSingleDelegate
- (void)pickerSingle:(STPickerSingle *)pickerSingle selectedTitle:(NSString *)selectedTitle {
    self.select_activity = selectedTitle;
    XDSendSaveMeInfoCell *cell = (XDSendSaveMeInfoCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.contentLabel.text = selectedTitle;
}

@end
