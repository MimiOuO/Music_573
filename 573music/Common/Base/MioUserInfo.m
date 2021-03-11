//
//  ZMUserInfo.m
//  ZMBCY
//
//  Created by ZOMAKE on 2018/1/6.
//  Copyright © 2018年 Brance. All rights reserved.
//

#import "MioUserInfo.h"

#define userSessionToken @"userSessionToken"

static MioUserInfo *_userInfo;
@implementation MioUserInfo

/** 用户信息类的单例 */
+ (instancetype)shareUserInfo{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _userInfo = [[MioUserInfo alloc] init];
    });
    return _userInfo;
}

- (BOOL)isLogin{
	return [userdefault objectForKey:@"token"];
}

- (void)saveUserInfoToSandbox{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	NSData* imageData = [NSKeyedArchiver archivedDataWithRootObject:[UIImage imageNamed:@"icon"]];
	[[NSUserDefaults standardUserDefaults] setObject:imageData forKey:@"icon"];
	[defaults setObject:@"Orrilan Fitness" forKey:@"userName"];
	[defaults setObject:@"Male" forKey:@"sex"];
	[defaults setObject:@"Keep going,Never stop!" forKey:@"sign"];
    [defaults synchronize];
	
}

- (void)loginOut{
    [userdefault setObject:@"" forKey:@"token"];
	[userdefault synchronize];
}

- (NSString *)vip_remain_format{
    if (_vip_remain.intValue > 86400) {
        return [NSString stringWithFormat:@"%d天",_vip_remain.intValue/86400 + 1];
    }else{
        return [NSString stringWithFormat:@"%d小时",_vip_remain.intValue/1440 + 1];
    }
}


@end
