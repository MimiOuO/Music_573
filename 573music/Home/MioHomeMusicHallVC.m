//
//  MIoHomeMusicHallVC.m
//  573music
//
//  Created by Mimio on 2020/12/14.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioHomeMusicHallVC.h"

#import "SDCycleScrollView.h"
#import "ScanSuccessJumpVC.h"
#import "MioAlbumListPageVC.h"
#import "MioSonglistPageVC.h"
#import "MioMusicListPageVC.h"
#import "MioCategoryListVC.h"
#import "MioMusicRankListVC.h"
#import "MioSingerListVC.h"

#import "MioMusicView.h"
#import "MioSonglistCollectionCell.h"
#import "MioAlbumCollectionCell.h"
#import "MioHallRankView.h"

#import "MioSongListVC.h"
#import "MioAlbumVC.h"
#import "MioMusicRankVC.h"

#import "MioMvVC.h"
#import "MioTestVC.h"
@interface MioHomeMusicHallVC ()<SDCycleScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *bgScroll;
@property (nonatomic, strong) SDCycleScrollView *adScroll;
@property (nonatomic, strong) NSMutableArray *adUrlArr;
@property (nonatomic, strong) NSMutableArray *adJumpArr;
@property (nonatomic, strong) UIScrollView *songlistScroll;
@property (nonatomic, strong) UIScrollView *musicScroll;
@property (nonatomic, strong) UIScrollView *rankScroll;
@property (nonatomic, strong) UIScrollView *albumScroll;

@property (nonatomic, strong) NSArray *songlistArr;
@property (nonatomic, strong) NSArray *musicArr;
@property (nonatomic, strong) NSArray *rankArr;
@property (nonatomic, strong) NSArray *albumArr;
@end

@implementation MioHomeMusicHallVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bgImg.hidden = YES;
    self.view.backgroundColor = appClearColor;
    RecieveNotice(@"firstLaunch", request);
    
    _adJumpArr = [[NSMutableArray alloc] init];
    [self creatUI];
    [self request];
}

-(void)request{
    [MioGetCacheReq(api_ranks, @{@"page":@"音乐馆"}) success:^(NSDictionary *result){
        NSArray *data = [result objectForKey:@"data"];
        for (int i = 0;i < data.count; i++) {
            if (Equals(@"歌曲", data[i][@"type"])) {
                _musicArr = [MioMusicModel mj_objectArrayWithKeyValuesArray:data[i][@"data"]];
            }
            if (Equals(@"专辑", data[i][@"type"])) {
                _albumArr = [MioAlbumModel mj_objectArrayWithKeyValuesArray:data[i][@"data"]];
            }
            if (Equals(@"歌单", data[i][@"type"])) {
                _songlistArr = [MioSongListModel mj_objectArrayWithKeyValuesArray:data[i][@"data"]];
            }
        }
        [self updateUI];
        [_bgScroll.mj_header endRefreshing];
        
    } failure:^(NSString *errorInfo) {}];
    
    [MioGetCacheReq(api_ranks,(@{@"type":@"歌曲",@"lock":@"0"})) success:^(NSDictionary *result){
        _rankArr = [result objectForKey:@"data"];
        [self updateRank];
    } failure:^(NSString *errorInfo) {}];
    
    [MioGetCacheReq(api_banners, @{@"position":@"音乐馆"}) success:^(NSDictionary *result){
        NSArray *data = [result objectForKey:@"data"];
        NSMutableArray *tempArr = [[NSMutableArray alloc] init];
        for (int i = 0;i < data.count; i++) {
            [tempArr addObject:data[i][@"cover_image_path"]];
            [_adJumpArr addObject:data[i][@"href"]];
        }
        _adUrlArr = tempArr;
        _adScroll.imageURLStringsGroup = _adUrlArr;
    } failure:^(NSString *errorInfo) {}];
    
}

