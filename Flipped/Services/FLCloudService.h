//
//  FLCloudService.h
//  Flipped
//
//  Created by ShaoJun on 2017/7/18.
//  Copyright © 2017年 junshao. All rights reserved.
//

#import "FLBaseService.h"

@interface FLCloudService : FLBaseService

+(void)getYoutuSigWithSuccessBlock:(void (^)(NSString *))successBlock failBlock:(void (^)(NSError *error))failedBlock;

@end
