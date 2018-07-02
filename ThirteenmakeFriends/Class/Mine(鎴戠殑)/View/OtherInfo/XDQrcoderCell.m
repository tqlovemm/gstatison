//
//  XDQrcoderCell.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/11/17.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDQrcoderCell.h"
#import "UIButton+EMWebCache.h"
#import <QiniuSDK.h>
#import "ProfileUser.h"
#import "XDAccountTool.h"
#import "MBProgressHUD+MJ.h"

@interface XDQrcoderCell ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>


@property (nonatomic, weak) UILabel *wxLabel;

@property (nonatomic, weak) UITextField *wxTextField;

@property (nonatomic, weak) UIView *lineView;

@property (nonatomic, weak) UILabel *wxCodeLab;

@property (nonatomic, weak) UIButton *wxCodeBtn;

@property (nonatomic, weak) UILabel *desLabel;

@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *path;

@end

@implementation XDQrcoderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        // 创建cell内部子控件
        [self setupSubViews];
    }
    return self;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    // 1、创建Cell
    static NSString *identifier = @"XDQrcoderCellID";
    XDQrcoderCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[XDQrcoderCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    // 3、返回Cell
    return cell;
}

/**
 *  创建cell内部子控件
 */
- (void)setupSubViews {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(saveMessage)
                                                 name:@"SaveWeichatMessage"
                                               object:nil];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *wxLabel = [[UILabel alloc]init];
    wxLabel.font = kPingFangRegularFont(16);
    wxLabel.textColor = RGB(65, 65, 65);
    wxLabel.backgroundColor = [UIColor clearColor];
    wxLabel.text = @"微信号";
    [self.contentView addSubview:wxLabel];
    self.wxLabel = wxLabel;
    
    UITextField *wxTextField = [[UITextField alloc] init];
    wxTextField.placeholder = @"请输入您的微信号";
    wxTextField.textColor = RGB(226, 99, 142);
    wxTextField.font = kPingFangRegularFont(14);
    wxTextField.enablesReturnKeyAutomatically = YES;
    [self.contentView addSubview:wxTextField];
    self.wxTextField = wxTextField;
    wxTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入您的微信号" attributes:@{NSForegroundColorAttributeName: RGB(226, 99, 142)}];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = RGB(230, 230, 230);
    [self.contentView addSubview:lineView];
    self.lineView = lineView;
    
    UILabel *wxCodeLab = [[UILabel alloc]init];
    wxCodeLab.font = kPingFangRegularFont(16);
    wxCodeLab.textColor = RGB(65, 65, 65);
    wxCodeLab.backgroundColor = [UIColor clearColor];
    wxCodeLab.text = @"微信二维码";
    [self.contentView addSubview:wxCodeLab];
    self.wxCodeLab = wxCodeLab;
    
    UIButton *wxCodeBtn = [[UIButton alloc] init];
    wxCodeBtn.backgroundColor = RGB(240, 239, 245);
    wxCodeBtn.titleLabel.font = kPingFangRegularFont(14);
    [wxCodeBtn setTitleColor:RGB(226, 99, 142) forState:UIControlStateNormal];
    wxCodeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    wxCodeBtn.titleLabel.numberOfLines = 0;
    wxCodeBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [wxCodeBtn setAttributedTitle:[self getTitle] forState:UIControlStateNormal];
    [wxCodeBtn addTarget:self action:@selector(openAlbum) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:wxCodeBtn];
    self.wxCodeBtn = wxCodeBtn;
    
    UILabel *desLabel = [[UILabel alloc]init];
    desLabel.numberOfLines = 0;
    desLabel.font = kPingFangRegularFont(12);
    desLabel.textColor = RGB(119, 119, 119);
    desLabel.backgroundColor = [UIColor clearColor];
    NSMutableAttributedString *allStr = [[NSMutableAttributedString alloc] initWithString:@"1.微信号将保密隐藏，不会在资料中公开显示\n2.仅在促成双方约会的时候，推送给对方，提高约会效率\n"];
    NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:@"3.微信号及二维码一经保存不可自行修改，可联系客服处理\n" attributes:@{NSForegroundColorAttributeName:RGB(226, 99, 142)                                                                             }];
    [allStr appendAttributedString:str1];
    NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:@"4.提供虚假微信，平台将进行相应处理"];
    [allStr appendAttributedString:str2];
    desLabel.attributedText = allStr;
