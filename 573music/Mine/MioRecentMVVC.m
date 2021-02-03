//
//  MioRecentMVVC.m
//  573music
//
//  Created by Mimio on 2021/1/12.
//  Copyright © 2021 Mimio. All rights reserved.
//

#import "MioRecentMVVC.h"
#import "MioMvModel.h"
#import "MioMVCollectionCell.h"
#import "MioMvVC.h"
#import <WHC_ModelSqlite.h>
#import "MioMutipleVC.h"

@interface MioRecentMVVC ()<UICollectionViewDataSource,UICollectionViewDelegate,MutipleDeleteDelegate>
@property (nonatomic, strong) UICollectionView *collection;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) UICollectionReusableView *headerView;
@end

@implementation MioRecentMVVC

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.bgImg.hidden = YES;
    self.view.backgroundColor = appClearColor;
    
    _dataArr = [[[WHCSqlite query:[MioMvModel class] where:@"savetype = 'recentMV'"] reverseObjectEnumerator] allObjects];
    
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    flowLayout.sectionInset = UIEdgeInsetsMake(0, Mar, Mar, Mar);
    _collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KSW, KSH - NavH - 40 - TabH ) collectionViewLayout:flowLayout];
    _collection.dataSource = self;
    _collection.delegate = self;
    _collection.showsVerticalScrollIndicator = NO;
    _collection.backgroundColor = appClearColor;
    [_collection registerClass:[MioMVCollectionCell class] forCellWithReuseIdentifier:@"MioMVCollectionCell"];
    [_collection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self.view addSubview:_collection];
    _collection.autoHideMjFooter = YES;
    _collection.ly_emptyView = [MioEmpty noDataEmpty];

}

-(void)clearData{
    _dataArr = @[];
    [_collection reloadData];
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader){
        if (!_headerView){
            _headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        }
        [_headerView removeAllSubviews];
        UILabel *countLab = [UILabel creatLabel:frame(Mar, 0, 100, 48) inView:_headerView text:[NSString stringWithFormat:@"%lu个视频",(unsigned long)_dataArr.count] color:color_text_two size:14 alignment:NSTextAlignmentLeft];

        UIButton *multipleBtn = [UIButton creatBtn:frame(KSW - 100, 0, 100, 48) inView:_headerView bgImage:@"" action:^{
            if (_dataArr.count > 0) {
                MioMutipleVC *vc = [[MioMutipleVC alloc] init];
                vc.musicArr = _dataArr;
                vc.type = MioMutipleTypeLocalList;
                vc.delegate = self;
                MioNavVC *nav = [[MioNavVC alloc] initWithRootViewController:vc];
                nav.modalPresentationStyle = 0;
                [self presentViewController:nav animated:YES completion:nil];
            }
        }];
        MioImageView *multipleIcon = [MioImageView creatImgView:frame(KSW - 24 -  18, 15, 18, 18) inView:_headerView image:@"liebiao_duoxuan" bgTintColorName:name_icon_one radius:0];
        reusableview = _headerView;
    }
    return reusableview;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(KSW, 48);
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


-(void)mutipleDelete:(NSArray<MioMusicModel *> *)selectArr{

    for (int i = 0;i < selectArr.count; i++) {
        [WHCSqlite delete:[MioMvModel class] where:[NSString stringWithFormat:@"savetype = 'recentMV' and mv_id = %@",selectArr[i].mv_id]];
    }
    
    _dataArr = [[[WHCSqlite query:[MioMvModel class] where:@"savetype = 'recentMV'"] reverseObjectEnumerator] allObjects];
    [_collection reloadData];
}

@end
