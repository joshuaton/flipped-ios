//
//  FLVideoMainViewController.m
//  Flipped
//
//  Created by ShaoJun on 2017/8/19.
//  Copyright © 2017年 junshao. All rights reserved.
//

#import "FLVideoMainViewController.h"
#import "Masonry.h"
#import "FLUserInfoManager.h"
#import "CallC2CMakeViewController.h"
#import "CallC2CRecvViewController.h"
#import "FLFlippedCallsService.h"
#import <Lottie/Lottie.h>

typedef NS_ENUM(NSInteger, MatchStatus) {
    MatchStatusDefault = 0,
    MatchStatusMatching,
    MatchStatusSuccess,
    MatchStatusFailed,
};

@interface FLVideoMainViewController() <TILCallIncomingCallListener>
@property (nonatomic, strong) UIButton *matchButton;
@property (nonatomic, strong) UILabel *tipsLabel;
@property (nonatomic, strong) LOTAnimationView *animation;



@end

@implementation FLVideoMainViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self.animation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.animation.superview);
        make.left.equalTo(@100);
        make.right.equalTo(@-100);
        make.height.equalTo(self.animation.mas_width);
    }];
    
    [self.matchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.matchButton.superview);
        make.left.equalTo(@10);
        make.right.equalTo(@-10);
        make.height.equalTo(@50);
    }];
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.matchButton.mas_bottom).offset(10);
        make.left.equalTo(@10);
        make.right.equalTo(@-10);
    }];
}



#pragma mark - action

-(void)matchBtnClick{
    [FLFlippedCallsService getFlippedCallWithSuccessBlock:^(NSString *uid, NSInteger callTimeout, NSInteger wait_timeout) {
        
        NSLog(@"junshao match uid %@", uid);
        NSLog(@"junshao callTimeout %ld", callTimeout);
        NSLog(@"junshao wait_timeout %ld", wait_timeout);
        
        //没有匹配到，监听秒数为callTimeout
        if(wait_timeout > 0){
            [[TILCallManager sharedInstance] setIncomingCallListener:self];
            
            self.tipsLabel.text = @"正在匹配中";
            

            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(wait_timeout * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.tipsLabel.text = @"没有匹配到，点击重新匹配";
                [[TILCallManager sharedInstance] setIncomingCallListener:nil];
            });
        }else if(uid.length > 0){
            [[TILCallManager sharedInstance] setIncomingCallListener:nil];
            
            NSString *peerId = uid;
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            CallC2CMakeViewController *make = [storyboard instantiateViewControllerWithIdentifier:@"CallC2CMakeViewController"];
            make.peerId = peerId;
            [self presentViewController:make animated:YES completion:nil];
        }
    } failBlock:^(NSError *error) {
        
    }];
}

#pragma mark - private

-(void)statusChanged:(MatchStatus)status{
    
    if(status == MatchStatusDefault){
        
        [self.animation removeFromSuperview];
        self.animation = nil;
        
    }else if(status == MatchStatusMatching){
        
        self.animation = [LOTAnimationView animationNamed:@"like"];
        self.animation.loopAnimation = YES;
        [self.view addSubview:self.animation];
        [self.animation playWithCompletion:^(BOOL animationFinished) {
            // Do Something
        }];
        
    }else if(status == MatchStatusSuccess){
        
        [self.animation removeFromSuperview];
        self.animation = nil;
        
    }else if(status == MatchStatusFailed){
        
        [self.animation removeFromSuperview];
        self.animation = nil;
    }
}

#pragma mark - TILCallIncomingCallListener

- (void)onC2CCallInvitation:(TILCallInvitation *)invitation{
    
    self.tipsLabel.text = @"";
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CallC2CRecvViewController *call = [storyboard instantiateViewControllerWithIdentifier:@"CallC2CRecvViewController"];
    call.invite = invitation;
    UINavigationController *nav = (UINavigationController*)[UIApplication sharedApplication].delegate.window.rootViewController;
    [nav presentViewController:call animated:YES completion:nil];
}

- (void)onMultiCallInvitation:(TILCallInvitation *)invitation{
}

#pragma mark - getter & setter

-(UIButton *)matchButton{
    if(!_matchButton){
        _matchButton = [[UIButton alloc] init];
        [_matchButton setTitle:@"点击匹配" forState:UIControlStateNormal];
        _matchButton.backgroundColor = COLOR_M;
        [_matchButton setTitleColor:COLOR_W forState:UIControlStateNormal];
        [_matchButton addTarget:self action:@selector(matchBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_matchButton];
    }
    return _matchButton;
}

-(UILabel *)tipsLabel{
    if(!_tipsLabel){
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.textColor = COLOR_M;
        [self.view addSubview:_tipsLabel];
    }
    return _tipsLabel;
}

@end
