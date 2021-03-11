//
//  MioSearchTotalVC.m
//  573music
//
//  Created by Mimio on 2021/3/2.
//  Copyright © 2021 Mimio. All rights reserved.
//

#import "MioSearchTotalVC.h"
#import "MioSingerModel.h"
#import "MioSongListModel.h"
#import "MioAlbumModel.h"
#import "MioMvModel.h"

#import "MioMusicNoImgTableCell.h"
#import "MioSonglistTableCell.h"
#import "MioAlbumTableCell.h"
#import "MioMVTableCell.h"

#import "MioSingerVC.h"
#import "MioSongListVC.h"
#import "MioAlbumVC.h"
#import "MioMvVC.h"

@interface MioSearchTotalVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIScrollView *scroll;
@property (nonatomic, strong) NSArray<MioSingerModel *> *singerArr;
@property (nonatomic, strong) NSArray<MioMusicModel *> *songsArr;
@property (nonatomic, strong) NSArray<MioSongListModel *> *songlistArr;
@property (nonatomic, strong) NSArray<MioAlbumModel *> *albumArr;
@property (nonatomic, strong) NSArray<MioMvModel *> *mvArr;

@property (nonatomic, assign) int singerCount;
@property (nonatomic, assign) int songsCount;
@property (nonatomic, assign) int songlistCount;
@property (nonatomic, assign) int albumCount;
@property (nonatomic, assign) int mvCount;

@property (nonatomic, strong) UITableView *songTable;
@property (nonatomic, strong) UITableView *songlistTable;
@property (nonatomic, strong) UITableView *albumTable;
@property (nonatomic, strong) UITableView *mvTable;
@end

@implementation MioSearchTotalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bgImg.hidden = YES;
    self.view.backgroundColor = appClearColor;
    
    _scroll = [UIScrollView creatScroll:frame(0, 0, KSW, KSH - NavH - 40 - TabH) inView:self.view contentSize:CGSizeMake(KSW, KSH)];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    RecieveNotice(@"search", requestData);
}

-(void)requestData{
    
    if (_searchKey.length == 0 ) {
        return;
    }
    [UIWindow showLoading];
    
    YTKBatchRequest *batchRequest = [[YTKBatchRequest alloc] initWithRequestArray:@[MioGetReq(api_singers, @{@"s":_searchKey}), MioGetReq(api_songs, @{@"s":_searchKey}),MioGetReq(api_songLists, @{@"s":_searchKey}),MioGetReq(api_albums, @{@"s":_searchKey}),MioGetReq(api_mvs, @{@"s":_searchKey})]];
    [batchRequest startWithCompletionBlockWithSuccess:^(YTKBatchRequest *batchRequest) {
        NSArray *requests = batchRequest.requestArray;
        _singerArr = [MioSingerModel mj_objectArrayWithKeyValuesArray:[requests[0] responseJSONObject][@"data"]];
        _singerCount = [[requests[0] responseJSONObject][@"meta"][@"total"] intValue];
        _songsArr = [MioMusicModel mj_objectArrayWithKeyValuesArray:[requests[1] responseJSONObject][@"data"]];
        _songsCount = [[requests[1] responseJSONObject][@"meta"][@"total"] intValue];
        _songlistArr = [MioSongListModel mj_objectArrayWithKeyValuesArray:[requests[2] responseJSONObject][@"data"]];
        _songlistCount = [[requests[2] responseJSONObject][@"meta"][@"total"] intValue];
        _albumArr = [MioAlbumModel mj_objectArrayWithKeyValuesArray:[requests[3] responseJSONObject][@"data"]];
        _albumCount = [[requests[3] responseJSONObject][@"meta"][@"total"] intValue];
        _mvArr = [MioMvModel mj_objectArrayWithKeyValuesArray:[requests[4] responseJSONObject][@"data"]];
        _mvCount = [[requests[4] responseJSONObject][@"meta"][@"total"] intValue];
        [self creatUI];
        [UIWindow hiddenLoading];
    } failure:^(YTKBatchRequest *batchRequest) {
        [UIWindow hiddenLoading];
        [UIWindow showInfo:@"请求失败，请重试"];
        
        NSLog(@"failed");
    }];
}

