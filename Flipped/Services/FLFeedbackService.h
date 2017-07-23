//
//  FLFeedbackService.h
//  Flipped
//
//  Created by ShaoJun on 2017/7/23.
//  Copyright © 2017年 junshao. All rights reserved.
//

#import "FLBaseService.h"

@interface FLFeedbackService : FLBaseService

+(void)publishFeedbackWithData:(NSString *)contentStr successBlock:(void (^)())successBlock failBlock:(void (^)(NSError *error))failedBlock;


@end
