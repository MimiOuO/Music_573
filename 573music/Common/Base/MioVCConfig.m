//
//  MioVCConfig.m
//  573music
//
//  Created by Mimio on 2020/11/20.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioVCConfig.h"


@implementation MioVCConfig
+(MioBottomType)getBottomType:(UIViewController *)VC{
    NSString *vcName = NSStringFromClass([VC class]);
    NSArray *followArr = @[@"MioPlayListVC",@"MioMutipleVC"];
    if ([followArr containsObject:vcName]) {
        if (Equals([userdefault objectForKey:@"currentBottomType"], @"MioBottomNone")) {
            return MioBottomNone;
        }else if (Equals([userdefault objectForKey:@"currentBottomType"], @"MioBottomAll")){
            return MioBottomAll;
        }else{
            return MioBottomHalf;
        }
        
    }
    
    NSArray *noneArr = @[@"MioLoginVC",@"MioTestVC",@"MioMainPlayerVC",@"MioMutipleVC",@"MioLoginVC",@"MioPasswordLoginVC",@"MioModiPassWordVC",@"MioMoreVC",@"MioTimeOffVC",@"MioEditInfoVC",@"PYSearchViewController",@"MioMvVC",@"MioViewController",@"MioMvCmtVC",@"MioMutipleVC",@"MioListenMusicVC",@"LBXScanBaseViewController",@"ScanSuccessJumpVC"];
    NSArray *allArr = @[@"MioHomeVC",@"MioGroudVC",@"MioMineVC",@"MioHomeRecommendVC",@"MioHomeMusicHallVC"];
    
    
    if ([noneArr containsObject:vcName]){
        [userdefault setObject:@"MioBottomNone" forKey:@"currentBottomType"];
        return MioBottomNone;
    }
    else if ([allArr containsObject:vcName]){
        [userdefault setObject:@"MioBottomAll" forKey:@"currentBottomType"];
        return MioBottomAll;
    }
    else{
        [userdefault setObject:@"MioBottomHalf" forKey:@"currentBottomType"];
        return MioBottomHalf;
    }

}

@end
