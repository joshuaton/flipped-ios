//
//  FLUserService.m
//  Flipped
//
//  Created by ShaoJun on 2017/7/15.
//  Copyright © 2017年 junshao. All rights reserved.
//

#import "FLUserService.h"

@implementation FLUserService

+(void)getVertifyCodeWithWithPhoneNum:(NSString *)phoneNum successBlock:(void (^)())successBlock failBlock:(void (^)(NSError *error))failedBlock{
    
    NSString *url = [self getRequestUrl:@"srp/password"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"phone"] = phoneNum;
    
    [[AFHTTPSessionManager manager] GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        NSError *error;
        NSLog(@"%@", result);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self handleStatusCode:task];
        failedBlock(error);
    }];
    
}

@end
