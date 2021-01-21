//
//  MioNoticeVC.m
//  573music
//
//  Created by Mimio on 2021/1/20.
//  Copyright © 2021 Mimio. All rights reserved.
//

#import "MioNoticeVC.h"
#import <WMPageController.h>
#import "MioLikeAndCmtNoticeVC.h"
#import "MioSystemNoticeVC.h"
@interface MioNoticeVC ()<WMPageControllerDelegate,WMPageControllerDataSource>
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) WMPageController *pageController;
@end

@implementation MioNoticeVC

- (void)viewDidLoad {
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
    _pageController.menuHeight         = 48;
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
    [_contentView addSubview:self.pageController.view];
    
    UIButton *backBtn = [UIButton creatBtn:frame(0, StatusH, 50, 44) inView:self.view bgColor:appClearColor title:@"" titleColor:appClearColor font:10 radius:0  action:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

-(NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController{
    return 2;
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index{
    if (index == 0) {
        return [[MioLikeAndCmtNoticeVC alloc] init];
    }else{
        return [[MioSystemNoticeVC alloc] init];
    }
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index{
    
    if (index == 0) {
        return @"喜欢和评论";
    }else{
        return @"系统通知";
    }
    
}


@end
