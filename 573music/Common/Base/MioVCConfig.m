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
    NSArray *noneArr = @[@"MioLoginVC",@"MioTestVC",@"MioMainPlayerVC"];
    NSArray *allArr = @[@"MioHomeVC",@"MioGroudVC",@"MioMineVC"];
    
    NSString *vcName = NSStringFromClass([VC class]);
    if ([noneArr containsObject:vcName])
        return MioBottomNone;
    else if ([allArr containsObject:vcName])
        return MioBottomAll;
    else
        return MioBottomHalf;
}

@end
