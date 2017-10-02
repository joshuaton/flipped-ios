//
//  FLVideoMainViewController.m
//  Flipped
//
//  Created by ShaoJun on 2017/8/19.
//  Copyright © 2017年 junshao. All rights reserved.
//

//todo 通话界面修改

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

@property (nonatomic, strong) UIImageView *matchTipImageView;
@property (nonatomic, strong) UIButton *matchButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UILabel *tipsLabel;
@property (nonatomic, strong) LOTAnimationView *animation;

@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSTimer *timer;



@end

@implementation FLVideoMainViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"配聊";
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.tipsLabel.superview).offset(-(60+48)*SCREEN_SCALE_HEIGHT);
        make.centerX.equalTo(self.tipsLabel.superview);
    }];
    
    [self.matchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.tipsLabel.mas_top).offset(-30*SCREEN_SCALE_HEIGHT);
        make.left.equalTo(@(100*SCREEN_SCALE_WIDTH));
        make.right.equalTo(@(-100*SCREEN_SCALE_WIDTH));
        make.height.equalTo(@50);
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.matchButton);
        make.left.equalTo(self.matchButton);
        make.bottom.equalTo(self.matchButton);
        make.right.equalTo(self.matchButton);
        make.width.equalTo(self.matchButton);
        make.height.equalTo(self.matchButton);
    }];
    
    [self.matchTipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.matchTipImageView.superview);
        make.top.equalTo(@(200*SCREEN_SCALE_HEIGHT));
    }];
    
    [self statusChanged:MatchStatusDefault];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self statusChanged:MatchStatusDefault];
}

#pragma mark - public

-(void)beginMatch{
    [self matchBtnClick];
}

#pragma mark - action

-(void)matchBtnClick{
    [self statusChanged:MatchStatusMatching];
    
    [FLFlippedCallsService getFlippedCallWithSuccessBlock:^(NSString *uid, NSInteger callTimeout, NSInteger wait_timeout) {
        
        NSLog(@"junshao match uid %@", uid);
        NSLog(@"junshao callTimeout %ld", (long)callTimeout);
        NSLog(@"junshao wait_timeout %ld", (long)wait_timeout);
        
        //没有匹配到，监听秒数为callTimeout
        if(wait_timeout > 0){
            [self statusChanged:MatchStatusMatching];
            
            self.timer = [NSTimer scheduledTimerWithTimeInterval:wait_timeout target:self selector:@selector(matchFailed) userInfo:nil repeats:NO];
        }
        //匹配到，拉起视频
        else if(uid.length > 0){
            [self statusChanged:MatchStatusDefault];
            
            NSString *peerId = uid;
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            CallC2CMakeViewController *make = [storyboard instantiateViewControllerWithIdentifier:@"CallC2CMakeViewController"];
            make.peerId = peerId;
            [self presentViewController:make animated:YES completion:nil];
            
        }
    } failBlock:^(NSError *error) {
        NSLog(@"junshao error");
        [self statusChanged:MatchStatusFailed];
    }];
}

-(void)cancelBtnClick{
    
    [self statusChanged:MatchStatusDefault];
    [FLFlippedCallsService quitFlippedCallWithSuccessBlock:^{
        
    } failBlock:^(NSError *error) {
        
    }];
}

#pragma mark - private

-(void)matchFailed{
    [self statusChanged:MatchStatusFailed];
}

