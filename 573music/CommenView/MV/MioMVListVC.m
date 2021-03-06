//
//  MioMVListVC.m
//  573music
//
//  Created by Mimio on 2021/1/26.
//  Copyright © 2021 Mimio. All rights reserved.
//

#import "MioMVListVC.h"
#import "MioMvModel.h"
#import "MioMVCollectionCell.h"
#import "MioMvVC.h"
@interface MioMVListVC ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collection;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation MioMVListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navView.leftButton setImage:backArrowIcon forState:UIControlStateNormal];
    [self.navView.centerButton setTitle:@"热门榜" forState:UIControlStateNormal];
    
    _dataArr = [[NSMutableArray alloc] init];
    _page = 1;
    
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    flowLayout.sectionInset = UIEdgeInsetsMake(Mar, Mar, Mar, Mar);
    _collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, NavH, KSW, KSH - NavH - TabH) collectionViewLayout:flowLayout];
    _collection.dataSource = self;
    _collection.delegate = self;
    _collection.showsVerticalScrollIndicator = NO;
    _collection.backgroundColor = appClearColor;
    [_collection registerClass:[MioMVCollectionCell class] forCellWithReuseIdentifier:@"MioMVCollectionCell"];
    [self.view addSubview:_collection];
    _collection.autoHideMjFooter = YES;
    _collection.ly_emptyView = [MioEmpty noDataEmpty];
    _collection.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page = _page + 1;
        [self requestData];
    }];
    
    [self requestData];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIWindow showLoading];
    });
}

-(void)requestData{
    
    [MioGetReq(api_rankDetail(@"8"), (@{@"page":Str(_page)})) success:^(NSDictionary *result){
        NSArray *data = result[@"data"][@"data_paginate"][@"data"];
        [_collection.mj_footer endRefreshing];
        if (_page == 1) {
            [_dataArr removeAllObjects];
        }
        if (Equals(result[@"data"][@"data_paginate"][@"next_page_url"], @"<null>")) {
            [_collection.mj_footer endRefreshingWithNoMoreData];
        }
        
        [_dataArr addObjectsFromArray:[MioMvModel mj_objectArrayWithKeyValuesArray:data]];
        [_collection reloadData];
        [UIWindow hiddenLoading];
    } failure:^(NSString *errorInfo) {
        [UIWindow hiddenLoading];
    }];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((KSW_Mar2 - 10)/2,(KSW_Mar2 - 10)/2 * 10/17 + 70);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MioMVCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MioMVCollectionCell" forIndexPath:indexPath];
    cell.model = _dataArr[indexPath.row];
    return cell;
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:
(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 12.0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MioMvVC *vc = [[MioMvVC alloc] init];
    vc.mvId = ((MioMvModel *)_dataArr[indexPath.row]).mv_id;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
