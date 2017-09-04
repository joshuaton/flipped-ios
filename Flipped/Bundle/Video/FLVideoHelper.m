//
//  VideoHelper.m
//  Flipped
//
//  Created by ShaoJun on 2017/9/4.
//  Copyright © 2017年 junshao. All rights reserved.
//

#import "FLVideoHelper.h"
#import "FLUserInfoManager.h"
#import "FLVideoService.h"

@implementation FLVideoHelper

+(void)login{
    
    [[ILiveSDK getInstance] initSdk:1400038614 accountType:14999];
    
    if(![[FLUserInfoManager sharedUserInfoManager] checkLogin]){
        return;
    }
    
    [FLVideoService getSigWithSuccessBlock:^(NSString *sig) {
        
        [[ILiveLoginManager getInstance] iLiveLogin:[FLUserInfoManager sharedUserInfoManager].uid sig:sig succ:^{
            NSLog(@"-----> video login succ");
        } failed:^(NSString *module, int errId, NSString *errMsg) {
            NSLog(@"-----> video login fail %@,%d,%@",module,errId,errMsg);
        }];
    } failBlock:^(NSError *error) {
        
    }];
}

@end
