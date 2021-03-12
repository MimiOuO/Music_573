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
#import "CountdownTimer.h"
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
    [self requestDJTabs];
    [self requestSkin];
    [self requestVersion];
    [self requestTreaties];
    [self requestShareUrl];
    [self requestVipTimeLeft];
    
    [self configAd];
    RecieveNotice(@"loginSuccess", resetTimeLeft);
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
        
        NSMutableArray *songlistCategoryArr = [[NSMutableArray alloc] init];
        for (int i = 0;i < data.count; i++) {
            [songlistCategoryArr addObjectsFromArray:data[i][@"tags"]];
        }
        [userdefault setObject:songlistCategoryArr forKey:@"oldSonglistCategory"];
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

-(void)requestDJTabs{
    [MioGetReq(api_mvTabs, @{@"position":@"DJ专区"}) success:^(NSDictionary *result){
        NSArray *data = [result objectForKey:@"data"][0][@"tags"];
        [userdefault setObject:data forKey:@"djtabs"];
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
        if (remoteVersion.length < 4) {
            remoteVersion = [remoteVersion stringByAppendingString:@"0"];
        }
        if (currentVersion.length < 4) {
            currentVersion = [currentVersion stringByAppendingString:@"0"];
        }
        if ([remoteVersion intValue] == [currentVersion intValue]) {
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

-(void)requestTreaties{
    [MioGetReq(api_treaties, @{@"k":@"v"}) success:^(NSDictionary *result){
        NSDictionary *data = [result objectForKey:@"data"][@"urls"];
        NSString *levelTip = data[@"等级说明"][@"value"];
        NSString *jifenTip = data[@"积分说明"][@"value"];
        NSString *xieyiUrl = data[@"用户协议"][@"url"];
        NSString *yinsiUrl = data[@"服务条款"][@"url"];
        [userdefault setObject:levelTip forKey:@"levelTip"];
        [userdefault setObject:jifenTip forKey:@"jifenTip"];
        [userdefault setObject:xieyiUrl forKey:@"xieyiUrl"];
        [userdefault setObject:yinsiUrl forKey:@"yinsiUrl"];
        [userdefault synchronize];
    } failure:^(NSString *errorInfo) {}];
}

-(void)resetTimeLeft{
    [CountdownTimer stopTimerWithKey:vipCutDown];
    [MioGetReq(api_userInfo, @{@"k":@"v"}) success:^(NSDictionary *result){
        NSDictionary *data = [result objectForKey:@"data"];
        MioUserInfo *user = [MioUserInfo mj_objectWithKeyValues:data];
        if (user.vip_remain.intValue > 0) {
            [userdefault setObject:@"1" forKey:@"isVip"];
            [userdefault synchronize];
            

        
            [CountdownTimer startTimerWithKey:vipCutDown count:user.vip_remain.intValue callBack:^(NSInteger count, BOOL isFinished) {
                
//                NSLog(@"会员剩余时间%ld",(long)count);
                if (count == 1) {
                    [userdefault setObject:@"0" forKey:@"isVip"];
                    [userdefault synchronize];
                }
            }];
        }
    } failure:^(NSString *errorInfo) {}];
    [self requestLottery];
}

-(void)requestVipTimeLeft{
    [MioGetReq(api_userInfo, @{@"k":@"v"}) success:^(NSDictionary *result){
        NSDictionary *data = [result objectForKey:@"data"];
        MioUserInfo *user = [MioUserInfo mj_objectWithKeyValues:data];
        if (user.vip_remain.intValue > 0) {
            [userdefault setObject:@"1" forKey:@"isVip"];
            [userdefault synchronize];
        
            
            
            [CountdownTimer startTimerWithKey:vipCutDown count:user.vip_remain.intValue callBack:^(NSInteger count, BOOL isFinished) {
                
//                NSLog(@"会员剩余时间%ld",(long)count);
                if (count == 1) {
                    [userdefault setObject:@"0" forKey:@"isVip"];
                    [userdefault synchronize];
                }
            }];
        }
        if (user.vip_remain.intValue < 86400*3) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIWindow showShare];
            });
        }
        
    } failure:^(NSString *errorInfo) {}];

}

-(void)requestLottery{
    [MioGetReq(api_isLottery, @{@"k":@"v"}) success:^(NSDictionary *result){
        NSDictionary *data = [result objectForKey:@"data"];
        if ([data[@"is_lottery"] intValue] ==  1) {
            return;
        }else{
            [UIWindow showLucky];
        }
    } failure:^(NSString *errorInfo) {}];
}

-(void)configAd{
    [XHLaunchAd setLaunchSourceType:SourceTypeLaunchScreen];
    [XHLaunchAd setWaitDataDuration:2];
    
    [MioGetCacheReq(api_banners, @{@"position":IPHONE_X?@"启动页大":@"启动页小"}) success:^(NSDictionary *result){
        NSArray *data = [result objectForKey:@"data"];
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
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
        });
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
