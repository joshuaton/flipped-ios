//
//  FLCloudService.m
//  Flipped
//
//  Created by ShaoJun on 2017/7/18.
//  Copyright © 2017年 junshao. All rights reserved.
//

#import "FLCloudService.h"

@implementation FLCloudService

+(void)getYoutuSigWithSuccessBlock:(void (^)(NSString *sig))successBlock failBlock:(void (^)(NSError *error))failedBlock{
    
    NSString *url = [NSString stringWithFormat:@"youtusig?fileid=/1251789367/flipped/test/a.jpg"];
    
    [[self sharedHttpSessionManager] GET:url parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *result = (NSDictionary *)responseObject;
        successBlock(result[@"sig"]);
        NSLog(@"youtu sig success: %@", result[@"sig"]);
        
        [[self sharedHttpSessionManager].requestSerializer setValue:result[@"sig"] forHTTPHeaderField:@"Authorization"];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failedBlock(error);
    }];
}

+(void)uploadImage:(UIImage *)image withSuccessBlock:(void (^)(NSString *url))successBlock failBlock:(void (^)(NSError *error))failedBlock{
    
    NSString *url = @"https://gz.file.myqcloud.com/files/v2/1251789367/flipped/images";
    //todo https://qcloud.com/document/api/436/6066
    //上传图片有问题
    
    [[AFHTTPSessionManager manager] POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    
        [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 1) name:@"filecontent" fileName:@"image.jpg" mimeType:@"image/jpeg"];
        
 
    } progress:nil success:^(NSURLSessionDataTask *task, id responseObject){
        NSLog(@"upload image success %@", responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
//        //如果是auth过期 重新请求auth并重新upload
//        NSData* data = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
//        NSDictionary* dict = data?[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]:nil;
//        if([dict[@"code"] integerValue] == -96){
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                NSLog(@"auth过期，重新申请");
//                NSURLSessionTask* old_task = task;
//                [manager.requestSerializer setValue:[self getAuthorization:YES] forHTTPHeaderField:@"Authorization"];
//                //重新上传
//                [self uploadImage:image manager:manager needToPress:press successBlock:^(NSURLSessionTask * _Nonnull task, id  _Nullable responseObject) {
//                    if(successBlock) successBlock(old_task,responseObject);
//                } failedBlock:failedBlock];
//            });
//            return;
//        }
//        else if([dict[@"code"] integerValue] == -70){
//            [[NSUserDefaults standardUserDefaults] removeObjectForKey:Authorization];
//        }
        failedBlock(error);
    }];
}

@end
