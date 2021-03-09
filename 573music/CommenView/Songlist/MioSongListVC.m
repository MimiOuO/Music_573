//
//  MioSongListVC.m
//  573music
//
//  Created by Mimio on 2020/12/11.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioSongListVC.h"
#import "MioSongListModel.h"
#import "MioMusicTableCell.h"
#import "MioMutipleVC.h"
#import "MioEditSonglistVC.h"
@interface MioSongListVC ()<UITableViewDelegate,UITableViewDataSource,MutipleDeleteDelegate>
@property (nonatomic, strong) MioSongListModel *songlist;
@property (nonatomic, strong) UIView *headerView;

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

@implementation MioSongListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArr = [[NSMutableArray alloc] init];
    _page = 1;
    [self creatUI];
    
    [self.navView.centerButton setTitle:@"歌单" forState:UIControlStateNormal];
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
    [self requestData];
}

-(void)requestData{
    [MioGetReq(api_songListDetail(_songlistId), @{@"page":Str(_page)}) success:^(NSDictionary *result){
        NSDictionary *data = [result objectForKey:@"data"];
        _songlist = [MioSongListModel mj_objectWithKeyValues:data];
    
        [self updateData];
        [self.tableView.mj_footer endRefreshing];
        if (_page == 1) {
            [_dataArr removeAllObjects];
        }
        if (Equals(data[@"songs_paginate"][@"next_page_url"], @"<null>")) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        [_dataArr addObjectsFromArray:[MioMusicModel mj_objectArrayWithKeyValuesArray:_songlist.songs]];
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
    
    
    _headerView = [UIView creatView:frame(0, 0, KSW, 300) inView:nil bgColor:appClearColor radius:0];
    _tableView.tableHeaderView = _headerView;
    
    UIImageView *coverBg = [UIImageView creatImgView:frame(KSW/2 - 110, 15, 220, 220) inView:_headerView image:@"gedan_shadow" radius:0];
    _coverImg = [UIImageView creatImgView:frame(KSW/2 - 90, 12, 180, 180) inView:_headerView image:@"qxt_zhuanji" radius:8];
    
    _titleLab = [UILabel creatLabel:frame(Mar, 220, KSW_Mar2, 22) inView:_headerView text:@"" color:appWhiteColor boldSize:16 alignment:NSTextAlignmentCenter];
    _countLab = [UILabel creatLabel:frame(Mar, 244, KSW_Mar2, 17) inView:_headerView text:@"" color:rgba(255, 255, 255, 0.7) size:14 alignment:NSTextAlignmentCenter];
    _introLab = [UILabel creatLabel:frame(Mar, 263, KSW_Mar2, 17) inView:_headerView text:@"" color:rgba(255, 255, 255, 0.7) size:12 alignment:NSTextAlignmentCenter];
    _arrow = [UIImageView creatImgView:frame(KSW - 14, 264.5, 14, 14) inView:_headerView image:@"gedan_more" radius:0];
    _arrow.hidden = YES;
    _likeBtn = [UIButton creatBtn:frame(KSW/2 - 40, 169, 80, 49) inView:_headerView bgImage:@"xihuan_no" action:^{
        [self likeClick];
    }];
    [_likeBtn setBackgroundImage:image(@"xihuan_yes") forState:UIControlStateSelected];
}

-(void)updateData{
    [_coverBg sd_setImageWithURL:_songlist.cover_image_path.mj_url   placeholderImage:image(@"gequ_zhanweitu")];
    [_coverImg sd_setImageWithURL:_songlist.cover_image_path.mj_url   placeholderImage:image(@"qxt_zhuanji")];
    _titleLab.text = _songlist.title;
    _countLab.text = [NSString stringWithFormat:@"播放%@次",_songlist.hits_all];
//    _titleLab.width = [_titleLab.text widthForFont:BoldFont(16)];
    _introLab.text = _songlist.song_list_description;

    if (_songlist.is_like) {
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
    
    if(_songlist.user_id == currentUserId){
        _likeBtn.hidden = YES;
        UIButton *editBtn = [UIButton creatBtn:frame(KSW - 44 - 26, StatusH + 9, 26, 26) inView:self.navView.mainView bgImage:@"bianji_icon-1" action:^{
            MioEditSonglistVC *vc = [[MioEditSonglistVC alloc] init];
            vc.model = _songlist;
            [self.navigationController pushViewController:vc animated:YES];
        }];
//        UILabel *likeNum = [UILabel creatLabel:frame(150, _introLab.bottom + 6, 100, 17) inView:_headerView text:[NSString stringWithFormat:@"%@人喜欢",_songlist.like_num] color:appWhiteColor size:12 alignment:NSTextAlignmentLeft];
        [self.navView.rightButton setImage:image(@"more") forState:UIControlStateNormal];
        WEAKSELF;
        self.navView.rightButtonBlock = ^{
            UIAlertController *alertController = [[UIAlertController alloc] init];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除歌单" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确定删除？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"我再想想" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    [[[MioDeleteRequest alloc] initWithRequestUrl:api_DeleteSongLists(weakSelf.songlist.song_list_id) argument:nil] success:^(NSDictionary *result){
                        NSDictionary *data = [result objectForKey:@"data"];
                        [UIWindow showInfo:@"删除成功"];
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    } failure:^(NSString *errorInfo) {
                        [UIWindow showInfo:errorInfo];
                    }];

                }];
                [alertController addAction:cancelAction];
                [alertController addAction:okAction];
                alertController.modalPresentationStyle = 0;
                [weakSelf presentViewController:alertController animated:YES completion:nil];
        
            }];

            [alertController addAction:cancelAction];
            [alertController addAction:deleteAction];
            [weakSelf presentViewController:alertController animated:YES completion:nil];
        };
    }

}

