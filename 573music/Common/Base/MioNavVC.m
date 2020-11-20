//
//  BaseNavigationController.m
//  Timeshutter
//
//  Created by Mimio on 2019/7/24.
//  Copyright © 2017年 292692700@qq.com. All rights reserved.
//

#import "MioNavVC.h"
#import "MioTabbarVC.h"
@interface MioNavVC ()
@property (strong, nonatomic) UIView *bottomNavLine;
@end

@implementation MioNavVC

-(UIView *)bottomNavLine{
    if (!_bottomNavLine) {
        _bottomNavLine = [[UIView alloc]initWithFrame:CGRectMake(0, 44, KSW, 1.0/ [UIScreen mainScreen].scale)];
        _bottomNavLine.backgroundColor =grayTextColor;
    }
    return _bottomNavLine;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //藏旧
//    [self hideBorderInView:self.navigationBar];
//    //添新
//    [self.navigationBar addSubview:self.bottomNavLine];
    
}

- (void)hideBorderInView:(UIView *)view{
    if ([view isKindOfClass:[UIImageView class]]
        && view.frame.size.height <= 1) {
        view.hidden = YES;
    }
    for (UIView *subView in view.subviews) {
        [self hideBorderInView:subView];
    }
}

- (void)showNavBottomLine{
    _bottomNavLine.hidden = NO;
}

- (void)hideNavBottomLine{
    [self hideBorderInView:self.navigationBar];
    if (_bottomNavLine) {
        _bottomNavLine.hidden = YES;
    }
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        if (@available(iOS 13.0, *)) {
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
        } else {
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        }
    }
    return self;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return self.statusBarStyle;
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count > 0) {
//        viewController.hidesBottomBarWhenPushed = YES;//隐藏二级页面的tabbar
//        self.navigationController.tabBarController.tabBar.transform = CGAffineTransformMakeTranslation(0, 20);
        
    }
    [super pushViewController:viewController animated:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}

//- (UIViewController *)popViewControllerAnimated:(BOOL)animated{
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"login2" object:nil];
//    [super popViewControllerAnimated:animated];
//    return nil;
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
