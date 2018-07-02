
//
//  XDNewReportViewController.m
//  ThirteenmakeFriends
//
//  Created by 空谷凌虚 on 2018/5/10.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import "XDNewReportViewController.h"

#import "TZImagePickerController.h"

#import "XDCollectionViewFlowLayout.h"
#import "XDNewReportCollectionViewCell.h"
#import "XDSendSaveMeInfoCell.h"
#import "XDSendSaveMeTextCell.h"
#import "PostImageCollectionViewCell.h"

//#import "XDPhotoBrowser.h"
#import "ICEPhotoBrowser.h"

#import "UIPlaceHolderTextView.h"
#import "MBProgressHUD+MJ.h"

#import "XDNRContentCollectionViewCell.h"
#import "XDNRHeaderCollectionViewCell.h"
#import "XDNRFooterCollectionViewCell.h"

#import "XDReportPostModel.h"




#define CollectionCellPadding  10 //section 3 内的collection 上下左右间距都为10
#define ItemSpacing            0 //item间距
#define LineSpacing            10 //行间距

@interface XDNewReportViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,TZImagePickerControllerDelegate,XDCollectionViewDelegateFlowLayout>

@property (nonatomic, strong) XDCollectionViewFlowLayout *layout;
@property (strong, nonatomic) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *imagesArray;
@property (nonatomic, strong) NSMutableArray *assetsArray;

@property (copy, nonatomic) NSString *selectTitle;
@property (strong, nonatomic) NSArray * reportsArray;

@property (nonatomic, strong) TZImagePickerController *imagePickerVc;

@property (strong, nonatomic) XDReportPostModel *reportModel;

@end

@implementation XDNewReportViewController

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
    self.title = @"举报";
    
    [self configViews];
  
    [self setupForDismissKeyboard];
    
    [self requestData];
}

- (void)requestData {
    
    [self showHudInView:self.view hint:@"加载中..."];
    
    [FKL_DataService requestURL:[NSString url_getThreadReportchioce] parameters:nil withType:@"GET" format:@"JSON" complete:^(id result) {
        [self hideHud];
        if ([result[@"code"] integerValue] == 200) {
            self.reportsArray = [XDReportPostModel objectArrayWithKeyValuesArray:result[@"data"]];


            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
        } else {
            [self.view makeToast:result[@"message"] duration:2.0 position:CSToastPositionCenter];
        }
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideHud];
        NSLog(@"%@",error);
        [self.view makeToast:error.localizedDescription duration:2.0 position:CSToastPositionCenter];
    }];
}

