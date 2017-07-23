//
//  FLUserInfoManager.m
//  Flipped
//
//  Created by ShaoJun on 2017/7/19.
//  Copyright © 2017年 junshao. All rights reserved.
//

#import "FLUserInfoManager.h"
#import "FLBaseViewController.h"
#import "FLLoginViewController.h"

static FLUserInfoManager *userInfoManager;

@interface FLUserInfoManager()

@end

@implementation FLUserInfoManager

+(FLUserInfoManager *)sharedHttpSessionManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userInfoManager = [[FLUserInfoManager alloc] init];
    });
    
    return userInfoManager;
}

-(NSString *)uid{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uid = [defaults objectForKey:@"x-uid"];
    return uid;
}

-(BOOL)isLogin{
    if(self.uid == nil || !self.uid || self.uid.length == 0){
        return NO;
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = [defaults objectForKey:@"key"];
    if(key == nil || !key || key.length == 0){
        return NO;
    }
    
    return YES;
}

-(BOOL)checkLogin{
    
    if(![self isLogin]){
        [FLLoginViewController present];
        return NO;
    }
    return YES;
}

@end
