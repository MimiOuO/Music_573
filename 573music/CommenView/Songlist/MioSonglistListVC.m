//
//  MioSonglistListVC.m
//  573music
//
//  Created by Mimio on 2020/12/30.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioSonglistListVC.h"
#import "MioSonglistCollectionCell.h"
#import "MioSongListVC.h"

@interface MioSonglistListVC ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collection;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger page;
@end

@implementation MioSonglistListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bgImg.hidden = YES;
    self.view.backgroundColor = appClearColor;
    
    _dataArr = [[NSMutableArray alloc] init];
    _page = 1;
    [self creatUI];
    [self requestData];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIWindow showLoading];
    });
}

-(void)requestData{
    [MioGetReq(api_rankDetail(_rankId), @{@"page":Str(_page)}) success:^(NSDictionary *result){
        NSArray *data = result[@"data"][@"data_paginate"][@"data"];
        [self.collection.mj_footer endRefreshing];
        if (Equals(result[@"data"][@"data_paginate"][@"next_page_url"], @"<null>")) {
            [self.collection.mj_footer endRefreshingWithNoMoreData];
        }
        [_dataArr addObjectsFromArray:[MioSongListModel mj_objectArrayWithKeyValuesArray:data]];
        [self.collection reloadData];
        [UIWindow hiddenLoading];
    } failure:^(NSString *errorInfo) {
        [UIWindow hiddenLoading];
    }];
}

-(void)creatUI{
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    flowLayout.sectionInset = UIEdgeInsetsMake(Mar, 0, Mar, 0);
    _collection = [[UICollectionView alloc] initWithFrame:CGRectMake(Mar, 0 , KSW_Mar2, KSH - NavH -TabH) collectionViewLayout:flowLayout];
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
