//
//  UIViewController+MioExtension.h
//  573music
//
//  Created by Mimio on 2021/3/4.
//  Copyright © 2021 Mimio. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (MioExtension)
-(UINavigationController *)currentTabbarSelectedNavigationController;

-(UITabBarController *)currentTtabarController;
@end

NS_ASSUME_NONNULL_END
