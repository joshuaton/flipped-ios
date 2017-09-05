//
//  FLBaseService.h
//  Flipped
//
//  Created by ShaoJun on 2017/7/15.
//  Copyright © 2017年 junshao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FLAFHTTPSessionManager.h"

@interface FLBaseService : NSObject

+(FLAFHTTPSessionManager *)sharedHttpSessionManager;

@end
