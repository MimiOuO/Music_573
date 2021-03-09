//
//  MioAlbumVC.m
//  573music
//
//  Created by Mimio on 2020/12/28.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioAlbumVC.h"
#import "MioAlbumModel.h"
#import "MioMusicTableCell.h"
#import "MioMutipleVC.h"
#import "MioMainPlayerVC.h"
#import "MioBottomPlayView.h"

@interface MioAlbumVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) MioAlbumModel *album;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *countLab;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *introLab;
@property (nonatomic, strong) UIImageView *arrow;
@property (nonatomic, strong) UIButton *likeBtn;

@property (nonatomic, strong) UIImageView *coverImg;
@property (nonatomic, strong) UIImageView *coverBg;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation MioAlbumVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArr = [[NSMutableArray alloc] init];
    _page = 1;
    [self creatUI];
    [self requestData];
    
    [self.navView.centerButton setTitle:@"专辑" forState:UIControlStateNormal];
    [self.navView.centerButton setTitleColor:appWhiteColor forState:UIControlStateNormal];
    [self.navView.leftButton setImage:backArrowWhiteIcon forState:UIControlStateNormal];
    self.navView.mainView.backgroundColor = appClearColor;
    self.navView.bgImg.hidden = YES;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIWindow showLoading];
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    statusBarLight;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.view.frame = frame(0, 0, KSW, KSH);
}

