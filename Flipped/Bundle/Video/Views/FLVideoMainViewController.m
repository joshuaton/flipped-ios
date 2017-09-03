//
//  FLVideoMainViewController.m
//  Flipped
//
//  Created by ShaoJun on 2017/8/19.
//  Copyright © 2017年 junshao. All rights reserved.
//

#import "FLVideoMainViewController.h"
#import "Masonry.h"
#import "FLCommHeader.h"
#import <TILCallSDK/TILCallSDK.h>
#import "FLUserInfoManager.h"

@interface FLVideoMainViewController() <TILCallNotificationListener,TILCallStatusListener, TILCallMemberEventListener>

@property (nonatomic, strong) UITextField *textFiled;
@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) TILC2CCall *call;

@end

@implementation FLVideoMainViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self.textFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(50+64));
        make.left.equalTo(@10);
        make.right.equalTo(@-10);
        make.height.equalTo(@30);
    }];
    
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textFiled.mas_bottom).offset(10);
        make.left.equalTo(@10);
        make.right.equalTo(@-10);
        make.height.equalTo(@30);
    }];
}



#pragma mark - action

-(void)btnClick{
    
    [self makeCall];
}

#pragma mark - private

-(void)makeCall{
    
    TILCallConfig * config = [[TILCallConfig alloc] init];
    TILCallBaseConfig * baseConfig = [[TILCallBaseConfig alloc] init];
    baseConfig.callType = TILCALL_TYPE_VIDEO;
    baseConfig.isSponsor = YES;
    baseConfig.peerId = self.textFiled.text;
    baseConfig.heartBeatInterval = 15;
    config.baseConfig = baseConfig;
    
    TILCallListener * listener = [[TILCallListener alloc] init];
    //注意：
    //［通知回调］可以获取通话的事件通知，建议双人和多人都走notifListener
    // [通话状态回调] 也可以获取通话的事件通知
    listener.callStatusListener = self;
    listener.memberEventListener = self;
    listener.notifListener = self;
    config.callListener = listener;
    
    TILCallSponsorConfig *sponsorConfig = [[TILCallSponsorConfig alloc] init];
    sponsorConfig.waitLimit = 10;
    sponsorConfig.callId = (int)([[NSDate date] timeIntervalSince1970]) % 1000 * 1000 + arc4random() % 1000;
    sponsorConfig.onlineInvite = YES;
    config.sponsorConfig = sponsorConfig;
    
    _call = [[TILC2CCall alloc] initWithConfig:config];
    [_call createRenderViewIn:self.view];
    [_call makeCall:nil custom:nil result:^(TILCallError *err) {
        if(err){
            NSLog(@"呼叫失败");
        }
        else{
            NSLog(@"呼叫成功");
        }
    }];
}

#pragma mark - 音视频事件回调
- (void)onMemberAudioOn:(BOOL)isOn members:(NSArray *)members
{
    
}

- (void)onMemberCameraVideoOn:(BOOL)isOn members:(NSArray *)members
{
    if(isOn){
        for (TILCallMember *member in members) {
            NSString *identifier = member.identifier;
            if([identifier isEqualToString:[FLUserInfoManager sharedUserInfoManager].uid]){
                [_call addRenderFor:[FLUserInfoManager sharedUserInfoManager].uid atFrame:self.view.bounds];
                [_call sendRenderViewToBack:[FLUserInfoManager sharedUserInfoManager].uid];
            }
            else{
                [_call addRenderFor:identifier atFrame:CGRectMake(20, 20, 120, 160)];
            }
        }
    }
    else{
        for (TILCallMember *member in members) {
            NSString *identifier = member.identifier;
            [_call removeRenderFor:identifier];
        }
    }
}

#pragma mark - getter & setter

-(UITextField *)textFiled{
    if(!_textFiled){
        _textFiled = [[UITextField alloc] init];
        _textFiled.layer.borderWidth = 1;
        _textFiled.layer.borderColor = COLOR_M.CGColor;
        [self.view addSubview:_textFiled];
    }
    return _textFiled;
}

-(UIButton *)button{
    if(!_button){
        _button = [[UIButton alloc] init];
        [_button setTitle:@"发起通话" forState:UIControlStateNormal];
        _button.backgroundColor = COLOR_M;
        [_button setTitleColor:COLOR_W forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_button];
    }
    return _button;
}

@end
