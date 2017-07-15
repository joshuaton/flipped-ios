//
//  FLBaseService.m
//  Flipped
//
//  Created by ShaoJun on 2017/7/15.
//  Copyright © 2017年 junshao. All rights reserved.
//

#import "FLBaseService.h"
#import "FLLoginViewController.h"
#import "FLBaseViewController.h"
#import <CommonCrypto/CommonDigest.h>

static AFHTTPSessionManager *manager;

@implementation FLBaseService

+(AFHTTPSessionManager *)sharedHttpSessionManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

        manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        //    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [manager.requestSerializer setValue:@"18923881572" forHTTPHeaderField:@"x-uid"];
        NSString *token = [defaults objectForKey:@"Authorization"];
        if(token && token.length > 0){
            [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
        }else{
            NSString *salt = [defaults objectForKey:@"salt"];
//            key = md5(phone + md5(password + salt))
            
        }
        
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes= [NSSet setWithObjects:@"text/html", @"application/json", nil];
    });
    
    return manager;
}

+(NSString *)getRequestUrl:(NSString *)path{
    return [NSString stringWithFormat:@"http://119.29.156.112/%@", path];
}

+(void)handleStatusCode:(NSURLSessionDataTask *)task{
    
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
        NSLog(@"statusCode : %ld", statusCode);
    }
}


- (NSString *)MD5:(NSString *)mdStr
{
    const char *original_str = [mdStr UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}

@end
