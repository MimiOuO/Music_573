//
//  ZMMainViewController.m
//  ZMBCY
//
//  Created by Mimio on 2019/7/23.
//  Copyright © 2019年 Mimio. All rights reserved.
//

#import "MioMainViewController.h"
#import "MioBaseNavigationController.h"
#import "MioHomeVC.h"
#import "Lottie.h"
#import "MioGroudVC.h"
#import "MioMineVC.h"
@interface MioMainViewController ()

@property (nonatomic, strong) UIControl *shadowView;
@property (nonatomic, strong) UIView *tipView;
@property (nonatomic, strong) UIButton *agreeBtn;
@property (nonatomic, strong) UIButton *rejectBtn;
@property (nonatomic, strong) UILabel *gameNameLab;
@property (nonatomic, strong) UILabel *price;
@property (nonatomic, strong) UILabel *userName;
@property (nonatomic, strong) UILabel *timeAndNum;
@property (nonatomic, strong) UILabel *remark;
@property (nonatomic, strong) LOTAnimationView *hud1;
@property (nonatomic, strong) LOTAnimationView *hud2;
@property (nonatomic, strong) LOTAnimationView *hud3;
@property (nonatomic, strong) LOTAnimationView *hud4;

@end

@implementation MioMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UITabBar appearance] setBarTintColor:appWhiteColor];
    [UITabBar appearance].translucent = NO;
    
    // 设置一个自定义 View,大小等于 tabBar 的大小
    UIView *bgView = [[UIView alloc] initWithFrame:frame(0, 0, KSW, 49 + SafeBotH)];
    // 给自定义 View 设置颜色
    bgView.backgroundColor = appWhiteColor;
    // 将自定义 View 添加到 tabBar 上
    [self.tabBar insertSubview:bgView atIndex:0];
    
//    UIImageView *upShaow = [UIImageView creatImgView:frame(0, -13, KSW, 13) inView:self.tabBar image:@"Home_upshadow" radius:0];
    UIView *split = [UIView creatView:frame(0, 0, KSW, 0.5) inView:self.tabBar bgColor:rgba(0, 0, 0, 0.1)];
    self.tabBar.backgroundImage = [[UIImage alloc]init];
    self.tabBar.shadowImage = [[UIImage alloc]init];
    if (@available(iOS 13.0, *)) {
        UITabBarAppearance *tabBarAppearance = [self.tabBar.standardAppearance copy];
        [tabBarAppearance setBackgroundImage:[UIImage new]];
        [tabBarAppearance setShadowColor:[UIColor clearColor]];
        [self.tabBar setStandardAppearance:tabBarAppearance];
    }else{
        [self.tabBar setBackgroundImage:[UIImage new]];
        [self.tabBar setShadowImage:[UIImage new]];
    }


    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(login) name:@"login" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTip:) name:@"showTip" object:nil];
    
    //首页
    [self addChildVc:[MioHomeVC new] title:@"首页" image:@"tab_home_ordinary" selectedImage:@"tab_home_selected"];
    //发现
    [self addChildVc:[MioGroudVC new] title:@"广场" image:@"tab_found_ordinary" selectedImage:@""];
    //消息
//    [self addChildVc:[EMConversationsViewController new] title:@"消息" image:@"tab_message_ordinary" selectedImage:@""];
    //我的
    [self addChildVc:[MioMineVC new] title:@"我的" image:@"tab_my_ordinary" selectedImage:@"tab_my_selected"];
	
    
    _hud1 = [LOTAnimationView animationNamed:@"首页"];
    _hud2 = [LOTAnimationView animationNamed:@"社区"];
    _hud3 = [LOTAnimationView animationNamed:@"消息"];
    _hud4 = [LOTAnimationView animationNamed:@"我的"];
    _hud1.userInteractionEnabled = NO;
    _hud2.userInteractionEnabled = NO;
    _hud3.userInteractionEnabled = NO;
    _hud4.userInteractionEnabled = NO;
    
}



#pragma mark - 添加子控制器
- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage{
    // 设置子控制器的文字(可以设置tabBar和navigationBar的文字)
    childVc.title = title;
    
    // 设置子控制器的tabBarItem图片
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    // 禁用图片渲染
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    MioBaseNavigationController *nav = [[MioBaseNavigationController alloc] initWithRootViewController:childVc];

    //设置item按钮
    nav.tabBarItem = [[UITabBarItem alloc]initWithTitle:title image:[[UIImage imageNamed:image]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    //未选中字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:rgb(136, 134, 135),NSFontAttributeName:[UIFont systemFontOfSize:10]} forState:UIControlStateNormal];
    
    //选中字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:mainColor,NSFontAttributeName:[UIFont systemFontOfSize:10]} forState:UIControlStateSelected];
    self.tabBar.tintColor = mainColor;
    
    [nav.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -2)];
    
    // 添加子控制器
    [self addChildViewController:nav];
   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"内存爆了");
}


- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    
    NSInteger index = [self.tabBar.items indexOfObject:item];
    
    UIView *subview1 = self.tabBar.subviews[3];
    UIView *subview2 = self.tabBar.subviews[4];
    UIView *subview3 = self.tabBar.subviews[5];
    UIView *subview4 = self.tabBar.subviews[6];
    
    
    UIView *subimg1;
    UIView *subimg2;
    UIView *subimg3;
    UIView *subimg4;
    
    for (UIView *subImg in subview1.subviews) {
        if ([subImg isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) {
            subimg1 = subImg;
        }
    }
    for (UIView *subImg in subview2.subviews) {
        if ([subImg isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) {
            subimg2 = subImg;
        }
    }
    for (UIView *subImg in subview3.subviews) {
        if ([subImg isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) {
            subimg3 = subImg;
        }
    }
    for (UIView *subImg in subview4.subviews) {
        if ([subImg isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) {
            subimg4 = subImg;
        }
    }

    
    _hud1.frame = frame(0, 5.33, 25, 25);
    _hud1.centerX = subview1.width/2;
    [subview1 addSubview:_hud1];
    

    _hud2.frame = frame(0, 5.33, 25, 25);
    _hud2.centerX = subview2.width/2;
    [subview2 addSubview:_hud2];
    
    _hud3.frame = frame(0, 5.33, 25, 25);
    _hud3.centerX = subview3.width/2;
    [subview3 addSubview:_hud3];
    
    _hud4.frame = frame(0, 5.33, 25, 25);
    _hud4.centerX = subview4.width/2;
    [subview4 addSubview:_hud4];
    
    if (index == 0) {
        
        [_hud1 play];
        [_hud2 stop];
        [_hud3 stop];
        [_hud4 stop];
        
        subimg1.hidden = YES;
        subimg2.hidden = NO;
        subimg3.hidden = NO;
        subimg4.hidden = NO;
    }
    
    if (index == 1) {

        [_hud1 stop];
        [_hud2 play];
        [_hud3 stop];
        [_hud4 stop];
        
        subimg1.hidden = NO;
        subimg2.hidden = YES;
        subimg3.hidden = NO;
        subimg4.hidden = NO;
    }

    if (index == 2) {

        [_hud1 stop];
        [_hud2 stop];
        [_hud3 play];
        [_hud4 stop];
        
        subimg1.hidden = NO;
        subimg2.hidden = NO;
        subimg3.hidden = YES;
        subimg4.hidden = NO;
    }
    if (index == 3) {

        [_hud1 stop];
        [_hud2 stop];
        [_hud3 stop];
        [_hud4 play];
        
        subimg1.hidden = NO;
        subimg2.hidden = NO;
        subimg3.hidden = NO;
        subimg4.hidden = YES;
    }
    
    

        
//    subview.subviews
//    [hud1 playWithCompletion:^(BOOL animationFinished) {
//        for (UIView *subImg in subview.subviews) {
//            if ([subImg isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) {
////                subImg.hidden = NO;
//                [hud removeFromSuperview];
//            }
//        }
//    }];
//    if (index > 0) {
//        if (![MioUserInfo shareUserInfo].isLogin) {
//            goLogin;
//            return;
//        }else{
//            [self animationWithIndex:index];
//
//        }
//    }else{
//        [self animationWithIndex:index];
//    }
}


- (void)animationWithIndex:(NSInteger) index {
    
    NSMutableArray * tabbarbuttonArray = [NSMutableArray array];
    for (UIView *tabBarButton in self.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabbarbuttonArray addObject:tabBarButton];
        }
    }
    CABasicAnimation*pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulse.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pulse.duration = 0.08;
    pulse.repeatCount = 1;
    pulse.autoreverses= YES;
    pulse.fromValue= [NSNumber numberWithFloat:0.9];
    pulse.toValue= [NSNumber numberWithFloat:1.1];
    [[((UIButton *)tabbarbuttonArray[index]) layer] addAnimation:pulse forKey:nil];
}

-(void)login{
    
    MioLoginVC *vc = [[MioLoginVC alloc] init];
    MioBaseNavigationController *nav = [[MioBaseNavigationController alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle = 0;
    [self presentViewController:nav animated:YES completion:nil];
    return;
    
}


@end
