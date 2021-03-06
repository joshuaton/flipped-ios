//
//  FLBaseViewController.h
//  Flipped
//
//  Created by junshao on 2017/7/4.
//  Copyright © 2017年 junshao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FLBaseViewController : UIViewController

+ (UIViewController*)currentViewController;

- (void)configLeftNavigationItemWithTitle:(NSString *)title image:(UIImage *)image action:(SEL)action;
- (void)configRightNavigationItemWithTitle:(NSString *)title image:(UIImage *)image action:(SEL)action;

@end
