//
//  FLFlippedWordsService.h
//  Flipped
//
//  Created by junshao on 2017/7/5.
//  Copyright © 2017年 junshao. All rights reserved.
//

#import "FLBaseService.h"
#import "FLFlippedWord.h"

@interface FLFlippedWordsService : FLBaseService

+(void)getNearbyFlippedWordsWithSuccessBlock:(void (^)(NSMutableArray *flippedWords))successBlock failBlock:(void (^)(NSError *error))failedBlock;

+(void)getSendFlippedWordsWithSuccessBlock:(void (^)(NSMutableArray *flippedWords))successBlock failBlock:(void (^)(NSError *error))failedBlock;

+(void)getReceiveFlippedWordsWithSuccessBlock:(void (^)(NSMutableArray *flippedWords))successBlock failBlock:(void (^)(NSError *error))failedBlock;

+(void)publishFlippedWordsWithData:(FLFlippedWord *)data successBlock:(void (^)())successBlock failBlock:(void (^)(NSError *error))failedBlock;

+(void)getFlippedWordsDetailWithId:(NSString *)flippedId successBlock:(void (^)(FLFlippedWord *data))successBlock failBlock:(void (^)(NSError *error))failedBlock;

+(void)commentFlippedWordWithId:(NSString *)flippedId content:(NSString *)contentStr successBlock:(void (^)())successBlock failBlock:(void (^)(NSError *error))failedBlock;

+(void)getCommentsWithId:(NSString *)flippedId successBlock:(void (^)(NSArray *comments))successBlock failBlock:(void (^)(NSError *error))failedBlock;

@end
