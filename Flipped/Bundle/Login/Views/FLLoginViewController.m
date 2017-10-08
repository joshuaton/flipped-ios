//
//  FLLoginViewController.m
//  Flipped
//
//  Created by junshao on 2017/7/4.
//  Copyright © 2017年 junshao. All rights reserved.
//

#import "FLLoginViewController.h"
#import "Masonry.h"
#import "FLUserService.h"
#import "FLToast.h"
#import "FLHelpViewController.h"
#import "FLUserInfoManager.h"
#import "FLVideoHelper.h"

@interface FLLoginViewController()

@property (nonatomic, strong) UITextField *phoneNumTextField;
@property (nonatomic, strong) UIView *phoneNumLineView;
@property (nonatomic, strong) UITextField *vertifyCodeTextField;
@property (nonatomic, strong) UIView *vertifyCodeLineView;
@property (nonatomic, strong) UIButton *getVertifyCodeButton;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, assign) NSInteger time;

@end

@implementation FLLoginViewController

-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    //清空本地登录数据
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [defaults dictionaryRepresentation];
    for (id  key in dic) {
        if([key isEqualToString:@"splashShowed"]){
            continue;
        }
        [defaults removeObjectForKey:key];
    }
    [defaults synchronize];
    
    //登出视频sdk
    [[ILiveLoginManager getInstance] iLiveLogout:^{
        
    } failed:^(NSString *module, int errId, NSString *errMsg) {
        
    }];
    
    self.title = @"登录";
    [self configLeftNavigationItemWithTitle:@"关闭" image:nil action:@selector(closeBtnClick)];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self makeConstraints];

    [self.phoneNumTextField becomeFirstResponder];
}

-(void)makeConstraints{
    
    [self.phoneNumTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneNumTextField.superview).offset(64+20);
        make.left.equalTo(self.phoneNumTextField.superview).offset(10);
        make.right.equalTo(self.phoneNumTextField.superview).offset(-10);
        make.height.equalTo(@40);
    }];
    
    [self.phoneNumLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.phoneNumTextField);
        make.bottom.equalTo(self.phoneNumTextField);
        make.right.equalTo(self.phoneNumTextField);
        make.height.equalTo(@1);
    }];
    
    [self.getVertifyCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneNumTextField.mas_bottom).offset(20);
        make.right.equalTo(self.getVertifyCodeButton.superview).offset(-10);
        make.width.equalTo(@(self.getVertifyCodeButton.frame.size.width+20));
        make.height.equalTo(@40);
    }];

    [self.vertifyCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.getVertifyCodeButton);
        make.left.equalTo(self.phoneNumTextField);
        make.right.equalTo(self.getVertifyCodeButton.mas_left).offset(-10);
        make.height.equalTo(@40);
    }];
    
    [self.vertifyCodeLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.vertifyCodeTextField);
        make.bottom.equalTo(self.vertifyCodeTextField);
        make.right.equalTo(self.vertifyCodeTextField);
        make.height.equalTo(@1);
    }];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.vertifyCodeTextField.mas_bottom).offset(40);
        make.centerX.equalTo(self.loginButton.superview);
        make.width.equalTo(@100);
        make.height.equalTo(@40);
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
                [self.getVertifyCodeButton setTitleColor:COLOR_H1 forState:UIControlStateNormal];
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
    
    NSString *phoneNum = self.phoneNumTextField.text;
    phoneNum = [phoneNum stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:phoneNum forKey:@"x-uid"];
    
    [FLUserService loginWithPhoneNum:self.phoneNumTextField.text vertifyCode:self.vertifyCodeTextField.text successBlock:^{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOGIN_SUCCESS object:self userInfo:nil];
        
        //登录video
        [FLVideoHelper login];
        
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

-(UITextField *)phoneNumTextField{
    if(!_phoneNumTextField){
        
        _phoneNumTextField = [[UITextField alloc] init];
        _phoneNumTextField.font = FONT_XL;
        _phoneNumTextField.textColor = COLOR_H1;
        _phoneNumTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 0)];
        //设置显示模式为永远显示(默认不显示)
        _phoneNumTextField.leftViewMode = UITextFieldViewModeAlways;
        
        NSString *holderText = @"请输入手机号";
        NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:holderText];
        [placeholder addAttribute:NSForegroundColorAttributeName
                            value:COLOR_H4
                            range:NSMakeRange(0, holderText.length)];
        [placeholder addAttribute:NSFontAttributeName
                            value:FONT_XL
                            range:NSMakeRange(0, holderText.length)];
        _phoneNumTextField.attributedPlaceholder = placeholder;
        
        [self.view addSubview:_phoneNumTextField];
    }
    return _phoneNumTextField;
}

-(UIView *)phoneNumLineView{
    if(!_phoneNumLineView){
        _phoneNumLineView = [[UIView alloc] init];
        _phoneNumLineView.backgroundColor = COLOR_H4;
        [self.view addSubview:_phoneNumLineView];
    }
    return _phoneNumLineView;
}

-(UITextField *)vertifyCodeTextField{
    if(!_vertifyCodeTextField){
        _vertifyCodeTextField = [[UITextField alloc] init];
        _vertifyCodeTextField.font = FONT_XL;
        _vertifyCodeTextField.textColor = COLOR_H1;
        _vertifyCodeTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 0)];
        //设置显示模式为永远显示(默认不显示)
        _vertifyCodeTextField.leftViewMode = UITextFieldViewModeAlways;
        
        NSString *holderText = @"请输入验证码";
        NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:holderText];
        [placeholder addAttribute:NSForegroundColorAttributeName
                            value:COLOR_H4
                            range:NSMakeRange(0, holderText.length)];
        [placeholder addAttribute:NSFontAttributeName
                            value:FONT_XL
                            range:NSMakeRange(0, holderText.length)];
        _vertifyCodeTextField.attributedPlaceholder = placeholder;
        
        [self.view addSubview:_vertifyCodeTextField];
    }
    return _vertifyCodeTextField;
}

-(UIView *)vertifyCodeLineView{
    if(!_vertifyCodeLineView){
        _vertifyCodeLineView = [[UIView alloc] init];
        _vertifyCodeLineView.backgroundColor = COLOR_H4;
        [self.view addSubview:_vertifyCodeLineView];
    }
    return _vertifyCodeLineView;
}

-(UIButton *)getVertifyCodeButton{
    if(!_getVertifyCodeButton){
        _getVertifyCodeButton = [[UIButton alloc] init];
        [_getVertifyCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        _getVertifyCodeButton.titleLabel.font = FONT_L;
        _getVertifyCodeButton.backgroundColor = COLOR_M;
        _getVertifyCodeButton.layer.cornerRadius = 4;
        [_getVertifyCodeButton setTitleColor:COLOR_W forState:UIControlStateNormal];
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
        _loginButton.titleLabel.font = FONT_L;
        _loginButton.backgroundColor = COLOR_M;
        _loginButton.layer.cornerRadius = 4;
        [_loginButton setTitleColor:COLOR_W forState:UIControlStateNormal];
        [_loginButton sizeToFit];
        [_loginButton addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_loginButton];
    }
    return _loginButton;
}



@end
