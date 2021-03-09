//
//  MioCategorySonglistPageVC.m
//  573music
//
//  Created by Mimio on 2021/3/5.
//  Copyright © 2021 Mimio. All rights reserved.
//

#import "MioCategorySonglistPageVC.h"
#import <WMPageController.h>
#import "MioCategorySonglistRecommendVC.h"
#import "MioCategorySonglistVC.h"
#import "MioCategoryListVC.h"
@interface MioCategorySonglistPageVC ()<WMPageControllerDelegate,WMPageControllerDataSource>

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) WMPageController *pageController;
@end

@implementation MioCategorySonglistPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navView.leftButton setImage:backArrowIcon forState:UIControlStateNormal];
    [self.navView.centerButton setTitle:@"分类歌单" forState:UIControlStateNormal];
    
    _contentView = [[UIView alloc] initWithFrame:frame(0, NavH, KSW, KSH - NavH - TabH)];
    _contentView.backgroundColor = appClearColor;
    [self.view addSubview:_contentView];
    

    _pageController = [[WMPageController alloc] init];
    [self addChildViewController:_pageController];
    _pageController.delegate           = self;
    _pageController.dataSource         = self;
    _pageController.menuViewStyle      = WMMenuViewStyleLine;
    _pageController.automaticallyCalculatesItemWidths = YES;
    _pageController.itemMargin         = 30;
    _pageController.menuHeight         = 40;
    _pageController.titleFontName      = @"PingFangSC-Medium";
    _pageController.titleSizeNormal    = 14;
    _pageController.titleSizeSelected  = 14;
    _pageController.menuBGColor        = appClearColor;
    _pageController.titleColorNormal   = color_text_one;
    _pageController.titleColorSelected = color_main;
    _pageController.progressWidth      = 16;
    _pageController.progressHeight     = 3;
    _pageController.progressViewCornerRadius = 1.5;
    _pageController.progressViewBottomSpace = 4;
    _pageController.menuViewContentMargin = 40;
    _pageController.viewFrame = CGRectMake(0, 0 , KSW , KSH - NavH - TabH);
    [_contentView addSubview:self.pageController.view];
    
    MioImageView *menuBg = [MioImageView creatImgView:frame(0, 0, KSW, 40) inView:_pageController.menuView skin:SkinName image:@"picture_bql" radius:0];
    [_pageController.menuView sendSubviewToBack:menuBg];
    
    UIButton *moreBtn = [UIButton creatBtn:frame(KSW - 40, NavH, 40, 40) inView:self.view bgImage:@"picture_li" action:^{
        MioCategoryListVC *vc = [[MioCategoryListVC alloc] init];
        vc.from = @"songlist";
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    MioImageView *moreImg = [MioImageView creatImgView:frame(10, 12, 20, 20) inView:moreBtn image:@"gedan_system" bgTintColorName:name_icon_one radius:0];
    
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController{
    
    return 8;
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index{
    
    if (index == 0) {
        MioCategorySonglistRecommendVC *vc = [[MioCategorySonglistRecommendVC alloc] init];
        return vc;
    }
    else if (index == 1){
        MioCategorySonglistVC *vc = [[MioCategorySonglistVC alloc] init];
        vc.tag = @"全部";
        return vc;
    }
    else{
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        NSMutableArray *newArr = [[userdefault objectForKey:@"newSonglistCategory"] mutableCopy];
        NSMutableArray *oldArr = [[userdefault objectForKey:@"oldSonglistCategory"] mutableCopy];
        [arr addObjectsFromArray:newArr];
        [arr addObjectsFromArray:oldArr];
        
    
        NSMutableArray *resultArr = [NSMutableArray array];

        for (NSString *item in arr) {
            if (![resultArr containsObject:item]) {
              [resultArr addObject:item];
            }
        }
        
        MioCategorySonglistVC *vc = [[MioCategorySonglistVC alloc] init];
        vc.tag = resultArr[index - 2];
        return vc;
    }
//    return [UIViewController new];
    
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index{
    
    if (index == 0) {
        return @"推荐";
    }else if (index == 1){
        return @"全部";
    }else{
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        NSMutableArray *newArr = [[userdefault objectForKey:@"newSonglistCategory"] mutableCopy];
        NSMutableArray *oldArr = [[userdefault objectForKey:@"oldSonglistCategory"] mutableCopy];
        [arr addObjectsFromArray:newArr];
        [arr addObjectsFromArray:oldArr];
        
    
        NSMutableArray *resultArr = [NSMutableArray array];

        for (NSString *item in arr) {
            if (![resultArr containsObject:item]) {
              [resultArr addObject:item];
            }
        }
        
        return resultArr[index - 2];
    }
}

@end
