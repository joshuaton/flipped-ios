//
//  FLBaseService.m
//  Flipped
//
//  Created by ShaoJun on 2017/7/15.
//  Copyright © 2017年 junshao. All rights reserved.
//

#import "FLBaseService.h"
#import "FLLoginViewController.h"
#import "FLBaseViewController.h"

@implementation FLBaseService

+ (void)load{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"18923881572" forHTTPHeaderField:@"x-uid"];
    [manager.requestSerializer setValue:@"Authorization" forHTTPHeaderField:@"Authorization"];
    
    manager.responseSerializer.acceptableContentTypes= [NSSet setWithObjects:@"text/html", @"application/json", nil];
}

+(NSString *)getRequestUrl:(NSString *)path{
    return [NSString stringWithFormat:@"http://119.29.156.112/%@", path];
}

+(void)handleStatusCode:(NSURLSessionDataTask *)task{
    
    NSInteger statusCode = 0;
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
    statusCode = httpResponse.statusCode;
    
    if(statusCode == 401){
        
        FLLoginViewController *vc = [[FLLoginViewController alloc] init];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
        [[FLBaseViewController currentViewController] presentViewController:navi animated:YES completion:nil];
        return;
    }
}

@end
