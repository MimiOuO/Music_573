//
//  MioCategorySonglistListVC.m
//  573music
//
//  Created by Mimio on 2021/3/5.
//  Copyright © 2021 Mimio. All rights reserved.
//

#import "MioCategorySonglistListVC.h"
#import "MioSonglistCollectionCell.h"
#import "MioSongListVC.h"
@interface MioCategorySonglistListVC ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collection;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger page;
@end

@implementation MioCategorySonglistListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navView.leftButton setImage:backArrowIcon forState:UIControlStateNormal];
    [self.navView.centerButton setTitle:_tag forState:UIControlStateNormal];
    
    _dataArr = [[NSMutableArray alloc] init];
    _page = 1;
    [self creatUI];
    [self requestData];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIWindow showLoading];
    });
}

-(void)requestData{
    MioGetRequest *getreq;
    if (Equals(@"全部", _tag)) {
        NSDictionary *dic = @{@"hits_all":@"desc"};
        getreq = MioGetReq(api_songLists, (@{@"orders":@[dic],@"page":Str(_page)}));
    }else{
        getreq = MioGetReq(api_songLists, (@{@"s":_tag,@"columns":@[@"tags"],@"page":Str(_page)}));
    }
    [getreq success:^(NSDictionary *result){
        NSArray *data = [result objectForKey:@"data"];
        [self.collection.mj_footer endRefreshing];
        if (Equals(result[@"links"][@"next"], @"<null>")) {
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
