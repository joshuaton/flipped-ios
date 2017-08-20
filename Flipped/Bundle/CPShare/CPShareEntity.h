//
//  CPShareEntity.h
//  CampusIOS
//
//  Created by Terry on 15/10/10.
//  Copyright © 2015年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SharePlat) {
    ShareNone = 0,
    WXSession,
    WXTimeline,
    QQZone,
    QQSession,
    CopyURL,
    InApp
};

@protocol CPShareDelegate <NSObject>
@optional
- (void)shareView:(UIView *)view chooseSharePlat:(SharePlat)plat;
@end

@interface CPShareEntity : NSObject
@property (nonatomic, copy  ) NSString *title;
@property (nonatomic, copy  ) NSString *desc;
@property (nonatomic, copy  ) NSString *previewImageUrl;
@property (nonatomic, copy  ) NSString *contentUrl;
@property (nonatomic, copy  ) NSString *type;//暂时无用
@end