-(void)statusChanged:(MatchStatus)status{
    
    self.status = status;
    
    if(status == MatchStatusDefault){
        [self.timer invalidate];
        self.matchTipImageView.hidden = NO;
        self.matchButton.hidden = NO;
        self.cancelButton.hidden = YES;
        self.tipsLabel.text = @"点击开始匹配心动的Ta";
        
        [self.animation removeFromSuperview];
        self.animation = nil;
        
        [[TILCallManager sharedInstance] setIncomingCallListener:nil];
        
    }else if(status == MatchStatusMatching){
        
        self.matchButton.hidden = YES;
        self.cancelButton.hidden = NO;
        self.matchTipImageView.hidden = YES;
        self.tipsLabel.text = @"正在匹配中...";
        
        if(self.animation == nil){
            self.animation = [LOTAnimationView animationNamed:@"like"];
            self.animation.loopAnimation = YES;
            [self.view addSubview:self.animation];
            [self.animation playWithCompletion:^(BOOL animationFinished) {
                // Do Something
            }];
            
            [self.animation mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self.matchTipImageView);
                make.left.equalTo(@(35*SCREEN_SCALE_WIDTH));
                make.right.equalTo(@(-35*SCREEN_SCALE_WIDTH));
                make.height.equalTo(self.animation.mas_width);
            }];
        }
       
        [[TILCallManager sharedInstance] setIncomingCallListener:self];
        
    }else if(status == MatchStatusSuccess){
        
        self.matchButton.hidden = NO;
        self.cancelButton.hidden = YES;
        self.matchTipImageView.hidden = NO;
        self.tipsLabel.text = @"点击开始匹配心动的Ta";

        [self.animation removeFromSuperview];
        self.animation = nil;
        
        [[TILCallManager sharedInstance] setIncomingCallListener:nil];
        
    }else if(status == MatchStatusFailed){
        
        self.matchButton.hidden = NO;
        self.cancelButton.hidden = YES;
        self.matchTipImageView.hidden = NO;
        self.tipsLabel.text = @"没有匹配到，点击重新匹配";
        
        [self.animation removeFromSuperview];
        self.animation = nil;
        
        [[TILCallManager sharedInstance] setIncomingCallListener:nil];
    }
}

#pragma mark - TILCallIncomingCallListener

- (void)onC2CCallInvitation:(TILCallInvitation *)invitation{
    
    [self statusChanged:MatchStatusDefault];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CallC2CRecvViewController *call = [storyboard instantiateViewControllerWithIdentifier:@"CallC2CRecvViewController"];
    call.invite = invitation;
    UINavigationController *nav = (UINavigationController*)[UIApplication sharedApplication].delegate.window.rootViewController;
    [nav presentViewController:call animated:YES completion:nil];
    
}

- (void)onMultiCallInvitation:(TILCallInvitation *)invitation{
}

#pragma mark - getter & setter

-(UIImageView *)matchTipImageView{
    if(!_matchTipImageView){
        _matchTipImageView = [[UIImageView alloc] init];
        _matchTipImageView.image = [UIImage imageNamed:@"flipped_match_tips"];
        [self.view addSubview:_matchTipImageView];
    }
    return _matchTipImageView;
}

-(UIButton *)matchButton{
    if(!_matchButton){
        _matchButton = [[UIButton alloc] init];
        [_matchButton setTitle:@"点击匹配" forState:UIControlStateNormal];
        _matchButton.backgroundColor = COLOR_M;
        _matchButton.titleLabel.font = FONT_L;
        _matchButton.layer.cornerRadius = 4;
        [_matchButton setTitleColor:COLOR_W forState:UIControlStateNormal];
        [_matchButton addTarget:self action:@selector(matchBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_matchButton];
    }
    return _matchButton;
}

-(UIButton *)cancelButton{
    if(!_cancelButton){
        _cancelButton = [[UIButton alloc] init];
        [_cancelButton setTitle:@"退出匹配" forState:UIControlStateNormal];
        _cancelButton.backgroundColor = COLOR_M;
        _cancelButton.titleLabel.font = FONT_L;
        _cancelButton.layer.cornerRadius = 4;
        [_cancelButton setTitleColor:COLOR_W forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_cancelButton];
    }
    return _cancelButton;
}

-(UILabel *)tipsLabel{
    if(!_tipsLabel){
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.font = FONT_M;
        _tipsLabel.textColor = COLOR_M;
        [self.view addSubview:_tipsLabel];
    }
    return _tipsLabel;
}

@end
