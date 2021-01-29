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
    [self requestHotSearch];
    [self requesttimeInterval];
    [self requestMVTabs];
    [self requestSkin];
    [self requestVersion];
    [self requestShareUrl];
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


-(void)requestHotSearch{
    [MioGetReq(api_hotSearch, @{@"k":@"v"}) success:^(NSDictionary *result){
        NSArray *data = [result objectForKey:@"data"];
        [userdefault setObject:data forKey:@"hotsearch"];
        [userdefault synchronize];
    } failure:^(NSString *errorInfo) {}];
}

-(void)requestMVTabs{
    [MioGetReq(api_mvTabs, @{@"position":@"mv"}) success:^(NSDictionary *result){
        NSArray *data = [result objectForKey:@"data"][0][@"tags"];
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

-(void)requesttimeInterval{
    [MioGetReq(api_timeInterval, @{@"k":@"v"}) success:^(NSDictionary *result){
        NSDictionary *data = [result objectForKey:@"data"];
        NSString *interval = [NSString stringWithFormat:@"%@",data[@"seconds"]];
        [userdefault setObject:interval forKey:@"timeInterval"];
        [userdefault synchronize];
    } failure:^(NSString *errorInfo) {}];
}

-(void)requestShareUrl{
    [MioGetReq(api_shareUrl, @{@"k":@"v"}) success:^(NSDictionary *result){
        NSDictionary *data = [result objectForKey:@"data"];
        NSString *shareUrl = data[@"url"];
        [userdefault setObject:shareUrl forKey:@"shareUrl"];
        [userdefault synchronize];
    } failure:^(NSString *errorInfo) {}];
}

-(void)configAd{
    [XHLaunchAd setLaunchSourceType:SourceTypeLaunchScreen];
    [XHLaunchAd setWaitDataDuration:2];
    
    [MioGetCacheReq(api_banners, @{@"position":IPHONE_X?@"启动页大":@"启动页小"}) success:^(NSDictionary *result){
        NSArray *data = [result objectForKey:@"data"];
        
        //配置广告数据
        XHLaunchImageAdConfiguration *imageAdconfiguration = [XHLaunchImageAdConfiguration defaultConfiguration];
        
        imageAdconfiguration.imageNameOrURLString = data[0][@"cover_image_path"];
        
        imageAdconfiguration.openModel = data[0][@"href"];
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
