//
//  FLAFHTTPSessionManager.h
//  Flipped
//
//  Created by ShaoJun on 2017/7/15.
//  Copyright © 2017年 junshao. All rights reserved.
//

#import "AFNetworking.h"

@interface FLAFHTTPSessionManager : AFHTTPSessionManager

- (NSURLSessionDataTask *)FLGET:(NSString *)URLString
                   parameters:(id)parameters
                      success:(void (^)(NSURLSessionDataTask * task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure;

-(NSURLSessionDataTask *)FLPOST:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure;

-(NSURLSessionDataTask *)FLDELETE:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure;

@end
