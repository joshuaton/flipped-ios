//
//  FLCommHeader.h
//  Flipped
//
//  Created by ShaoJun on 2017/7/8.
//  Copyright © 2017年 junshao. All rights reserved.
//

#import "UIColor+HexColor.h"

#define SCREEN_WIDTH      [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT     [[UIScreen mainScreen] bounds].size.height

#define SCREEN_SCALE_WIDTH  (SCREEN_WIDTH/375.0)
#define SCREEN_SCALE_HEIGHT  (SCREEN_HEIGHT/667.0)

//font
#define FONT_XL [UIFont systemFontOfSize:18]
#define FONT_L [UIFont systemFontOfSize:16]     ///< 主文字
#define FONT_M [UIFont systemFontOfSize:14]     ///< 副文字
#define FONT_S [UIFont systemFontOfSize:12]
#define FONT_XS [UIFont systemFontOfSize:10]

//color
#define COLOR_M  [UIColor colorWithHexString:@"e17141"]  ///< 主色
#define COLOR_B  [UIColor colorWithHexString:@"52beef"]  ///< 突出的非警告文字，按钮和icon边框
#define COLOR_R  [UIColor colorWithHexString:@"ed4956"]  ///< 警告色、突出、提示气泡
#define COLOR_P  [UIColor colorWithHexString:@"fd7196"]  ///< 性别icon
#define COLOR_H1 [UIColor colorWithHexString:@"262626"]  ///< 标题文字、主要文字、按钮边框
#define COLOR_H2 [UIColor colorWithHexString:@"8a8a8a"]  ///< 辅助文字
#define COLOR_H4 [UIColor colorWithHexString:@"cbcbcf"]  ///< 分割线，1px
#define COLOR_H5 [UIColor colorWithHexString:@"f0f0f0"]  ///< 底色
#define COLOR_H6 [UIColor colorWithHexString:@"fbfbfb"]  ///< 上下栏底色
#define COLOR_W  [UIColor colorWithHexString:@"ffffff"]  ///< 辅助色

//notification
#define NOTIFICATION_LOGIN_SUCCESS @"NOTIFICATION_LOGIN_SUCCESS"
#define NOTIFICATION_POST_SUCCESS @"NOTIFICATION_POST_SUCCESS"
#define NOTIFICATION_DELETE_SUCCESS @"NOTIFICATION_DELETE_SUCCESS"

