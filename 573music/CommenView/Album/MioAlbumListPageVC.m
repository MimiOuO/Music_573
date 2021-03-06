//
//  MioHotAlbumListVC.m
//  573music
//
//  Created by Mimio on 2020/12/28.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioAlbumListPageVC.h"
#import <WMPageController.h>
#import "MioAlbumListVC.h"

@interface MioAlbumListPageVC ()<WMPageControllerDelegate,WMPageControllerDataSource>
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) WMPageController *pageController;
@end

@implementation MioAlbumListPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    [self.navView.leftButton setImage:backArrowIcon forState:UIControlStateNormal];
    [self.navView.centerButton setTitle:@"" forState:UIControlStateNormal];
    self.navView.mainView.backgroundColor = appClearColor;
    
    _contentView = [[UIView alloc] initWithFrame:frame(0, 0, KSW, KSH - TabH)];
    _contentView.backgroundColor = appClearColor;
    [self.view addSubview:_contentView];
    

    
    _pageController = [[WMPageController alloc] init];
    [self addChildViewController:_pageController];
    _pageController.delegate           = self;
    _pageController.dataSource         = self;
    _pageController.menuViewStyle      = WMMenuViewStyleLine;
    _pageController.menuViewLayoutMode = WMMenuViewLayoutModeCenter;
    _pageController.automaticallyCalculatesItemWidths = YES;
    _pageController.itemMargin         = 16;
    _pageController.menuHeight         = 44;
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
    _pageController.viewFrame = CGRectMake(0, StatusH , KSW , KSH - StatusH  - TabH);
    if (_index) {
        _pageController.selectIndex        = _index;
    }
    [_contentView addSubview:self.pageController.view];
    
    UIButton *backBtn = [UIButton creatBtn:frame(0, StatusH, 50, 44) inView:self.view bgColor:appClearColor title:@"" titleColor:appClearColor font:10 radius:0  action:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController{
    
    return 2;
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index{
    
    if (index == 0) {
        MioAlbumListVC *vc = [[MioAlbumListVC alloc] init];
        vc.rankId = @"3";
        return vc;
    }else{
        MioAlbumListVC *vc = [[MioAlbumListVC alloc] init];
        vc.rankId = @"7";
        return vc;
    }
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index{
    
    if (index == 0) {
        return @"热门专辑";
    }else{
        return @"最新专辑";
    }
    
}


@end
