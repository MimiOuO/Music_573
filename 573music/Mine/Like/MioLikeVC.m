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

@property (nonatomic, assign) int songsCount;
@property (nonatomic, assign) int songlistsCount;
@property (nonatomic, assign) int albumsCount;
@property (nonatomic, assign) int singersCount;
@property (nonatomic, assign) int mvsCount;
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
    _pageController.menuViewLayoutMode = WMMenuViewLayoutModeCenter;
    _pageController.itemMargin         = 10;
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
    
    [self requestCount];
}

-(void)requestCount{
    [MioGetReq(api_likesCount, @{@"k":@"v"}) success:^(NSDictionary *result){
        NSDictionary *data = [result objectForKey:@"data"][@"likes"];
        
        _songsCount = [data[@"song"] intValue];
        _singersCount = [data[@"singer"] intValue];
        _songlistsCount = [data[@"song_list"] intValue];
        _albumsCount = [data[@"album"] intValue];
        _mvsCount = [data[@"mv"] intValue];
        
        [_pageController reloadData];
        
    } failure:^(NSString *errorInfo) {}];
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
        return [NSString stringWithFormat:@"歌曲 %d",_songsCount];
    }else if (index == 1) {
        return [NSString stringWithFormat:@"歌手 %d",_singersCount];
    }else if (index == 2) {
        return [NSString stringWithFormat:@"歌单 %d",_songlistsCount];
    }else if (index == 3) {
        return [NSString stringWithFormat:@"专辑 %d",_albumsCount];
    }else{
        return [NSString stringWithFormat:@"视频 %d",_mvsCount];
    }
}


@end
