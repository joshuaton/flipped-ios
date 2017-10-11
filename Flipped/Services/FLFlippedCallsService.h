//
//  FLFlippedCallsService.h
//  Flipped
//
//  Created by junshao on 2017/9/5.
//  Copyright © 2017年 junshao. All rights reserved.
//

#import "FLBaseService.h"

@interface FLFlippedCallsService : FLBaseService

+(void)getFlippedCallWithSuccessBlock:(void (^)(NSString *uid, NSInteger callTimeout, NSInteger waitTimeout))successBlock failBlock:(void (^)(NSError *error))failedBlock;

+(void)quitFlippedCallWithSuccessBlock:(void (^)())successBlock failBlock:(void (^)(NSError *error))failedBlock;

@end
