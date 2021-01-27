//
//  MioCategoryAlbumVC.m
//  573music
//
//  Created by Mimio on 2020/12/31.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioCategoryAlbumVC.h"
#import "MioAlbumCollectionCell.h"
#import "MioAlbumListPageVC.h"
#import "MioAlbumVC.h"

@interface MioCategoryAlbumVC ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collection;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger page;
@end

@implementation MioCategoryAlbumVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bgImg.hidden = YES;
    self.view.backgroundColor = appClearColor;
    
    _dataArr = [[NSMutableArray alloc] init];
    _page = 1;
    [self creatUI];
    [self requestData];
    
}

-(void)requestData{
    [MioGetReq(api_albums, (@{@"s":_tag,@"columns":@[@"tags"],@"page":Str(_page)})) success:^(NSDictionary *result){
        NSArray *data = [result objectForKey:@"data"];
        [self.collection.mj_footer endRefreshing];
        if (Equals(result[@"links"][@"next"], @"<null>")) {
            [self.collection.mj_footer endRefreshingWithNoMoreData];
        }
        
        [_dataArr addObjectsFromArray:[MioAlbumModel mj_objectArrayWithKeyValuesArray:data]];
        [self.collection reloadData];
    } failure:^(NSString *errorInfo) {}];
}

-(void)creatUI{
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    flowLayout.sectionInset = UIEdgeInsetsMake(Mar, 0, Mar, 0);
    _collection = [[UICollectionView alloc] initWithFrame:CGRectMake(Mar, 0 , KSW_Mar2, KSH - NavH -TabH) collectionViewLayout:flowLayout];
    _collection.dataSource = self;
    _collection.delegate = self;
    _collection.showsVerticalScrollIndicator = NO;
    _collection.backgroundColor = appClearColor;
    [_collection registerClass:[MioAlbumCollectionCell class] forCellWithReuseIdentifier:@"MioAlbumCollectionCell"];
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
    return CGSizeMake((KSW_Mar2 - 20)/3,(KSW_Mar2 - 20)/3 + 36);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MioAlbumCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MioAlbumCollectionCell" forIndexPath:indexPath];
    cell.model = _dataArr[indexPath.row];

    return cell;
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:
(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 12.0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MioAlbumVC *vc = [[MioAlbumVC alloc] init];
    vc.album_id = ((MioAlbumModel *)_dataArr[indexPath.row]).album_id;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
