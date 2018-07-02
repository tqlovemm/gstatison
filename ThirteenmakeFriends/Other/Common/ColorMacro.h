//
//  ColorMacro.h
//  ThirteenmakeFriends
//
//  Created by iOS on 27/3/17.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#ifndef ColorMacro_h
#define ColorMacro_h

#define DefaultColor_App_Gray               RGBA(190, 190, 190, 1)  // 文字灰色

#define DefaultColor_BG_gray                RGBA(240, 239, 245, 1)   // 背景颜色

#define RGB(r, g, b)                        [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define RGBA(r, g, b, a)                    [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define HEXCOLOR(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0 green:((float)((hex & 0xFF00) >> 8)) / 255.0 blue:((float)(hex & 0xFF)) / 255.0 alpha:1]
#define HEXCOLORA(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0 green:((float)((hex & 0xFF00) >> 8)) / 255.0 blue:((float)(hex & 0xFF)) / 255.0 alpha:a]

// 全局背景色
#define GlobalBGColor RGB(226, 226, 226)
#define ThemeColor RGB(14, 180, 0)

#define BtnThemeColor RGB(232, 63, 120)


#if APP_Puppet  // Puppet *****************************************
/* 导航栏按钮颜色 */
#define NormalNavBtnColor RGB(255, 255, 255)
/* 导航栏背景色 */
#define NavigationBarColor RGB(29, 28, 27)
/* 文字 */
#define ThemeColor1 RGB(241, 196, 121)
/* 登录注册按钮高亮背景 */
#define ThemeColor2 RGB(29, 28, 27)
/* 标签 */
#define ThemeColor3 RGB(255, 79, 102)
/* 登录注册处按钮未输入背景 */
#define ThemeColor4 RGB(201, 201, 201)
/* 登录注册处按钮未输入边框 */
#define ThemeColor5 RGB(201, 201, 201)
/* 登录注册处文本框背景 */
#define ThemeColor6 RGBA(216, 216, 216, 0.2)
/* 约会按钮阴影色 */
#define ThemeColor7 RGB(29, 28, 27)
/* 登录注册文本框placeholder颜色 */
#define ThemeColor8 RGB(222, 222, 222)

/* 导航栏文字色 */
#define kNav_Text_color ThemeColor1

#elif APP_myPuppet // myPuppet *****************************************
/* 导航栏按钮颜色 */
#define NormalNavBtnColor RGB(255, 255, 255)
/* 导航栏背景色 */
#define NavigationBarColor RGB(51, 51, 51)
/* 文字 */
#define ThemeColor1 RGB(97, 60, 187)
/* 登录注册按钮高亮背景 */
#define ThemeColor2 RGB(29, 28, 27)
/* 标签 */
#define ThemeColor3 RGB(255, 79, 102)
/* 登录注册处按钮未输入背景 */
#define ThemeColor4 RGB(201, 201, 201)
/* 登录注册处按钮未输入边框 */
#define ThemeColor5 RGB(201, 201, 201)
/* 登录注册处文本框背景 */
#define ThemeColor6 RGBA(216, 216, 216, 0.2)
/* 约会按钮阴影色 */
#define ThemeColor7 RGB(194, 138, 255)
/* 登录注册文本框placeholder颜色 */
#define ThemeColor8 RGB(68, 66, 66)

/* 导航栏文字色 */
#define kNav_Text_color RGB(255, 255, 255)

#else // 正常 *****************************************
/* 导航栏按钮颜色 */
#define NormalNavBtnColor RGB(65, 65, 65)
/* 导航栏背景色 */
#define NavigationBarColor RGB(248, 248, 248)
/* 文字 */
#define ThemeColor1 RGB(232, 63, 120)
/* 登录注册按钮高亮背景 */
#define ThemeColor2 RGB(238, 239, 244)
/* 标签 */
#define ThemeColor3 RGB(232, 63, 120)
/* 登录注册处按钮未输入背景 */
#define ThemeColor4 [UIColor clearColor]
/* 登录注册处按钮未输入边框 */
#define ThemeColor5 RGB(255, 255, 255)
/* 登录注册处文本框背景 */
#define ThemeColor6 RGBA(14, 14, 14, 0.65)
/* 约会按钮阴影色 */
#define ThemeColor7 RGB(232, 63, 120)
/* 登录注册文本框placeholder颜色 */
#define ThemeColor8 RGB(186, 186, 186)

/* 导航栏文字色 */
#define kNav_Text_color RGB(31, 31, 31)

#endif

// 男性
#define Man_NavigationBarColor RGB(43, 41, 65)
#define Woman_NavigationBarColor RGB(254, 91, 153)

#endif /* ColorMacro_h */
