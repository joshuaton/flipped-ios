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

@interface FLVideoMainViewController()

@property (nonatomic, strong) UITextField *textFiled;
@property (nonatomic, strong) UIButton *button;

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

-(void)btnClick{
    
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
