//
//  FLLoginViewController.m
//  Flipped
//
//  Created by junshao on 2017/7/4.
//  Copyright © 2017年 junshao. All rights reserved.
//

#import "FLLoginViewController.h"
#import "FLCommHeader.h"

@interface FLLoginViewController()

@property (nonatomic, strong) UITextField *phoneNumTextField;
@property (nonatomic, strong) UITextField *vertifyCodeTextField;
@property (nonatomic, strong) UIButton *getVertifyCodeButton;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UILabel *helpLabel;

@end

@implementation FLLoginViewController

-(void)viewDidLoad{
    self.phoneNumTextField.frame = CGRectMake(0, 0, SCREEN_WIDTH, 100);
    self.vertifyCodeTextField.frame = CGRectMake(0, 100, SCREEN_WIDTH, 100);
}

-(UITextField *)phoneNumTextField{
    if(!_phoneNumTextField){
        
        UILabel *label =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 90, 50)];
        label.text = @"手机号";
        
        _phoneNumTextField = [[UITextField alloc] init];
        _phoneNumTextField.placeholder = @"请输入手机号";
        _phoneNumTextField.leftView = label;
        _phoneNumTextField.leftViewMode = UITextFieldViewModeAlways;
        [self.view addSubview:_phoneNumTextField];
    }
    return _phoneNumTextField;
}

-(UITextField *)vertifyCodeTextField{
    if(!_vertifyCodeTextField){
        
        UILabel *label =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 90, 50)];
        label.text = @"验证码";
        
        _vertifyCodeTextField = [[UITextField alloc] init];
        _vertifyCodeTextField.placeholder = @"请输入验证码";
        _vertifyCodeTextField.leftView = label;
        _vertifyCodeTextField.leftViewMode = UITextFieldViewModeAlways;
        [self.view addSubview:_vertifyCodeTextField];
    }
    return _vertifyCodeTextField;
}

-(UIButton *)getVertifyCodeButton{
    if(!_getVertifyCodeButton){
        _getVertifyCodeButton = [[UIButton alloc] init];
        [_getVertifyCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.view addSubview:_getVertifyCodeButton];
    }
    return _getVertifyCodeButton;
}

-(UIButton *)loginButton{
    if(!_loginButton){
        _loginButton = [[UIButton alloc] init];
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [self.view addSubview:_loginButton];
    }
    return _loginButton;
}

-(UILabel *)helpLabel{
    if(!_helpLabel){
        _helpLabel = [[UILabel alloc] init];
        _helpLabel.text = @"使用帮助";
        [self.view addSubview:_helpLabel];
    }
    return _helpLabel;
}

@end
