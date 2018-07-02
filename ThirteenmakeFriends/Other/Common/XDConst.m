//
//  XDConst.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 16/4/18.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma mark - 个推推送

/** 强制退出*/
NSString * const PUSH_LOGINOUT         = @"SSCOMM_LOGINOUT";

/** 我的粉丝*/
NSString * const PUSH_FANS         = @"SSCOMM_FANS";

/** 评论详情*/
NSString * const PUSH_COMMENT_DETAIL         = @"SSCOMM_NEWSCOMMENT_DETAIL";

/** 系统通知*/
NSString * const PUSH_NOTICE         = @"SSCOMM_NOTICE";

/** 推送网页内容*/
NSString * const PUSH_AD_WEB        = @"SSCOMM_AD_WEB";

/** 超级喜欢*/
NSString * const PUSH_SUPERLIKE         = @"SSCOMM_SUPER_FLOP";

/** 翻牌喜欢*/
NSString * const PUSH_LIKE         = @"SSCOMM_LIKE_FLOP";

/** 关注好友的新帖子*/
NSString * const PUSH_FANS_THREAD_DETAIL         = @"SSCOMM_FANS_THREAD_DETAIL";

/** 救我通知*/
NSString * const PUSH_SSCOMM_SAVEME         = @"SSCOMM_SAVEME";


/** 聊天*/
NSString * const SSCOMM_CHAT         = @"SSCOMM_CHAT";
#pragma mark - 翻牌

NSString * const HaremHtmlString  =  @"http://13loveme.com:8888/flop/flop-list?flag=";

NSString * const PilotString1 = @"PilotString1";//送礼物引导提示1
NSString * const PilotString2 = @"PilotString2";//送礼物引导提示2
#pragma mark - 错误提示的标识
/**
 *  错误提示的标识
 */

/** 网络不给力*/
NSString * const error_nonet_flag         = @"error_nonet";

/** 暂无相关内容*/
NSString * const error_nodata_flag        = @"error_nodata";

/** 没有登录*/
NSString * const error_notlogin_flag      = @"error_notlogin";

/** 数据获取失败*/
NSString * const error_getfail_flag       = @"error_getfail";

/** 抱歉!尚未覆盖到该地区*/
NSString * const error_notyetreach_flag   = @"error_notyetreach";

/** 您还没有相关的订单*/
NSString * const error_order_null_flag    = @"error_order_null";

/** 您的购物车内还没有任何商品*/
NSString * const error_gouwuche_null_flag = @"error_gouwuche_null";

/** 服务器维护中,请稍后再试*/
NSString * const server_ismaintain_flag   = @"server_ismaintain";

/** 抱歉!定位失败*/
NSString * const error_locfail_flag       = @"error_locfail";

/** 暂无翻牌信息*/
NSString * const error_noflopdata_flag        = @"error_noflopdata";

/** 暂无排行榜信息*/
NSString * const error_noRankdata_flag        = @"noData_Rank";



#pragma mark - 网络情况
/**
 *  网络情况
 */

/** 网络超时*/
NSString * const NET_TIMEOUT_FLAG = @"net_timeout";

/** 网络丢失--断网*/
NSString * const NET_LOST_FLAG    = @"net_lost";

/** 网络断开连接时的提示信息*/
NSString * const kNET_IS_LOST     = @"网络不给力,请检查您的网络连接!";

/** 请求超时的提示信息*/
NSString * const kNET_IS_TIMEOUT     = @"请求超时,请稍后再试~";

#pragma mark - 客服
/** 客服id */
NSString * const kServiceName     = @"shisan-kefu";

#pragma mark - 其他

/** 觅约标题 */
NSString * const kSendSeekTitle    = @"发布觅约";

/** 编辑资料标题 */
NSString * const kEditDataTitle    = @"编辑资料";

/** 男性 */
NSString * const kSex_man    = @"0";

/** 女性 */
NSString * const kSex_woman    = @"1";


/** 我的标签 */
NSString * const kmyLabel    = @"我的标签";

/** 觅约标签 */
NSString * const kseekLabel    = @"觅约标签";

