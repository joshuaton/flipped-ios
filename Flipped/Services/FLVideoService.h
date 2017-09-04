//
//  FLVideoService.h
//  Flipped
//
//  Created by ShaoJun on 2017/9/4.
//  Copyright © 2017年 junshao. All rights reserved.
//

#import "FLBaseService.h"

@interface FLVideoService : FLBaseService

+(void)getSigWithSuccessBlock:(void (^)(NSString *sig))successBlock failBlock:(void (^)(NSError *error))failedBlock;

@end
