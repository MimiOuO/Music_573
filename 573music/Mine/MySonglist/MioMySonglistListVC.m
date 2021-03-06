//
//  MioMySonglistListVC.m
//  573music
//
//  Created by Mimio on 2021/1/14.
//  Copyright © 2021 Mimio. All rights reserved.
//

#import "MioMySonglistListVC.h"
#import "MioSonglistCollectionCell.h"
#import "MioSongListVC.h"

@interface MioMySonglistListVC ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collection;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger page;
@end

@implementation MioMySonglistListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navView.leftButton setImage:backArrowIcon forState:UIControlStateNormal];
    [self.navView.centerButton setTitle:@"我的歌单" forState:UIControlStateNormal];
    
    _dataArr = [[NSMutableArray alloc] init];
    _page = 1;
    [self creatUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _page = 1;
    [self requestData];
}

-(void)requestData{
    [MioGetReq(api_mySongLists, @{@"page":Str(_page)}) success:^(NSDictionary *result){
        NSArray *data = [result objectForKey:@"data"];
        [self.collection.mj_footer endRefreshing];
        if (_page == 1) {
            [_dataArr removeAllObjects];
        }
        if (Equals(result[@"links"][@"next"], @"<null>")) {
            [self.collection.mj_footer endRefreshingWithNoMoreData];
        }
        [_dataArr addObjectsFromArray:[MioSongListModel mj_objectArrayWithKeyValuesArray:data]];
        [self.collection reloadData];
    } failure:^(NSString *errorInfo) {}];
}

-(void)creatUI{
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    flowLayout.sectionInset = UIEdgeInsetsMake(Mar, 0, Mar, 0);
    _collection = [[UICollectionView alloc] initWithFrame:CGRectMake(Mar, NavH , KSW_Mar2, KSH - NavH -TabH) collectionViewLayout:flowLayout];
    _collection.dataSource = self;
    _collection.delegate = self;
    _collection.showsVerticalScrollIndicator = NO;
    _collection.backgroundColor = appClearColor;
    [_collection registerClass:[MioSonglistCollectionCell class] forCellWithReuseIdentifier:@"MioSonglistCollectionCell"];
    _collection.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_collection];
    _collection.autoHideMjFooter = YES;
    _collection.ly_emptyView = [MioEmpty noDataEmpty];
    _collection.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page = _page + 1;
        [self requestData];
    }];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((KSW_Mar2 - 21)/3,(KSW_Mar2 - 21)/3 + 36);
//    return CGSizeMake((KSW_Mar2 - 16)/3, (KSW_Mar2 - 16)/3 + 40);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MioSonglistCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MioSonglistCollectionCell" forIndexPath:indexPath];
    cell.model = _dataArr[indexPath.row];

    return cell;
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:
(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 12.0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MioSongListVC *vc = [[MioSongListVC alloc] init];
    vc.songlistId = ((MioSongListModel *)_dataArr[indexPath.row]).song_list_id;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