-(void)creatUI{
    [_scroll removeAllSubviews];
    CGFloat totalHeight = 12;
    if (_singerArr.count > 0 || _songsArr.count > 0) {
        UIView *singerView = [UIView creatView:frame(Mar, 12, KSW_Mar2, 72) inView:_scroll bgColor:color_card radius:6];
        if (_singerArr.count != 0) {
            UIImageView *avatar = [UIImageView creatImgView:frame(12, 8, 56, 56) inView:singerView image:@"" radius:28];
            [avatar sd_setImageWithURL:_singerArr[0].cover_image_path.mj_url placeholderImage:image(@"qxt_geshou")];
            UILabel *singerName = [UILabel creatLabel:frame(82, 16, KSW_Mar2 - 102 , 22) inView:singerView text:_singerArr[0].singer_name color:color_text_one size:16 alignment:NSTextAlignmentLeft];
            UILabel *intro = [UILabel creatLabel:frame(82, 40, KSW_Mar2 - 102, 17) inView:singerView text:[NSString stringWithFormat:@"粉丝%@ 歌曲%@首",_singerArr[0].like_num,_singerArr[0].songs_num] color:color_text_two size:12 alignment:NSTextAlignmentLeft];
            [singerView whenTapped:^{
                MioSingerVC *vc = [[MioSingerVC alloc] init];
                vc.singerId = _singerArr[0].singer_id;
                [self.navigationController pushViewController:vc animated:YES];
            }];
        }else{
            [MioGetReq(api_singerDetail(_songsArr[0].singer_id), @{@"k":@"v"}) success:^(NSDictionary *result){
                NSDictionary *data = [result objectForKey:@"data"];
                MioSingerModel *singer = [MioSingerModel mj_objectWithKeyValues:data];
                
                UIImageView *avatar = [UIImageView creatImgView:frame(12, 8, 56, 56) inView:singerView image:@"" radius:28];
                [avatar sd_setImageWithURL:singer.cover_image_path.mj_url placeholderImage:image(@"qxt_geshou")];
                UILabel *singerName = [UILabel creatLabel:frame(82, 16, KSW_Mar2 - 102 , 22) inView:singerView text:singer.singer_name color:color_text_one size:16 alignment:NSTextAlignmentLeft];
                UILabel *intro = [UILabel creatLabel:frame(82, 40, KSW_Mar2 - 102, 17) inView:singerView text:[NSString stringWithFormat:@"粉丝%@ 歌曲%@首",singer.like_num,singer.songs_num] color:color_text_two size:12 alignment:NSTextAlignmentLeft];
                [singerView whenTapped:^{
                    MioSingerVC *vc = [[MioSingerVC alloc] init];
                    vc.singerId = singer.singer_id;
                    [self.navigationController pushViewController:vc animated:YES];
                }];

            } failure:^(NSString *errorInfo) {}];
        }
        
        UIImageView *arrow = [UIImageView creatImgView:frame(KSW_Mar2 - 14 - 12, 29, 14, 14) inView:singerView image:@"return_more" radius:0];
        totalHeight = totalHeight + 72 + 12;
    }
    if (_songsArr.count > 0) {
        UIView *songView = [UIView creatView:frame(Mar, totalHeight, KSW_Mar2,84+54*(_songsArr.count>10?10:_songsArr.count)) inView:_scroll bgColor:color_card radius:6];
        totalHeight = totalHeight + songView.height + 12;
        UILabel *titleLab = [UILabel creatLabel:frame(12, 0, 100, 44) inView:songView text:[NSString stringWithFormat:@"歌曲(%d)",_songsCount] color:color_text_one size:14 alignment:NSTextAlignmentLeft];
        _songTable = [UITableView creatTable:frame(0, 44, KSW_Mar2, 54*(_songsArr.count>10?10:_songsArr.count)) inView:songView vc:self];
        UILabel *allLab = [UILabel creatLabel:frame(0, _songTable.bottom, KSW_Mar2, 40) inView:songView text:@"查看全部歌曲 >" color:color_text_two size:12 alignment:NSTextAlignmentCenter];
        [allLab whenTapped:^{
            PostNotice(@"swithSongs");
        }];
    }
    if (_songlistArr.count > 0) {
        UIView *songlistView = [UIView creatView:frame(Mar, totalHeight, KSW_Mar2, 84+73*(_songlistArr.count>6?6:_songlistArr.count)) inView:_scroll bgColor:color_card radius:6];
        totalHeight = totalHeight + songlistView.height + 12;
        UILabel *titleLab = [UILabel creatLabel:frame(12, 0, 100, 44) inView:songlistView text:[NSString stringWithFormat:@"歌单(%d)",_songlistCount] color:color_text_one size:14 alignment:NSTextAlignmentLeft];
        _songlistTable = [UITableView creatTable:frame(0, 44, KSW_Mar2, 73*(_songlistArr.count>6?6:_songlistArr.count)) inView:songlistView vc:self];
        UILabel *allLab = [UILabel creatLabel:frame(0, _songlistTable.bottom, KSW_Mar2, 40) inView:songlistView text:@"查看全部歌单 >" color:color_text_two size:12 alignment:NSTextAlignmentCenter];
        [allLab whenTapped:^{
            PostNotice(@"swithSonglist");
        }];
    }
    if (_albumArr.count > 0) {
        UIView *albumView = [UIView creatView:frame(Mar, totalHeight, KSW_Mar2, 84+73*(_albumArr.count>6?6:_albumArr.count)) inView:_scroll bgColor:color_card radius:6];
        totalHeight = totalHeight + albumView.height + 12;
        UILabel *titleLab = [UILabel creatLabel:frame(12, 0, 100, 44) inView:albumView text:[NSString stringWithFormat:@"专辑(%d)",_albumCount] color:color_text_one size:14 alignment:NSTextAlignmentLeft];
        _albumTable = [UITableView creatTable:frame(0, 44, KSW_Mar2, 73*(_albumArr.count>10?10:_albumArr.count)) inView:albumView vc:self];
        UILabel *allLab = [UILabel creatLabel:frame(0, _albumTable.bottom, KSW_Mar2, 40) inView:albumView text:@"查看全部专辑 >" color:color_text_two size:12 alignment:NSTextAlignmentCenter];
        [allLab whenTapped:^{
            PostNotice(@"swithAlbum");
        }];
    }
    if (_mvArr.count > 0) {
        UIView *mvView = [UIView creatView:frame(Mar, totalHeight, KSW_Mar2, 84+74*(_mvArr.count>6?6:_mvArr.count)) inView:_scroll bgColor:color_card radius:6];
        totalHeight = totalHeight + mvView.height + 12;
        UILabel *titleLab = [UILabel creatLabel:frame(12, 0, 100, 44) inView:mvView text:[NSString stringWithFormat:@"视频(%d)",_mvCount] color:color_text_one size:14 alignment:NSTextAlignmentLeft];
        _mvTable = [UITableView creatTable:frame(0, 44, KSW_Mar2, 74*(_mvArr.count>10?10:_mvArr.count)) inView:mvView vc:self];
        UILabel *allLab = [UILabel creatLabel:frame(0, _mvTable.bottom, KSW_Mar2, 40) inView:mvView text:@"查看全部视频 >" color:color_text_two size:12 alignment:NSTextAlignmentCenter];
        [allLab whenTapped:^{
            PostNotice(@"swithMV");
        }];
    }
    _scroll.contentSize = CGSizeMake(KSW, totalHeight);

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _songTable) {
        return (_songsArr.count>10?10:_songsArr.count);
    }
    if (tableView == _songlistTable) {
        return (_songlistArr.count>6?6:_songlistArr.count);
    }
    if (tableView == _albumTable) {
        return (_albumArr.count>6?6:_albumArr.count);
    }
    if (tableView == _mvTable) {
        return (_mvArr.count>6?6:_mvArr.count);
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _songTable) {
        return 54;
    }
    if (tableView == _songlistTable) {
        return 73;
    }
    if (tableView == _albumTable) {
        return 73;
    }
    if (tableView == _mvTable) {
        return 74;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _songTable) {
        static NSString *identifier = @"cell";
        MioMusicNoImgTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MioMusicNoImgTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.model = _songsArr[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (tableView == _songlistTable) {
        static NSString *identifier = @"cell";
        MioSonglistTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MioSonglistTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.model = _songlistArr[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (tableView == _albumTable) {
        static NSString *identifier = @"cell";
        MioAlbumTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MioAlbumTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.width = KSW_Mar2;
        cell.model = _albumArr[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{
        static NSString *identifier = @"cell";
        MioMVTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MioMVTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.width = KSW_Mar2;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = _mvArr[indexPath.row];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _songTable) {
        [mioM3U8Player playWithMusicList:_songsArr andIndex:indexPath.row fromModel:MioFromUnkown andId:@""];
    }
    if (tableView == _songlistTable) {
        MioSongListVC *vc = [[MioSongListVC alloc] init];
        vc.songlistId = ((MioSongListModel *)_songlistArr[indexPath.row]).song_list_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (tableView == _albumTable) {
        MioAlbumVC *vc = [[MioAlbumVC alloc] init];
        vc.album_id = ((MioAlbumModel *)_albumArr[indexPath.row]).album_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (tableView == _mvTable) {
        MioMvVC *vc = [[MioMvVC alloc] init];
        vc.mvId = ((MioMvModel *)_mvArr[indexPath.row]).mv_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
