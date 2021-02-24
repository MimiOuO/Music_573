//
//  MioDownloadVC.m
//  573music
//
//  Created by Mimio on 2020/12/24.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioDownloadVC.h"
#import <WMPageController.h>
#import "MioDownloadMusicVC.h"
#import "MioDownloadMVVC.h"
#import "MioDownloadingVC.h"
#import <SJM3U8Download.h>
#import <SJM3U8DownloadListController.h>
#import <SJM3U8DownloadListControllerDefines.h>
//#import "SODownloader+MusicDownloader.h"
//#import "SOSimulateDB.h"

static void * kDownloaderCompleteArrayKVOContext = &kDownloaderCompleteArrayKVOContext;
static void * kDownloaderKVOContext = &kDownloaderKVOContext;

@interface MioDownloadVC ()<WMPageControllerDelegate,WMPageControllerDataSource>
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) WMPageController *pageController;
@property (nonatomic, strong) MioDownloadMusicVC *downloadMusicVC;
@property (nonatomic, strong) MioDownloadMVVC *downloadMVVC;
@property (nonatomic, strong) MioDownloadingVC *downloadingVC;
@end

@implementation MioDownloadVC

- (void)viewDidLoad {
    [super viewDidLoad];

    RecieveNotice(@"downloadCountChange", reloadCount);
    
    _downloadMusicVC = [[MioDownloadMusicVC alloc] init];
    _downloadMVVC = [[MioDownloadMVVC alloc] init];
    _downloadingVC = [[MioDownloadingVC alloc] init];
    
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
    _pageController.menuItemWidth      = 100;
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
    [self.navView.centerButton setTitle:@"下载" forState:UIControlStateNormal];
    
    
//    [[SODownloader musicDownloader] addObserver:self forKeyPath:SODownloaderCompleteArrayObserveKeyPath options:NSKeyValueObservingOptionNew context:kDownloaderCompleteArrayKVOContext];
}


//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
//    if (context == kDownloaderCompleteArrayKVOContext) {
//        [_downloadingVC reload];
//        [_downloadMusicVC reload];
////        NSLog(@"——————%lu",(unsigned long)[SODownloader musicDownloader].downloadArray.count);
////        NSLog(@"——————%lu",(unsigned long)[SODownloader musicDownloader].completeArray.count);
//        [_pageController reloadData];
//    } else {
//        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
//    }
//}



- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController{
    
    return 3;
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index{
    
    if (index == 0) {
        
        return _downloadMusicVC;
    }else if (index == 1) {
        
        return _downloadMVVC;
    }else{
        return _downloadingVC;
    }
    
    
}


- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index{
    
    if (index == 0) {
        return @"音乐";
//        return [NSString stringWithFormat:@"音乐 %lu",(unsigned long)[SODownloader musicDownloader].completeArray.count];
    }else if (index == 1) {
        return @"视频";
    }else{
//        return @"正在下载";
        
        return [NSString stringWithFormat:@"正在下载 %lu",SJM3U8DownloadListController.shared.count];
    }
    
}

-(void)reloadCount{
    [_pageController reloadData];
}


- (void)dealloc {
    // 移除对"已下载"列表的观察
//    [[SODownloader musicDownloader]removeObserver:self forKeyPath:SODownloaderCompleteArrayObserveKeyPath];
//    [[SODownloader musicDownloader]removeObserver:self forKeyPath:SODownloaderCompleteArrayObserveKeyPath];
}

@end
