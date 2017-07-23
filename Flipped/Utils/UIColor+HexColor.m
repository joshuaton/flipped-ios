//
//  UIColor+HexColor.m
//  CampusIOS
//
//  Created by enqingchen on 15/5/18.
//  Copyright (c) 2015年 Tencent. All rights reserved.
//

#import "UIColor+HexColor.h"

static NSCache* loadedColorCache = nil;

@implementation UIColor (HexColor)

+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha
{
    if ([color length] != 6)
    {
        return [UIColor clearColor];
    }

    color = [color uppercaseString];

    UIColor* _color = nil;
    //只缓存不透明的颜色
    if(alpha == 1.0){
        _color = [loadedColorCache objectForKey:color];
        if(_color) return _color;
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [color substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [color substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [color substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    _color = [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
    if(alpha == 1.0){
        [loadedColorCache setObject:_color forKey:color];
    }
    return _color;
}
+ (void)load{
    loadedColorCache = [[NSCache alloc] init];
}
//默认alpha值为1
+ (UIColor *)colorWithHexString:(NSString *)color
{
    return [self colorWithHexString:color alpha:1.0f];
}
/**
 *  释放内存中所有已加载的自定义表情
 */
+(void)releaseAllLoadedColor{
    [loadedColorCache removeAllObjects];
}
@end
