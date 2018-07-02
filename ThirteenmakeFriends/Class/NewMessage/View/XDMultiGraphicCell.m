//
//  XDMultiGraphicCell.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2018/1/26.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import "XDMultiGraphicCell.h"
#import "XDGraphicItemView.h"
#import "XDGraphicHeaderView.h"
#import "XDMsgCategoryModel.h"

@interface XDMultiGraphicCell ()

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UIView *contextView;

@property (nonatomic, weak) XDGraphicHeaderView *headerView;

@property (nonatomic, weak) XDGraphicItemView *item1;

@property (nonatomic, weak) XDGraphicItemView *item2;

@property (nonatomic, weak) XDGraphicItemView *item3;

@end

@implementation XDMultiGraphicCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    // 创建cell
    static NSString *ID = @"XDMultiGraphicCellID";
    XDMultiGraphicCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if(cell == nil)
    {
        cell = [[XDMultiGraphicCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self xdd_setupView];
    }
    return self;
}

- (void)xdd_setupView
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    
    self.timeLabel = [UILabel new];
    self.timeLabel.font = kPingFangRegularFont(12);
    self.timeLabel.textColor = RGB(170, 170, 170);
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.timeLabel];
    
    self.contextView = [UIView new];
    self.contextView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.contextView];
    
    XDGraphicHeaderView *headerView = [[XDGraphicHeaderView alloc] init];
    headerView.tag = 0;
    [self.contextView addSubview:headerView];
    self.headerView = headerView;
    
    XDGraphicItemView *item1 = [[XDGraphicItemView alloc] init];
    item1.tag = 1;
    [self.contextView addSubview:item1];
    self.item1 = item1;
    
    XDGraphicItemView *item2 = [[XDGraphicItemView alloc] init];
    item2.tag = 2;
    [self.contextView addSubview:item2];
    self.item2 = item2;
    
    XDGraphicItemView *item3 = [[XDGraphicItemView alloc] init];
    item3.tag = 3;
    [self.contextView addSubview:item3];
    self.item3 = item3;
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {        
        make.left.top.right.mas_equalTo(self.contextView);
        make.height.mas_equalTo(196);
    }];
    
    [self.item1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.headerView);
        make.top.mas_equalTo(self.headerView.mas_bottom);
    }];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(messageItemTapped:)];
    [self.headerView addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(messageItemTapped:)];
    [self.item1 addGestureRecognizer:tap2];
    
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(messageItemTapped:)];
    [self.item2 addGestureRecognizer:tap3];
    
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(messageItemTapped:)];
    [self.item3 addGestureRecognizer:tap4];
}

- (void)setModel:(XDNewMessageModel *)model {
    _model = model;
    
    self.timeLabel.text = [model getMessageTimeWithCreate_at:model.created_at];
    
    NSArray *modelArray = model.graphicArray;
    self.headerView.model = modelArray.firstObject;
    self.item1.model = [modelArray objectAtIndex:1];
    
    if (modelArray.count < 5 && modelArray.count > 2) {
        if (modelArray.count == 3) { // 三个
            [self.item2 mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(self.headerView);
                make.top.mas_equalTo(self.item1.mas_bottom);
            }];
            
            [self.item3 mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(self.headerView);
                make.top.mas_equalTo(self.item1.mas_bottom);
            }];
            
            [self.contextView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.contentView).offset(12);
                make.top.mas_equalTo(self.timeLabel.mas_bottom).offset(10);
                make.right.mas_equalTo(self.contentView).offset(-12);
                make.bottom.mas_equalTo(self.item2.mas_bottom);
                make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10);
            }];
            
            [self.timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self.contentView);
                make.top.mas_equalTo(self.contentView).offset(10);
                make.width.lessThanOrEqualTo(@(300));
            }];
            
            self.item2.hidden = NO;
            self.item3.hidden = YES;
            
            self.item2.model = [modelArray objectAtIndex:2];
        } else { // 四个
            
            [self.item2 mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(self.headerView);
                make.top.mas_equalTo(self.item1.mas_bottom);
            }];
            
            [self.item3 mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(self.headerView);
                make.top.mas_equalTo(self.item2.mas_bottom);
            }];
            
            [self.contextView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.contentView).offset(12);
                make.top.mas_equalTo(self.timeLabel.mas_bottom).offset(10);
                make.right.mas_equalTo(self.contentView).offset(-12);
                make.bottom.mas_equalTo(self.item3.mas_bottom);
                make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10);
            }];
            
            [self.timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self.contentView);
                make.top.mas_equalTo(self.contentView).offset(10);
                make.width.lessThanOrEqualTo(@(300));
            }];
            
            self.item2.model = [modelArray objectAtIndex:2];
            self.item3.model = [modelArray objectAtIndex:3];
            self.item2.hidden = NO;
            self.item3.hidden = NO;
        }
    } else { // 只有两个
        [self.contextView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView).offset(12);
            make.top.mas_equalTo(self.timeLabel.mas_bottom).offset(10);
            make.right.mas_equalTo(self.contentView).offset(-12);
            make.bottom.mas_equalTo(self.item1.mas_bottom);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10);
        }];
        
        [self.timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.contentView);
            make.top.mas_equalTo(self.contentView).offset(10);
            make.width.lessThanOrEqualTo(@(300));
        }];
        
        self.item2.hidden = YES;
        self.item3.hidden = YES;
    }
}

