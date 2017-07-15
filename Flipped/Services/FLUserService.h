//
//  FLUserService.h
//  Flipped
//
//  Created by ShaoJun on 2017/7/15.
//  Copyright © 2017年 junshao. All rights reserved.
//

#import "FLBaseService.h"

@interface FLUserService : FLBaseService

+(void)getVertifyCodeWithWithPhoneNum:(NSString *)phoneNum successBlock:(void (^)())successBlock failBlock:(void (^)(NSError *error))failedBlock;

+(void)loginWithPhoneNum:(NSString *)phoneNum vertifyCode:(NSString *)vertifyCode successBlock:(void (^)())successBlock failBlock:(void (^)(NSError *error))failedBlock;

@end
