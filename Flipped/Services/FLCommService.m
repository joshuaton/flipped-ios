//
//  FLCommService.m
//  Flipped
//
//  Created by ShaoJun on 2017/8/1.
//  Copyright © 2017年 junshao. All rights reserved.
//

#import "FLCommService.h"

@implementation FLCommService

+(void)requestWithURI:(NSString *)uri method:(NSString *)method params:(NSDictionary *)params successBlock:(void (^)())successBlock failBlock:(void (^)(NSError *error))failedBlock{
    
    if([uri hasPrefix:@"/"]){
        uri = [uri substringFromIndex:1];
    }
    
    if([method isEqualToString:@"POST"]){
        
        [[self sharedHttpSessionManager] FLPOST:uri parameters:params success:successBlock failure:^(NSURLSessionDataTask *task, NSError *error) {
            if(failedBlock){
                failedBlock(error);
            }
        }];
        
    }else if([method isEqualToString:@"DELETE"]){
        
        [[self sharedHttpSessionManager] FLDELETE:uri parameters:params success:successBlock failure:^(NSURLSessionDataTask *task, NSError *error) {
            if(failedBlock){
                failedBlock(error);
            }
        }];
        
    }
}

@end
