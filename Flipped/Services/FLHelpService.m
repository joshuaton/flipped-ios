//
//  FLHelpService.m
//  Flipped
//
//  Created by ShaoJun on 2017/7/23.
//  Copyright © 2017年 junshao. All rights reserved.
//

#import "FLHelpService.h"
#import "FLContent.h"

@implementation FLHelpService

+(void)getHelpContentWithSuccessBlock:(void (^)(NSMutableArray *contents))successBlock failBlock:(void (^)(NSError *error))failedBlock{
    
    [[self sharedHttpSessionManager] GET:@"help" parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        NSError *error;
        NSMutableArray *modelArray = [FLContent arrayOfModelsFromDictionaries:result[@"contents"] error:&error];
        
        successBlock([modelArray copy]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failedBlock(error);
    }];
}


@end

