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
@property (nonatomic, strong) UILabel *phoneNumLabel;
@property (nonatomic, strong) UITextField *phoneNumTextField;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UITextView *contentTextView;
@property (nonatomic, strong) UIView *addPicView;

@end

@implementation FLPostViewController

-(void)viewDidLoad{
    [super viewDidLoad];

    self.title = @"发布动心话";
    [self configRightNavigationItemWithTitle:@"发布" image:nil action:@selector(postBtnDidClick)];
    
    [self makeConstraints];
}

-(void)makeConstraints{
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipsLabel.superview).offset(64+20);
        make.centerX.equalTo(self.tipsLabel.superview);
    }];
    
    [self.phoneNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipsLabel.mas_bottom).offset(20);
        make.left.equalTo(self.phoneNumLabel.superview).offset(10);
        make.right.equalTo(self.phoneNumLabel.superview).offset(-10);
    }];
    
    [self.phoneNumTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneNumLabel.mas_bottom).offset(5);
        make.left.equalTo(self.phoneNumTextField.superview).offset(10);
        make.right.equalTo(self.phoneNumTextField.superview).offset(-10);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneNumTextField.mas_bottom).offset(10);
        make.left.equalTo(self.phoneNumTextField);
        make.right.equalTo(self.phoneNumTextField);
    }];
    
    [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLabel.mas_bottom).offset(5);
        make.left.equalTo(self.contentLabel);
        make.right.equalTo(self.contentLabel);
        make.height.equalTo(@100);
    }];
    
    [self.addPicView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentTextView.mas_bottom).offset(10);
        make.left.equalTo(self.contentTextView);
        make.right.equalTo(self.contentTextView);
        make.height.equalTo(@100);
    }];
}

#pragma mark - action

-(void)postBtnDidClick{
    
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

-(UILabel *)phoneNumLabel{
    if(!_phoneNumLabel){
        _phoneNumLabel = [[UILabel alloc] init];
        _phoneNumLabel.text = @"输入Ta的手机";
        [self.view addSubview:_phoneNumLabel];
    }
    return _phoneNumLabel;
}

-(UITextField *)phoneNumTextField{
    if(!_phoneNumTextField){
        _phoneNumTextField = [[UITextField alloc] init];
        _phoneNumTextField.borderStyle = UITextBorderStyleLine;
        [self.view addSubview:_phoneNumTextField];
    }
    return _phoneNumTextField;
}

-(UILabel *)contentLabel{
    if(!_contentLabel){
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.text = @"想对Ta说的话";
        [self.view addSubview:_contentLabel];
    }
    return _contentLabel;
}

-(UITextView *)contentTextView{
    if(!_contentTextView){
        _contentTextView = [[UITextView alloc] init];
        _contentTextView.layer.borderWidth = 1;
        _contentTextView.layer.borderColor = [UIColor blackColor].CGColor;
        [self.view addSubview:_contentTextView];
    }
    return _contentTextView;
}

-(UIView *)addPicView{
    if(!_addPicView){
        _addPicView = [[UIView alloc] init];
        _addPicView.backgroundColor = [UIColor blackColor];
        [self.view addSubview:_addPicView];
    }
    return _addPicView;
}

@end
