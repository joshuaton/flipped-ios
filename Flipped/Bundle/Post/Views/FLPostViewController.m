//
//  FLPostViewController.m
//  Flipped
//
//  Created by junshao on 2017/7/4.
//  Copyright © 2017年 junshao. All rights reserved.
//

#import "FLPostViewController.h"
#import "Masonry.h"
#import "FLCommHeader.h"

@interface FLPostViewController()

@property (nonatomic, strong) UILabel *tipsLabel;
@property (nonatomic, strong) UITextField *phoneNumTextField;
@property (nonatomic, strong) UITextField *contentTextField;
@property (nonatomic, strong) UIView *postView;

@end

@implementation FLPostViewController

-(void)viewDidLoad{
    [super viewDidLoad];

    self.title = @"发布动心话";
    
    [self makeConstraints];
}

-(void)makeConstraints{
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipsLabel.superview).offset(64+20);
        make.centerX.equalTo(self.tipsLabel.superview);
    }];
    
    [self.phoneNumTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipsLabel.mas_bottom).offset(20);
        make.left.equalTo(self.phoneNumTextField.superview).offset(10);
        make.right.equalTo(self.phoneNumTextField.superview).offset(-10);
    }];
    
    [self.contentTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneNumTextField.mas_bottom).offset(10);
        make.left.equalTo(self.phoneNumTextField);
        make.right.equalTo(self.phoneNumTextField);
    }];
    
    [self.postView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentTextField.mas_bottom).offset(10);
        make.left.equalTo(self.contentTextField);
        make.right.equalTo(self.contentTextField);
        make.height.equalTo(@50);
    }];
}

#pragma mark - getter & setter

-(UILabel *)tipsLabel{
    if(!_tipsLabel){
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.text = @"对Ta说出心动的话";
        [self.view addSubview:_tipsLabel];
    }
    return _tipsLabel;
}

-(UITextField *)phoneNumTextField{
    if(!_phoneNumTextField){
        _phoneNumTextField = [[UITextField alloc] init];
        _phoneNumTextField.placeholder = @"输入Ta的手机";
        [self.view addSubview:_phoneNumTextField];
    }
    return _phoneNumTextField;
}

-(UITextField *)contentTextField{
    if(!_contentTextField){
        _contentTextField = [[UITextField alloc] init];
        _contentTextField.placeholder = @"输入心动的话";
        [self.view addSubview:_contentTextField];
    }
    return _contentTextField;
}

-(UIView *)postView{
    if(!_postView){
        _postView = [[UIView alloc] init];
        [self.view addSubview:_postView];
    }
    return _postView;
}

@end
