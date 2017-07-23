//
//  FLFeedbackService.m
//  Flipped
//
//  Created by ShaoJun on 2017/7/23.
//  Copyright © 2017年 junshao. All rights reserved.
//

#import "FLFeedbackService.h"
#import "FLContent.h"

@implementation FLFeedbackService

+(void)publishFeedbackWithData:(NSString *)contentStr successBlock:(void (^)())successBlock failBlock:(void (^)(NSError *error))failedBlock{
    
    FLContent *content = [[FLContent alloc] init];
    content.type = @"text";
    content.text = contentStr;
    NSMutableArray *modelArray = [FLContent arrayOfDictionariesFromModels:@[content]];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict[@"contents"] = modelArray;
    
    [[self sharedHttpSessionManager] POST:@"feedbacks" parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable error) {
        successBlock();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error ) {
        failedBlock(error);
    }];

}

@end

