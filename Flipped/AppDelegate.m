//
//  AppDelegate.m
//  Flipped
//
//  Created by junshao on 2017/7/4.
//  Copyright © 2017年 junshao. All rights reserved.
//

#import "MTA.h"
#import "MTAConfig.h"
#import "AppDelegate.h"
#import "FLSquareViewController.h"
#import "FLMineViewController.h"
#import "FLUserInfoManager.h"
#import "FLNewMineViewController.h"
#import "UIColor+HexColor.h"

@interface AppDelegate () <UITabBarControllerDelegate>

@property (nonatomic, strong) UITabBarController *tabBarController;
@property (nonatomic, strong) UINavigationController *squareNav;
@property (nonatomic, strong) UINavigationController *mineNav;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [MTA startWithAppkey:@"I82NYP3VM7PZ"];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    FLSquareViewController *squareViewController = [[FLSquareViewController alloc] init];
    self.squareNav = [[UINavigationController alloc] initWithRootViewController:squareViewController];
    
    UIImage *squareImage = [[UIImage imageNamed:@"comm_tab_square"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *squareImageSelected = [[UIImage imageNamed:@"comm_tab_square_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UITabBarItem *squareTabBarItem = [[UITabBarItem alloc] initWithTitle:@"广场" image:squareImage selectedImage:squareImageSelected];
    squareViewController.tabBarItem = squareTabBarItem;
    
    FLNewMineViewController *mineViewController = [[FLNewMineViewController alloc] init];
    self.mineNav = [[UINavigationController alloc] initWithRootViewController:mineViewController];
    
    UIImage *mineImage = [[UIImage imageNamed:@"comm_tab_mine"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *mineImageSelected = [[UIImage imageNamed:@"comm_tab_mine_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UITabBarItem *mineTabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:mineImage selectedImage:mineImageSelected];
    mineViewController.tabBarItem = mineTabBarItem;
    
    //未选中字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"555555"]} forState:UIControlStateNormal];
    
    //选中字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"439c36"]} forState:UIControlStateSelected];
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.delegate = self;
    self.tabBarController.viewControllers = @[self.squareNav, self.mineNav];
    
    self.window.rootViewController = self.tabBarController;
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

#pragma mark - UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    
    if(viewController == self.mineNav && ![[FLUserInfoManager sharedUserInfoManager] checkLogin]){
        return NO;
    }
    
    return YES;
}

@end
