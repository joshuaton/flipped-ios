//
//  FLUserService.m
//  Flipped
//
//  Created by ShaoJun on 2017/7/15.
//  Copyright © 2017年 junshao. All rights reserved.
//

#import "FLUserService.h"
#import "NSString+MD5.h"


@implementation FLUserService

+(void)getVertifyCodeWithWithPhoneNum:(NSString *)phoneNum successBlock:(void (^)())successBlock failBlock:(void (^)(NSError *error))failedBlock{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:phoneNum forKey:@"x-uid"];
    
    NSString *url = [self getRequestUrl:@"password"];
    
    [[self sharedHttpSessionManager] GET:url parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        NSLog(@"%@", result);

        [defaults setObject:result[@"s"] forKey:@"salt"];
        
        successBlock();
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failedBlock(error);
    }];
    
}

+(void)loginWithPhoneNum:(NSString *)phoneNum vertifyCode:(NSString *)vertifyCode successBlock:(void (^)())successBlock failBlock:(void (^)(NSError *error))failedBlock{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    //计算key = md5(phone + md5(password + salt))
    NSString *salt = [defaults objectForKey:@"salt"];
    NSString *passwordSalt = [NSString stringWithFormat:@"%@%@", vertifyCode, salt];
    NSString *passwordSaltMd5 = [passwordSalt MD5];
    NSString *str = [NSString stringWithFormat:@"%@%@", phoneNum, passwordSaltMd5];
    NSString *key = [str MD5];
    [defaults setObject:key forKey:@"key"];
    
    NSString *url = [self getRequestUrl:@"login"];
    
    [[self sharedHttpSessionManager] GET:url parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject: %@", responseObject);
        successBlock();
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failedBlock(error);
    }];
}



@end
