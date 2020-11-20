//
//  MioVCConfig.h
//  573music
//
//  Created by Mimio on 2020/11/20.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, MioBottomType) {
    MioBottomNone,
    MioBottomHalf,
    MioBottomAll,
};

@interface MioVCConfig : NSObject
+(MioBottomType)getBottomType:(UIViewController *)VC;
@end

NS_ASSUME_NONNULL_END