-(void)requestData{
    [MioGetReq(api_albumDetail(_album_id), @{@"page":Str(_page)}) success:^(NSDictionary *result){
        NSDictionary *data = [result objectForKey:@"data"];
        _album = [MioAlbumModel mj_objectWithKeyValues:data];
        [self updateData];
        
        [self.tableView.mj_footer endRefreshing];

        if (Equals(data[@"songs_paginate"][@"next_page_url"], @"<null>")) {
            [_tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        [_dataArr addObjectsFromArray:[MioMusicModel mj_objectArrayWithKeyValuesArray:data[@"songs_paginate"][@"data"]]];
        [_tableView reloadData];
        [UIWindow hiddenLoading];
    } failure:^(NSString *errorInfo) {
        [UIWindow hiddenLoading];
    }];
    
}

-(void)creatUI{
    _coverBg = [UIImageView creatImgView:frame(0, 0, KSW, 300 + NavH + 44) inView:self.view image:@"gequ_zhanweitu" radius:0];
    UIVisualEffectView *effect = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    effect.frame = frame(0, 0, KSW, 300 + NavH + 44);
    effect.alpha = 1;
    [_coverBg addSubview:effect];
    
    _tableView = [[UITableView alloc] initWithFrame:frame(0, NavH, KSW, KSH - NavH - TabH) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = appClearColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.bounces = NO;
    _tableView.autoHideMjFooter = YES;
//    _tableView.ly_emptyView = [MioEmpty noDataEmpty];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page = _page + 1;
        [self requestData];
    }];
    [self.view addSubview:_tableView];
    
    
    UIView *headerView = [UIView creatView:frame(0, 0, KSW, 300) inView:nil bgColor:appClearColor radius:0];
    _tableView.tableHeaderView = headerView;
    
    UIImageView *coverBg = [UIImageView creatImgView:frame(KSW/2 - 110, 15, 220, 220) inView:headerView image:@"gedan_shadow" radius:0];
    UIImageView *coverBg2 = [UIImageView creatImgView:frame(KSW/2 - 65, 12, 180, 180) inView:headerView image:@"zhuanji_heijiao" radius:0];
    _coverImg = [UIImageView creatImgView:frame(KSW/2 - 90, 12, 180, 180) inView:headerView image:@"qxt_zhuanji" radius:8];
    
    _titleLab = [UILabel creatLabel:frame(Mar, 220, KSW_Mar2, 22) inView:headerView text:@"" color:appWhiteColor boldSize:16 alignment:NSTextAlignmentCenter];

    _nameLab = [UILabel creatLabel:frame(Mar, 244, KSW_Mar2, 17) inView:headerView text:@"" color:rgba(255, 255, 255, 0.7) size:12 alignment:NSTextAlignmentCenter];
//    _countLab = [UILabel creatLabel:frame(150, 81.5, KSW - 183, 17) inView:headerView text:@"" color:rgba(255, 255, 255, 0.7) size:12 alignment:NSTextAlignmentLeft];
    _introLab = [UILabel creatLabel:frame(Mar, 263, KSW_Mar2, 17) inView:headerView text:@"" color:rgba(255, 255, 255, 0.7) size:12 alignment:NSTextAlignmentCenter];
    _arrow = [UIImageView creatImgView:frame(KSW - 14, 264.5, 14, 14) inView:headerView image:@"gedan_more" radius:0];
    _arrow.hidden = YES;
    _likeBtn = [UIButton creatBtn:frame(KSW/2 - 40, 169, 80, 49) inView:headerView bgImage:@"xihuan_no" action:^{
        [self likeClick];
    }];
    [_likeBtn setBackgroundImage:image(@"xihuan_yes") forState:UIControlStateSelected];
    
    if ([self.navigationController.viewControllers[0] isKindOfClass:[MioMainPlayerVC class]]) {
        MioBottomPlayView *bottomPlayer = [[MioBottomPlayView alloc] initWithFrame:frame(0, KSH - 50 - SafeBotH, KSW, 50 + SafeBotH)];
        [self.view addSubview:bottomPlayer];
        [bottomPlayer whenTapped:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}

-(void)updateData{
    [_coverBg sd_setImageWithURL:_album.cover_image_path.mj_url   placeholderImage:image(@"gequ_zhanweitu")];
    [_coverImg sd_setImageWithURL:_album.cover_image_path.mj_url   placeholderImage:image(@"qxt_zhuanji")];
    _titleLab.text = _album.title;
    _nameLab.text = [NSString stringWithFormat:@"%@ · 播放%@次",_album.singer_name,_album.hits_all];
//    _countLab.text = [NSString stringWithFormat:@"%@首歌曲",_album.song_num];
    _introLab.text = _album.album_description;
    if (_album.is_like) {
        _likeBtn.selected = YES;
    }
    if ([_introLab.text widthForFont:Font(12)] > KSW_Mar2 ) {
        _arrow.hidden = NO;
        [_introLab whenTapped:^{
                [UIWindow showMessage:_introLab.text withTitle:@"简介"];
        }];
    }else{
        _arrow.hidden = YES;
    }

}

-(void)likeClick{
    goLogin;
    [MioPostReq(api_likes, (@{@"model_name":@"album",@"model_ids":@[_album_id]})) success:^(NSDictionary *result){
        NSDictionary *data = [result objectForKey:@"data"];
        _likeBtn.selected = !_likeBtn.selected;
        if (_likeBtn.selected) {
            [UIWindow showSuccess:@"已收藏到我的喜欢"];
        }else{
            [UIWindow showSuccess:@"已取消收藏"];
        }
    } failure:^(NSString *errorInfo) {
        [UIWindow showInfo:errorInfo];
    }];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KSW, 48)];
    [sectionHeader addRoundedCorners:UIRectCornerTopRight|UIRectCornerTopLeft withRadii:CGSizeMake(16, 16)];
    MioImageView *bgImg = [MioImageView creatImgView:frame(0, 0, KSW, 48) inView:sectionHeader skin:SkinName image:@"picture_li" radius:0];
    UIButton *playAllBtn = [UIButton creatBtn:frame(0, 0, 150, 48) inView:sectionHeader bgImage:@"" action:^{
        if (_dataArr.count > 0) {
            [mioM3U8Player playWithMusicList:_dataArr andIndex:0 fromModel:MioFromAlbum andId:_album_id];
        }
    }];
    MioImageView *playAllIcon = [MioImageView creatImgView:frame(Mar, 14, 20, 20) inView:sectionHeader image:@"exclude_play" bgTintColorName:name_main radius:0];
    UILabel *playAllLab = [UILabel creatLabel:frame(40, 13, 200, 22) inView:sectionHeader text:[NSString stringWithFormat:@"播放全部(共%d首歌曲)",_album.song_num.intValue] color:color_text_one size:16 alignment:NSTextAlignmentLeft];
    UIButton *multipleBtn = [UIButton creatBtn:frame(KSW - 100, 0, 100, 48) inView:sectionHeader bgImage:@"" action:^{
        if (_dataArr.count > 0) {
            MioMutipleVC *vc = [[MioMutipleVC alloc] init];
            vc.musicArr = _dataArr;
            vc.type = MioMutipleTypeSongList;
            vc.fromModel = MioFromAlbum;
            vc.fromId = _album_id;
            MioNavVC *nav = [[MioNavVC alloc] initWithRootViewController:vc];
            nav.modalPresentationStyle = 0;
            [self presentViewController:nav animated:YES completion:nil];
        }
    }];
    MioImageView *multipleIcon = [MioImageView creatImgView:frame(KSW - 24 -  18, 15, 18, 18) inView:sectionHeader image:@"liebiao_duoxuan" bgTintColorName:name_icon_one radius:0];
    
    return sectionHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 56;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 72;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    MioMusicTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MioMusicTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = appClearColor;
    cell.model = _dataArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [mioM3U8Player playWithMusicList:_dataArr andIndex:indexPath.row fromModel:MioFromAlbum andId:_album_id];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > 300) {
        offsetY = 300.0;
    }
    if (offsetY  < 0) {
        offsetY = 0.0;
    }
    
    [self.navView.centerButton setTitle:offsetY > 100?_album.title:@"专辑" forState:UIControlStateNormal];
    _coverBg.top = -offsetY;
}
@end
