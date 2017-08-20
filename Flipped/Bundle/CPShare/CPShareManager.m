//
//  CPShare.m
//  CampusIOS
//
//  Created by Terry on 15/10/10.
//  Copyright © 2015年 Tencent. All rights reserved.
//

#import "CPShareManager.h"
#import "WXApi.h"

NSInteger callLoginType;

@interface CPShareManager()<CPShareDelegate>
@property (nonatomic, copy) ShareCompletionBlock completionBlock;
@property (nonatomic, strong) CPShareEntity *model;
@property (nonatomic, copy) WillShareBlock willShareBlock;
@property (nonatomic, assign) NSInteger resultCode;
@end

@implementation CPShareManager
+ (CPShareManager*)shareInstance
{
    static CPShareManager *shareManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[CPShareManager alloc] init];
    });
    return shareManager;
}

+ (BOOL)canShare {
    if (![WXApi isWXAppInstalled]) {
        return NO;
    } else {
        return YES;
    }
}

+ (BOOL)isWXAppInstalled{
    return [WXApi isWXAppInstalled];
}
#pragma mark - public interface

- (void)share:(CPShareEntity*)entity toPlat:(SharePlat)sharePlat shareCompletionBlock:(ShareCompletionBlock)completionBlock {
    if (entity.previewImageUrl.length == 0) {
        entity.previewImageUrl = @"https://campus-10046755.file.myqcloud.com/logo/logo.png";
    }
    
    self.completionBlock = completionBlock;
    if (sharePlat == WXSession ||sharePlat == WXTimeline) {
        //WX分享
#if !TARGET_IPHONE_SIMULATOR
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareResult:) name:ShareResultNotification object:nil];
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = entity.title;
        message.description = entity.desc;
        //压缩分享的缩略图
        if (entity.previewImageUrl) {
            entity.previewImageUrl = [entity.previewImageUrl stringByReplacingOccurrencesOfString:@"http://" withString:@"https://"];
            UIImage *thumImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:entity.previewImageUrl]]];
            if (thumImage == nil) {
                thumImage = [UIImage imageNamed:@"logo"];
            }
            
            NSData *thumData = UIImageJPEGRepresentation(thumImage, 1);
            NSUInteger length = thumData.length;
            CGFloat rate = 0.5;
            while (length > (32 * 1024)) {//微信分享规范，缩略图不能大于32k
                thumImage = [thumImage tiledScaleImageWithSize:CGSizeMake(512, 512) scale:1.0];
                thumData = UIImageJPEGRepresentation(thumImage, rate);
                if (ABS((length - thumData.length)) < (5 * 1024)) {//两次压缩效果已经不明显了，停止压缩
                    break;
                }
                rate *= 0.5;
                length = thumData.length;
            }
            if(thumData.length > (32 * 1024)){//压缩完之后依然大于32k，就直接用logo图替代
                thumData = UIImageJPEGRepresentation([UIImage imageNamed:@"logo"], 1);
            }
            [message setThumbData:thumData];
        }
        else{
            [message setThumbImage:[UIImage imageNamed:ShareThumbImage]];
        }
        WXWebpageObject *ext = [WXWebpageObject object];
        ext.webpageUrl = entity.contentUrl;
        message.mediaObject = ext;
        
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        req.scene = sharePlat == WXSession?WXSceneSession:WXSceneTimeline;
        
        [WXApi sendReq:req];
#endif
    }
    
}

-(void)shareResult:(NSNotification *)notification {
    NSString *result = [notification object];
    self.resultCode = [result integerValue];
    if (self.completionBlock) {
        self.completionBlock(self.resultCode, _model);
        self.completionBlock = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    int resultCode;
    switch (resp.errCode) {
        case -2:
            resultCode = 1;
            break;
        case 0:
            resultCode = 0;
            break;
        default:
            resultCode = -1;
            break;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ShareResultNotification object:[NSString stringWithFormat:@"%d", resultCode]];
}

@end