//    desLabel.text = @"1.微信号将保密隐藏，不会在资料中公开显示\n2.仅在促成双方约会的时候，推送给对方，提高约会效率\n3.微信号及二维码一经保存不可自行修改，可联系客服处理\n4.提供虚假微信，平台将进行相应处理";
    [self.contentView addSubview:desLabel];
    self.desLabel = desLabel;
    
    XD_WeakSelf
    [self.wxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.mas_equalTo(35);
    }];
    
    [self.wxTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.left.mas_equalTo(self.wxLabel);
        make.top.mas_equalTo(self.wxLabel.mas_bottom).offset(24);
        make.size.mas_equalTo(CGSizeMake(200, 44));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.wxLabel);
        make.top.mas_equalTo(self.wxTextField.mas_bottom).offset(2);
        make.height.mas_equalTo(0.5);
        make.right.mas_equalTo(0);
    }];
    
    [self.wxCodeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.wxLabel);
        make.top.mas_equalTo(self.lineView.mas_bottom).offset(65);
    }];
    
    [self.wxCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.wxCodeLab.mas_bottom).offset(24);
        make.size.mas_equalTo(CGSizeMake(180, 240));
    }];
    
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.wxCodeLab);
        make.top.mas_equalTo(self.wxCodeBtn.mas_bottom).offset(37);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-12);
        make.bottom.mas_equalTo(self.contentView).offset(-20);
    }];
    
}

- (void)setQrCoder:(NSString *)qrCoder {
    _qrCoder = qrCoder;
    
    if (qrCoder.length > 0) {
//        [self.wxCodeBtn sd_setImageWithURL:[NSURL URLWithString:self.qrCoder] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"square_image_placeholder"]];
        [self.wxCodeBtn sd_setImageWithURL:[NSURL URLWithString:self.qrCoder] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"square_image_placeholder"]];
        [self.wxCodeBtn setAttributedTitle:nil forState:UIControlStateNormal];
    }
}

- (void)setWeichat:(NSString *)weichat {
    _weichat = weichat;
    
    self.wxTextField.text = weichat;
    if (weichat.length > 0) {
        self.wxTextField.enabled = NO;
    }
}

- (NSAttributedString *)getTitle {
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@""];
    
    NSAttributedString *givingStr = [[NSAttributedString alloc] initWithString:@"+" attributes:@{NSForegroundColorAttributeName:RGB(226, 99, 142),NSFontAttributeName:[UIFont systemFontOfSize:50]                                                                             }];
    [string appendAttributedString:givingStr];
    NSAttributedString *wechatStr = [[NSAttributedString alloc] initWithString:@"\n\n上传微信二维码" attributes:@{NSForegroundColorAttributeName:RGB(226, 99, 142)                                                                           }];
    [string appendAttributedString:wechatStr];
    
    return string;
}

#pragma mark - 打开相册
- (void)openAlbum {
    if (self.qrCoder.length > 0) {
        return;
    }
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) return;
    
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    // 接管控制状态栏的外观
    ipc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    ipc.navigationBar.translucent = NO;
    //    ipc.allowsEditing = YES;
    ipc.delegate = self;
    [self.navigationController presentViewController:ipc animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // 1.取出选中的图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
//    [self.wxCodeBtn setAttributedTitle:nil forState:UIControlStateNormal];
    [self.wxCodeBtn setImage:image forState:UIControlStateNormal];
}

