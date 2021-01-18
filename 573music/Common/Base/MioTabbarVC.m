//
//  ZMMainViewController.m
//  ZMBCY
//
//  Created by Mimio on 2019/7/23.
//  Copyright © 2019年 Mimio. All rights reserved.
//

#import "MioTabbarVC.h"
#import "MioNavVC.h"
//#import "EMConversationsViewController.h"
#import "MioHomeVC.h"
#import "Lottie.h"
#import "MioGroudVC.h"
#import "MioMineVC.h"
#import "MioMainPlayerVC.h"
#import "MioBottomPlayView.h"

@interface MioTabbarVC ()

@property (nonatomic, strong) UIControl *shadowView;
@property (nonatomic, strong) MioBottomPlayView *bottomPlayer;
@property (nonatomic, strong) UIImageView *bgView;

@property (nonatomic, strong) MioHomeVC *homeVC;
@property (nonatomic, strong) MioGroudVC *groundVC;
@property (nonatomic, strong) MioMineVC *mineVC;


@property (nonatomic, strong) MioMainPlayerVC *mainPlayerVC;

@end

@implementation MioTabbarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UITabBar appearance] setBarTintColor:appWhiteColor];
    [UITabBar appearance].translucent = NO;
    
    self.tabbar = [[MioTabbar alloc] init];
    [self setValue:self.tabbar forKeyPath:@"tabBar"];
    
    // 设置一个自定义 View,大小等于 tabBar 的大小
    _bgView = [[UIImageView alloc] initWithFrame:frame(0, 0, KSW, 49 + SafeBotH)];
    _bgView.image = imagePath(@"picture_bql");

    
    // 将自定义 View 添加到 tabBar 上
    [self.tabBar insertSubview:_bgView atIndex:0];
    
    MioView *split = [MioView creatView:frame(0, 0, KSW, 0.5) inView:self.tabbar bgColorName:name_split radius:0];
    
    _mainPlayerVC = [[MioMainPlayerVC alloc] init];
    _bottomPlayer = [[MioBottomPlayView alloc] initWithFrame:frame(0, -50, KSW, 50)];
    [_bottomPlayer whenTapped:^{
        if (mioM3U8Player.currentMusic) {
            MioNavVC *nav = [[MioNavVC alloc] initWithRootViewController:_mainPlayerVC];
            nav.modalPresentationStyle = 0;
            [self presentViewController:nav animated:YES completion:nil];
        }
    }];
    [self.tabbar addSubview:_bottomPlayer];
    [self.tabbar sendSubviewToBack:_bottomPlayer];
    

    
    RecieveChangeSkin;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(login) name:@"login" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mioBottomNone) name:@"MioBottomNone" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mioBottomHalf) name:@"MioBottomHalf" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mioBottomAll) name:@"MioBottomAll" object:nil];
 
    
    _homeVC = [MioHomeVC new];
    _groundVC = [MioGroudVC new];
    _mineVC = [MioMineVC new];
    //首页
    [self addChildVc:_homeVC title:@"首页" image:imagePath(@"tab_yingyue_putong") selectedImage:imagePath(@"tab_yingyue")];
    //发现
    [self addChildVc:_groundVC title:@"广场" image:imagePath(@"tab_mv_putong") selectedImage:imagePath(@"tab_mv")];
 
    //我的
    [self addChildVc:_mineVC title:@"我的" image:imagePath(@"tab_me_putong") selectedImage:imagePath(@"tab_me")];
	


}

-(void)changeSkin{

    NSArray<UITabBarItem *> *items = self.tabBar.items;
    
    items[0].image = [UIImage imageWithCGImage:imagePath(@"tab_yingyue_putong").CGImage scale:3 orientation:UIImageOrientationUp];
    items[1].image = [UIImage imageWithCGImage:imagePath(@"tab_mv_putong").CGImage scale:3 orientation:UIImageOrientationUp];
    items[2].image = [UIImage imageWithCGImage:imagePath(@"tab_me_putong").CGImage scale:3 orientation:UIImageOrientationUp];
    
    items[0].selectedImage = [[UIImage imageWithCGImage:imagePath(@"tab_yingyue").CGImage scale:3 orientation:UIImageOrientationUp] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    items[1].selectedImage = [[UIImage imageWithCGImage:imagePath(@"tab_mv").CGImage scale:3 orientation:UIImageOrientationUp] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    items[2].selectedImage = [[UIImage imageWithCGImage:imagePath(@"tab_me").CGImage scale:3 orientation:UIImageOrientationUp] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    self.tabBar.tintColor = color_main;
    self.tabBar.unselectedItemTintColor = color_icon_three;

    
    _bgView.image = imagePath(@"picture_bql");
}


#pragma mark - 添加子控制器
- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage{
    // 设置子控制器的文字(可以设置tabBar和navigationBar的文字)
    childVc.title = title;
    
    // 设置子控制器的tabBarItem图片
    childVc.tabBarItem.image = image;
    // 禁用图片渲染
    childVc.tabBarItem.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    MioNavVC *nav = [[MioNavVC alloc] initWithRootViewController:childVc];

    UIImage *normalImage = [UIImage imageWithCGImage:image.CGImage scale:3 orientation:UIImageOrientationUp];
    UIImage *selectImage = [UIImage imageWithCGImage:selectedImage.CGImage scale:3 orientation:UIImageOrientationUp];
    //设置item按钮
    nav.tabBarItem = [[UITabBarItem alloc]initWithTitle:title image:[normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[selectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    self.tabBar.tintColor = color_main;
    self.tabBar.unselectedItemTintColor = color_icon_three;


    
    [nav.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -2)];
    
    // 添加子控制器
    [self addChildViewController:nav];
   
}

-(void)mioBottomHalf{
    [UIView animateWithDuration:0.3 animations:^{
        self.tabBar.frame = frame(0, KSH, KSW, 49 + SafeBotH);
        _bottomPlayer.frame = frame(0, -50-SafeBotH, KSW, 50+SafeBotH);
    } completion:^(BOOL finished) {
        
    }];
   
}
 
-(void)mioBottomAll{
    [UIView animateWithDuration:0.3 animations:^{
        self.tabBar.frame = frame(0, KSH - 49 - SafeBotH, KSW, 49 + SafeBotH);
        _bottomPlayer.frame = frame(0, -50, KSW, 50);
    } completion:^(BOOL finished) {
        
    }];
}

-(void)mioBottomNone{
    [UIView animateWithDuration:0.3 animations:^{
        self.tabBar.frame = frame(0, KSH + _bottomPlayer.height + 10, KSW, 49 + SafeBotH);
        _bottomPlayer.frame = frame(0, -50, KSW, 50);
    } completion:^(BOOL finished) {
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"内存爆了");
}


- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    
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
    MioNavVC *nav = [[MioNavVC alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle = 0;
    [self presentViewController:nav animated:YES completion:nil];
    return;
    
}


@end
