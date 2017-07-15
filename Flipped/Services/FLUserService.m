//
//  FLUserService.m
//  Flipped
//
//  Created by ShaoJun on 2017/7/15.
//  Copyright © 2017年 junshao. All rights reserved.
//

#import "FLUserService.h"
#import "NSString+MD5.h"
#include <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>
#import "NSString+Base64.h"


@implementation FLUserService

+(void)getVertifyCodeWithWithPhoneNum:(NSString *)phoneNum successBlock:(void (^)())successBlock failBlock:(void (^)(NSError *error))failedBlock{
    
    [[self sharedHttpSessionManager].requestSerializer setValue:phoneNum forHTTPHeaderField:@"x-uid"];

    NSString *url = [self getRequestUrl:@"password"];
    
    [[self sharedHttpSessionManager] GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        NSLog(@"%@", result);

        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:result[@"s"] forKey:@"salt"];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self handleStatusCode:task];
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
    NSLog(@"hmacsha1 key: %@", key);
    
    //请求uri
    NSString *url = [self getRequestUrl:@"login"];
    
    //获取本地毫秒数ts
    NSTimeInterval nowtime = [[NSDate date] timeIntervalSince1970]*1000;
    long long theTime = [[NSNumber numberWithDouble:nowtime] longLongValue];
    NSString *ts = [NSString stringWithFormat:@"%llu",theTime];
    NSLog(@"ts: %@", ts);
    
    //随机值rd
    NSInteger rd = arc4random() % 10000;
    NSLog(@"rd: %ld", rd);
    
    //计算signature = base64(hmacsha1(key, phone + ts + rd + method + uri + body))
    str = [NSString stringWithFormat:@"%@%@%ld%@%@%@", phoneNum, ts, rd, @"GET", @"/login", @""];
    NSLog(@"hmacsha1 value: %@", str);
    str = [self hmacSha1:key text:str];
    NSString *signature = [str base64EncodedString];
    
    //计算token = base64(jsonencode({"ts": ts, "rd": rd, "sign": signature}))
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict[@"ts"] = ts;
    dict[@"rd"] = [NSString stringWithFormat:@"%ld", rd];
    dict[@"sign"] = signature;
    
    NSData *data=[NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
    NSString *json=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"json: %@", json);
    
    NSString *token = [json base64EncodedString];
    
    [[self sharedHttpSessionManager].requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    
    [[self sharedHttpSessionManager] GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        NSLog(@"%@", result);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self handleStatusCode:task];
        failedBlock(error);
    }];
}

+ (NSString *)hmacSha1:(NSString*)key text:(NSString*)text{
    
    const char *cKey  = [key cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [text cStringUsingEncoding:NSUTF8StringEncoding];
    uint8_t cHMAC[CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    NSString *hash;
//    NSMutableString * output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
//    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++){
//        [output appendFormat:@"%02x", cHMAC[i]];
//    }
//    hash = output;
    return hash;
}

@end
