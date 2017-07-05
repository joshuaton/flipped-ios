//
//  FLFlippedWordsService.m
//  Flipped
//
//  Created by junshao on 2017/7/5.
//  Copyright © 2017年 junshao. All rights reserved.
//

#import "FLFlippedWordsService.h"
#import "AFNetworking.h"

@implementation FLFlippedWordsService

+(void)getNearbyFlippedWords{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"18923881572" forHTTPHeaderField:@"x-user"];
    [manager.requestSerializer setValue:@"Authorization" forHTTPHeaderField:@"Authorization"];
    
    manager.responseSerializer.acceptableContentTypes= [NSSet setWithObjects:@"text/html", nil];
    
    [manager GET:@"https://flippedwords.com/nearby_flippedwords" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSInteger statusCode = 0;
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        statusCode = httpResponse.statusCode;
        
        NSLog(@"statusCode: %ld", statusCode);
    }];
    
}

@end
