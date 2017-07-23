//
//  FLLoginViewController.m
//  Flipped
//
//  Created by junshao on 2017/7/4.
//  Copyright © 2017年 junshao. All rights reserved.
//

#import "FLLoginViewController.h"
#import "FLCommHeader.h"
#import "Masonry.h"
#import "FLUserService.h"
#import "FLToast.h"
#import "FLHelpViewController.h"

@interface FLLoginViewController()

@property (nonatomic, strong) UILabel *phoneNumLabel;
@property (nonatomic, strong) UITextField *phoneNumTextField;
@property (nonatomic, strong) UILabel *vertifyCodeLabel;
@property (nonatomic, strong) UITextField *vertifyCodeTextField;
@property (nonatomic, strong) UIButton *getVertifyCodeButton;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, assign) NSInteger time;

@end

@implementation FLLoginViewController

-(void)viewDidLoad{
    
    [super viewDidLoad];
        
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"" forKey:@"uid"];
    [defaults setObject:@"" forKey:@"key"];
    
    self.title = @"请登录";
    [self configLeftNavigationItemWithTitle:@"关闭" image:nil action:@selector(closeBtnClick)];
    
    [self makeConstraints];
    
}

-(void)makeConstraints{
    
    [self.phoneNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneNumLabel.superview).offset(64+20);
        make.left.equalTo(self.phoneNumLabel.superview).offset(10);
        make.width.equalTo(@(self.phoneNumLabel.frame.size.width));
        make.height.equalTo(@(self.phoneNumLabel.frame.size.height+10));
    }];
    
    [self.phoneNumTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneNumLabel);
        make.left.equalTo(self.phoneNumLabel.mas_right).offset(10);
        make.right.equalTo(self.phoneNumTextField.superview).offset(-10);
        make.centerY.equalTo(self.phoneNumLabel.mas_centerY);
    }];
    
    [self.vertifyCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneNumLabel.mas_bottom).offset(20);
        make.left.equalTo(self.phoneNumLabel);
        make.width.equalTo(@(self.vertifyCodeLabel.frame.size.width));
        make.height.equalTo(@(self.vertifyCodeLabel.frame.size.height+10));
    }];
    
    [self.getVertifyCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.vertifyCodeLabel);
        make.right.equalTo(self.getVertifyCodeButton.superview).offset(-10);
        make.width.equalTo(@(self.getVertifyCodeButton.frame.size.width+20));
        make.centerY.equalTo(self.vertifyCodeLabel.mas_centerY);
    }];

    [self.vertifyCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.vertifyCodeLabel);
        make.left.equalTo(self.phoneNumTextField);
        make.right.equalTo(self.getVertifyCodeButton.mas_left).offset(-10);
        make.centerY.equalTo(self.vertifyCodeLabel.mas_centerY);
    }];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.vertifyCodeTextField.mas_bottom).offset(40);
        make.centerX.equalTo(self.loginButton.superview);
        make.width.equalTo(@100);
    }];
    

}

#pragma mark - public

+(void)present{
    if([[FLBaseViewController currentViewController] isKindOfClass:[FLLoginViewController class]]){
        return;
    }
    
    FLLoginViewController *vc = [[FLLoginViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
    [[FLBaseViewController currentViewController] presentViewController:navi animated:YES completion:nil];
}

#pragma mark - private

// 开启倒计时效果
-(void)openCountdown{
    
    __block NSInteger time = 59; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮的样式
                [self.getVertifyCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
                [self.getVertifyCodeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                self.getVertifyCodeButton.userInteractionEnabled = YES;
            });
            
        }else{
            
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮显示读秒效果
                [self.getVertifyCodeButton setTitle:[NSString stringWithFormat:@"重新发送(%.2d)", seconds] forState:UIControlStateNormal];
                [self.getVertifyCodeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                self.getVertifyCodeButton.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}

#pragma mark - action

-(void)closeBtnClick{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)getVertifyBtnClick:(UIButton *)sender{
    [FLUserService getVertifyCodeWithWithPhoneNum:self.phoneNumTextField.text successBlock:^{
        
        [FLToast showToast:@"验证码已经发送到手机"];
        
        [self openCountdown];
        
    } failBlock:^(NSError *error) {
        
        
    }];
}

-(void)loginBtnClick{
    [FLUserService loginWithPhoneNum:self.phoneNumTextField.text vertifyCode:self.vertifyCodeTextField.text successBlock:^{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOGIN_SUCCESS object:self userInfo:nil];
        
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    } failBlock:^(NSError *error) {
        
    }];
}

-(void)helpClick{
    FLHelpViewController *vc = [[FLHelpViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - getter & setter

-(UILabel *)phoneNumLabel{
    if(!_phoneNumLabel){
        _phoneNumLabel = [[UILabel alloc] init];
        _phoneNumLabel.text = @"手机号";
        _phoneNumLabel.font = [UIFont systemFontOfSize:18];
        [_phoneNumLabel sizeToFit];
        [self.view addSubview:_phoneNumLabel];
    }
    return _phoneNumLabel;
}

-(UITextField *)phoneNumTextField{
    if(!_phoneNumTextField){
        _phoneNumTextField = [[UITextField alloc] init];
        _phoneNumTextField.placeholder = @"请输入手机号";
        _phoneNumTextField.leftViewMode = UITextFieldViewModeAlways;
        _phoneNumTextField.borderStyle = UITextBorderStyleLine;
        _phoneNumTextField.keyboardType = UIKeyboardTypePhonePad;

        [self.view addSubview:_phoneNumTextField];
    }
    return _phoneNumTextField;
}

-(UILabel *)vertifyCodeLabel{
    if(!_vertifyCodeLabel){
        _vertifyCodeLabel = [[UILabel alloc] init];
        _vertifyCodeLabel.text = @"验证码";
        _vertifyCodeLabel.font = [UIFont systemFontOfSize:18];
        [_vertifyCodeLabel sizeToFit];
        [self.view addSubview:_vertifyCodeLabel];
    }
    return _vertifyCodeLabel;
}

-(UITextField *)vertifyCodeTextField{
    if(!_vertifyCodeTextField){
        _vertifyCodeTextField = [[UITextField alloc] init];
        _vertifyCodeTextField.placeholder = @"请输入验证码";
        _vertifyCodeTextField.leftViewMode = UITextFieldViewModeAlways;
        _vertifyCodeTextField.borderStyle = UITextBorderStyleLine;
        _vertifyCodeTextField.keyboardType = UIKeyboardTypePhonePad;

        [self.view addSubview:_vertifyCodeTextField];
    }
    return _vertifyCodeTextField;
}

-(UIButton *)getVertifyCodeButton{
    if(!_getVertifyCodeButton){
        _getVertifyCodeButton = [[UIButton alloc] init];
        [_getVertifyCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_getVertifyCodeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _getVertifyCodeButton.layer.borderWidth = 1;
        _getVertifyCodeButton.layer.borderColor = [UIColor blackColor].CGColor;
        _getVertifyCodeButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_getVertifyCodeButton addTarget:self action:@selector(getVertifyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_getVertifyCodeButton sizeToFit];
        [self.view addSubview:_getVertifyCodeButton];
    }
    return _getVertifyCodeButton;
}

-(UIButton *)loginButton{
    if(!_loginButton){
        _loginButton = [[UIButton alloc] init];
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_loginButton sizeToFit];
        _loginButton.layer.borderWidth = 1;
        _loginButton.layer.borderColor = [UIColor blackColor].CGColor;
        [_loginButton addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_loginButton];
    }
    return _loginButton;
}



@end
