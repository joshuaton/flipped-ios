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
#import "FLUserInfoManager.h"
#import "FLNewMineViewController.h"
#import "UIColor+HexColor.h"
#import "FLSplashViewController.h"
#import "FLVideoMainViewController.h"
#import "WXApi.h"
#import "FLVideoService.h"
#import "FLVideoHelper.h"
#import <MapKit/MapKit.h>
#import "TIMMessageListenerImpl.h"
#import "FLToast.h"
#import "NSObject+JSONUtils.h"

@interface AppDelegate () <UITabBarControllerDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) FLSplashViewController *splashViewController;
@property (nonatomic, strong) UITabBarController *tabBarController;
@property (nonatomic, strong) UINavigationController *squareNav;
@property (nonatomic, strong) UINavigationController *videoNav;
@property (nonatomic, strong) UINavigationController *mineNav;

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [MTA startWithAppkey:@"I82NYP3VM7PZ"];
    [WXApi registerApp:@"wxf72f0e149d736899"];
    [[ILiveSDK getInstance] initSdk:1400038614 accountType:14999];
    TIMMessageListenerImpl * impl = [[TIMMessageListenerImpl alloc] init];
    [[TIMManager sharedInstance] setMessageListener:impl];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    FLSquareViewController *squareViewController = [[FLSquareViewController alloc] init];
    self.squareNav = [[UINavigationController alloc] initWithRootViewController:squareViewController];
    
    UIImage *squareImage = [[UIImage imageNamed:@"comm_tab_square"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *squareImageSelected = [[UIImage imageNamed:@"comm_tab_square_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UITabBarItem *squareTabBarItem = [[UITabBarItem alloc] initWithTitle:@"表白墙" image:squareImage selectedImage:squareImageSelected];
    squareViewController.tabBarItem = squareTabBarItem;
    
    FLVideoMainViewController *videoViewController = [[FLVideoMainViewController alloc] init];
    self.videoNav = [[UINavigationController alloc] initWithRootViewController:videoViewController];
    UIImage *videoImage = [[UIImage imageNamed:@"comm_tab_video"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *videoImageSelected = [[UIImage imageNamed:@"comm_tab_video_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UITabBarItem *videoTabBarItem = [[UITabBarItem alloc] initWithTitle:@"配聊" image:videoImage selectedImage:videoImageSelected];
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
//    self.tabBarController.viewControllers = @[self.squareNav, self.mineNav];

    
    //tabBar颜色
//    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.tabBarController.tabBar.frame.size.height)];
//    backView.backgroundColor = COLOR_M;
//    [self.tabBarController.tabBar insertSubview:backView atIndex:0];
    self.tabBarController.tabBar.opaque = NO;
    self.tabBarController.tabBar.barTintColor = COLOR_M;
    
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
    
    [FLVideoHelper login];
    
    [self startLocation];
    
    [self registNotification];
        
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    __block UIBackgroundTaskIdentifier bgTaskID;
    bgTaskID = [application beginBackgroundTaskWithExpirationHandler:^ {
        
        //不管有没有完成，结束background_task任务
        [application endBackgroundTask: bgTaskID];
        bgTaskID = UIBackgroundTaskInvalid;
    }];
    
    NSUInteger unReadCount = 0;
    [UIApplication sharedApplication].applicationIconBadgeNumber = unReadCount;
    
    TIMBackgroundParam  *param = [[TIMBackgroundParam alloc] init];
    [param setC2cUnread:(int)unReadCount];
    
    [[TIMManager sharedInstance] doBackground:param succ:^() {
        NSLog(@"doBackgroud Succ");
    } fail:^(int code, NSString * err) {
        NSLog(@"Fail: %d->%@", code, err);
    }];
    
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [[TIMManager sharedInstance] doForeground];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSString *token = [NSString stringWithFormat:@"%@", deviceToken];
    [[TIMManager sharedInstance] log:TIM_LOG_INFO tag:@"SetToken" msg:[NSString stringWithFormat:@"My Token is :%@", token]];
    TIMTokenParam *param = [[TIMTokenParam alloc] init];
    
    /* 用户自己到苹果注册开发者证书，在开发者账号中下载并生成证书(p12文件)，将生成的p12文件传到腾讯证书管理控制台，控制台会自动生成一个证书id，将证书id传入一下busiId参数中。*/
    
#if DEBUG
    param.busiId = 6050;
#else
    param.busiId = 6049;
#endif
    

    
    [param setToken:deviceToken];
    
    //    [[TIMManager sharedInstance] setToken:param];
    [[TIMManager sharedInstance] setToken:param succ:^{
        
        NSLog(@"-----> 上传token成功 ");
    } fail:^(int code, NSString *msg) {
        NSLog(@"-----> 上传token失败 ");
    }];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    [self application:application didReceiveRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    if(![FLUserInfoManager sharedInstance].isLogin){
        return;
    }
    
    NSString *ext = userInfo[@"ext"];
    ext = [ext stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
    NSDictionary* extDict = [ext cp_toJSONObject];
    NSLog(@"%@", extDict);
    
    NSString *url = extDict[@"url"];
    if([url isEqualToString:@"flipped://flippedwords.com/match"]){
        //切到第2个tab立即开始匹配
        [self.tabBarController setSelectedViewController:self.videoNav];
        [self.squareNav popToRootViewControllerAnimated:NO];
        [self.videoNav popToRootViewControllerAnimated:NO];
        [self.mineNav popToRootViewControllerAnimated:NO];
        
        //防止还没有执行viewdidload就执行
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            FLVideoMainViewController *videoMainVC = (FLVideoMainViewController *)[self.videoNav viewControllers][0];
            [videoMainVC beginMatch];
        });
    }
}

#pragma mark - private

-(void)startLocation{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 100.0f;
    if ([[[UIDevice currentDevice ]systemVersion] doubleValue] >8.0){
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
}

- (void)registNotification{
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}



#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
            
        case kCLAuthorizationStatusNotDetermined:
            if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                [self.locationManager requestWhenInUseAuthorization];
            }break;
        default:break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if ([error code] == kCLErrorDenied) {
        NSLog(@"访问被拒绝");
    }
    if ([error code] == kCLErrorLocationUnknown) {
        NSLog(@"无法获取位置信息");
    }
}
//定位代理经纬度回调
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *newLocation = locations[0];
    
    CLLocationCoordinate2D oldCoordinate = newLocation.coordinate;
    
    NSLog(@"旧的经度：%f,旧的纬度：%f",oldCoordinate.longitude,oldCoordinate.latitude);
    
    [FLUserInfoManager sharedInstance].lng = oldCoordinate.longitude;
    [FLUserInfoManager sharedInstance].lat = oldCoordinate.latitude;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOCATION_SUCCESS object:self userInfo:nil];
    
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [manager stopUpdatingLocation];
}

#pragma mark - UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    
    if(viewController == self.mineNav && ![[FLUserInfoManager sharedInstance] checkLogin]){
        return NO;
    }
    
    if(viewController == self.videoNav && ![[FLUserInfoManager sharedInstance] checkLogin]){
        return NO;
    }
    
    return YES;
}

@end
