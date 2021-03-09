//
//  ZMViewController.m
//  ZMBCY
//
//  Created by Mimio on 2019/7/24.
//  Copyright © 2019年 Mimio. All rights reserved.
//

#import "MioViewController.h"
#import "MioNavView.h"
#import <YTKNetwork.h>
//#import "MioGetRequest.h"


@implementation MioViewController


-(MioNavView *)navView{
	if (!_navView) {
		MioNavView *navView = [[MioNavView alloc] init];
		[self.view addSubview:navView];
		self.navView = navView;
		self.navView.frame = CGRectMake(0, 0, KSW, NavH);
		[self.navView.superview layoutIfNeeded];
	}
	return _navView;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	//禁止自动布局
	if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
		self.automaticallyAdjustsScrollViewInsets = NO;
	}
    self.view.height = KSH;
    
	//设置背景颜色
	self.view.backgroundColor = appWhiteColor;
    //隐藏自带的导航栏
    self.navigationController.navigationBar.hidden = YES;
    
    //背景图
//         _bgImg = //[MioImageView creatView:frame(0, 0, KSW, KSH) inView:self.view bgColor:appWhiteColor radius:0];
    
    _bgImg = [MioImageView creatImgView:frame(0, 0, KSW, KSH) inView:self.view skin:SkinName image:@"picture" radius:0];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    if (Equals(statusColor, @"white")) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }else{
        if (@available(iOS 13.0, *)) {
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
        } else {
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        }
    }
    

//    self.view.height = KSH;
    if ([MioVCConfig getBottomType:self] == MioBottomAll) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MioBottomAll" object:nil];
        self.view.height = KSH - 49 - SafeBotH - 50;
    }
    if ([MioVCConfig getBottomType:self] == MioBottomHalf) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MioBottomHalf" object:nil];
        self.view.height = KSH - SafeBotH - 50;
    }
    if ([MioVCConfig getBottomType:self] == MioBottomNone) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MioBottomNone" object:nil];
        self.view.height = KSH;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    self.view.height = KSH;
    if ([MioVCConfig getBottomType:self] == MioBottomAll) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MioBottomAll" object:nil];
        self.view.height = KSH - 49 - SafeBotH - 50;
    }
    if ([MioVCConfig getBottomType:self] == MioBottomHalf) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MioBottomHalf" object:nil];
        self.view.height = KSH - SafeBotH - 50;
    }
    if ([MioVCConfig getBottomType:self] == MioBottomNone) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MioBottomNone" object:nil];
        self.view.height = KSH;
    }
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIWindow hiddenEnterLoading];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    //[svprogressHUD dismiss];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"内存爆了");
}


-(UINavigationController *)currentTabbarSelectedNavigationController
{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    UIViewController *rootVC = window.rootViewController;
    if ([rootVC isKindOfClass:[UINavigationController class]]) {
        return (UINavigationController *)rootVC;
    }else if([rootVC isKindOfClass:[UITabBarController class]]){
        UITabBarController *tabarController = [self currentTtabarController];
        UINavigationController *selectedNV = (UINavigationController *)tabarController.selectedViewController;
        if ([selectedNV isKindOfClass:[UINavigationController class]]) {
            return selectedNV;
        }
    }

    return nil;
}

-(UITabBarController *)currentTtabarController
{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    UIViewController *tabbarController = window.rootViewController;
    if ([tabbarController isKindOfClass:[UITabBarController class]]) {
        return (UITabBarController *)tabbarController;
    }
    return nil;
}

@end
