
//
//  XDConst.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 16/4/18.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma mark - 个推推送

/** 强制退出*/
extern NSString * const PUSH_LOGINOUT;

/** 我的粉丝*/
extern NSString * const PUSH_FANS;

/** 评论详情*/
extern NSString * const PUSH_COMMENT_DETAIL;

/** 系统通知*/
extern NSString * const PUSH_NOTICE;

/** 推送网页内容*/
extern NSString * const PUSH_AD_WEB;

/** 超级喜欢*/
extern NSString * const PUSH_SUPERLIKE;

/** 翻牌喜欢*/
extern NSString * const PUSH_LIKE;

/** 关注好友的新帖子*/
extern NSString * const PUSH_FANS_THREAD_DETAIL;

/** 救我通知*/
extern NSString * const PUSH_SSCOMM_SAVEME;

/** 聊天*/
extern NSString * const SSCOMM_CHAT;

#pragma mark - 翻牌

extern NSString * const HaremHtmlString;

extern NSString * const PilotString1;//引导提示
extern NSString * const PilotString2;//引导提示
#pragma mark - 错误提示的标识
/**
 *  错误提示的标识
 */

/** 网络不给力*/
extern NSString * const error_nonet_flag;

/** 暂无相关内容*/
extern NSString * const error_nodata_flag;

/** 没有登录*/
extern NSString * const error_notlogin_flag;

/** 数据获取失败*/
extern NSString * const error_getfail_flag;

/** 抱歉!尚未覆盖到该地区*/
extern NSString * const error_notyetreach_flag;

/** 您还没有相关的订单*/
extern NSString * const error_order_null_flag;

/** 您的购物车内还没有任何商品*/
extern NSString * const error_gouwuche_null_flag;

/** 服务器维护中,请稍后再试*/
extern NSString * const server_ismaintain_flag;

/** 抱歉!定位失败*/
extern NSString * const error_locfail_flag;

/** 暂无翻牌信息*/
extern NSString * const error_noflopdata_flag;

/** 暂无排行榜信息*/
extern NSString * const error_noRankdata_flag;


#pragma mark - 网络情况
/**
 *  网络情况
 */

/** 网络超时*/
extern NSString * const NET_TIMEOUT_FLAG;

/** 网络丢失--断网*/
extern NSString * const NET_LOST_FLAG;

/** 网络断开连接时的提示信息*/
extern NSString * const kNET_IS_LOST;

/** 请求超时的提示信息*/
extern NSString * const kNET_IS_TIMEOUT;


#pragma mark - 客服
/** 客服id */
extern NSString * const kServiceName;

#pragma mark - 其他

/** 觅约标题 */
extern NSString * const kSendSeekTitle;

/** 编辑资料标题 */
extern NSString * const kEditDataTitle;

/** 男性 */
extern NSString * const kSex_man;

/** 女性 */
extern NSString * const kSex_woman;

/** 我的标签 */
extern NSString * const kmyLabel;

/** 觅约标签 */
extern NSString * const kseekLabel;

#pragma mark - 会话
/** 打招呼 */
extern NSString * const ksayHello_extKey_sayHelloPrompt;

#pragma mark - 公/私钥

/** 公钥 */
extern NSString * const kRSA_Public_key;

#pragma mark - 翻牌错误提示的标识

/** 达到今日限制 */
extern NSString * const flop_error_today_limit;

/** 暂无翻牌内容 */
extern NSString * const flop_error_nodata;

/** 本地区暂无数据 */
extern NSString * const flop_error_localArea_nodata;

/** 未认证 */
extern NSString * const flop_error_unauthorized;


#pragma mark - 马甲包相关
/** 心动币名字 */
extern NSString * const coin_name;
extern NSString * const diamonds_name;
/** 客服名称 */
extern NSString * const kServiceNiceName;
/** 觅约记录名 */
extern NSString * const kSeek_record_name;
/** 我的-心动币 */
extern NSString * const kMine_coin_name;
/** 我的-用户名-前缀 */
extern NSString * const kMine_username_prefix;

/** 注册协议名 */
extern NSString * const kReg_user_agreement;
/** 注册app描述 */
extern NSString * const kReg_app_des;

/** 支付类型 4.合作商马甲包 5.自己平台马甲包 */
extern NSString * const kPay_Peppet_Type;
