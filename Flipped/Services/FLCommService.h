//
//  FLCommService.h
//  Flipped
//
//  Created by ShaoJun on 2017/8/1.
//  Copyright © 2017年 junshao. All rights reserved.
//

#import "FLBaseService.h"

@interface FLCommService : FLBaseService

+(void)requestWithURI:(NSString *)uri method:(NSString *)method params:(NSDictionary *)params successBlock:(void (^)())successBlock failBlock:(void (^)(NSError *error))failedBlock;


@end
