//
//  AppDelegate.m
//  ifixMerchat
//
//  Created by Mimio on 2020/3/30.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "AppDelegate.h"
#import "MioTabbarVC.h"
#import <JJException.h>
#import <JPUSHService.h>

#import "MioLoginVC.h"

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#import <SSZipArchive.h>
#endif
@interface AppDelegate ()
@property (nonatomic, assign) float tabbarHeight;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.window.rootViewController = [[MioTabbarVC alloc] init];

    
    [self.window makeKeyAndVisible];
    
    JJException.exceptionWhenTerminate = NO;
    
    [JJException configExceptionCategory:JJExceptionGuardNSStringContainer | JJExceptionGuardArrayContainer | JJExceptionGuardUnrecognizedSelector | JJExceptionGuardDictionaryContainer];
    [JJException startGuardException];
    
    [self registPlatform];
    
    [self changeSkinLocation];
    
    [self initSettings];
    
    [self initAudioPlayer];
    return YES;
}



-(void)initSettings{
    NSLog(@"%@",[userdefault objectForKey:@"first"]);
    if (![userdefault objectForKey:@"first"]) {
        [userdefault setObject:@"1" forKey:@"first"];
        [userdefault setObject:@"bai" forKey:@"skin"];
    }
}

-(void)changeSkinLocation{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDirectory = [path objectAtIndex:0];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"hei" ofType:@"zip"];
    NSString *dstPath = [NSString stringWithFormat:@"%@/Skin/hei.zip",
                         NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]];

    [[NSFileManager defaultManager] copyItemAtPath:filePath toPath:dstPath error:nil];
    
    NSString *zipPath =
    [NSString stringWithFormat:@"%@/Skin/hei.zip",
                     NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]];

    NSString *unzipPath = [NSString stringWithFormat:@"%@/Skin",
                           NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]];
   
    NSLog(@"Unzip path: %@", unzipPath);
    if (!unzipPath) {
        return;
    }
    
    BOOL success = [SSZipArchive unzipFileAtPath:zipPath
                                   toDestination:unzipPath
                              preserveAttributes:YES
                                       overwrite:YES
                                  nestedZipLevel:0
                                        password:nil
                                           error:nil
                                        delegate:nil
                                 progressHandler:nil
                               completionHandler:nil];
    if (success) {
        NSLog(@"Success unzip");
        
    } else {
        NSLog(@"No success unzip");
        
        
    }
}

#pragma mark - 程序将要进入后台
- (void)applicationWillResignActive:(UIApplication *)application {
    MioTabbarVC *mt=(MioTabbarVC *)[UIApplication sharedApplication].delegate.window.rootViewController;
    _tabbarHeight = mt.tabBar.frame.origin.y;
}
#pragma mark - 程序将要进入前台
- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    MioTabbarVC *mt=(MioTabbarVC *)[UIApplication sharedApplication].delegate.window.rootViewController;
    mt.tabBar.frame = frame(0, _tabbarHeight, KSW, 49 + SafeBotH);
    
}


-(void)registPlatform{

 
    //======================================================================//
    //                                 极光
    //======================================================================//
    //Required
    //notice: 3.0.0 及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound|JPAuthorizationOptionProvidesAppNotificationSettings;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义 categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    
    // Required
    // init Push
    // notice: 2.1.5 版本的 SDK 新增的注册方法，改成可上报 IDFA，如果没有使用 IDFA 直接传 nil
    [JPUSHService setupWithOption:nil appKey:@"c6160bed256ee7eaabbb2a6d"
                          channel:@"App Store"
                 apsForProduction:1
            advertisingIdentifier:nil];
    [JPUSHService setAlias:currentUserId completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        NSLog(@"rescode: %ld, \ntags: %@, \nalias: %@\n", (long)iResCode, @"tag" , iAlias);
    } seq:0];
    
}

/// 在这里写支持的旋转方向，为了防止横屏方向，应用启动时候界面变为横屏模式
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    // 可以这么写
    if (self.allowOrentitaionRotation) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark- JPUSHRegisterDelegate

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}


// iOS 12 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification{
    if (notification && [notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //从通知界面直接进入应用
    }else{
        //从通知设置界面进入应用
    }
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionBadge); // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置
    if ([[userInfo objectForKey:@"type"] isEqualToString:@"order"]) {
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"showTip" object:nil userInfo:userInfo]];
    }
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required, For systems with less than or equal to iOS 6
    [JPUSHService handleRemoteNotification:userInfo];
    
}

@end
