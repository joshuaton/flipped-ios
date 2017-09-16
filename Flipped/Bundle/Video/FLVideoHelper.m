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
#import "FLToast.h"

@implementation FLVideoHelper

+(void)login{
    
    
    if(![[FLUserInfoManager sharedUserInfoManager] isLogin]){
        return;
    }
    
    [FLVideoService getSigWithSuccessBlock:^(NSString *sig) {
        
        [[ILiveLoginManager getInstance] iLiveLogin:[FLUserInfoManager sharedUserInfoManager].uid sig:sig succ:^{
            NSLog(@"-----> video login succ");
        } failed:^(NSString *module, int errId, NSString *errMsg) {
            [FLToast showToast:[NSString stringWithFormat:@"video login fail %@,%d,%@", module,errId,errMsg]];
        }];
    } failBlock:^(NSError *error) {
        
    }];
}

@end
