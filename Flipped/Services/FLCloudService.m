//
//  FLCloudService.m
//  Flipped
//
//  Created by ShaoJun on 2017/7/18.
//  Copyright © 2017年 junshao. All rights reserved.
//

#import "FLCloudService.h"

@implementation FLCloudService

+(void)getYoutuSigWithSuccessBlock:(void (^)(NSString *))successBlock failBlock:(void (^)(NSError *error))failedBlock{
    
    NSString *url = [NSString stringWithFormat:@"youtusig?fileid=/1251789367/flipped/test/a.jpg"];
    
    [[self sharedHttpSessionManager] GET:url parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *result = (NSDictionary *)responseObject;
        successBlock(result[@"sig"]);
        NSLog(@"youtu sig success: %@", result[@"sig"]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failedBlock(error);
    }];
}

@end
