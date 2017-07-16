//
//  FLFlippedWordsService.m
//  Flipped
//
//  Created by junshao on 2017/7/5.
//  Copyright © 2017年 junshao. All rights reserved.
//

#import "FLFlippedWordsService.h"
#import "FLFlippedWord.h"
#import "FLLoginViewController.h"
#import "FLCommHeader.h"

@implementation FLFlippedWordsService


+(void)getNearbyFlippedWordsWithSuccessBlock:(void (^)(NSMutableArray *flippedWords))successBlock failBlock:(void (^)(NSError *error))failedBlock{
    
    NSString *url = [self getRequestUrl:@"nearby_flippedwords"];
    [[self sharedHttpSessionManager] GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        NSError *error;
        NSMutableArray *modelArray = [FLFlippedWord arrayOfModelsFromDictionaries:result[@"flippedwords"] error:&error];
        
        successBlock(modelArray);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failedBlock(error);
    }];
    
}

+(void)getSendFlippedWordsWithSuccessBlock:(void (^)(NSMutableArray *flippedWords))successBlock failBlock:(void (^)(NSError *error))failedBlock{
    
    NSString *url = [self getRequestUrl:@"mypub_flippedwords"];
    [[self sharedHttpSessionManager] GET:url parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        NSError *error;
        NSMutableArray *modelArray = [FLFlippedWord arrayOfModelsFromDictionaries:result[@"flippedwords"] error:&error];
        
        successBlock(modelArray);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failedBlock(error);
    }];
}

+(void)getReceiveFlippedWordsWithSuccessBlock:(void (^)(NSMutableArray *flippedWords))successBlock failBlock:(void (^)(NSError *error))failedBlock{
    
    NSString *url = [self getRequestUrl:@"my_flippedwords"];
    [[self sharedHttpSessionManager] GET:url parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        NSError *error;
        NSMutableArray *modelArray = [FLFlippedWord arrayOfModelsFromDictionaries:result[@"flippedwords"] error:&error];
        
        successBlock(modelArray);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failedBlock(error);
    }];

}

+(void)publishFlippedWordsWithData:(FLFlippedWord *)data successBlock:(void (^)())successBlock failBlock:(void (^)(NSError *error))failedBlock{
    
    NSString *url = [self getRequestUrl:@"flippedwords"];
    
    NSDictionary *dict = [data toDictionary];
    
    [[self sharedHttpSessionManager] POST:url parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable error) {
        successBlock();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error ) {
        failedBlock(error);
    }];
}

@end
