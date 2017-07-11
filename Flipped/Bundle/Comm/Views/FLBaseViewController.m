//
//  FLBaseViewController.m
//  Flipped
//
//  Created by junshao on 2017/7/4.
//  Copyright © 2017年 junshao. All rights reserved.
//

#import "FLBaseViewController.h"

static __weak UIViewController* __currentViewController;

@interface FLBaseViewController()

@end

@implementation FLBaseViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    __currentViewController = self;
}

+ (UIViewController*)currentViewController{
    return __currentViewController;
}

@end
