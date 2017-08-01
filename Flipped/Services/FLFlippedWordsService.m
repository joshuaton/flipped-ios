//
//  FLFlippedWordsService.m
//  Flipped
//
//  Created by junshao on 2017/7/5.
//  Copyright © 2017年 junshao. All rights reserved.
//

#import "FLFlippedWordsService.h"
#import "FLFlippedWord.h"
#import "FLCommHeader.h"

@implementation FLFlippedWordsService


+(void)getNearbyFlippedWordsWithSuccessBlock:(void (^)(NSMutableArray *flippedWords))successBlock failBlock:(void (^)(NSError *error))failedBlock{
    
    [[self sharedHttpSessionManager] FLGET:@"nearby_flippedwords" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *result = (NSDictionary *)responseObject;
        NSError *error;
        NSMutableArray *modelArray = [FLFlippedWord arrayOfModelsFromDictionaries:result[@"flippedwords"] error:&error];
        
        successBlock(modelArray);

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failedBlock(error);
    }];
    
}

+(void)getSendFlippedWordsWithSuccessBlock:(void (^)(NSMutableArray *flippedWords))successBlock failBlock:(void (^)(NSError *error))failedBlock{
    
    [[self sharedHttpSessionManager] FLGET:@"mypub_flippedwords" parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        NSError *error;
        NSMutableArray *modelArray = [FLFlippedWord arrayOfModelsFromDictionaries:result[@"flippedwords"] error:&error];
        
        successBlock(modelArray);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failedBlock(error);
    }];
}

+(void)getReceiveFlippedWordsWithSuccessBlock:(void (^)(NSMutableArray *flippedWords))successBlock failBlock:(void (^)(NSError *error))failedBlock{
    
    [[self sharedHttpSessionManager] FLGET:@"my_flippedwords" parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        NSError *error;
        NSMutableArray *modelArray = [FLFlippedWord arrayOfModelsFromDictionaries:result[@"flippedwords"] error:&error];
        
        successBlock(modelArray);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failedBlock(error);
    }];

}

+(void)publishFlippedWordsWithData:(FLFlippedWord *)data successBlock:(void (^)())successBlock failBlock:(void (^)(NSError *error))failedBlock{
        
    NSDictionary *dict = [data toDictionary];
    
    [[self sharedHttpSessionManager] FLPOST:@"flippedwords" parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable error) {
        successBlock();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error ) {
        failedBlock(error);
    }];
}

+(void)getFlippedWordsDetailWithId:(NSString *)flippedId successBlock:(void (^)(FLFlippedWord *data))successBlock failBlock:(void (^)(NSError *error))failedBlock{
    
    NSString *url = [NSString stringWithFormat:@"flippedwords/%@", flippedId];
    
    [[self sharedHttpSessionManager] FLGET:url parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        NSError *error;
        NSMutableArray *modelArray = [FLFlippedWord arrayOfModelsFromDictionaries:@[result] error:&error];
        
        successBlock(modelArray[0]);
    } failure:^(NSURLSessionDataTask * _Nullable task , NSError * _Nonnull error) {
        failedBlock(error);
    }];
    
}

@end
