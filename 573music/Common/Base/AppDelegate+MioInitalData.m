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

@end
