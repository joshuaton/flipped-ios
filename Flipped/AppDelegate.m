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
#import <ZegoLiveRoom/ZegoLiveRoom.h>

static ZegoLiveRoomApi *g_ZegoApi = nil;

@interface AppDelegate () <UITabBarControllerDelegate>

@property (nonatomic, strong) FLSplashViewController *splashViewController;
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
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:COLOR_W} forState:UIControlStateSelected];
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.delegate = self;
    self.tabBarController.viewControllers = @[self.squareNav, self.mineNav];
    
    //tabBar颜色
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 49)];
    backView.backgroundColor = COLOR_M;
    [self.tabBarController.tabBar insertSubview:backView atIndex:0];
    self.tabBarController.tabBar.opaque = YES;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *splashShowed = [defaults objectForKey:@"splashShowed"];
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
    
    [self setupZegoLive];
        
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

-(void)setupZegoLive{
    
    // 设置是否开启“测试环境”,在初始化SDK之前调用，true:开启 false:关闭
    [ZegoLiveRoomApi setUseTestEnv:true];
    
    //设置实时视频环境，在初始化SDK之前调用，type设置为2
    [ZegoLiveRoomApi setBusinessType:2];
    
    //设置调试模式,建议在初始化SDK前调用,方便在开发模式下查问题。
    #ifdef DEBUG
    [ZegoLiveRoomApi setVerbose:YES];
    #endif

    //设置用户信息，在loginRoom之前调用
    [ZegoLiveRoomApi setUserID:@"18923881572" userName:@"junshao"];
    
    
    // Demo 把signKey先写到代码中
    // ！！！注意：这个Appid和signKey需要从server下发到App，避免在App中存储，防止盗用
    Byte signkey[] = {0x91,0x93,0xcc,0x66,0x2a,0x1c,0xe,0xc1,
        0x35,0xec,0x71,0xfb,0x7,0x19,0x4b,0x38,
        0x15,0xf1,0x43,0xf5,0x7c,0xd2,0xb5,0x9a,
        0xe3,0xdd,0xdb,0xe0,0xf1,0x74,0x36,0xd};
//    NSData * appSign = [[NSData alloc] initWithBytes:signkey length:32];
    uint appID = 1;
    
    // 初始化SDK
    NSData *sign = [[NSData alloc]initWithBytes:signkey length:32];
    g_ZegoApi = [[ZegoLiveRoomApi alloc] initWithAppID:appID appSignature:sign];
    
    // 设置是否开启“硬件加速”, true: 开启  false:关闭
    // ！！！打开硬编硬解，业务侧需要有后台控制开关，避免碰到版本升级或者硬件升级时出现硬编硬解失败的问题，若硬编失败我们会转成软编。
    [ZegoLiveRoomApi requireHardwareEncoder:true];
}

#pragma mark - UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    
    if(viewController == self.mineNav && ![[FLUserInfoManager sharedUserInfoManager] checkLogin]){
        return NO;
    }
    
    return YES;
}

@end
