//
//  MioLikeMusicVC.m
//  573music
//
//  Created by Mimio on 2021/1/6.
//  Copyright © 2021 Mimio. All rights reserved.
//

#import "MioLikeMusicVC.h"
#import "MioMutipleVC.h"
#import "MioMusicTableCell.h"

@interface MioLikeMusicVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation MioLikeMusicVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bgImg.hidden = YES;
    self.view.backgroundColor = appClearColor;
    
    _dataArr = [[NSMutableArray alloc] init];
    _page = 1;
    
    _table = [UITableView creatTable:frame(0, 0, KSW, KSH - NavH - 40 - TabH) inView:self.view vc:self];
    UIView *sectionHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KSW, 48)];
    
    UIButton *playAllBtn = [UIButton creatBtn:frame(0, 0, 150, 48) inView:sectionHeader bgImage:@"" action:^{
        
    }];
    MioImageView *playAllIcon = [MioImageView creatImgView:frame(Mar, 14, 20, 20) inView:sectionHeader image:@"exclude_play" bgTintColorName:name_main radius:0];
    UILabel *playAllLab = [UILabel creatLabel:frame(40, 13, 80, 22) inView:sectionHeader text:@"播放全部" color:color_text_one size:16 alignment:NSTextAlignmentLeft];
    UIButton *multipleBtn = [UIButton creatBtn:frame(KSW - 100, 0, 100, 48) inView:sectionHeader bgImage:@"" action:^{
        MioMutipleVC *vc = [[MioMutipleVC alloc] init];
        vc.musicArr = _dataArr;
        vc.type = MioMutipleTypeSongList;
        MioNavVC *nav = [[MioNavVC alloc] initWithRootViewController:vc];
        nav.modalPresentationStyle = 0;
        [self presentViewController:nav animated:YES completion:nil];
    }];
    UIImageView *multipleIcon = [UIImageView creatImgView:frame(KSW - 24 -  18, 15, 18, 18) inView:sectionHeader image:@"liebiao_duoxuan" radius:0];
    _table.tableHeaderView = sectionHeader;
    _table.autoHideMjFooter = YES;
    _table.ly_emptyView = [MioEmpty noDataEmpty];
    _table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page = _page + 1;
        [self requestData];
    }];
    [self requestData];
}

-(void)requestData{

    
    [MioGetReq(api_likeMusic, (@{@"page":Str(_page)})) success:^(NSDictionary *result){
        NSArray *data = [result objectForKey:@"data"];
        [_table.mj_footer endRefreshing];
        if (_page == 1) {
            [_dataArr removeAllObjects];
        }
        if (data.count < 10) {
            [_table.mj_footer endRefreshingWithNoMoreData];
        }
        
        [_dataArr addObjectsFromArray:[MioMusicModel mj_objectArrayWithKeyValuesArray:data]];
        [_table reloadData];
    } failure:^(NSString *errorInfo) {
        [_table.mj_footer endRefreshing];
        [UIWindow showInfo:errorInfo];
    }];
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
    cell.model = _dataArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [UIWindow showInfo:@"还未对接"];
}

@end
