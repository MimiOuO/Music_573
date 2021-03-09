//
//  MioHomeRecommendVC.m
//  573music
//
//  Created by Mimio on 2020/12/14.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioHomeRecommendVC.h"
#import "MioSingerModel.h"

#import "MioMusicView.h"
#import "MioSonglistCollectionCell.h"
#import "MioAlbumCollectionCell.h"
#import "MioHallRankView.h"
#import "MioRadioView.h"
#import "MioSingerView.h"
#import "MioAlbumListPageVC.h"
#import "MioSonglistPageVC.h"
#import "MioMusicListPageVC.h"

#import "MioSongListVC.h"
#import "MioAlbumVC.h"
#import "MioMusicRankVC.h"
#import "MioSingerVC.h"
@interface MioHomeRecommendVC ()
@property (nonatomic, strong) UIScrollView *bgScroll;

@property (nonatomic, strong) UIScrollView *radioScroll;
@property (nonatomic, strong) UIScrollView *songlistScroll;
@property (nonatomic, strong) UIScrollView *musicScroll;
@property (nonatomic, strong) UIScrollView *singerScroll;
@property (nonatomic, strong) UIScrollView *albumScroll;

@property (nonatomic, strong) NSArray<MioSongListModel *> *radioArr;
@property (nonatomic, strong) NSArray<MioSongListModel *> *songlistArr;
@property (nonatomic, strong) NSArray<MioMusicModel *> *musicArr;
@property (nonatomic, strong) NSArray<MioSingerModel *>*singerArr;
@property (nonatomic, strong) NSArray<MioAlbumModel *> *albumArr;
@end

@implementation MioHomeRecommendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bgImg.hidden = YES;
    self.view.backgroundColor = appClearColor;

    [self creatUI];
    [self request];
    
}

-(void)request{
    [MioGetCacheReq(api_ranks, @{@"page":@"推荐"}) success:^(NSDictionary *result){
        
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
            if (Equals(@"歌手", data[i][@"type"])) {
                _singerArr = [MioSingerModel mj_objectArrayWithKeyValuesArray:data[i][@"data"]];
            }
        }
        [self updateUI];
        [_bgScroll.mj_header endRefreshing];
    } failure:^(NSString *errorInfo) {
        NSLog(@"%@",errorInfo);
    }];
    [MioGetCacheReq(api_radios, @{@"k":@"v"}) success:^(NSDictionary *result){
        NSArray *data = [result objectForKey:@"data"];
        _radioArr = [MioSongListModel mj_objectArrayWithKeyValuesArray:data];
        [self updateRadio];
    } failure:^(NSString *errorInfo) {}];
}

