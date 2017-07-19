//
//  FLFlippedDetailViewController.m
//  Flipped
//
//  Created by junshao on 2017/7/19.
//  Copyright © 2017年 junshao. All rights reserved.
//

#import "FLFlippedDetailViewController.h"
#import "Masonry.h"
#import "FLFlippedWordsService.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "FLToast.h"

@interface FLFlippedDetailViewController()

@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *sendLabel;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation FLFlippedDetailViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"详情";
    [self configRightNavigationItemWithTitle:@"举报" image:nil action:@selector(reportBtnClick)];

    [self makeConstraints];
    
    [FLFlippedWordsService getFlippedWordsDetailWithId:self.flippedId successBlock:^(FLFlippedWord *data) {
        
        [self showData:data];
    } failBlock:^(NSError *error) {
        NSLog(@"get detail error");

    }];
}

-(void)makeConstraints{
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLabel.superview).offset(64+10);
        make.left.equalTo(self.contentLabel.superview).offset(10);
        make.right.equalTo(self.contentLabel.superview).offset(-10);
    }];
    
    [self.sendLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLabel.mas_bottom).offset(10);
        make.left.equalTo(self.contentLabel);
        make.right.equalTo(self.contentLabel);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sendLabel.mas_bottom).offset(10);
        make.left.equalTo(self.sendLabel);
        make.right.equalTo(self.sendLabel);
        make.height.equalTo(@250);
    }];

}

-(void)showData:(FLFlippedWord *)data{
    
    NSArray<FLContent> *contents = data.contents;
    
    BOOL hasImage = NO;
    
    for(int i=0; i<contents.count; i++){
        FLContent *content = contents[i];
        
        if([content.type isEqualToString:@"text"]){
            self.contentLabel.text = content.text;
        }else if([content.type isEqualToString:@"picture"]){
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:content.text] placeholderImage:[UIImage imageNamed:@"flipped_pic_default"]];
            hasImage = YES;
            
        }
    }
    
    self.sendLabel.text = [NSString stringWithFormat:@"发送给：%@", data.sendto];
    
    if(hasImage){
        self.imageView.hidden = NO;
    }else{
        self.imageView.hidden = YES;
    }
}

#pragma mark - action

-(void)reportBtnClick{
    [FLToast showToast:@"举报内容已收到，会尽快处理"];
}

#pragma mark - getter & setter

-(UILabel *)contentLabel{
    if(!_contentLabel){
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont systemFontOfSize:18];
        [self.view addSubview:_contentLabel];
    }
    return _contentLabel;
}

-(UILabel *)sendLabel{
    if(!_sendLabel){
        _sendLabel = [[UILabel alloc] init];
        _sendLabel.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:_sendLabel];
    }
    return _sendLabel;
}

-(UIImageView *)imageView{
    if(!_imageView){
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:_imageView];
    }
    return _imageView;
}

@end
