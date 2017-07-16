//
//  FLToast.m
//  Flipped
//
//  Created by ShaoJun on 2017/7/16.
//  Copyright © 2017年 junshao. All rights reserved.
//

#import "FLToast.h"
#import "FLBaseViewController.h"

@implementation FLToast

+(void)showToast:(NSString *)text{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[FLBaseViewController currentViewController].view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = text;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:[FLBaseViewController currentViewController].view animated:YES];
    });
}

@end
