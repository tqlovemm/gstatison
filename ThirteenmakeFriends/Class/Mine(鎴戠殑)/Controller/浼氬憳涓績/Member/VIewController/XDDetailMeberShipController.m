//
//  XDDetailMeberShipController.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/7/20.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDDetailMeberShipController.h"
#import "XDCardModel.h"

@interface XDDetailMeberShipController ()

@property (weak, nonatomic) UILabel *desLabel;

@property (weak, nonatomic) UILabel *desTitleLabel;

@end

@implementation XDDetailMeberShipController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (instancetype)init {
    if (self = [super init]) {
        self.title = @"翻你牌子";
        
        UILabel *desTitleLabel = [[UILabel alloc]init];
        desTitleLabel.textColor = RGB(65, 65, 65);
        desTitleLabel.font = kPingFangRegularFont(20);
        [self.view addSubview:desTitleLabel];
        self.desTitleLabel = desTitleLabel;
        
        UILabel *desLabel = [[UILabel alloc]init];
        desLabel.textColor = RGB(155, 155, 155);
        desLabel.font = kPingFangRegularFont(14);
        desLabel.numberOfLines = 0;
        desLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:desLabel];
        self.desLabel = desLabel;
        
        desTitleLabel.text = @"翻你牌子";
        desLabel.text = @"女生通过翻牌加你好友\n愿者上钩";
        
        WEAKSELF
        [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(weakSelf);
            make.width.mas_lessThanOrEqualTo(204);
        }];
        
        [desTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(desLabel.mas_top).offset(-6);
            make.centerX.mas_equalTo(desLabel);
        }];
    }
    return  self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setShipModel:(XDMemberShipModel *)shipModel {
    _shipModel = shipModel;
    
    self.desTitleLabel.text = shipModel.authName;
    self.desLabel.text = shipModel.authContent;
    self.title = shipModel.authName;
}

@end
