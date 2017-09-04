//
//  FLFeedbackViewController.m
//  Flipped
//
//  Created by ShaoJun on 2017/7/23.
//  Copyright © 2017年 junshao. All rights reserved.
//

#import "FLFeedbackViewController.h"
#import "Masonry.h"
#import "FLFeedbackService.h"
#import "FLToast.h"

@interface FLFeedbackViewController()

@property (nonatomic, strong) UITextView *contentTextView;

@end

@implementation FLFeedbackViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"反馈问题";
    [self configRightNavigationItemWithTitle:@"提交" image:nil action:@selector(feedbackBtnDidClick)];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentTextView.superview).offset(64+10);
        make.left.equalTo(self.contentTextView.superview).offset(10);
        make.right.equalTo(self.contentTextView.superview).offset(-10);
        make.height.equalTo(@150);
    }];
    
    [self.contentTextView becomeFirstResponder];
}

-(void)feedbackBtnDidClick{
    
    NSString *content = self.contentTextView.text;
    content = [content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if(content.length == 0){
        [FLToast showToast:@"内容不能为空"];
        return;
    }
    
    [FLFeedbackService publishFeedbackWithData:content successBlock:^{
        [FLToast showToast:@"已收到您的反馈，我们会尽快改进"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } failBlock:^(NSError *error) {
        
    }];
}

-(UITextView *)contentTextView{
    if(!_contentTextView){
        _contentTextView = [[UITextView alloc] init];
        _contentTextView.layer.borderWidth = 1;
        _contentTextView.layer.borderColor = COLOR_H1.CGColor;
        _contentTextView.font = FONT_L;
        
        UILabel *placeHolderLabel = [[UILabel alloc] init];
        placeHolderLabel.text = @"对我们的应用有什么建议，发现了什么bug，请反馈给我们，谢谢！";
        placeHolderLabel.numberOfLines = 0;
        placeHolderLabel.textColor = COLOR_H2;
        placeHolderLabel.font = FONT_L;
        [placeHolderLabel sizeToFit];
        [_contentTextView addSubview:placeHolderLabel];
        [_contentTextView setValue:placeHolderLabel forKey:@"_placeholderLabel"];

        [self.view addSubview:_contentTextView];
    }
    return _contentTextView;
}

@end
