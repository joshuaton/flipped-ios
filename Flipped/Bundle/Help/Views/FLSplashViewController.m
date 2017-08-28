//
//  FLSplashViewController.m
//  Flipped
//
//  Created by ShaoJun on 2017/8/12.
//  Copyright © 2017年 junshao. All rights reserved.
//

#import "FLSplashViewController.h"
#import "FLCommHeader.h"

#define BUTTON_HEIGHT 50
#define BUTTON_WIDTH BUTTON_HEIGHT*3.85

@interface FLSplashViewController()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView0;
@property (nonatomic, strong) UIImageView *imageView1;
@property (nonatomic, strong) UIImageView *imageView2;
@property (nonatomic, strong) UIButton *enterButton;

@end

@implementation FLSplashViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.imageView0.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.imageView1.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.imageView2.frame = CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
 
    self.enterButton.frame = CGRectMake(SCREEN_WIDTH*2+(SCREEN_WIDTH-BUTTON_WIDTH)/2, SCREEN_HEIGHT-57*SCREEN_SCALE_HEIGHT-BUTTON_HEIGHT, BUTTON_WIDTH, BUTTON_HEIGHT);
}

#pragma mark - action

-(void)buttonClick{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *splashShowed = [NSNumber numberWithBool:YES];
    [defaults setObject:splashShowed forKey:@"splashShowed"];
    
    if(self.clickEnterButtonCallback){
        self.clickEnterButtonCallback();
    }
    
}

#pragma mark - getter & setter

-(UIScrollView *)scrollView{
    if(!_scrollView){
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.pagingEnabled=YES;
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 3, SCREEN_HEIGHT);
        _scrollView.bounces = NO;
        _scrollView.showsHorizontalScrollIndicator = FALSE;
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
    
}



-(UIImageView *)imageView0{
    if(!_imageView0){
        _imageView0 = [[UIImageView alloc] init];
        _imageView0.contentMode = UIViewContentModeScaleAspectFit;
        _imageView0.image = [UIImage imageNamed:@"flipped_splash0"];
        [self.scrollView addSubview:_imageView0];
    }
    return _imageView0;
}

-(UIImageView *)imageView1{
    if(!_imageView1){
        _imageView1 = [[UIImageView alloc] init];
        _imageView1.contentMode = UIViewContentModeScaleAspectFit;
        _imageView1.image = [UIImage imageNamed:@"flipped_splash1"];
        [self.scrollView addSubview:_imageView1];
    }
    return _imageView1;
}

-(UIImageView *)imageView2{
    if(!_imageView2){
        _imageView2 = [[UIImageView alloc] init];
        _imageView2.contentMode = UIViewContentModeScaleAspectFit;
        _imageView2.image = [UIImage imageNamed:@"flipped_splash2"];
        [self.scrollView addSubview:_imageView2];
    }
    return _imageView2;
}

-(UIButton *)enterButton{
    if(!_enterButton){
        _enterButton = [[UIButton alloc] init];
        [_enterButton setBackgroundImage:[UIImage imageNamed:@"flipped_splash_button"] forState:UIControlStateNormal];
        [_enterButton addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:_enterButton];
    }
    return _enterButton;
}

@end
