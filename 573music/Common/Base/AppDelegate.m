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

#import "AppDelegate+MioInitalData.h"

#import <XHLaunchAd.h>
#import "ScanSuccessJumpVC.h"

#import "AFNetworkReachabilityManager.h"

#import "HcdGuideView.h"
#endif
@interface AppDelegate ()<XHLaunchAdDelegate>
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
    
    [self initSettings];
    
    [self changeSkinLocation];
    
    self.window.rootViewController = [[MioTabbarVC alloc] init];
    [self.window makeKeyAndVisible];
    
    [self configGuideView];
    
    [self configAd];
    
    [self initalData];
    
    [self listenNetwork];
    
    [self checkVersion];
    
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

-(void)configAd{
    [XHLaunchAd setLaunchSourceType:SourceTypeLaunchScreen];
    [XHLaunchAd setWaitDataDuration:2];
    [MioGetCacheReq(api_startAd, @{@"k":@"v"}) success:^(NSDictionary *result){
        NSDictionary *data = [result objectForKey:@"data"];
        
        //配置广告数据
        XHLaunchImageAdConfiguration *imageAdconfiguration = [XHLaunchImageAdConfiguration defaultConfiguration];
        
        imageAdconfiguration.imageNameOrURLString = data[@"url"];
        
        imageAdconfiguration.openModel = @"http://www.baidu.com";
        imageAdconfiguration.frame = CGRectMake(0, 0, KSW, KSH- 78 - SafeBotH);
        imageAdconfiguration.skipButtonType = SkipTypeTimeText;
       
        UIImageView *icon = [UIImageView creatImgView:frame(KSW2 - 98/2, KSH - 25 - 28 - SafeBotH, 98, 28) inView:nil image:@"573logo" radius:0];
        imageAdconfiguration.subViews = [NSArray arrayWithObject:icon];
        
        //显示图片开屏广告
        [XHLaunchAd imageAdWithImageAdConfiguration:imageAdconfiguration delegate:self];
    } failure:^(NSString *errorInfo) {}];
 
}

-(BOOL)xhLaunchAd:(XHLaunchAd *)launchAd clickAtOpenModel:(id)openModel clickPoint:(CGPoint)clickPoint{
    
    NSLog(@"广告点击事件");
    
    //openModel即配置广告数据设置的点击广告时打开页面参数(configuration.openModel)
    
    if(openModel == nil) return NO;
    
    ScanSuccessJumpVC *vc = [[ScanSuccessJumpVC alloc] init];
    NSString *urlString = (NSString *)openModel;
    vc.jump_URL = urlString;
    //此处不要直接取keyWindow
    UIViewController* rootVC = [[UIApplication sharedApplication].delegate window].rootViewController;
    [((UITabBarController*)rootVC).selectedViewController pushViewController:vc animated:YES];
    
    return YES;//YES移除广告,NO不移除广告
}


-(void)initSettings{
    [userdefault setObject:@"不开启" forKey:@"timeoff"];
    if (![userdefault objectForKey:@"first"]) {
        [userdefault setObject:@"1" forKey:@"first"];
        [userdefault setObject:@"bai" forKey:@"skin"];
        [userdefault setObject:@"1" forKey:@"showJifen"];
        [userdefault setObject:@"标清" forKey:@"defaultQuailty"];
        [userdefault setObject:@"-1" forKey:@"currentPlayIndex"];
        [userdefault setObject:@"0" forKey:@"onlyWifi"];
        [userdefault setObject:@"1" forKey:@"openNewtwork"];
        setPlayOrder(MioPlayOrderCycle);
        [userdefault synchronize];
    }
}

-(void)checkVersion{
    
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
}


/// 在这里写支持的旋转方向，为了防止横屏方向，应用启动时候界面变为横屏模式
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    // 可以这么写
    if (self.allowOrentitaionRotation) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
    return UIInterfaceOrientationMaskPortrait;
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
