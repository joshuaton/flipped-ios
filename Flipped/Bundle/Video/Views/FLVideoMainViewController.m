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

@interface FLVideoMainViewController() <TILCallIncomingCallListener>
@property (nonatomic, strong) UILabel *myUidLabel;
@property (nonatomic, strong) UITextField *textFiled;
@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) TILC2CCall *call;

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
    
    self.myUidLabel.text = [NSString stringWithFormat:@"我的账号: %@", [FLUserInfoManager sharedUserInfoManager].uid];
    
    [[TILCallManager sharedInstance] setIncomingCallListener:self];

}



#pragma mark - action

-(void)btnClick{
    
    [self makeCall];
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

@end
