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

@interface FLVideoMainViewController() <TILCallIncomingCallListener>
@property (nonatomic, strong) UILabel *myUidLabel;
@property (nonatomic, strong) UITextField *textFiled;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIButton *matchButton;
@property (nonatomic, strong) UILabel *tipsLabel;

@end

@implementation FLVideoMainViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self.myUidLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(50+64));
        make.left.equalTo(@10);
        make.right.equalTo(@-10);
        make.height.equalTo(@30);
    }];
    
    [self.textFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.myUidLabel.mas_bottom).offset(10);
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
    
    [self.matchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.button.mas_bottom).offset(10);
        make.left.equalTo(@10);
        make.right.equalTo(@-10);
        make.height.equalTo(@30);
    }];
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.matchButton.mas_bottom).offset(10);
        make.left.equalTo(@10);
        make.right.equalTo(@-10);
        make.height.equalTo(@30);
    }];
    
    self.myUidLabel.text = [NSString stringWithFormat:@"我的账号: %@", [FLUserInfoManager sharedUserInfoManager].uid];
    

}



#pragma mark - action

-(void)btnClick{
    
    [self makeCall];
}

-(void)matchBtnClick{
    [FLFlippedCallsService getFlippedCallWithSuccessBlock:^(NSString *uid, NSInteger callTimeout, NSInteger wait_timeout) {
        
        NSLog(@"junshao match uid %@", uid);
        NSLog(@"junshao callTimeout %ld", callTimeout);
        NSLog(@"junshao wait_timeout %ld", wait_timeout);
        
        //没有匹配到，监听秒数为callTimeout
        if(wait_timeout > 0){
            [[TILCallManager sharedInstance] setIncomingCallListener:self];
            
            self.tipsLabel.text = @"正在匹配中";
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.tipsLabel.text = @"没有匹配到，点击重新匹配";
                [[TILCallManager sharedInstance] setIncomingCallListener:nil];
            });
        }else if(uid.length > 0 && ![uid isEqualToString:[FLUserInfoManager sharedUserInfoManager].uid]){
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

-(void)makeCall{
    
    NSString *peerId = self.textFiled.text;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CallC2CMakeViewController *make = [storyboard instantiateViewControllerWithIdentifier:@"CallC2CMakeViewController"];
    make.peerId = peerId;
    [self presentViewController:make animated:YES completion:nil];
    
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

-(UILabel *)myUidLabel{
    if(!_myUidLabel){
        _myUidLabel = [[UILabel alloc] init];
        _myUidLabel.textColor = COLOR_M;
        [self.view addSubview:_myUidLabel];
    }
    return _myUidLabel;
}

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
