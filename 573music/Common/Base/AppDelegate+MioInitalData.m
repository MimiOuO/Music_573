//
//  AppDelegate+MioInitalData.m
//  573music
//
//  Created by Mimio on 2020/12/31.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "AppDelegate+MioInitalData.h"

@implementation AppDelegate (MioInitalData)
-(void)initalData{
    [self requestSingerGroup];
    [self requestCategory];
    [self requestMVTabs];
    [self requestSkin];
}

-(void)requestSingerGroup{
    [MioGetReq(api_singersGroup, @{@"k":@"v"}) success:^(NSDictionary *result){
        NSDictionary *data = [result objectForKey:@"data"];
        [userdefault setObject:data forKey:@"singerGroup"];
        [userdefault synchronize];
    } failure:^(NSString *errorInfo) {}];
}

-(void)requestCategory{
    [MioGetReq(api_categories, @{@"k":@"v"}) success:^(NSDictionary *result){
        NSArray *data = [result objectForKey:@"data"];
        [userdefault setObject:data forKey:@"category"];
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

@end
