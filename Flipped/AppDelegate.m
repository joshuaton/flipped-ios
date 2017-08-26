//
//  AppDelegate.m
//  Flipped
//
//  Created by junshao on 2017/7/4.
//  Copyright © 2017年 junshao. All rights reserved.
//

#import "MTA.h"
#import "AppDelegate.h"
#import "FLSquareViewController.h"
#import "FLMineViewController.h"
#import "FLUserInfoManager.h"
#import "FLNewMineViewController.h"
#import "UIColor+HexColor.h"
#import "FLCommHeader.h"
#import "FLSplashViewController.h"
#import "FLVideoMainViewController.h"
#import "WXApi.h"

@interface AppDelegate () <UITabBarControllerDelegate>

@property (nonatomic, strong) FLSplashViewController *splashViewController;
@property (nonatomic, strong) UITabBarController *tabBarController;
@property (nonatomic, strong) UINavigationController *squareNav;
@property (nonatomic, strong) UINavigationController *videoNav;
@property (nonatomic, strong) UINavigationController *mineNav;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [MTA startWithAppkey:@"I82NYP3VM7PZ"];
    [WXApi registerApp:@"wxf72f0e149d736899"];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    FLSquareViewController *squareViewController = [[FLSquareViewController alloc] init];
    self.squareNav = [[UINavigationController alloc] initWithRootViewController:squareViewController];
    
    UIImage *squareImage = [[UIImage imageNamed:@"comm_tab_square"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *squareImageSelected = [[UIImage imageNamed:@"comm_tab_square_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UITabBarItem *squareTabBarItem = [[UITabBarItem alloc] initWithTitle:@"广场" image:squareImage selectedImage:squareImageSelected];
    squareViewController.tabBarItem = squareTabBarItem;
    
    FLVideoMainViewController *videoViewController = [[FLVideoMainViewController alloc] init];
    self.videoNav = [[UINavigationController alloc] initWithRootViewController:videoViewController];
    UIImage *videoImage = [[UIImage imageNamed:@"comm_tab_square"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *videoImageSelected = [[UIImage imageNamed:@"comm_tab_square_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UITabBarItem *videoTabBarItem = [[UITabBarItem alloc] initWithTitle:@"视频" image:videoImage selectedImage:videoImageSelected];
    videoViewController.tabBarItem = videoTabBarItem;
    
    FLNewMineViewController *mineViewController = [[FLNewMineViewController alloc] init];
    self.mineNav = [[UINavigationController alloc] initWithRootViewController:mineViewController];
    
    UIImage *mineImage = [[UIImage imageNamed:@"comm_tab_mine"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *mineImageSelected = [[UIImage imageNamed:@"comm_tab_mine_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UITabBarItem *mineTabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:mineImage selectedImage:mineImageSelected];
    mineViewController.tabBarItem = mineTabBarItem;
    
    //未选中字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"555555"]} forState:UIControlStateNormal];
    
    //选中字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:COLOR_W} forState:UIControlStateSelected];
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.delegate = self;
    self.tabBarController.viewControllers = @[self.squareNav, self.videoNav, self.mineNav];
    
    //tabBar颜色
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 49)];
    backView.backgroundColor = COLOR_M;
    [self.tabBarController.tabBar insertSubview:backView atIndex:0];
    self.tabBarController.tabBar.opaque = YES;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *splashShowed = [defaults objectForKey:@"splashShowed"];
//    splashShowed = @0;
    if(!splashShowed || [splashShowed isEqualToNumber:[NSNumber numberWithBool:NO]]){
        self.splashViewController = [[FLSplashViewController alloc] init];
        Weak_Self wself = self;
        self.splashViewController.clickEnterButtonCallback = ^{
            wself.window.rootViewController = wself.tabBarController;
        };
        self.window.rootViewController = self.splashViewController;
    }else{
        self.window.rootViewController = self.tabBarController;
    }
    
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - private

#pragma mark - UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    
    if(viewController == self.mineNav && ![[FLUserInfoManager sharedUserInfoManager] checkLogin]){
        return NO;
    }
    
    return YES;
}

@end
