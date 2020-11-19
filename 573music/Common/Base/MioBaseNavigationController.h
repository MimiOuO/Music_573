//
//  BaseNavigationController.h
//  Timeshutter
//
//  Created by Mimio on 2019/7/24.
//  Copyright © 2017年 292692700@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MioBaseNavigationController : UINavigationController

@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;

- (void)showNavBottomLine;
- (void)hideNavBottomLine;

@end
