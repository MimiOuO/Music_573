//
//  MioRecentVC.m
//  573music
//
//  Created by Mimio on 2021/1/12.
//  Copyright © 2021 Mimio. All rights reserved.
//

#import "MioRecentVC.h"
#import <WMPageController.h>
#import <WHC_ModelSqlite.h>
#import "MioMvModel.h"
#import "MioRecentMusicVC.h"
#import "MioRecentMVVC.h"
@interface MioRecentVC ()<WMPageControllerDelegate,WMPageControllerDataSource>
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) WMPageController *pageController;
@property (nonatomic, strong) MioRecentMusicVC *recentMusic;
@property (nonatomic, strong) MioRecentMVVC *recentMV;
@end

@implementation MioRecentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _contentView = [[UIView alloc] initWithFrame:frame(0, NavH, KSW, KSH - TabH)];
    _contentView.backgroundColor = appClearColor;
    [self.view addSubview:_contentView];
    
    MioImageView *bgimg = [MioImageView creatImgView:frame(0, - NavH, KSW, NavH + 40) inView:_contentView skin:SkinName image:@"picture_li" radius:0];
    
    _recentMusic = [[MioRecentMusicVC alloc] init];
    _recentMV = [[MioRecentMVVC alloc] init];
    
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
    WEAKSELF;
    [self.navView.leftButton setImage:backArrowIcon forState:UIControlStateNormal];
    [self.navView.centerButton setTitle:@"最近播放" forState:UIControlStateNormal];
    [self.navView.rightButton setTitle:@"清空" forState:UIControlStateNormal];
    self.navView.rightButtonBlock = ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确定清空最近播放歌曲和视频？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"我再想想" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [WHCSqlite delete:[MioMusicModel class] where:@"savetype = 'recentMusic'"];
            [WHCSqlite delete:[MioMvModel class] where:@"savetype = 'recentMV'"];
            [weakSelf.recentMusic clearData];
            [weakSelf.recentMV clearData];
            [weakSelf.pageController reloadData];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        alertController.modalPresentationStyle = 0;
        [weakSelf presentViewController:alertController animated:YES completion:nil];
    };
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController{
    
    return 2;
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index{
    
    if (index == 0) {
        return _recentMusic;
    }else{
        return _recentMV;
    }
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index{
    
    NSArray *musicArr = [[[WHCSqlite query:[MioMusicModel class] where:@"savetype = 'recentMusic'"] reverseObjectEnumerator] allObjects];
    NSArray *mvArr = [[[WHCSqlite query:[MioMvModel class] where:@"savetype = 'recentMV'"] reverseObjectEnumerator] allObjects];
    if (index == 0) {
        return [NSString stringWithFormat:@"歌曲 %d",musicArr.count];
    }else{
        return [NSString stringWithFormat:@"视频 %d",mvArr.count];
    }
}
@end

