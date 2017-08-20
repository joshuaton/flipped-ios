//
//  CPShareView.h
//  CampusX
//
//  Created by jocentzhou on 2017/4/9.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ShareButtonType){
    ShareButtonTypeWXFriend = 100,    //微信好友
    ShareButtonTypeWXTimeline,  //微信朋友圈
    ShareButtonTypeQQFriend,    //QQ好友
    ShareButtonTypeQQZone,      //QQ控件
    ShareButtonTypeMineTweet,   // 我的动态
    ShareButtonTypeTeamTweet    // 小组动态
};

typedef NS_ENUM(NSInteger, OperButtonType){
    OperButtonTypeSetting = 200,      // 设置
    OperButtonTypeReport,       // 举报
    OperButtonTypeEdit,         // 编辑
    OperButtonTypeDelete,        // 删除
    OperButtonTypeFollow,        //关注
    OperButtonTypeCancelFollow  //取消关注
};

@interface CPShareView : UIWindow

@property (nonatomic, strong) NSString* shareDesc;
@property (nonatomic, strong) NSString* shareTitle;
@property (nonatomic, strong) NSString* shareUrl;
@property (nonatomic, strong) NSString* previewImageUrl;    //分享预览图片
@property (nonatomic, strong) NSArray *shareBtnTypes;    // 分享渠道数组
@property (nonatomic, strong) NSArray *operBtnTypes;    // 操作类型数组
@property (nonatomic, copy) void (^btnClickBlock)(NSInteger); //点击按钮的回调


+ (CPShareView*) sharedInstance;
- (void) show;
@end
