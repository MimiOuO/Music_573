//
//  MioRecommendMVVC.m
//  573music
//
//  Created by Mimio on 2020/12/29.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioRecommendMVVC.h"
#import "SDCycleScrollView.h"
#import "ScanSuccessJumpVC.h"
#import "MioMvModel.h"
#import "MioMVCollectionCell.h"
#import "MioMvVC.h"
#import "MioMVRankView.h"
#import "MioMVRankListVC.h"
#import "MioMVRankVC.h"
@interface MioRecommendMVVC ()<UICollectionViewDataSource,UICollectionViewDelegate,SDCycleScrollViewDelegate>
@property (nonatomic, strong) UICollectionView *collection;
@property (nonatomic, strong) SDCycleScrollView *adScroll;
@property (nonatomic, strong) NSMutableArray *adUrlArr;
@property (nonatomic, strong) UIScrollView *rankScroll;

@property (nonatomic, strong) NSArray *rankArr;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSArray *hotArr;
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
    [MioGetCacheReq(api_mvs, @{@"page":Str(_page)}) success:^(NSDictionary *result){
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
    
    [MioGetCacheReq(api_ranks,(@{@"type":@"歌曲",@"limit":@"3"})) success:^(NSDictionary *result){
        _rankArr = [result objectForKey:@"data"];
    } failure:^(NSString *errorInfo) {}];
    
    [MioGetCacheReq(api_banners,nil) success:^(NSDictionary *result){
        NSArray *data = [result objectForKey:@"data"];
        NSMutableArray *tempArr = [[NSMutableArray alloc] init];
        for (int i = 0;i < data.count; i++) {
            [tempArr addObject:data[i][@"cover_image_path"]];
        }
        _adUrlArr = tempArr;
        
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

-(void)updateRank{
    _rankScroll.contentSize = CGSizeMake(_rankArr.count * 242 + 24, 140);
    for (int i = 0;i < _rankArr.count; i++) {
        MioMVRankView *rankCell = [[MioMVRankView alloc] initWithFrame:CGRectMake( Mar + i * 242,  0, 234, 140)];
        rankCell.rankDic = _rankArr[i];
        [_rankScroll addSubview:rankCell];
        [rankCell whenTapped:^{
            MioMVRankVC *vc = [[MioMVRankVC alloc] init];
            vc.rankId = _rankArr[i][@"rank_id"];
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }
}

#pragma mark - collectionview
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {

    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader){

        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        headerView.backgroundColor = appClearColor;
        [headerView removeAllSubviews];
        
        _adScroll = [SDCycleScrollView cycleScrollViewWithFrame:frame(Mar,12, KSW_Mar2, 140) delegate:self placeholderImage:nil];
        _adScroll.autoScrollTimeInterval = 5;
        _adScroll.pageDotImage = image(@"lunbo01");
        _adScroll.currentPageDotImage = image(@"lunbo02");
        _adScroll.imageURLStringsGroup = _adUrlArr;
        ViewRadius(_adScroll, 6);
        [headerView addSubview:_adScroll];
        
        NSArray *titleYArr = @[@182,@380,(KSW>400?@819:@790)];
        NSArray *titleArr = @[@"排行榜",@"热门MV",@"最新MV"];
        for (int i = 0;i < titleYArr.count; i++) {
            MioLabel *titleLab = [MioLabel creatLabel:frame(Mar, [titleYArr[i] intValue], 100, 20) inView:headerView text:titleArr[i] colorName:name_text_one boldSize:14 alignment:NSTextAlignmentLeft];
            MioLabel *moreLab = [MioLabel creatLabel:frame(KSW_Mar - 50, [titleYArr[i] intValue], 50, 20) inView:headerView text:@"更多" colorName:name_text_two size:12 alignment:NSTextAlignmentCenter];
            MioImageView *arrow1 = [MioImageView creatImgView:frame(KSW_Mar -  14,[titleYArr[i] intValue] + 3, 14, 14) inView:headerView image:@"return_more" bgTintColorName:name_icon_two radius:0];
            [moreLab whenTapped:^{
                if (i == 0) {
                    MioMVRankListVC *vc = [[MioMVRankListVC alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                }else if (i == 1){
                    
                }else if (i == 2){
                    
                }
            }];
        }
        
        
        _rankScroll = [UIScrollView creatScroll:frame(0, 210, KSW, 140) inView:headerView contentSize:CGSizeMake(_rankArr.count * 242 + 24, 140)];
        [self updateRank];
        
        for (int i = 0;i < (_dataArr.count<4?_dataArr.count:4); i++) {
            MioMVCollectionCell *mvCell = [[MioMVCollectionCell alloc] initWithFrame:CGRectMake( Mar + (i%2)*((KSW_Mar2 - 10)/2 + 8) , 408+ ((KSW_Mar2 - 10)/2 * 10/17 + 70 + 12)*(i/2), (KSW_Mar2 - 10)/2, (KSW_Mar2 - 10)/2 * 10/17 + 70)];
            mvCell.model = _dataArr[i];
            [headerView addSubview:mvCell];
            [mvCell whenTapped:^{
                MioMvVC *vc = [[MioMvVC alloc] init];
                vc.mvId = ((MioMvModel *)_dataArr[i]).mv_id;
                [self.navigationController pushViewController:vc animated:YES];
            }];
        }
        
        reusableview = headerView;
    }
    return reusableview;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(self.view.frame.size.width, 818 + (KSW>400?19:0));
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

#pragma mark - 广告
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    ScanSuccessJumpVC *vc = [[ScanSuccessJumpVC alloc] init];
    vc.jump_URL = @"http://www.baidu.com";
    [self.navigationController pushViewController:vc animated:YES];
}


@end
