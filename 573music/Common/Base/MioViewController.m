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
	//设置背景颜色
	self.view.backgroundColor = appBgColor;
    //隐藏自带的导航栏
    self.navigationController.navigationBar.hidden = YES;

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    if (@available(iOS 13.0, *)) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
    } else {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
}



- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    //[svprogressHUD dismiss];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"内存爆了");
}




@end
