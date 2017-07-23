//
//  UIColor+HexColor.h
//  CampusIOS
//
//  Created by enqingchen on 15/5/18.
//  Copyright (c) 2015年 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#define RGBA_COLOR(R, G, B, A) [UIColor colorWithRed:((R) / 255.0f) green:((G) / 255.0f) blue:((B) / 255.0f) alpha:A]
#define RGB_COLOR(R, G, B) [UIColor colorWithRed:((R) / 255.0f) green:((G) / 255.0f) blue:((B) / 255.0f) alpha:1.0f]

@interface UIColor (HexColor)

+ (UIColor *)colorWithHexString:(NSString *)color;

//从十六进制字符串获取颜色，
//color:只支持 @“123456” 长度为6
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

/**
 *  释放内存中所有已加载的自定义表情
 */
+(void)releaseAllLoadedColor;
@end

