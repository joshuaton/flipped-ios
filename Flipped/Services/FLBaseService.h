//
//  FLBaseService.h
//  Flipped
//
//  Created by ShaoJun on 2017/7/15.
//  Copyright © 2017年 junshao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface FLBaseService : NSObject

+(NSString *)getRequestUrl:(NSString *)path;

+(void)handleStatusCode:(NSURLSessionDataTask *)task;

@end
