//
//  FLFlippedWordsService.h
//  Flipped
//
//  Created by junshao on 2017/7/5.
//  Copyright © 2017年 junshao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLFlippedWordsService : NSObject

+(void)getNearbyFlippedWordsWithSuccessBlock:(void (^)(NSMutableArray *flippedWords))successBlock failBlock:(void (^)(NSError *error))failedBlock;

@end
