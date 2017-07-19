//
//  FLToast.h
//  Flipped
//
//  Created by ShaoJun on 2017/7/16.
//  Copyright © 2017年 junshao. All rights reserved.
//

#import "MBProgressHUD.h"

@interface FLToast : NSObject

+(void)showToast:(NSString *)text;

+(void)showLoading:(NSString *)text;

+(void)hideLoading;

@end
