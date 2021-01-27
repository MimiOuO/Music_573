//
//  AppDelegate+MioInitalData.m
//  573music
//
//  Created by Mimio on 2020/12/31.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "AppDelegate+MioInitalData.h"
#import <XHLaunchAd.h>
#import "ScanSuccessJumpVC.h"
@interface AppDelegate()<XHLaunchAdDelegate>
@end

@implementation AppDelegate (MioInitalData)
-(void)initalData{
    [self requestSingerGroup];
    [self requestSingerCategory];
    [self requestCategory];
    [self requestMVTabs];
    [self requestSkin];
    [self requestVersion];
    [self configAd];
}

-(void)requestSingerGroup{
    [MioGetReq(api_singersGroup, @{@"k":@"v"}) success:^(NSDictionary *result){
        NSArray *data = [result objectForKey:@"data"];
        [userdefault setObject:data forKey:@"singerGroup"];
        [userdefault synchronize];
    } failure:^(NSString *errorInfo) {}];
}

-(void)requestCategory{
    [MioGetReq(api_categories, @{@"position":@"首页分类"}) success:^(NSDictionary *result){
        NSArray *data = [result objectForKey:@"data"];
        [userdefault setObject:data forKey:@"category"];
        [userdefault synchronize];
    } failure:^(NSString *errorInfo) {}];
}

-(void)requestSingerCategory{
    [MioGetReq(api_categories, @{@"position":@"歌手"}) success:^(NSDictionary *result){
        NSArray *data = [result objectForKey:@"data"];
        [userdefault setObject:data forKey:@"singerCategory"];
        [userdefault synchronize];
    } failure:^(NSString *errorInfo) {}];
}

-(void)requestMVTabs{
    [MioGetReq(api_mvTabs, @{@"k":@"v"}) success:^(NSDictionary *result){
        NSArray *data = [result objectForKey:@"data"][@"list"];
        [userdefault setObject:data forKey:@"mvtabs"];
        [userdefault synchronize];
    } failure:^(NSString *errorInfo) {}];
}

-(void)requestSkin{
    [MioGetReq(api_skin, @{@"k":@"v"}) success:^(NSDictionary *result){
        NSArray *data = [result objectForKey:@"data"];
        [userdefault setObject:data forKey:@"skinlist"];
        [userdefault synchronize];
    } failure:^(NSString *errorInfo) {}];
}

-(void)requestVersion{
    [MioGetReq(api_version, @{@"k":@"v"}) success:^(NSDictionary *result){
        NSDictionary *data = [result objectForKey:@"data"];
        NSString * remoteVersion = [[data objectForKey:@"ios_version"] stringByReplacingOccurrencesOfString:@"." withString:@""];
        NSString * currentVersion = [[NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"] stringByReplacingOccurrencesOfString:@"." withString:@""];
        if ([remoteVersion intValue] <= [currentVersion intValue]) {
            return;
        }
        [UIWindow showNewVersion:[data objectForKey:@"ios_info"] link:[data objectForKey:@"ios_spread_url"]];
    } failure:^(NSString *errorInfo) {}];
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


@end
