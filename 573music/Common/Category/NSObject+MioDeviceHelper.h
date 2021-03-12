//
//  NSObject+MioDeviceHelper.h
//  573music
//
//  Created by Mimio on 2021/3/12.
//  Copyright © 2021 Mimio. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (MioDeviceHelper)
+ (NSString *)getCurrentDeviceModel;
+(NSString *)getDeviceIDInKeychain;
@end

NS_ASSUME_NONNULL_END