- (void)reportAction {
    
    if (self.reportModel == nil) {
        [MBProgressHUD showError:@"请选择举报的内容"];
        return;
    }
    
    [self showHudInView:self.view hint:@"举报中..."];
    
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"user_id"] = self.user_id;
    paras[@"wid"] = self.thread_id;
    paras[@"report_id"] = @(self.reportModel.report_id);
    
    XDSendSaveMeTextCell *cell = (XDSendSaveMeTextCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    NSString *text = cell.textView.txtView.text;
    paras[@"reason"] = text;
    NSMutableString *imageStr = [NSMutableString string];
    
    for (UIImage *image in self.imagesArray) {
        NSData *data = [image wxImageSize:image];
        NSString *dataStr = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
        [imageStr appendString:dataStr];
        [imageStr appendString:@"@"];
    }
    if (self.imagesArray.count > 0) {
        NSUInteger location = [imageStr length]-1;
        NSRange range = NSMakeRange(location, 1);
        [imageStr replaceCharactersInRange:range withString:@""];
    }
    paras[@"base64ImageString"] = imageStr;
    
    // 公钥加密
    NSString *encryWithPublicKeyStr = [RSAUtil encryptString:[NSString stringWithFormat:@"%@",User_ID] publicKey:kRSA_Public_key];
    [FKL_DataService requestURL:[NSString url_postThreadReport] parameters:paras headerKey:@"sign" headerValue:encryWithPublicKeyStr withType:@"POST" format:@"JSON" complete:^(id result) {
        [self hideHud];
        if ([result[@"code"] integerValue] == 200) {
            [MBProgressHUD showSuccess:@"举报成功" toView:nil];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self.view makeToast:result[@"message"] duration:2.0 position:CSToastPositionCenter];
        }
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideHud];
        NSLog(@"%@",error);
        [self.view makeToast:error.localizedDescription duration:2.0 position:CSToastPositionCenter];
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
    

    [self.collectionView registerNib:[UINib nibWithNibName:@"XDNRContentCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"XDNRContentCollectionViewCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"XDNRHeaderCollectionViewCell" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"XDNRHeaderCollectionViewCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"XDNRFooterCollectionViewCell" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"XDNRFooterCollectionViewCell"];
    
    [self.collectionView registerClass:[XDNewReportCollectionViewCell class] forCellWithReuseIdentifier:@"XDNewReportCollectionViewCell"];
    
    
//    [self.collectionView registerClass:[XDSendSaveMeInfoCell class] forCellWithReuseIdentifier:@"XDSendSaveMeInfoCellID"];

    //文字框
    [self.collectionView registerClass:[XDSendSaveMeTextCell class] forCellWithReuseIdentifier:@"XDSendSaveMeTextCellID"];
    //图片框
    [self.collectionView registerNib:[UINib nibWithNibName:@"PostImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"PostImageCollectionViewCell"];
    
}

#pragma mark - layout
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count;
    switch (section) {
        case 0:
            count = self.reportsArray.count;
            break;
        case 1:
            count = 1;
            break;
        case 2:
            if (self.imagesArray.count == 0) count = 1;
            else if (self.imagesArray.count == 3) count = 3;
            else count = self.imagesArray.count + 1;
            break;
            
        default:
            count = 0;
            break;
    }
    return count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        return CGSizeMake(SCREEN_WIDTH, 30);
    }
    return CGSizeZero;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == 2) {
        return CGSizeMake(SCREEN_WIDTH, 80);
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size;
    if (indexPath.section == 1) {
        size = CGSizeMake(SCREEN_WIDTH, 90);
    } else if (indexPath.section == 2) {
        size = CGSizeMake(90,90);
    } else {
        size = CGSizeMake(SCREEN_WIDTH, 44);
    }
    return size;
}



//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 2) {
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
    if (section == 2) {
        return 10;
    } else {
        return ItemSpacing;
    }
}

#pragma mmark -
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        XDNRContentCollectionViewCell *cell  = (XDNRContentCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"XDNRContentCollectionViewCell" forIndexPath:indexPath];
         XDReportPostModel *model = self.reportsArray[indexPath.row];
        cell.selectBtn.selected = [self.reportModel isEqual:model]?YES:NO;
        cell.nameLab.text = model.content;
        cell.lineView.hidden = indexPath.row+1 == self.reportsArray.count?YES:NO;
        return cell;
        
    }  else if (indexPath.section == 1) {
        XDSendSaveMeTextCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XDSendSaveMeTextCellID" forIndexPath:indexPath];
        return cell;
    } else if (indexPath.section == 2) {
        
        PostImageCollectionViewCell *cell = (PostImageCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"PostImageCollectionViewCell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        cell.tag             = indexPath.row;
        
        cell.imgViewPic.layer.masksToBounds  = YES;
        cell.imgViewPic.layer.cornerRadius   = 5;
        
        WEAKSELF
        cell.cancleBlock = ^(){
            [weakSelf.imagesArray removeObjectAtIndex:indexPath.row];
            [weakSelf.assetsArray removeObjectAtIndex:indexPath.row];
            [weakSelf.collectionView reloadData];
        };
        
        //数据源为0 默认一个加号cell
        //数据源为3 无操作
        if (self.imagesArray.count == 0)
            [self changeCellStyle:cell withBool:YES AtIndexPath:indexPath];
        else if(self.imagesArray.count == 3)
            [self changeCellStyle:cell withBool:NO AtIndexPath:indexPath];
        else {
            //数据源为其他的时候
            //等于个数的时候显示加号
            //不等于的时候显示图片
            if (indexPath.row == self.imagesArray.count)
                [self changeCellStyle:cell withBool:YES AtIndexPath:indexPath];
            else
                [self changeCellStyle:cell withBool:NO AtIndexPath:indexPath];
        }
        return cell;
    }
    return nil;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableview = nil;
    if(indexPath.section== 0 || indexPath.section== 1){
        if(kind == UICollectionElementKindSectionHeader){
            XDNRHeaderCollectionViewCell *headerView=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"XDNRHeaderCollectionViewCell" forIndexPath:indexPath];
            headerView.titlelab.text = indexPath.section== 0?@"选择举报原因:":@"补充截图证据和举报理由（选填）";
            reusableview = headerView;
        }
    }else if (indexPath.section==2){
        
        if(kind == UICollectionElementKindSectionFooter){
            XDNRFooterCollectionViewCell *footerView=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"XDNRFooterCollectionViewCell" forIndexPath:indexPath];
            [footerView.surebtn addTarget:self action:@selector(reportAction) forControlEvents:(UIControlEventTouchUpInside)];
            reusableview = footerView;
        }
    }
    return reusableview;
}

/**
 改变cell的样式
 
 @param sender cell
 @param boolVaule bool
 @param indexPath indexpath
 */
- (void)changeCellStyle:(PostImageCollectionViewCell *)sender withBool:(BOOL)boolVaule AtIndexPath:(NSIndexPath *)indexPath{
    if (boolVaule) {
        [sender.imgViewPic setImage:[UIImage imageNamed:@"found_add"]];
    }else {
        [sender.imgViewPic setImage:nil];
        [sender.imgViewPic setImage:self.imagesArray[indexPath.row]];
    }
    sender.btnCancle.hidden = boolVaule;
    sender.imgCancle.hidden = boolVaule;
}

#pragma mark - 设置每个secion背景色
- (UIColor *)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout backgroundColorForSection:(NSInteger)section {
    return [@[
              [UIColor whiteColor],
              [UIColor whiteColor],
              [UIColor whiteColor]
              ] objectAtIndex:section];
}

#pragma mark - 点击某个item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
    if (indexPath.section == 2) {
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
            ICEPhotoBrowser *photoBrowser = [ICEPhotoBrowser defaultManager];
            photoBrowser.superVC = self;
            [photoBrowser showBrowserWithImages:self.imagesArray andCurrentIndex:indexPath.row];
        }
    } else if (indexPath.section == 0) {
        XDReportPostModel *model = self.reportsArray[indexPath.row];
        self.reportModel = model;
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
    }
}


@end

