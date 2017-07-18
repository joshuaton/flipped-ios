//
//  FLCloudService.h
//  Flipped
//
//  Created by ShaoJun on 2017/7/18.
//  Copyright © 2017年 junshao. All rights reserved.
//

#import "FLBaseService.h"

@interface FLCloudService : FLBaseService

+(void)getYoutuSigWithSuccessBlock:(void (^)(NSString *sig))successBlock failBlock:(void (^)(NSError *error))failedBlock;

+(void)uploadImage:(UIImage *)image withSuccessBlock:(void (^)(NSString *url))successBlock failBlock:(void (^)(NSError *error))failedBlock;

@end
