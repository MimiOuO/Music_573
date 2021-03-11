//
//  MioSearchMVResultVC.m
//  573music
//
//  Created by Mimio on 2020/12/31.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioSearchMVResultVC.h"
#import "MioMvModel.h"
#import "MioMVCollectionCell.h"
#import "MioMvVC.h"

@interface MioSearchMVResultVC ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collection;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation MioSearchMVResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.bgImg.hidden = YES;
    self.view.backgroundColor = appClearColor;
    
    _dataArr = [[NSMutableArray alloc] init];
    _page = 1;
    
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    flowLayout.sectionInset = UIEdgeInsetsMake(Mar, Mar, Mar, Mar);
    _collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KSW, KSH - NavH - 40 - TabH) collectionViewLayout:flowLayout];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    RecieveNotice(@"search", requestNewKeyData);
    [self requestData];
}

-(void)requestNewKeyData{
    _page = 1;
    [self requestData];
}

-(void)requestData{
    if (_searchKey.length == 0 ) {
        return;
    }
    [UIWindow showLoading];
    [MioGetReq(api_mvs, (@{@"s":_searchKey,@"page":Str(_page)})) success:^(NSDictionary *result){
        NSArray *data = [result objectForKey:@"data"];
        [_collection.mj_footer endRefreshing];
        if (_page == 1) {
            [_dataArr removeAllObjects];
        }
        if (Equals(result[@"links"][@"next"], @"<null>")) {
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