#pragma mark - 会话
/** 打招呼 */
NSString * const ksayHello_extKey_sayHelloPrompt = @"em_sayHello_extKey_sayHelloPrompt";

#pragma mark - 公/私钥

/** 公钥 */
NSString * const kRSA_Public_key = @"MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA9fQ/1Esba3rGt6cew3TRZikGLHDMlsG03IcfAcMyXCf0BS5U4i7DvQJC3SjY5f8ZZ4k3kvyERvrUy74JKadYkJz/jrPSEir1T502ca4gay8FoT2WFDpBvzUKpGaQmX3u/QjtExcNWvg53BczVtYQk+HYD1f/AzuA8Sw6VmTKvAK2pFN0VPPt3X/lnDN4gQCVjC/tWT+pKTjlhye243lVkhwOdNX2h2ZmW4Ksj4TpaA5H79F1SoLGptkC4EuH+N2YSiAx1KG10jH0guefh7UZmkU9alc7Q3pvyJRL3hN0H2dCsb8vxURf/n41J/AnVacQTiUYv2JNNu+DkAXbXdph2wIDAQAB";

#pragma mark - 翻牌错误提示的标识

/** 达到今日限制 */
NSString * const flop_error_today_limit = @"flop_error_today_limit";

/** 暂无翻牌内容 */
NSString * const flop_error_nodata = @"flop_error_nodata";

/** 本地区暂无数据 */
NSString * const flop_error_localArea_nodata = @"flop_error_localArea_nodata";

/** 未认证 */
NSString * const flop_error_unauthorized = @"flop_error_unauthorized";

#pragma mark - 马甲包相关

#if APP_Puppet  // Puppet *****************************************

/** 客服名称 */
NSString * const kServiceNiceName     = @"官方客服";
/** 心动币名字 */
NSString * const coin_name = @"金币";
/** 觅约记录名 */
NSString * const kSeek_record_name = @"约会记录";
/** 我的-心动币 */
NSString * const kMine_coin_name = @"我的钱包";
/** 我的-用户名-前缀 */
NSString * const kMine_username_prefix = @"账号";

/** 注册协议名 */
NSString * const kReg_user_agreement = @"《用户协议》";
/** 注册app描述 */
NSString * const kReg_app_des = @"一个真实高端的交友社区";

/** 支付类型 4.合作商马甲包 5.自己平台马甲包 */
NSString * const kPay_Peppet_Type = @"4";

#elif APP_myPuppet // myPuppet *****************************************

/** 客服名称 */
NSString * const kServiceNiceName     = @"官方客服";
/** 心动币名字 */
NSString * const coin_name = @"心动币";
NSString * const diamonds_name = @"钻石";
/** 觅约记录名 */
NSString * const kSeek_record_name = @"约会记录";
/** 我的-心动币 */
NSString * const kMine_coin_name = @"我的钱包";
/** 我的-用户名-前缀 */
NSString * const kMine_username_prefix = @"觅爱号";

/** 注册协议名 */
NSString * const kReg_user_agreement = @"《用户协议》";
/** 注册app描述 */
NSString * const kReg_app_des = @"你 的 约 会 我 来 守 护";

/** 支付类型 4.合作商马甲包 5.自己平台马甲包 */
NSString * const kPay_Peppet_Type = @"5";

#else // 正常 *****************************************

/** 客服名称 */
NSString * const kServiceNiceName     = @"客服十三";
/** 心动币名字 */
NSString * const coin_name = @"心动币";
/** 觅约记录名 */
NSString * const kSeek_record_name = @"觅约记录";
/** 我的-心动币 */
NSString * const kMine_coin_name = @"心动币";
/** 我的-用户名-前缀 */
NSString * const kMine_username_prefix = @"觅爱号";

/** 注册协议名 */
NSString * const kReg_user_agreement = @"《十三用户协议》";
/** 注册app描述 */
NSString * const kReg_app_des = @"一个有温度的交友社区";

/** 支付类型 4.合作商马甲包 5.自己平台马甲包 */
NSString * const kPay_Peppet_Type = @"6";

#endif