-(void)creatUI{
    _bgScroll = [UIScrollView creatScroll:frame(0, 44 , KSW,KSH - NavH - TabH - 44 -49) inView:self.view contentSize:CGSizeMake(KSW, 1490)];
    _bgScroll.mj_header = [MioRefreshHeader headerWithRefreshingBlock:^{
        [self request];
    }];
    UIImageView *radioImg = [UIImageView creatImgView:frame(29, 14, 72, 13) inView:_bgScroll image:@"diantai" radius:0];
    MioView *radioBg = [MioView creatView:frame(Mar, 26, KSW_Mar2, 136) inView:_bgScroll bgColorName:name_sup_one radius:6];
    
    NSArray *titleYArr = @[@182,@549,@811,@1149];
    NSArray *titleArr = @[@"热门歌单",@"热门单曲",@"热门专辑",@"热门歌手"];
    for (int i = 0;i < titleYArr.count; i++) {
        MioLabel *titleLab = [MioLabel creatLabel:frame(Mar, [titleYArr[i] intValue], 100, 20) inView:_bgScroll text:titleArr[i] colorName:name_text_one boldSize:14 alignment:NSTextAlignmentLeft];
        if (i < 3) {
            MioLabel *moreLab = [MioLabel creatLabel:frame(KSW_Mar - 50, [titleYArr[i] intValue], 50, 20) inView:_bgScroll text:@"更多" colorName:name_text_two size:12 alignment:NSTextAlignmentCenter];
            MioImageView *arrow1 = [MioImageView creatImgView:frame(KSW_Mar -  14,[titleYArr[i] intValue] + 3, 14, 14) inView:_bgScroll image:@"return_more" bgTintColorName:name_icon_two radius:0];
            [moreLab whenTapped:^{
                if (Equals(titleArr[i], @"热门歌单")) {
                    MioSonglistPageVC *vc = [[MioSonglistPageVC alloc] init];
                    vc.index = 0;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                if (Equals(titleArr[i], @"热门单曲")) {
                    MioMusicListPageVC *vc = [[MioMusicListPageVC alloc] init];
                    vc.index = 0;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                if (Equals(titleArr[i], @"热门专辑")) {
                    MioAlbumListPageVC *vc = [[MioAlbumListPageVC alloc] init];
                    vc.index = 0;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }];
        }
    }
    
    
    _radioScroll = [UIScrollView creatScroll:frame(22, 32, KSW - 44 , 124) inView:_bgScroll contentSize:CGSizeMake(0,0)];
    _songlistScroll = [UIScrollView creatScroll:frame(0, 210, KSW, 149*2 + 12) inView:_bgScroll contentSize:CGSizeMake(0,0)];
    _musicScroll = [UIScrollView creatScroll:frame(0, 577, KSW, 60*3 + 24) inView:_bgScroll contentSize:CGSizeMake(0,0)];

    _albumScroll = [UIScrollView creatScroll:frame(0, 839, KSW, 132*2 + 12) inView:_bgScroll contentSize:CGSizeMake(0,0)];
    _singerScroll = [UIScrollView creatScroll:frame(0, 1177, KSW, 56*4 + 36) inView:_bgScroll contentSize:CGSizeMake(0,0)];
    _singerScroll.contentInset = UIEdgeInsetsMake(0, 0, 0, Mar);
}

-(void)updateUI{
    
    _songlistScroll.contentSize = CGSizeMake(ceilf(_songlistArr.count/2.0)*118 + 24, 149*2 + 12);
    _musicScroll.contentSize = CGSizeMake(ceilf(_musicArr.count/3.0)*KSW_Mar2 + 24, 60*3 + 24);
    _albumScroll.contentSize = CGSizeMake(ceilf(_albumArr.count/2.0)*118 + 24, 132*2 + 12);
    _singerScroll.contentSize = CGSizeMake(ceilf(_singerArr.count/4.0)*KSW_Mar2 + 24, 56*4 + 36);
    
    
    [_songlistScroll removeAllSubviews];
    [_musicScroll removeAllSubviews];
    [_albumScroll removeAllSubviews];
    [_singerScroll removeAllSubviews];

    
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
            [mioM3U8Player playWithMusicList:_musicArr andIndex:i fromModel:MioFromRank andId:@"2"];
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
    for (int i = 0;i < _singerArr.count; i++) {
        MioSingerView *singerCell = [[MioSingerView alloc] initWithFrame:CGRectMake( Mar + (i/4) * (KSW_Mar2 + 8), 68*(i%4), KSW_Mar2, 56)];
        singerCell.model = _singerArr[i];
        [_singerScroll addSubview:singerCell];
        [singerCell whenTapped:^{
            MioSingerVC *vc = [[MioSingerVC alloc] init];
            vc.singerId = _singerArr[i].singer_id;
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }
}

-(void)updateRadio{
    _radioScroll.contentSize = CGSizeMake(_radioArr.count*96 + 6, 124);
    [_radioScroll removeAllSubviews];
    for (int i = 0;i < _radioArr.count; i++) {
        MioRadioView *radioCell = [[MioRadioView alloc] initWithFrame:CGRectMake( 6 + i * 96, 0, 90, 124)];
        radioCell.model = _radioArr[i];
        [_radioScroll addSubview:radioCell];
        [radioCell whenTapped:^{
            setPlayOrder(MioPlayOrderSingle);
            [userdefault synchronize];
            [mioM3U8Player playWithMusicList:[MioMusicModel mj_objectArrayWithKeyValuesArray:_radioArr[i].songs] andIndex:0 fromModel:MioFromUnkown andId:@""];
            PostNotice(@"hiddenPlaylistIcon");
            [userdefault setObject:@"1" forKey:@"isRadio"];
            [userdefault synchronize];
        }];
    }
}

@end
