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
@interface MioSongListVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) MioSongListModel *songlist;
@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) UILabel *titleLab;
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
        if (_songlist.songs.count < 10) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        [_dataArr addObjectsFromArray:[MioMusicModel mj_objectArrayWithKeyValuesArray:_songlist.songs]];
        [_tableView reloadData];
        
    } failure:^(NSString *errorInfo) {}];
    
}

-(void)creatUI{
    _coverBg = [UIImageView creatImgView:frame(0, 0, KSW, 164 + NavH + 44) inView:self.view image:@"gequ_zhanweitu" radius:0];
    UIVisualEffectView *effect = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    effect.frame = frame(0, 0, KSW, 300);
    effect.alpha = 1;
    [_coverBg addSubview:effect];
    
    _tableView = [[UITableView alloc] initWithFrame:frame(0, NavH, KSW, KSH - NavH - TabH) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = appClearColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.bounces = NO;
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page = _page + 1;
        [self requestData];
    }];
    [self.view addSubview:_tableView];
    
    
    _headerView = [UIView creatView:frame(0, 0, KSW, 164) inView:nil bgColor:appClearColor radius:0];
    _tableView.tableHeaderView = _headerView;
    
    UIImageView *coverBg = [UIImageView creatImgView:frame(14, 28, 120, 128) inView:_headerView image:@"gedan_shadow" radius:0];
    _coverImg = [UIImageView creatImgView:frame(20, 27, 110, 110) inView:_headerView image:@"qxt_zhuanji" radius:4];
    
    _titleLab = [UILabel creatLabel:frame(150, 45.5, KSW - 183, 22) inView:_headerView text:@"" color:appWhiteColor boldSize:16 alignment:NSTextAlignmentLeft];
    _introLab = [UILabel creatLabel:frame(150, 73.5, KSW - 183, 17) inView:_headerView text:@"" color:rgba(255, 255, 255, 0.7) size:12 alignment:NSTextAlignmentLeft];
    _arrow = [UIImageView creatImgView:frame(KSW - 33 - 14, 75, 14, 14) inView:_headerView image:@"gedan_more" radius:0];
    _arrow.hidden = YES;
    _likeBtn = [UIButton creatBtn:frame(150, 98.5, 50, 22) inView:_headerView bgImage:@"xihuan" action:^{
        [self likeClick];
    }];
    [_likeBtn setBackgroundImage:image(@"xihuan_yixihuan") forState:UIControlStateSelected];
}

-(void)updateData{
    [_coverBg sd_setImageWithURL:_songlist.cover_image_path.mj_url   placeholderImage:image(@"gequ_zhanweitu")];
    [_coverImg sd_setImageWithURL:_songlist.cover_image_path.mj_url   placeholderImage:image(@"qxt_zhuanji")];
    _titleLab.text = _songlist.title;
    _titleLab.width = [_titleLab.text widthForFont:BoldFont(16)];
    _introLab.text = _songlist.song_list_description;

    if (_songlist.is_like) {
        _likeBtn.selected = YES;
    }
    
    if ([_introLab.text widthForFont:Font(12)] > KSW - 183 ) {
        _arrow.hidden = NO;
        [_introLab whenTapped:^{
                [UIWindow showMessage:_introLab.text withTitle:@"简介"];
        }];
    }else{
        _arrow.hidden = YES;
    }
    
    if(_songlist.user_id == currentUserId){
        _likeBtn.hidden = YES;
        UIButton *editBtn = [UIButton creatBtn:frame(_titleLab.right + 4, _titleLab.top + 3, 16, 16) inView:_headerView bgImage:@"bianji_icon" action:^{
            MioEditSonglistVC *vc = [[MioEditSonglistVC alloc] init];
            vc.model = _songlist;
            [self.navigationController pushViewController:vc animated:YES];
        }];
        UILabel *likeNum = [UILabel creatLabel:frame(150, _introLab.bottom + 6, 100, 17) inView:_headerView text:[NSString stringWithFormat:@"%@人喜欢",_songlist.like_num] color:appWhiteColor size:12 alignment:NSTextAlignmentLeft];
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
    
    [MioPostReq(api_likes, (@{@"model_name":@"song_list",@"model_ids":@[_songlistId]})) success:^(NSDictionary *result){
        NSDictionary *data = [result objectForKey:@"data"];
        _likeBtn.selected = !_likeBtn.selected;
        [UIWindow showSuccess:@"操作成功"];
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
        
    }];
    MioImageView *playAllIcon = [MioImageView creatImgView:frame(Mar, 14, 20, 20) inView:sectionHeader image:@"exclude_play" bgTintColorName:name_main radius:0];
    UILabel *playAllLab = [UILabel creatLabel:frame(40, 13, 80, 22) inView:sectionHeader text:@"播放全部" color:color_text_one size:16 alignment:NSTextAlignmentLeft];
    UIButton *multipleBtn = [UIButton creatBtn:frame(KSW - 100, 0, 100, 48) inView:sectionHeader bgImage:@"" action:^{
        MioMutipleVC *vc = [[MioMutipleVC alloc] init];
        vc.musicArr = _dataArr;
        if (_songlist.user_id == currentUserId) {
            vc.type = MioMutipleTypeOwnSongList;
            vc.songlistId = _songlistId;
        }else{
            vc.type = MioMutipleTypeSongList;
        }
        
        MioNavVC *nav = [[MioNavVC alloc] initWithRootViewController:vc];
        nav.modalPresentationStyle = 0;
        [self presentViewController:nav animated:YES completion:nil];
    }];
    UIImageView *multipleIcon = [UIImageView creatImgView:frame(KSW - 24 -  18, 15, 18, 18) inView:sectionHeader image:@"liebiao_duoxuan" radius:0];
    
    return sectionHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 48;
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > 164) {
        offsetY = 164.0;
    }
    if (offsetY  < 0) {
        offsetY = 0.0;
    }
    
    [self.navView.centerButton setTitle:offsetY > 100?_songlist.title:@"专辑" forState:UIControlStateNormal];
    _coverBg.top = -offsetY;
}
@end
