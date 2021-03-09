//
//  MioCategorySonglistRecommendVC.m
//  573music
//
//  Created by Mimio on 2021/3/5.
//  Copyright © 2021 Mimio. All rights reserved.
//

#import "MioCategorySonglistRecommendVC.h"
#import "MioSonglistCollectionCell.h"
#import "MioSongListModel.h"
#import "WMZBannerView.h"
#import "MioSongListVC.h"

@interface MioCategorySonglistRecommendVC ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collection;
@property (nonatomic, strong) NSMutableArray<MioSongListModel *> *dataArr;
@property (nonatomic, strong) NSMutableArray<MioSongListModel *> *collectDataArr;
@property (nonatomic, strong) WMZBannerView *bannerView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) BOOL first;//解决轮播bug
@end

@implementation MioCategorySonglistRecommendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bgImg.hidden = YES;
    self.view.backgroundColor = appClearColor;
    
    _dataArr = [[NSMutableArray alloc] init];
    _collectDataArr = [[NSMutableArray alloc] init];
    _page = 1;
    _first = YES;
    [self creatUI];
    [self requestData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIWindow showLoading];
    });
}

-(void)requestData{
    [MioGetReq(api_rankDetail(@"1"), @{@"page":Str(_page)}) success:^(NSDictionary *result){
        NSArray *data = result[@"data"][@"data_paginate"][@"data"];
        [self.collection.mj_footer endRefreshing];
        if (Equals(result[@"data"][@"data_paginate"][@"next_page_url"], @"<null>")) {
            [self.collection.mj_footer endRefreshingWithNoMoreData];
        }

        
        [_dataArr addObjectsFromArray:[MioSongListModel mj_objectArrayWithKeyValuesArray:data]];

        _collectDataArr = [_dataArr mutableCopy];
        [_collectDataArr removeObjectsInRange:NSMakeRange(0, ((_dataArr.count > 6 )?6:_dataArr.count))];
        NSLog(@"%lu",(unsigned long)_collectDataArr.count);
        [self.collection reloadData];
        [UIWindow hiddenLoading];
        
    } failure:^(NSString *errorInfo) {
        [UIWindow hiddenLoading];
    }];
}


-(void)creatUI{
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    flowLayout.sectionInset = UIEdgeInsetsMake(Mar, 0, Mar, 0);
    _collection = [[UICollectionView alloc] initWithFrame:CGRectMake(Mar, 0 , KSW_Mar2, KSH - NavH -TabH ) collectionViewLayout:flowLayout];
    _collection.dataSource = self;
    _collection.delegate = self;
    _collection.showsVerticalScrollIndicator = NO;
    _collection.backgroundColor = appClearColor;
    [_collection registerClass:[MioSonglistCollectionCell class] forCellWithReuseIdentifier:@"MioSonglistCollectionCell"];
    [_collection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    _collection.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_collection];
    _collection.autoHideMjFooter = YES;
    _collection.ly_emptyView = [MioEmpty noDataEmpty];
    _collection.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page = _page + 1;
        [self requestData];
    }];
    
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(self.view.frame.size.width, 216);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {

    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader){

        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        headerView.backgroundColor = appClearColor;
        [headerView removeAllSubviews];
        
        _titleLab = [UILabel creatLabel:frame(0, 172, KSW_Mar2, 20) inView:headerView text:@"" color:color_text_one boldSize:14 alignment:NSTextAlignmentCenter];

        
        NSMutableArray *urlArr = [[NSMutableArray alloc] init];
        NSMutableArray *titleArr = [[NSMutableArray alloc] init];
        for (int i = 0;i < ((_dataArr.count > 6 )?6:_dataArr.count); i++) {
            [urlArr addObject:[NSString stringWithFormat:@"%@",_dataArr[i].cover_image_path.mj_url]];
            [titleArr addObject:_dataArr[i].title];
        }
        
        WMZBannerParam *param =
        BannerParam()
        .wPlaceholderImageSet(@"qxt_logo")
       .wFrameSet(CGRectMake(0, 24, KSW_Mar2, 140))
       .wDataSet(urlArr)
        .wEventClickSet(^(id anyID, NSInteger index) {
            MioSongListVC *vc = [[MioSongListVC alloc] init];
            vc.songlistId = ((MioSongListModel *)_dataArr[index]).song_list_id;
            [self.navigationController pushViewController:vc animated:YES];
        })
        .wEventScrollEndSet( ^(id anyID, NSInteger index, BOOL isCenter,UICollectionViewCell *cell) {
            if(_first){
                _first = NO;
                _titleLab.text = titleArr[0];
            }else{
                _titleLab.text = titleArr[index];
            }
            
        })
    //    .wEventDidScrollSet( ^(id anyID, NSInteger index, BOOL isCenter,UICollectionViewCell *cell) {
    //        NSLog(@"滚动2 %@ %ld",anyID,index);
    ////        _titleLab.text = titleArr[index];
    //    })
        
       //关闭pageControl
       .wHideBannerControlSet(YES)
       //开启缩放
       .wScaleSet(YES)
       //自定义item的大小
       .wItemSizeSet(CGSizeMake(140, 140))
        
       //固定移动的距离
       .wContentOffsetXSet(0.5)
        //循环
       .wRepeatSet(YES)
       .wZindexSet(YES)
       //整体左右间距  设置为size.width的一半 让最后一个可以居中
       .wSectionInsetSet(UIEdgeInsetsMake(0,10, 0, KSW_Mar2*0.55*0.3))
       //间距
       .wLineSpacingSet(-(140-(KSW_Mar2/2 - 70)/2))
        //默认滑动到第index个
        .wSelectIndexSet(0)
       ;
       WMZBannerView *bannerView = [[WMZBannerView alloc]initConfigureWithModel:param];
       [headerView addSubview:bannerView];

        reusableview = headerView;
    }
    return reusableview;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((KSW_Mar2 - 21)/3,(KSW_Mar2 - 21)/3 + 36);
//    return CGSizeMake((KSW_Mar2 - 16)/3, (KSW_Mar2 - 16)/3 + 40);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _collectDataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MioSonglistCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MioSonglistCollectionCell" forIndexPath:indexPath];
    cell.model = _collectDataArr[indexPath.row];

    return cell;
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:
(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 12.0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MioSongListVC *vc = [[MioSongListVC alloc] init];
    vc.songlistId = ((MioSongListModel *)_collectDataArr[indexPath.row]).song_list_id;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
