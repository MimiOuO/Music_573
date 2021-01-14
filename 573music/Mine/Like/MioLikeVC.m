//
//  MioLikeVC.m
//  573music
//
//  Created by Mimio on 2021/1/6.
//  Copyright © 2021 Mimio. All rights reserved.
//

#import "MioLikeVC.h"
#import <WMPageController.h>
#import "MioLikeMusicVC.h"
#import "MioLikeSingerVC.h"
#import "MioLikeSonglistVC.h"
#import "MioLikeAlbumVC.h"
#import "MioLikeMVVC.h"



@interface MioLikeVC ()<WMPageControllerDelegate,WMPageControllerDataSource>
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) WMPageController *pageController;
@end

@implementation MioLikeVC

- (void)viewDidLoad {
    [super viewDidLoad];

    
    _contentView = [[UIView alloc] initWithFrame:frame(0, NavH, KSW, KSH - TabH)];
    _contentView.backgroundColor = appClearColor;
    [self.view addSubview:_contentView];
    
    MioImageView *bgimg = [MioImageView creatImgView:frame(0, - NavH, KSW, NavH + 40) inView:_contentView skin:SkinName image:@"picture_li" radius:0];
    
    _pageController = [[WMPageController alloc] init];
    [self addChildViewController:_pageController];
    _pageController.delegate           = self;
    _pageController.dataSource         = self;
    _pageController.menuViewStyle      = WMMenuViewStyleLine;
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
 
    [self.navView.leftButton setImage:backArrowIcon forState:UIControlStateNormal];
    [self.navView.centerButton setTitle:@"我的喜欢" forState:UIControlStateNormal];
}


- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController{
    
    return 5;
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index{
    
    if (index == 0) {
        return [MioLikeMusicVC new];
    }else if (index == 1) {
        return [MioLikeSingerVC new];
    }else if (index == 2) {
        return [MioLikeSonglistVC new];
    }else if (index == 3) {
        return [MioLikeAlbumVC new];
    }else{
        return [MioLikeMVVC new];
    }
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index{
    
    if (index == 0) {
        return @"歌曲";
    }else if (index == 1) {
        return @"歌手";
    }else if (index == 2) {
        return @"歌单";
    }else if (index == 3) {
        return @"专辑";
    }else{
        return @"视频";
    }
}


@end
