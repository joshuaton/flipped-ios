//
//  FLUserInfoManager.h
//  Flipped
//
//  Created by ShaoJun on 2017/7/19.
//  Copyright © 2017年 junshao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLUserInfoManager : NSObject

@property (nonatomic, assign) BOOL login;
@property (nonatomic, copy) NSString *uid;

+(FLUserInfoManager *)sharedUserInfoManager;
-(BOOL)checkLogin; //判断登录，未登录弹出登录页
-(BOOL)isLogin; //只判断登录
+(BOOL)isTestAccount:(NSString *)account;

@end
