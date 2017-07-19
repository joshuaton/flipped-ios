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

+(FLUserInfoManager *)sharedHttpSessionManager;
-(BOOL)checkLogin;

@end
