//
//  MioSearchResultVC.m
//  orrilan
//
//  Created by 吉格斯 on 2019/8/6.
//  Copyright © 2019 Brance. All rights reserved.
//

#import "MioSearchResultVC.h"
#import <WMPageController.h>

#import "MioSearchTotalVC.h"
#import "MioSearchMusicResultVC.h"
#import "MioSearchSingerResultVC.h"
#import "MioSearchSonglistResultVC.h"
#import "MioSearchAlbumResultVC.h"
#import "MioSearchMVResultVC.h"

@interface MioSearchResultVC ()<WMPageControllerDelegate,WMPageControllerDataSource>
@property (nonatomic,copy) NSString * key;

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) WMPageController *pageController;

@property (nonatomic, strong) MioSearchTotalVC *totalResult;
@property (nonatomic, strong) MioSearchMusicResultVC *musicResult;
@property (nonatomic, strong) MioSearchSingerResultVC *singerResult;
@property (nonatomic, strong) MioSearchSonglistResultVC *songlistResult;
@property (nonatomic, strong) MioSearchAlbumResultVC *albumResult;
@property (nonatomic, strong) MioSearchMVResultVC *mvResult;
@end

@implementation MioSearchResultVC

- (void)viewDidLoad {
    [super viewDidLoad];

    _totalResult = [[MioSearchTotalVC alloc] init];
    _musicResult = [[MioSearchMusicResultVC alloc] init];
    _singerResult = [[MioSearchSingerResultVC alloc] init];
    _songlistResult = [[MioSearchSonglistResultVC alloc] init];
    _albumResult = [[MioSearchAlbumResultVC alloc] init];
    _mvResult = [[MioSearchMVResultVC alloc] init];
    

    _contentView = [[UIView alloc] initWithFrame:frame(0, 0, KSW, KSH - TabH)];
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
    
    RecieveNotice(@"swithSongs", switchSongs);
    RecieveNotice(@"swithSonglist", switchSonglist);
    RecieveNotice(@"swithAlbum", switchAlbum);
    RecieveNotice(@"swithMV", switchMV);
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController{
    
    return 6;
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index{
    if (index == 0) {
        return _totalResult;
    }else if (index == 1) {
        return _musicResult;
    }else if (index == 2){
        return _singerResult;
    }else if (index == 3){
        return _songlistResult;
    }else if (index == 4){
        return _albumResult;
    }else{
        return _mvResult;
    }
    
    
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index{
    
    if (index == 0) {
        return @"综合";
    }else if (index == 1) {
        return @"歌曲";
    }else if (index == 2){
        return @"歌手";
    }else if (index == 3){
        return @"歌单";
    }else if (index == 4){
        return @"专辑";
    }else{
        return @"视频";
    }
}

#pragma mark - netWork
-(void)serchRequest{
    _totalResult.searchKey = _key;
    _musicResult.searchKey = _key;
    _singerResult.searchKey = _key;
    _songlistResult.searchKey = _key;
    _albumResult.searchKey = _key;
    _mvResult.searchKey = _key;
    PostNotice(@"search");
}

-(void)switchSongs{
    _pageController.selectIndex = 1;
    [self serchRequest];
}

-(void)switchSonglist{
    _pageController.selectIndex = 3;
    [self serchRequest];
}

-(void)switchAlbum{
    _pageController.selectIndex = 4;
    [self serchRequest];
}
-(void)switchMV{
    _pageController.selectIndex = 5;
    [self serchRequest];
}

#pragma mark - PYSearchViewControllerDelegate

-(void)searchViewController:(PYSearchViewController *)searchViewController didSearchWithSearchBar:(UISearchBar *)searchBar searchText:(NSString *)searchText{
    _key = searchText;
    [self serchRequest];

}

-(void)searchViewController:(PYSearchViewController *)searchViewController didSelectSearchHistoryAtIndex:(NSInteger)index searchText:(NSString *)searchText{
    _key = searchText;
    [self serchRequest];
}
@end
