//
//  MIoHomeMusicHallVC.m
//  573music
//
//  Created by Mimio on 2020/12/14.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioHomeMusicHallVC.h"
#import "PYSearch.h"
#import "MioSearchResultVC.h"
#import "SDCycleScrollView.h"
#import "ScanSuccessJumpVC.h"
#import "MioAlbumListPageVC.h"
#import "MioSonglistPageVC.h"
#import "MioCategoryListVC.h"
#import "MioSingerVC.h"
#import "MioSingerModel.h"
#import "MioMusicRankListVC.h"
#import "MioSingerListVC.h"
@interface MioHomeMusicHallVC ()<SDCycleScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *bgScroll;
@property (nonatomic, strong) SDCycleScrollView *adScroll;
@property (nonatomic, strong) NSMutableArray *adUrlArr;
@end

@implementation MioHomeMusicHallVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bgImg.hidden = YES;
    self.view.backgroundColor = appClearColor;
    
    [self creatUI];
}

-(void)creatUI{
    _bgScroll = [UIScrollView creatScroll:frame(0, 0, KSW, KSH - NavH - TabH - 49) inView:self.view contentSize:CGSizeMake(KSW, 1493)];
    
    MioView *searchView = [MioView creatView:frame(Mar, 8, KSW_Mar2, 34) inView:_bgScroll bgColorName:name_search radius:17];;
    UIImageView *searchIcon = [UIImageView creatImgView:frame(12, 10, 14, 14) inView:searchView image:@"sosuo" radius:0];
    MioLabel *searchTip = [MioLabel creatLabel:frame(30, 0, 100, 34) inView:searchView text:@"请输入关键词搜索" colorName:name_text_two size:12 alignment:NSTextAlignmentLeft];
    [searchView whenTapped:^{
        [self searchClick];
    }];
    
    _adScroll = [SDCycleScrollView cycleScrollViewWithFrame:frame(Mar,62, KSW_Mar2, 140) delegate:self placeholderImage:nil];
    _adScroll.autoScrollTimeInterval = 4;
    ViewRadius(_adScroll, 6);
    [_bgScroll addSubview:_adScroll];
    
    MioView *rankView = [MioView creatView:frame(Mar, 232, 52, 52) inView:_bgScroll bgColorName:name_sup_one radius:26];
    MioView *songListView = [MioView creatView:frame(rankView.right + (KSW - 136 - 156)/4, 232, 52, 52) inView:_bgScroll bgColorName:name_sup_one radius:26];
    MioView *singerView = [MioView creatView:frame(songListView.right + (KSW - 136 - 156)/4, 232, 52, 52) inView:_bgScroll bgColorName:name_sup_one radius:26];
    MioView *albumView = [MioView creatView:frame(singerView.right + (KSW - 136 - 156)/4, 232, 52, 52) inView:_bgScroll bgColorName:name_sup_one radius:26];
    MioView *categoryView = [MioView creatView:frame(KSW - Mar -52, 232, 52, 52) inView:_bgScroll bgColorName:name_sup_one radius:26];
    
    MioImageView *rankImg = [MioImageView creatImgView:frame(13, 13, 26, 26) inView:rankView image:@"shouye_ranking" bgTintColorName:name_main radius:0];
    MioImageView *songListImg = [MioImageView creatImgView:frame(13, 13, 26, 26) inView:songListView image:@"shouye_gedan" bgTintColorName:name_main radius:0];
    MioImageView *singerImg = [MioImageView creatImgView:frame(13, 13, 26, 26) inView:singerView image:@"shouye_singer" bgTintColorName:name_main radius:0];
    MioImageView *albumImg = [MioImageView creatImgView:frame(13, 13, 26, 26) inView:albumView image:@"shouye_album" bgTintColorName:name_main radius:0];
    MioImageView *categoryImg = [MioImageView creatImgView:frame(13, 13, 26, 26) inView:categoryView image:@"shouye_system" bgTintColorName:name_main radius:0];
    
    MioLabel *rankLab = [MioLabel creatLabel:frame(rankView.left, 288, 52, 17) inView:_bgScroll text:@"排行榜" colorName:name_text_one size:12 alignment:NSTextAlignmentCenter];
    MioLabel *songlistLab = [MioLabel creatLabel:frame(songListView.left, 288, 52, 17) inView:_bgScroll text:@"歌单" colorName:name_text_one size:12 alignment:NSTextAlignmentCenter];
    MioLabel *singerLab = [MioLabel creatLabel:frame(singerView.left, 288, 52, 17) inView:_bgScroll text:@"歌手" colorName:name_text_one size:12 alignment:NSTextAlignmentCenter];
    MioLabel *albumLab = [MioLabel creatLabel:frame(albumView.left, 288, 52, 17) inView:_bgScroll text:@"专辑" colorName:name_text_one size:12 alignment:NSTextAlignmentCenter];
    MioLabel *categoryLab = [MioLabel creatLabel:frame(categoryView.left, 288, 52, 17) inView:_bgScroll text:@"分类" colorName:name_text_one size:12 alignment:NSTextAlignmentCenter];
    
    [rankView whenTapped:^{
        MioMusicRankListVC *vc = [[MioMusicRankListVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [songListView whenTapped:^{
        MioSonglistPageVC *vc = [[MioSonglistPageVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [singerView whenTapped:^{
        MioSingerListVC *vc = [[MioSingerListVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];

    }];
    [albumView whenTapped:^{
        MioAlbumListPageVC *vc = [[MioAlbumListPageVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [categoryView whenTapped:^{
        MioCategoryListVC *vc = [[MioCategoryListVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

#pragma mark - 搜索
-(void)searchClick{
        NSArray *hotSeaches = @[@"Java", @"Python", @"Objective-C", @"Swift", @"C", @"C++", @"PHP", @"C#", @"Perl", @"Go", @"JavaScript", @"R", @"Ruby", @"MATLAB"];
        PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:@"搜索品类、ID、昵称"];
        searchViewController.searchResultShowMode = PYSearchResultShowModeEmbed;
        MioSearchResultVC *resultVC = [[MioSearchResultVC alloc] init];
        searchViewController.searchResultController = resultVC;
        searchViewController.delegate = resultVC;
        searchViewController.searchBarBackgroundColor = color_card;
        searchViewController.searchHistoryStyle = PYSearchHistoryStyleNormalTag;
        searchViewController.hotSearchStyle = PYHotSearchStyleNormalTag;

        CATransition* transition = [CATransition animation];
        transition.type = kCATransitionMoveIn;//可更改为其他方式
        transition.subtype = kCATransitionFromTop;//可更改为其他方式
        [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];

        [self.navigationController pushViewController:searchViewController animated:NO];
}

#pragma mark - 广告
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    ScanSuccessJumpVC *vc = [[ScanSuccessJumpVC alloc] init];
    vc.jump_URL = @"http://www.baidu.com";
//    vc.url = _adUrlArr[index];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
