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

+(FLUserInfoManager *)sharedUserInfoManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userInfoManager = [[FLUserInfoManager alloc] init];
        
    });
    
    return userInfoManager;
}

#pragma mark - getter & setter

-(NSString *)uid{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uid = [defaults objectForKey:@"x-uid"];
    return uid;
}

-(double)lng{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    double lng = [[defaults objectForKey:@"lng"] doubleValue];
    return lng;
}

-(void)setLng:(double)lng{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@(lng) forKey:@"lng"];
}

-(double)lat{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    double lat = [[defaults objectForKey:@"lat"] doubleValue];
    return lat;
}

-(void)setLat:(double)lat{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@(lat) forKey:@"lat"];
}

#pragma mark - public

-(BOOL)isLogin{
    
    if([[self class] isTestAccount:self.uid]){
        return YES;
    }
    
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

+(BOOL)isTestAccount:(NSString *)account{
    NSArray *testAccounts = @[@"13570825566", @"13410794959"];

    for(int i=0; i<testAccounts.count; i++){
        NSString *testAccount = testAccounts[i];
        if([account isEqualToString:testAccount]){
            return YES;
        }
    }
    return NO;
}

@end