//- (void)setModelArray:(NSArray<XDNewMessageGraphicModel *> *)modelArray {
//    _modelArray = modelArray;
//
//    self.headerView.model = modelArray.firstObject;
//    self.item1.model = [modelArray objectAtIndex:1];
//
//    if (modelArray.count < 5 && modelArray.count > 2) {
//        if (modelArray.count == 3) { // 三个
//            [self.item2 mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.left.right.mas_equalTo(self.headerView);
//                make.top.mas_equalTo(self.item1.mas_bottom);
//            }];
//
//            [self.item3 mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.left.right.mas_equalTo(self.headerView);
//                make.top.mas_equalTo(self.item1.mas_bottom);
//            }];
//
//            [self.contextView mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.left.mas_equalTo(self.contentView).offset(12);
//                make.top.mas_equalTo(self.contentView).offset(10);
//                make.right.mas_equalTo(self.contentView).offset(-12);
//                make.bottom.mas_equalTo(self.item2.mas_bottom);
//                make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10);
//            }];
//
//            self.item2.hidden = NO;
//            self.item3.hidden = YES;
//
//            self.item2.model = [modelArray objectAtIndex:2];
//        } else { // 四个
//
//            [self.item2 mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.left.right.mas_equalTo(self.headerView);
//                make.top.mas_equalTo(self.item1.mas_bottom);
//            }];
//
//            [self.item3 mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.left.right.mas_equalTo(self.headerView);
//                make.top.mas_equalTo(self.item2.mas_bottom);
//            }];
//
//            [self.contextView mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.left.mas_equalTo(self.contentView).offset(12);
//                make.top.mas_equalTo(self.contentView).offset(10);
//                make.right.mas_equalTo(self.contentView).offset(-12);
//                make.bottom.mas_equalTo(self.item3.mas_bottom);
//                make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10);
//            }];
//
//            self.item2.model = [modelArray objectAtIndex:2];
//            self.item3.model = [modelArray objectAtIndex:3];
//            self.item2.hidden = NO;
//            self.item3.hidden = NO;
//        }
//    } else { // 只有两个
//        [self.contextView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(self.contentView).offset(12);
//            make.top.mas_equalTo(self.contentView).offset(10);
//            make.right.mas_equalTo(self.contentView).offset(-12);
//            make.bottom.mas_equalTo(self.item1.mas_bottom);
//            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10);
//        }];
//
//        self.item2.hidden = YES;
//        self.item3.hidden = YES;
//    }
//}

- (void)messageItemTapped:(UITapGestureRecognizer *)tap {
    NSArray *modelArray = self.model.graphicArray;
    XDNewMessageGraphicModel *model = [modelArray objectAtIndex:tap.view.tag];
    if (self.didSelectMessageItemBlock) {
        self.didSelectMessageItemBlock(model.url);
    }
}

@end
