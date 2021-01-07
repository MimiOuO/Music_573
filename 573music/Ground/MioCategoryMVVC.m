//
//  MioCategoryMVVC.m
//  573music
//
//  Created by Mimio on 2020/12/29.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioCategoryMVVC.h"
#import "MioMvModel.h"
#import "MioMVCollectionCell.h"
#import "MioMVBigCollectionCell.h"
#import "MioMvVC.h"

@interface MioCategoryMVVC ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collection;

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger page;


@end

@implementation MioCategoryMVVC

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
    [MioGetReq(api_mvs, @{@"page":Str(_page)}) success:^(NSDictionary *result){
        NSArray *data = [result objectForKey:@"data"];
        if (_page == 1) {
            [_dataArr removeAllObjects];
        }
        if (data.count < 10) {
            [self.collection.mj_footer endRefreshingWithNoMoreData];
        }
        [self.collection.mj_footer endRefreshing];
        [_dataArr addObjectsFromArray:[MioMvModel mj_objectArrayWithKeyValuesArray:data]];
        [self.collection reloadData];
    } failure:^(NSString *errorInfo) {}];
}
-(void)creatUI{
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    flowLayout.sectionInset = UIEdgeInsetsMake(Mar, Mar, Mar, Mar);
    _collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 44 , KSW, KSH - NavH - TabH - 44 - 49) collectionViewLayout:flowLayout];
    _collection.dataSource = self;
    _collection.delegate = self;
    _collection.showsVerticalScrollIndicator = NO;
    _collection.backgroundColor = appClearColor;
    [_collection registerClass:[MioMVCollectionCell class] forCellWithReuseIdentifier:@"MioMVCollectionCell"];
    [_collection registerClass:[MioMVBigCollectionCell class] forCellWithReuseIdentifier:@"MioMVBigCollectionCell"];
    _collection.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_collection];
    
    _collection.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page = _page + 1;
        [self requestData];
    }];
}

#pragma mark - collectionview


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row%9 == 0) {
        return CGSizeMake(KSW_Mar2,KSW_Mar2 * 10/17 + 54);
    }else{
        return CGSizeMake((KSW_Mar2 - 10)/2,(KSW_Mar2 - 10)/2 * 10/17 + 70);
    }
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row%9 == 0) {
        MioMVBigCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MioMVBigCollectionCell" forIndexPath:indexPath];
        cell.model = _dataArr[indexPath.row];
        return cell;
    }else{
        MioMVCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MioMVCollectionCell" forIndexPath:indexPath];
        cell.model = _dataArr[indexPath.row];
        return cell;
    }

    
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
