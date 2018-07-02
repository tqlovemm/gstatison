//
//  XDSeekRecordDetailController.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 16/6/30.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import "XDSeekRecordDetailController.h"
#import "UIImageView+WebCache.h"


#define SCREEN [UIScreen mainScreen].bounds.size
@interface XDSeekRecordDetailController ()<UIScrollViewDelegate>

{
    UIScrollView *_scrollView;
}
@end

@implementation XDSeekRecordDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.title = @"详情";
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, SCREEN.height - NavigationBar_Height)];
    _scrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view  addSubview:_scrollView];
    [self createScrollviewTheView];
}
- (void)createScrollviewTheView {
    //图片
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(postCellBorder, 10, SCREEN.width-20, SCREEN.width-20)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.seekRecord.avatar] placeholderImage:[UIImage imageNamed:@"square_image_placeholder"]];
    imageView.layer.cornerRadius = 5;
    imageView.layer.masksToBounds = YES;
    [_scrollView addSubview:imageView];
    //地区
    UILabel *regionLab = [[UILabel alloc]initWithFrame:CGRectMake(postCellBorder, CGRectGetMaxY(imageView.frame) + 10 , SCREEN.width-10,20 )];
    regionLab.text = [NSString stringWithFormat:@"地区 : %@" ,self.seekRecord.address];
    regionLab.font = [UIFont systemFontOfSize:15];
    regionLab.textAlignment = NSTextAlignmentLeft;
    [_scrollView addSubview:regionLab];
    //编号 nmber
    UILabel *numberLab = [[UILabel alloc]initWithFrame:CGRectMake(postCellBorder, CGRectGetMaxY(regionLab.frame) + 10 , SCREEN.width-10,20 )];
    numberLab.text = [NSString stringWithFormat:@"编号 : %@" ,self.seekRecord.number];
    numberLab.font = [UIFont systemFontOfSize:15];
    numberLab.textAlignment = NSTextAlignmentLeft;
    [_scrollView addSubview:numberLab];
    //标签  tab
    UILabel *tabLab = [[UILabel alloc]initWithFrame:CGRectMake(postCellBorder, CGRectGetMaxY(numberLab.frame) + 10, SCREEN.width-10, 20)];
    tabLab.text = [NSString stringWithFormat:@"妹子标签 : %@" ,self.seekRecord.mark];
    tabLab.font = [UIFont systemFontOfSize:15];
    tabLab.textAlignment = NSTextAlignmentLeft;
    tabLab.numberOfLines = 0;
    tabLab.size = [tabLab.text sizeWithFont:k15Font maxW:SCREEN.width-10];
    [_scrollView addSubview:tabLab];
    //要求 request
    UILabel *requestLab = [[UILabel alloc]initWithFrame:CGRectMake(postCellBorder, CGRectGetMaxY(tabLab.frame) + 10, SCREEN.width-10,20)];
    requestLab.text = [NSString stringWithFormat:@"交友要求 : %@" ,self.seekRecord.require];
    requestLab.font = [UIFont systemFontOfSize:15];
    requestLab.textAlignment = NSTextAlignmentLeft;
    requestLab.numberOfLines = 0;
    requestLab.size = [requestLab.text sizeWithFont:k15Font maxW:SCREEN.width-10];
    [_scrollView addSubview:requestLab];
    //结果 result
    UILabel *resultLab = [[UILabel alloc]initWithFrame:CGRectMake(postCellBorder, CGRectGetMaxY(requestLab.frame) + 10, SCREEN.width-10,20 )];
    NSString *seekState = nil;
    if (self.seekRecord.status == 10) { // 觅约等待中
        seekState = [NSString stringWithFormat:@"等待中"];
        [resultLab setTextColor:[UIColor orangeColor]];
    } else if (self.seekRecord.status == 11) { // 觅约成功
        seekState = [NSString stringWithFormat:@"成功"];
        [resultLab setTextColor:RGB(60, 179, 69)];
    } else if (self.seekRecord.status == 12) { // 觅约失败
        seekState = [NSString stringWithFormat:@"失败"];
        [resultLab setTextColor:RGB(251, 0, 0)];
    } else {
        seekState = [NSString stringWithFormat:@"未知操作"];
        [resultLab setTextColor:RGB(251, 0, 0)];
    }
    NSString *result = [NSString stringWithFormat:@"交友结果 : %@" ,seekState];
    NSMutableAttributedString * aAttributedString = [[NSMutableAttributedString alloc] initWithString:result];
    [aAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 6)];
    resultLab.attributedText = aAttributedString;
    resultLab.font = [UIFont systemFontOfSize:15];
    resultLab.textAlignment = NSTextAlignmentLeft;
    [_scrollView addSubview:resultLab];
    NSString *costRecordStr = nil;
    //心动币 JCB
    if (self.seekRecord.status == 10) { // 觅约等待中
        costRecordStr = [NSString stringWithFormat:@"冻结%ld%@",self.seekRecord.coin,coin_name];
    } else if (self.seekRecord.status == 11) { // 觅约成功
        costRecordStr = [NSString stringWithFormat:@"扣除%ld%@",self.seekRecord.coin,coin_name];
    } else if (self.seekRecord.status == 12) { // 觅约失败
        costRecordStr = [NSString stringWithFormat:@"返回%ld%@",self.seekRecord.coin,coin_name];
    } else {
        costRecordStr = [NSString stringWithFormat:@"未知操作"];
    }
    UILabel *jCBLab = [[UILabel alloc]initWithFrame:CGRectMake(postCellBorder, CGRectGetMaxY(resultLab.frame) + 10, SCREEN.width-10,20 )];
    jCBLab.text = [NSString stringWithFormat:@"%@ : %@" ,coin_name,costRecordStr];
    jCBLab.font = [UIFont systemFontOfSize:15];
    jCBLab.textAlignment = NSTextAlignmentLeft;
    [_scrollView addSubview:jCBLab];
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(jCBLab.frame) + 20);
}
@end