- (void)saveMessage {
    NSLog(@"保存图片成功");
    
    [self.wxTextField endEditing:YES];
    
    if (self.wxTextField.text.length == 0 && self.wxCodeBtn.imageView.image == nil) {
        [self.navigationController.view makeToast:@"微信号与二维码至少有一个不能为空" duration:2.0 position:CSToastPositionCenter];
        return;
    } else if (self.wxCodeBtn.imageView.image == nil && self.qrCoder.length == 0){
        self.path = nil;
        [self uploadMessage];
        return;
    }
    
    [self.navigationController showHudInView:self.navigationController.view hint:@"图片上传中..."];
    NSString *encryWithPublicKeyStr = [RSAUtil encryptString:[NSString stringWithFormat:@"%@",User_ID] publicKey:kRSA_Public_key];
    [FKL_DataService requestURL:[NSString url_getQiniuTokenWithQRCoder] parameters:nil headerKey:@"sign" headerValue:encryWithPublicKeyStr withType:@"GET" format:@"JSON" complete:^(id result) {
        [self.navigationController hideHud];
        if ([result[@"code"] integerValue] == 200) {
            self.token = result[@"data"][@"token"];
            self.path = result[@"data"][@"path"];
            
            [self uploadImageToQNFilePath:[self getImagePath:self.wxCodeBtn.imageView.image]];
        } else {
            [self.navigationController.view makeToast:result[@"message"]
                        duration:2.0
                        position:CSToastPositionCenter];
        }
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        [self.navigationController hideHud];
        [self.navigationController.view makeToast:error.localizedDescription
                    duration:2.0
                    position:CSToastPositionCenter];
    }];
    
}

- (void)uploadMessage {
    [self.navigationController showHudInView:self.navigationController.view hint:@"图片上传中..."];
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"wechat"] = self.wxTextField.text;
    paras[@"weima"] = self.path;
    NSString *encryWithPublicKeyStr = [RSAUtil encryptString:[NSString stringWithFormat:@"%@",User_ID] publicKey:kRSA_Public_key];
    [FKL_DataService requestURL:[NSString url_getQiniuTokenWithQRCoder] parameters:paras headerKey:@"sign" headerValue:encryWithPublicKeyStr withType:@"PATCH" format:@"JSON" complete:^(id result) {
        [self.navigationController hideHud];
        if ([result[@"code"] integerValue] == 200) {
            ProfileUser *user = [XDAccountTool account];
            if (self.path) {
                user.weima = result[@"data"];
            }
            user.wechat = self.wxTextField.text;
            [XDAccountTool save:user];
            [self.navigationController popViewControllerAnimated:YES];
            [MBProgressHUD showSuccess:@"上传成功"];
        } else {
            [self.navigationController.view makeToast:result[@"message"]
                                             duration:2.0
                                             position:CSToastPositionCenter];
        }
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        [self.navigationController hideHud];
        [self.navigationController.view makeToast:error.localizedDescription
                                         duration:2.0
                                         position:CSToastPositionCenter];
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)uploadImageToQNFilePath:(NSString *)filePath {
    [self.navigationController showHudInView:self.navigationController.view hint:@"图片上传中..."];
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    QNUploadOption *uploadOption = [[QNUploadOption alloc] initWithMime:nil progressHandler:^(NSString *key, float percent) {
        NSLog(@"percent == %.2f", percent);
    }
                                                                 params:nil
                                                               checkCrc:NO
                                                     cancellationSignal:nil];
    [upManager putFile:filePath key:self.path token:self.token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        if(info.ok)
        {
            NSLog(@"请求成功");
            [self.navigationController hideHud];
            
            [self uploadMessage];
        }
        else{
            NSLog(@"失败");
            [self.navigationController hideHud];
            [self.navigationController.view makeToast:info.error.localizedDescription
                                             duration:2.0
                                             position:CSToastPositionCenter];
            //如果失败，这里可以把info信息上报自己的服务器，便于后面分析上传错误原因
        }
        NSLog(@"info ===== %@", info);
        NSLog(@"resp ===== %@", resp);
    }
                option:uploadOption];
}

//照片获取本地路径转换
- (NSString *)getImagePath:(UIImage *)Image{
    NSString *filePath = nil;
//    NSData *data = nil;
//    if (UIImagePNGRepresentation(Image) == nil) {
//        data = UIImageJPEGRepresentation(Image, 1.0);
//    } else {
//        data = UIImagePNGRepresentation(Image);
//    }
    NSData *data = [Image wxImageSize:Image];
    
    //图片保存的路径
    //这里将图片放在沙盒的documents文件夹中
    NSString *DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    //文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //把刚刚图片转换的data对象拷贝至沙盒中
    [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *ImagePath = [[NSString alloc] initWithFormat:@"/theFirstImage.png"];
    [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:ImagePath] contents:data attributes:nil];
    
    //得到选择后沙盒中图片的完整路径
    filePath = [[NSString alloc] initWithFormat:@"%@%@", DocumentsPath, ImagePath];
    return filePath;
}

@end
