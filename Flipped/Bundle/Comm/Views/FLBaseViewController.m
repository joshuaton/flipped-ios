//
//  FLBaseViewController.m
//  Flipped
//
//  Created by junshao on 2017/7/4.
//  Copyright © 2017年 junshao. All rights reserved.
//

#import "FLBaseViewController.h"
#import "FLCommHeader.h"

static __weak UIViewController* __currentViewController;

@interface FLBaseViewController()

@end

@implementation FLBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = COLOR_W;
    
    //返回按钮不显示文字
    UIBarButtonItem * backButtonItem = [[UIBarButtonItem alloc] init];
    backButtonItem.title = @"";
    self.navigationItem.backBarButtonItem = backButtonItem;
    
    //返回按钮颜色
    self.navigationController.navigationBar.tintColor = COLOR_W;
    
    //修改navigationBar背景色
    self.navigationController.navigationBar.barTintColor = COLOR_M;
    
    //修改title文字颜色
    NSDictionary *dict = [NSDictionary dictionaryWithObject:COLOR_W forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;

    


}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    __currentViewController = self;
}

+ (UIViewController*)currentViewController {
    return __currentViewController;
}

#pragma mark - navigation

- (void)configLeftNavigationItemWithTitle:(NSString *)title image:(UIImage *)image action:(SEL)action{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    if(title && title.length > 0){
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:COLOR_W forState:UIControlStateNormal];
        btn.titleLabel.font = FONT_L;
    }
    if(image){
        [btn setImage:image forState:UIControlStateNormal];
    }
    
    UIBarButtonItem *publishItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = publishItem;
}

- (void)configRightNavigationItemWithTitle:(NSString *)title image:(UIImage *)image action:(SEL)action{
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    if(title && title.length > 0){
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:COLOR_W forState:UIControlStateNormal];
        btn.titleLabel.font = FONT_L;
    }
    if(image){
        [btn setImage:image forState:UIControlStateNormal];
    }
    
    UIBarButtonItem *publishItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = publishItem;
}



@end
