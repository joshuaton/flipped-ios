//
//  CPShareManager.h
//  CampusIOS
//
//  Created by Terry on 15/10/10.
//  Copyright © 2015年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CPShareEntity.h"

#if !TARGET_IPHONE_SIMULATOR
#import "WXApiObject.h"
#import "WXApi.h"
extern NSInteger callLoginType;
#endif

#define OpenAPIAPPID            TencentOpenAppid

#define ShareThumbImage                    @"logo"
#define ShareResultNotification            @"ShareResultNotification"
#define ShareSuccessStr                    @"0"
#define ShareFailedStr                     @"-1"
#define ShareCanceledStr                   @"1"

/**
 *  分享回调
 *
 *  @param resultCode 分享结果码 -1：失败   0.成功    1.取消
 */
typedef void(^ShareCompletionBlock)(NSInteger resultCode, CPShareEntity *model);

/**
 *  最终要分享之前的回调
 *
 *  @param model 分享数据
 *  @param plat  分享平台，注意当为站内分享时，通过willShareBlock进行数据传递，且不会执行ShareCompletionBlock回调
 */
typedef void(^WillShareBlock)(CPShareEntity *model, SharePlat plat);

@interface CPShareManager : NSObject

@property (nonatomic, assign) SharePlat             plat;
@property (nonatomic, strong) NSArray               *shareItems;
@property (nonatomic, strong) NSString              *title;

+ (CPShareManager*)shareInstance;

/**
 *  能否分享
 *
 *  @return 能否分享
 */
+ (BOOL)canShare;

+ (BOOL)isWXAppInstalled;

/**
 *  自定义界面时，点击分享平台按钮时候调用的接口， 调用之前需要先判断是否可以分享
 *
 *  @param model           分享内容
 *  @param sharePlat       分享平台
 *  @param completionBlock 分享完成的block（包括分享失败，成功，取消）
 */
- (void)share:(CPShareEntity*)model toPlat:(SharePlat)sharePlat shareCompletionBlock:(ShareCompletionBlock)completionBlock;

@end
