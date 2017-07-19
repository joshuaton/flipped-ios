//
//  FLAFHTTPSessionManager.m
//  Flipped
//
//  Created by ShaoJun on 2017/7/15.
//  Copyright © 2017年 junshao. All rights reserved.
//

#import "FLAFHTTPSessionManager.h"
#import "NSString+Base64.h"
#include <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>
#import "FLLoginViewController.h"
#import "FLBaseViewController.h"
#import "FLToast.h"

@implementation FLAFHTTPSessionManager

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                      success:(void (^)(NSURLSessionDataTask * task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure{
    

    [self calTokenWithURL:URLString method:@"GET" parameters:parameters];
    
    return [self GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {} success:success failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self handleStatusCode:task];
        [self handleError:error];
        
        if(failure){
            NSLog(@"http response error: %@", error);
            failure(task, error);
        }
    }];
}

-(NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure{
    
    [self calTokenWithURL:URLString method:@"POST" parameters:parameters];
    
    return [self POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {} success:success failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self handleStatusCode:task];
        [self handleError:error];
        
        if(failure){
            failure(task, error);
        }
    }];
}

#pragma mark - private

-(void)calTokenWithURL:(NSString *)urlStr method:(NSString *)method parameters:(NSMutableDictionary *)parameters{
    
    //uid
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uid = [defaults objectForKey:@"x-uid"];
    [self.requestSerializer setValue:uid forHTTPHeaderField:@"x-uid"];
    
    //获取本地毫秒数ts
    NSTimeInterval nowtime = [[NSDate date] timeIntervalSince1970]*1000;
    long long theTime = [[NSNumber numberWithDouble:nowtime] longLongValue];
    NSString *ts = [NSString stringWithFormat:@"%llu",theTime];
    NSLog(@"ts: %@", ts);
    
    //随机值rd
    NSInteger rd = arc4random() % 10000;
    NSLog(@"rd: %ld", rd);
    
    //请求uri
    NSString *uri = [NSString stringWithFormat:@"/%@", urlStr];
    
    //body
    NSString *body = @"";
    if([method isEqualToString:@"POST"]){
        NSData *tmpData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
        body = [[NSString alloc] initWithData:tmpData encoding:NSUTF8StringEncoding];
    }
    
    //key
    NSString *key = [defaults objectForKey:@"key"];
    NSLog(@"hmacsha1 key: %@", key);
    if(!key || key.length == 0){
        return;
    }
    
    //计算signature = base64(hmacsha1(key, phone + ts + rd + method + uri + body))
    NSString *str = [NSString stringWithFormat:@"%@%@%ld%@%@%@", uid, ts, rd, method, uri, body];
    NSLog(@"hmacsha1 value: %@", str);
    NSString *signature = [self hmacSha1AndBase64:key text:str];
    
    //计算token = base64(jsonencode({"ts": ts, "rd": rd, "sign": signature}))
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict[@"ts"] = ts;
    dict[@"rd"] = [NSString stringWithFormat:@"%ld", rd];
    dict[@"sign"] = signature;
    
    NSData *data=[NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
    NSString *json=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"json: %@", json);
    
    NSString *token = [json base64EncodedString];
    NSLog(@"token: %@", token);
    
    [self.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
}

- (NSString *)hmacSha1AndBase64:(NSString*)key text:(NSString*)text{
    
    const char *cKey  = [key cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [text cStringUsingEncoding:NSUTF8StringEncoding];
    uint8_t cHMAC[CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSMutableData * writer = [[NSMutableData alloc] init];
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++){
        uint8_t value = cHMAC[i];
        NSData *data = [NSData dataWithBytes: &value length: sizeof(value)];
        [data getBytes: &value length: sizeof(value)];
        [writer appendData:data];
    }
    return [writer base64EncodedStringWithOptions:0];
}

- (void)handleStatusCode:(NSURLSessionDataTask *)task{
    
    NSInteger statusCode = 0;
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
    statusCode = httpResponse.statusCode;
    
    if(statusCode == 401){
        
        FLLoginViewController *vc = [[FLLoginViewController alloc] init];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
        [[FLBaseViewController currentViewController] presentViewController:navi animated:YES completion:nil];
        return;
    }
    
    if(statusCode != 200){
        NSError *error = task.error;
        NSLog(@"statusCode : %ld error: %@", statusCode, error);
    }
}

-(void)handleError:(NSError *)error{
    NSData *data = error.userInfo[@"com.alamofire.serialization.response.error.data"];
    if(data){
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        [FLToast showToast:json[@"err"]];
        NSLog(@"http respnose error: %@", json[@"err"]);
    }

}


@end
