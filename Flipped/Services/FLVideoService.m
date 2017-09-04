//
//  FLVideoService.m
//  Flipped
//
//  Created by ShaoJun on 2017/9/4.
//  Copyright © 2017年 junshao. All rights reserved.
//

#import "FLVideoService.h"

@implementation FLVideoService

+(void)getSigWithSuccessBlock:(void (^)(NSString *sig))successBlock failBlock:(void (^)(NSError *error))failedBlock{
    
    [[self sharedHttpSessionManager] FLGET:@"ilvbsig" parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *result = (NSDictionary *)responseObject;
        NSString *sig = result[@"sig"];
        successBlock(sig);

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failedBlock(error);
    }];
}

@end