-(void)creatUI{
    _bgScroll = [UIScrollView creatScroll:frame(0, 44 , KSW,KSH - NavH - TabH - 44 -49) inView:self.view contentSize:CGSizeMake(KSW, 1443)];
    _bgScroll.mj_header = [MioRefreshHeader headerWithRefreshingBlock:^{
        [self request];
    }];
    
    _adScroll = [SDCycleScrollView cycleScrollViewWithFrame:frame(Mar,12, KSW_Mar2, 140) delegate:self placeholderImage:nil];
    _adScroll.autoScrollTimeInterval = 5;
    _adScroll.pageDotImage = image(@"lunbo01");
    _adScroll.currentPageDotImage = image(@"lunbo02");
    ViewRadius(_adScroll, 6);
    [_bgScroll addSubview:_adScroll];
    
    MioView *rankView = [MioView creatView:frame(Mar, 182, 52, 52) inView:_bgScroll bgColorName:name_sup_one radius:26];
    MioView *songListView = [MioView creatView:frame(rankView.right + (KSW - 136 - 156)/4, 182, 52, 52) inView:_bgScroll bgColorName:name_sup_one radius:26];
    MioView *singerView = [MioView creatView:frame(songListView.right + (KSW - 136 - 156)/4, 182, 52, 52) inView:_bgScroll bgColorName:name_sup_one radius:26];
    MioView *albumView = [MioView creatView:frame(singerView.right + (KSW - 136 - 156)/4, 182, 52, 52) inView:_bgScroll bgColorName:name_sup_one radius:26];
    MioView *categoryView = [MioView creatView:frame(KSW - Mar -52, 182, 52, 52) inView:_bgScroll bgColorName:name_sup_one radius:26];
    
    MioImageView *rankImg = [MioImageView creatImgView:frame(13, 13, 26, 26) inView:rankView image:@"shouye_ranking" bgTintColorName:name_main radius:0];
    MioImageView *songListImg = [MioImageView creatImgView:frame(13, 13, 26, 26) inView:songListView image:@"shouye_gedan" bgTintColorName:name_main radius:0];
    MioImageView *singerImg = [MioImageView creatImgView:frame(13, 13, 26, 26) inView:singerView image:@"shouye_singer" bgTintColorName:name_main radius:0];
    MioImageView *albumImg = [MioImageView creatImgView:frame(13, 13, 26, 26) inView:albumView image:@"shouye_album" bgTintColorName:name_main radius:0];
    MioImageView *categoryImg = [MioImageView creatImgView:frame(13, 13, 26, 26) inView:categoryView image:@"shouye_system" bgTintColorName:name_main radius:0];
    
    MioLabel *rankLab = [MioLabel creatLabel:frame(rankView.left, 238, 52, 17) inView:_bgScroll text:@"排行榜" colorName:name_text_one size:12 alignment:NSTextAlignmentCenter];
    MioLabel *songlistLab = [MioLabel creatLabel:frame(songListView.left, 238, 52, 17) inView:_bgScroll text:@"歌单" colorName:name_text_one size:12 alignment:NSTextAlignmentCenter];
    MioLabel *singerLab = [MioLabel creatLabel:frame(singerView.left, 238, 52, 17) inView:_bgScroll text:@"歌手" colorName:name_text_one size:12 alignment:NSTextAlignmentCenter];
    MioLabel *albumLab = [MioLabel creatLabel:frame(albumView.left, 238, 52, 17) inView:_bgScroll text:@"专辑" colorName:name_text_one size:12 alignment:NSTextAlignmentCenter];
    MioLabel *categoryLab = [MioLabel creatLabel:frame(categoryView.left, 238, 52, 17) inView:_bgScroll text:@"分类" colorName:name_text_one size:12 alignment:NSTextAlignmentCenter];
    
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
    
    NSArray *titleYArr = @[@285,@652,@914,@1082];
    NSArray *titleArr = @[@"最新歌单",@"最新单曲",@"排行榜",@"最新专辑"];
    for (int i = 0;i < titleYArr.count; i++) {
        MioLabel *titleLab = [MioLabel creatLabel:frame(Mar, [titleYArr[i] intValue], 100, 20) inView:_bgScroll text:titleArr[i] colorName:name_text_one boldSize:14 alignment:NSTextAlignmentLeft];
        MioLabel *moreLab = [MioLabel creatLabel:frame(KSW_Mar - 50, [titleYArr[i] intValue], 50, 20) inView:_bgScroll text:@"更多" colorName:name_text_two size:12 alignment:NSTextAlignmentCenter];
        MioImageView *arrow1 = [MioImageView creatImgView:frame(KSW_Mar -  14,[titleYArr[i] intValue] + 3, 14, 14) inView:_bgScroll image:@"return_more" bgTintColorName:name_icon_two radius:0];
        [moreLab whenTapped:^{
            if (Equals(titleArr[i], @"最新歌单")) {
                MioSonglistPageVC *vc = [[MioSonglistPageVC alloc] init];
                vc.index = 1;
                [self.navigationController pushViewController:vc animated:YES];
            }
            if (Equals(titleArr[i], @"最新单曲")) {
                MioMusicListPageVC *vc = [[MioMusicListPageVC alloc] init];
                vc.index = 1;
                [self.navigationController pushViewController:vc animated:YES];
            }
            if (Equals(titleArr[i], @"排行榜")) {
                MioMusicRankListVC *vc = [[MioMusicRankListVC alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
            if (Equals(titleArr[i], @"最新专辑")) {
                MioAlbumListPageVC *vc = [[MioAlbumListPageVC alloc] init];
                vc.index = 1;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }];
    }
    
    _songlistScroll = [UIScrollView creatScroll:frame(0, 313, KSW, 149*2 + 12) inView:_bgScroll contentSize:CGSizeMake(0,0)];
    _musicScroll = [UIScrollView creatScroll:frame(0, 680, KSW, 60*3 + 24) inView:_bgScroll contentSize:CGSizeMake(0,0)];
    _rankScroll = [UIScrollView creatScroll:frame(0, 942, KSW, 110) inView:_bgScroll contentSize:CGSizeMake(0,0)];
    _albumScroll = [UIScrollView creatScroll:frame(0, 1110, KSW, 132*2 + 12) inView:_bgScroll contentSize:CGSizeMake(0,0)];
    _rankScroll.pagingEnabled = YES;
}

-(void)updateUI{
    _songlistScroll.contentSize = CGSizeMake(ceilf(_songlistArr.count/2.0)*117 + 24, 149*2 + 12);
    _musicScroll.contentSize = CGSizeMake(ceilf(_musicArr.count/3.0)*KSW_Mar2 + 24, 60*3 + 24);
   
    _albumScroll.contentSize = CGSizeMake(ceilf(_albumArr.count/2.0)*118 + 24, 132*2 + 12);
    
    [_musicScroll removeAllSubviews];
    [_albumScroll removeAllSubviews];
    [_songlistScroll removeAllSubviews];
    
    
    for (int i = 0;i < _songlistArr.count; i++) {
        MioSonglistCollectionCell *songlistCell = [[MioSonglistCollectionCell alloc] initWithFrame:CGRectMake( Mar + (i/2) * 117, 160*(i%2), 109, 149)];
        songlistCell.model = _songlistArr[i];
        [_songlistScroll addSubview:songlistCell];
        [songlistCell whenTapped:^{
            MioSongListVC *vc = [[MioSongListVC alloc] init];
            vc.songlistId = ((MioSongListModel *)_songlistArr[i]).song_list_id;
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }
    
    for (int i = 0;i < _musicArr.count; i++) {
        MioMusicView *musicCell = [[MioMusicView alloc] initWithFrame:CGRectMake( Mar + (i/3) * KSW_Mar2,  72*(i%3), KSW_Mar2, 60)];
        musicCell.model = _musicArr[i];
        [_musicScroll addSubview:musicCell];
        [musicCell whenTapped:^{
            [mioM3U8Player playWithMusicList:_musicArr andIndex:i];
        }];
    }
    for (int i = 0;i < _albumArr.count; i++) {
        MioAlbumCollectionCell *albumCell = [[MioAlbumCollectionCell alloc] initWithFrame:CGRectMake( Mar + (i/2) * 118, 144*(i%2), 110, 132)];
        albumCell.model = _albumArr[i];
        [_albumScroll addSubview:albumCell];
        [albumCell whenTapped:^{
            MioAlbumVC *vc = [[MioAlbumVC alloc] init];
            vc.album_id = ((MioAlbumModel *)_albumArr[i]).album_id;
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }
    
}

-(void)updateRank{
    _rankScroll.contentSize = CGSizeMake(_rankArr.count * KSW, 110);
    for (int i = 0;i < _rankArr.count; i++) {
        MioHallRankView *rankCell = [[MioHallRankView alloc] initWithFrame:CGRectMake( i * KSW,  0, KSW, 110)];
        rankCell.rankDic = _rankArr[i];
        [_rankScroll addSubview:rankCell];
        [rankCell whenTapped:^{
            MioMusicRankVC *vc = [[MioMusicRankVC alloc] init];
            vc.rankId = _rankArr[i][@"rank_id"];
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }
}

#pragma mark - 广告
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    ScanSuccessJumpVC *vc = [[ScanSuccessJumpVC alloc] init];
    vc.jump_URL = _adJumpArr[index];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