-(void)likeClick{
    goLogin;
    [MioPostReq(api_likes, (@{@"model_name":@"song_list",@"model_ids":@[_songlistId]})) success:^(NSDictionary *result){
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
            [mioM3U8Player playWithMusicList:_dataArr andIndex:0 fromModel:MioFromSonglist andId:_songlistId];
        }
    }];
    MioImageView *playAllIcon = [MioImageView creatImgView:frame(Mar, 14, 20, 20) inView:sectionHeader image:@"exclude_play" bgTintColorName:name_main radius:0];
    UILabel *playAllLab = [UILabel creatLabel:frame(40, 13, 200, 22) inView:sectionHeader text:[NSString stringWithFormat:@"播放全部(共%d首歌曲)",_songlist.song_num.intValue] color:color_text_one size:16 alignment:NSTextAlignmentLeft];
    UIButton *multipleBtn = [UIButton creatBtn:frame(KSW - 100, 0, 100, 48) inView:sectionHeader bgImage:@"" action:^{
        if (_dataArr.count > 0) {
            MioMutipleVC *vc = [[MioMutipleVC alloc] init];
            vc.musicArr = _dataArr;
            if (_songlist.user_id == currentUserId) {
                vc.type = MioMutipleTypeOwnSongList;
                vc.delegate = self;
            }else{
                vc.type = MioMutipleTypeSongList;
            }
            vc.fromModel = MioFromSonglist;
            vc.fromId = _songlistId;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [mioM3U8Player playWithMusicList:_dataArr andIndex:indexPath.row fromModel:MioFromSonglist andId:_songlistId];
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > 300) {
        offsetY = 300.0;
    }
    if (offsetY  < 0) {
        offsetY = 0.0;
    }
    
    [self.navView.centerButton setTitle:offsetY > 100?_songlist.title:@"专辑" forState:UIControlStateNormal];
    _coverBg.top = -offsetY;
}

-(void)mutipleDelete:(NSArray<MioMusicModel *> *)selectArr{
    NSMutableArray *idArr = [[NSMutableArray alloc] init];
    for (int i = 0;i < selectArr.count; i++) {
        [idArr addObject:selectArr[i].song_id];
    }
    
    [MioPostReq(api_deleteInSonglist(_songlistId), @{@"ids":idArr}) success:^(NSDictionary *result){
        [UIWindow showSuccess:@"删除成功"];
        
    } failure:^(NSString *errorInfo) {}];

}
@end
