//
//  FLFlippedCallsService.m
//  Flipped
//
//  Created by junshao on 2017/9/5.
//  Copyright © 2017年 junshao. All rights reserved.
//

#import "FLFlippedCallsService.h"

@implementation FLFlippedCallsService

+(void)getFlippedCallWithSuccessBlock:(void (^)(NSString *uid, NSInteger callTimeout, NSInteger waitTimeout))successBlock failBlock:(void (^)(NSError *error))failedBlock{
    
//    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
//    dict[@"gender"] = @1;
//    dict[@"target_gender"] = @1;
    
    [[self sharedHttpSessionManager] FLPOST:@"flippedcalls" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        successBlock(result[@"uid"], [result[@"call_timeout"] integerValue], [result[@"wait_timeout"] integerValue]);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failedBlock(error);
    }];
}

+(void)quitFlippedCallWithSuccessBlock:(void (^)())successBlock failBlock:(void (^)(NSError *error))failedBlock{
    [[self sharedHttpSessionManager] FLDELETE:@"flippedcalls" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        successBlock();
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failedBlock(error);
    }];
}

@end
