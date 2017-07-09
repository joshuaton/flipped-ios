//
//  FLFlippedWordsService.m
//  Flipped
//
//  Created by junshao on 2017/7/5.
//  Copyright © 2017年 junshao. All rights reserved.
//

#import "FLFlippedWordsService.h"
#import "AFNetworking.h"
#import "FLFlippedWord.h"

@implementation FLFlippedWordsService

+(void)getNearbyFlippedWordsWithSuccessBlock:(void (^)(NSMutableArray *flippedWords))successBlock failBlock:(void (^)(NSError *error))failedBlock{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"18923881572" forHTTPHeaderField:@"x-uid"];
    [manager.requestSerializer setValue:@"Authorization" forHTTPHeaderField:@"Authorization"];
    
    manager.responseSerializer.acceptableContentTypes= [NSSet setWithObjects:@"text/html", @"application/json", nil];
    
    [manager GET:@"http://119.29.156.112/nearby_flippedwords" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        NSError *error;
        NSMutableArray *modelArray = [FLFlippedWord arrayOfModelsFromDictionaries:result[@"flippedwords"] error:&error];
        
        successBlock(modelArray);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSInteger statusCode = 0;
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        statusCode = httpResponse.statusCode;
        
        failedBlock(error);
    }];
    
}

@end
