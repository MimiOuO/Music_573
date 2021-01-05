//
//  MioRecommendMVVC.m
//  573music
//
//  Created by Mimio on 2020/12/29.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioRecommendMVVC.h"
#import "PYSearch.h"
#import "MioSearchResultVC.h"
#import "SDCycleScrollView.h"
#import "ScanSuccessJumpVC.h"
#import "MioMvModel.h"
#import "MioMVCollectionCell.h"
#import "MioMvVC.h"
@interface MioRecommendMVVC ()<UICollectionViewDataSource,UICollectionViewDelegate,SDCycleScrollViewDelegate>
@property (nonatomic, strong) UICollectionView *collection;
@property (nonatomic, strong) SDCycleScrollView *adScroll;
@property (nonatomic, strong) NSMutableArray *adUrlArr;

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger page;

@end

@implementation MioRecommendMVVC

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
    [_collection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    _collection.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_collection];
    
    _collection.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page = _page + 1;
        [self requestData];
    }];
}


#pragma mark - collectionview
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {

    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader){
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        headerView.backgroundColor = appClearColor;
        
        _adScroll = [SDCycleScrollView cycleScrollViewWithFrame:frame(Mar,12, KSW_Mar2, 140) delegate:self placeholderImage:nil];
        _adScroll.autoScrollTimeInterval = 4;
        ViewRadius(_adScroll, 6);
        [headerView addSubview:_adScroll];
        
        MioLabel *rankTitle = [MioLabel creatLabel:frame(Mar, 182, 50, 20) inView:headerView text:@"排行榜" colorName:name_text_one boldSize:14 alignment:NSTextAlignmentLeft];
        MioLabel *morerankLab = [MioLabel creatLabel:frame(KSW_Mar - 50, 185, 50, 23) inView:headerView text:@"更多" colorName:name_text_two size:12 alignment:NSTextAlignmentCenter];
        MioImageView *arrow1 = [MioImageView creatImgView:frame(KSW_Mar -  14, 189.5, 14, 14) inView:headerView image:@"return_more" bgTintColorName:name_icon_two radius:0];
        
        reusableview = headerView;
    }
    return reusableview;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(self.view.frame.size.width, 818);
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
