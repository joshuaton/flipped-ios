//
//  FLHelpService.h
//  Flipped
//
//  Created by ShaoJun on 2017/7/23.
//  Copyright © 2017年 junshao. All rights reserved.
//

#import "FLBaseService.h"

@interface FLHelpService : FLBaseService

+(void)getHelpContentWithSuccessBlock:(void (^)(NSMutableArray *contents))successBlock failBlock:(void (^)(NSError *error))failedBlock;



@end
