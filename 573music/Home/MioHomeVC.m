//
//  MioHomeVC.m
//  ifixMerchat
//
//  Created by Mimio on 2020/4/10.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioHomeVC.h"
#import <WMPageController.h>
#import "MioHomeMusicHallVC.h"
#import "MioHomeRecommendVC.h"

#import "MioFeedBackVC.h"
#import "MioTestVC.h"
#import "MioTest2VC.h"
#import "MioLabel.h"
#import "MioPlayListVC.h"

@interface MioHomeVC ()<WMPageControllerDelegate,WMPageControllerDataSource>
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) WMPageController *pageController;

@end

@implementation MioHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    RecieveChangeSkin;
    
    _contentView = [[UIView alloc] initWithFrame:frame(0, 0, KSW, KSH - TabH)];
    _contentView.backgroundColor = appClearColor;
    [self.view addSubview:_contentView];
    

    
    _pageController = [[WMPageController alloc] init];
    [self addChildViewController:_pageController];
    _pageController.delegate           = self;
    _pageController.dataSource         = self;
    _pageController.menuViewStyle      = WMMenuViewStyleLine;
    _pageController.menuViewLayoutMode = WMMenuViewLayoutModeLeft;
    _pageController.automaticallyCalculatesItemWidths = YES;
    _pageController.itemMargin         = 16;
    _pageController.menuHeight         = 48;
    _pageController.titleFontName      = @"PingFangSC-Medium";
    _pageController.titleSizeNormal    = 16;
    _pageController.titleSizeSelected  = 20;
    _pageController.menuBGColor        = appClearColor;
    _pageController.titleColorNormal   = subColor;
    _pageController.titleColorSelected = color_main;
    _pageController.progressWidth      = 16;
    _pageController.progressHeight     = 3;
    _pageController.progressViewCornerRadius = 1.5;
    _pageController.progressViewBottomSpace = 4;
    _pageController.viewFrame = CGRectMake(0, StatusH , KSW , KSH - StatusH - 44 - TabH);
    _pageController.menuViewContentMargin = 20;
    [_contentView addSubview:self.pageController.view];
    
    
//    self.view.backgroundColor = appWhiteColor;
//    UIButton *sdfsd = [UIButton creatBtn:frame(100, 100, 100, 100) inView:self.view bgColor:color_main title:@"111" titleColor:appWhiteColor font:14 radius:5 action:^{
//
//        if (Equals([userdefault objectForKey:@"skin"], @"bai") ) {
//            [userdefault setObject:@"hei" forKey:@"skin"];
//        }else{
//            [userdefault setObject:@"bai" forKey:@"skin"];
//        }
//
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeSkin" object:nil];
////        MioFeedBackVC *vc = [[MioFeedBackVC alloc] init];
////        [self.navigationController pushViewController:vc animated:YES];
//    }];
//    UIButton *sdfsdws = [UIButton creatBtn:frame(100, 220, 100, 100) inView:self.view bgColor:color_main title:@"111" titleColor:appWhiteColor font:14 radius:5 action:^{
//
//        [mioPlayer play];
//        return;
//        MioTestVC *vc = [[MioTestVC alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
//    }];
//
//    UIButton *sdfsdw21s = [UIButton creatBtn:frame(100, 340, 100, 100) inView:self.view bgColor:color_main title:@"222" titleColor:appWhiteColor font:14 radius:5 action:^{
//        MioPlayListVC * vc = [[MioPlayListVC alloc]init];
//        [self presentViewController:vc animated:YES completion:nil];
////        [mioPlayer pause];
//        return;
////        MioTest2VC *vc = [[MioTest2VC alloc] init];
////        [self.navigationController pushViewController:vc animated:YES];
//    }];
//
////    UIImageView *avatar = [UIImageView creatImginView:self.view image:@"avatar_bai" radius:0];
//    UIImageView *avatar = [UIImageView creatImgView:frame(100, 460, 100, 100) inView:self.view image:@"" radius:5];
//
//    NSString *path = [NSString stringWithFormat:@"%@/Skin/bai/icon_bai.jpg",
//                     NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]];
//    avatar.image = [UIImage imageWithContentsOfFile:path];
////    UIImage *_image = [UIImage imageWithContentsOfFile:fullPathToFile];
//
//
//    MioLabel *testlab = [[MioLabel alloc] init];
//    testlab.frame = frame( 0, 580, KSW, 23);
//    testlab.text = @"sdlfskjfsldjf234dsfsdfsf";
//    testlab.textColor = subColor;
//    [self.view addSubview:testlab];
//
//    NSLog(@"%@",colorPath);
//
//    [MioGetCacheReq(@"https://test.aw998.com/api/dance/all_listen_dance", (@{@"token":@"8bafb112da1c444cba40578884196350",@"random":@"1"})) success:^(NSDictionary *result){
//        NSArray *data = [result objectForKey:@"list"];
//        NSMutableArray *musicArr = [[NSMutableArray alloc] init];
//        for (int i = 0;i < data.count; i++) {
//            [musicArr addObject:[MioMusicModel mj_objectWithKeyValues:data[i]]];
//        }
//        if (musicArr.count > 0) {
////            [mioPlayer playWithMusicList:musicArr andIndex:0];
//        }
//    } failure:^(NSString *errorInfo) {
//        NSLog(@"%@",errorInfo);
//    }];
//

    
}

-(void)changeSkin{
    _pageController.titleColorSelected = color_main;
    [_pageController reloadData];
    CGFloat r = (CGFloat) [(colorDic[@"main"][@"r"]) intValue]/255.0;
    CGFloat g = (CGFloat) [(colorDic[@"main"][@"g"]) intValue]/255.0;
    CGFloat b = (CGFloat) [(colorDic[@"main"][@"b"]) intValue]/255.0;
    CGFloat a = (CGFloat) 1/1.0;
    CGFloat components[4] = {r,g,b,a};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

    CGColorRef color = CGColorCreate(colorSpace, components);
    CGColorSpaceRelease(colorSpace);
    
    _pageController.menuView.progressView.color =  color;
    [_pageController.menuView.progressView setNeedsDisplay];
    
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController{
    
    return 2;
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index{
    
    if (index == 0) {
        
        return [[MioHomeRecommendVC alloc] init];
    }else{
        return [[MioHomeMusicHallVC alloc] init];
    }
    
    
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index{
    
    if (index == 0) {
        return @"推荐";
    }else{
        return @"音乐馆";
    }
    
}

-(void)upScroll{
    WEAKSELF;
    [UIView animateWithDuration:0.3 animations:^{
//        weakSelf.publichBtn.top =  KSH - 56 - 23 - TabH;
    }];
}

-(void)downScroll{
    WEAKSELF;
    [UIView animateWithDuration:0.3 animations:^{
//        weakSelf.publichBtn.top = KSH - TabH;
    }];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"111");
}

@end
