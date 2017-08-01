//
//  FLCloudService.m
//  Flipped
//
//  Created by ShaoJun on 2017/7/18.
//  Copyright © 2017年 junshao. All rights reserved.
//

#import "FLCloudService.h"

@implementation FLCloudService

/**
 上传图片
 腾讯云文档 https://qcloud.com/document/api/436/6066

 @param image 图片UIImage
 @param successBlock 成功回调
 @param failedBlock 失败回调
 */
+(void)uploadImage:(UIImage *)image withSuccessBlock:(void (^)(NSString *url))successBlock failBlock:(void (^)(NSError *error))failedBlock{
    
    UInt64 currentTime = [[NSDate date] timeIntervalSince1970]*1000;
    NSString *filePathName = [NSString stringWithFormat:@"/1251789367/flipped/images/%llu.jpg", currentTime];
    
    NSString *sigUrl = [NSString stringWithFormat:@"youtusig?fileid=%@", filePathName];
    NSString *uploadUrl = [NSString stringWithFormat:@"https://gz.file.myqcloud.com/files/v2%@", filePathName];
    
    [[self sharedHttpSessionManager] FLGET:sigUrl parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *result = (NSDictionary *)responseObject;
        NSString *sig = result[@"sig"];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager.requestSerializer setValue:sig forHTTPHeaderField:@"Authorization"];
        
        [manager POST:uploadUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            NSMutableDictionary *mutableHeaders = [NSMutableDictionary dictionary];
            NSString *str = @"upload";
            NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
            [mutableHeaders setValue:[NSString stringWithFormat:@"form-data; name=\"op\""] forKey:@"Content-Disposition"];
            [formData appendPartWithHeaders:mutableHeaders body:data];
            
            [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 1) name:@"filecontent" fileName:@"image.jpg" mimeType:@"image/jpeg"];
            
            
        } progress:nil success:^(NSURLSessionDataTask *task, id responseObject){
            NSLog(@"upload image success %@", responseObject);
            NSString *picUrl = responseObject[@"data"][@"access_url"];
            successBlock(picUrl);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failedBlock(error);
        }];

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failedBlock(error);
    }];
}

@end
