//
//  FLBaseService.m
//  Flipped
//
//  Created by ShaoJun on 2017/7/15.
//  Copyright © 2017年 junshao. All rights reserved.
//

#import "FLBaseService.h"
#import <CommonCrypto/CommonDigest.h>

static FLAFHTTPSessionManager *manager;

@implementation FLBaseService

+(FLAFHTTPSessionManager *)sharedHttpSessionManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSURL *baseURL = [NSURL URLWithString:@"https://flippedwords.com/"];
        
        manager = [[FLAFHTTPSessionManager alloc] initWithBaseURL:baseURL];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes= [NSSet setWithObjects:@"text/html", @"application/json", nil];
        

    });
    
    return manager;
}



@end
