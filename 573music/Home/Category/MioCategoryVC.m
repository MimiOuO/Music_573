//
//  MioCategoryVC.m
//  573music
//
//  Created by Mimio on 2020/12/31.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioCategoryVC.h"
#import <WMPageController.h>

#import "MioCategoryMusicVC.h"
#import "MioCategorySonglistVC.h"
#import "MioCategoryAlbumVC.h"

@interface MioCategoryVC ()<WMPageControllerDelegate,WMPageControllerDataSource>

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) WMPageController *pageController;

@end

@implementation MioCategoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navView.leftButton setImage:backArrowIcon forState:UIControlStateNormal];
    [self.navView.centerButton setTitle:_tag forState:UIControlStateNormal];
    
    _contentView = [[UIView alloc] initWithFrame:frame(0, NavH, KSW, KSH - NavH - TabH)];
    _contentView.backgroundColor = appClearColor;
    [self.view addSubview:_contentView];
    

    _pageController = [[WMPageController alloc] init];
    [self addChildViewController:_pageController];
    _pageController.delegate           = self;
    _pageController.dataSource         = self;
    _pageController.menuViewStyle      = WMMenuViewStyleLine;
    _pageController.automaticallyCalculatesItemWidths = YES;
    _pageController.itemMargin         = 16;
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
    _pageController.viewFrame = CGRectMake(0, 0 , KSW , KSH - NavH - TabH);
    [_contentView addSubview:self.pageController.view];
    
    MioImageView *menuBg = [MioImageView creatImgView:frame(0, 0, KSW, 40) inView:_pageController.menuView skin:SkinName image:@"picture_bql" radius:0];
    [_pageController.menuView sendSubviewToBack:menuBg];
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController{
    
    return 3;
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index{
    
    if (index == 0) {
        MioCategoryMusicVC *vc = [[MioCategoryMusicVC alloc] init];
        vc.tag = _tag;
        return vc;
    }else if (index == 1){
        MioCategorySonglistVC *vc = [[MioCategorySonglistVC alloc] init];
        vc.tag = _tag;
        return vc;
    }else{
        MioCategoryAlbumVC *vc = [[MioCategoryAlbumVC alloc] init];
        vc.tag = _tag;
        return vc;
    }
    
    
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index{
    
    if (index == 0) {
        return @"歌曲";
    }else if (index == 1){
        return @"歌单";
    }else{
        return @"专辑";
    }
}
@end
