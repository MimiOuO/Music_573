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
//#import <JPUSHService.h>

#import "MioLoginVC.h"

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#import <SSZipArchive.h>

#import "AppDelegate+MioInitalData.h"



#import "AFNetworkReachabilityManager.h"

#import "HcdGuideView.h"

#import <SJM3U8Download.h>
#import <SJM3U8DownloadListController.h>
#import <WHC_ModelSqlite.h>
#endif
@interface AppDelegate ()
@property (nonatomic, assign) float tabbarHeight;
@property (nonatomic, strong) HcdGuideView *guideView;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
   

//
    JJException.exceptionWhenTerminate = NO;

    [JJException configExceptionCategory:JJExceptionGuardNSStringContainer | JJExceptionGuardArrayContainer | JJExceptionGuardUnrecognizedSelector | JJExceptionGuardDictionaryContainer];
    [JJException startGuardException];
//    
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    
    // 告诉app支持后台播放
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
    
    [self changeSkinLocation];
    
    [self initSettings];
    
    self.window.rootViewController = [[MioTabbarVC alloc] init];
    [self.window makeKeyAndVisible];
    
    [self configGuideView];
    
    [self initalData];
    
    [self listenNetwork];
    
    RecieveNotice(@"downLoadFinish", downloadFinish:);
    
    return YES;
}

-(void)configGuideView{
    
    self.guideView = [HcdGuideView sharedInstance];
    self.guideView.delegate = self;
    self.guideView.window = self.window;
    [self.guideView showGuideViewWithImages:@[@"1",@"2",@"3"]
                        andButtonTitle:@""
                   andButtonTitleColor:[UIColor clearColor]
                      andButtonBGColor:[UIColor clearColor]
                  andButtonBorderColor:[UIColor clearColor]];
}

-(void)initSettings{
    [userdefault setObject:@"不开启" forKey:@"timeoff"];//定时关闭
    if (![userdefault objectForKey:@"first"]) {
        [userdefault setObject:@"1" forKey:@"first"];//是否是第一次启动
        [userdefault setObject:@"bai" forKey:@"skin"];//默认皮肤
        [userdefault setObject:@"1" forKey:@"showJifen"];//是否显示积分
        [userdefault setObject:@"标准" forKey:@"defaultQuailty"];//默认音质
        [userdefault setObject:@"-1" forKey:@"currentPlayIndex"];//当前播放的index
        [userdefault setObject:@"0" forKey:@"onlyWifi"];//是否开启仅wifi
        [userdefault setObject:@"1" forKey:@"openNewtwork"];//是否允许访问网络
        [userdefault setObject:@"0" forKey:@"isRadio"];//播放的是不是电台
        setPlayOrder(MioPlayOrderCycle);//播放顺序
        [userdefault synchronize];

        [userdefault setObject:colorDic forKey:@"colorJson"];//color写入
        [userdefault synchronize];
    }
}

#pragma mark - 监听网络状态
-(void)listenNetwork{

    AFNetworkReachabilityManager *manger = [AFNetworkReachabilityManager sharedManager];
    //开启监听，记得开启，不然不走block
    [manger startMonitoring];
    //2.监听改变
    [manger setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {

        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                
                NSLog(@"未知");
                break;
            case AFNetworkReachabilityStatusNotReachable:
            
                NSLog(@"没有网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                
                NSLog(@"3G|4G");
                if (Equals([userdefault objectForKey:@"onlyWifi"], @"1")) {
                    [userdefault setObject:@"0" forKey:@"openNewtwork"];
                }else{
                    [userdefault setObject:@"1" forKey:@"openNewtwork"];
                }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                
                NSLog(@"WiFi");
                [userdefault setObject:@"1" forKey:@"openNewtwork"];
                break;
            default:
                break;
        }
    }];
    
}

-(void)downloadFinish:(NSNotification *)notification{
    NSDictionary * musicJson = [notification object];

    MioMusicModel *music = [MioMusicModel mj_objectWithKeyValues:musicJson];
    music.savetype = @"downloaded";
    [WHCSqlite insert:music];
    
}


#pragma mark - 程序将要进入后台
- (void)applicationWillResignActive:(UIApplication *)application {
    MioTabbarVC *mt=(MioTabbarVC *)[UIApplication sharedApplication].delegate.window.rootViewController;
    _tabbarHeight = mt.tabBar.frame.origin.y;
    
    //开启后台处理多媒体事件
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    AVAudioSession *session=[AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
}


#pragma mark - 程序将要进入前台
- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    MioTabbarVC *mt=(MioTabbarVC *)[UIApplication sharedApplication].delegate.window.rootViewController;
    mt.tabBar.frame = frame(0, _tabbarHeight, KSW, 49 + SafeBotH);
    
}

- (void)applicationWillTerminate:(UIApplication *)application{
    NSLog(@"杀后台了");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"killApp" object:nil];
    [SJM3U8DownloadListController.shared suspendAllItems];//取消所有下载任务
}


/// 在这里写支持的旋转方向，为了防止横屏方向，应用启动时候界面变为横屏模式
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    
    return UIInterfaceOrientationMaskAll;
    // 可以这么写
//    if (self.allowOrentitaionRotation) {
//        return UIInterfaceOrientationMaskAllButUpsideDown;
//    }
//    return UIInterfaceOrientationMaskPortrait;
}


#pragma mark - 移动皮肤包
-(void)changeSkinLocation{
    NSString * docsdir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dataFilePath = [docsdir stringByAppendingPathComponent:@"Skin"];
    [[NSFileManager defaultManager] createDirectoryAtPath:dataFilePath withIntermediateDirectories:YES attributes:nil error:nil];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"bai" ofType:@"zip"];
    NSString *dstPath = [NSString stringWithFormat:@"%@/Skin/bai.zip",
                         NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]];

    BOOL success1 = [[NSFileManager defaultManager] copyItemAtPath:filePath toPath:dstPath error:nil];
    
    NSString *zipPath =
    [NSString stringWithFormat:@"%@/Skin/bai.zip",
                     NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]];

    NSString *unzipPath = [NSString stringWithFormat:@"%@/Skin",
                           NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]];
   
    NSLog(@"Unzip path: %@", unzipPath);
    if (!unzipPath) {
        return;
    }

    BOOL success = [SSZipArchive unzipFileAtPath:zipPath toDestination:unzipPath preserveAttributes:YES overwrite:YES nestedZipLevel:0 password:nil error:nil delegate:nil progressHandler:nil completionHandler:nil];

    
    NSString *filePath2 = [[NSBundle mainBundle] pathForResource:@"hei" ofType:@"zip"];
    NSString *dstPath2 = [NSString stringWithFormat:@"%@/Skin/hei.zip",
                         NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]];

    BOOL success2 = [[NSFileManager defaultManager] copyItemAtPath:filePath2 toPath:dstPath2 error:nil];
    
    NSString *zipPath2 =
    [NSString stringWithFormat:@"%@/Skin/hei.zip",
                     NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]];

    NSString *unzipPath2 = [NSString stringWithFormat:@"%@/Skin",
                           NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]];
    
    if (!unzipPath2) {
        return;
    }
    
    BOOL success3 = [SSZipArchive unzipFileAtPath:zipPath2 toDestination:unzipPath2 preserveAttributes:YES overwrite:YES nestedZipLevel:0 password:nil error:nil delegate:nil progressHandler:nil completionHandler:nil];

}

@end
