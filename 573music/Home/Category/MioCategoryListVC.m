//
//  MioCategoryVC.m
//  573music
//
//  Created by Mimio on 2020/12/30.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioCategoryListVC.h"
#import "ZYCollectionView.h"
#import "CustomCell.h"
#import "MioCategoryVC.h"
#import "MioCategorySonglistListVC.h"
@interface MioCategoryListVC ()<ZYCollectionViewDelegate,ZYCollectionViewDataSource>
@property (nonatomic,readonly) ZYCollectionView * collectionView;
@property (nonatomic, strong) NSArray *categoryArr;
@end

@implementation MioCategoryListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navView.leftButton setImage:backArrowIcon forState:UIControlStateNormal];
    [self.navView.centerButton setTitle:@"分类" forState:UIControlStateNormal];
    
    _categoryArr = [userdefault objectForKey:@"category"];
    
    _collectionView = [[ZYCollectionView alloc] initWithFrame:CGRectMake(0, NavH, KSW, KSH)];
    self.collectionView.delegate   = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[CustomCell class] forCellWithReuseIdentifier:@"CELL"];
    self.collectionView.backgroundColor = appClearColor;
    [self.view addSubview:self.collectionView];
}

#pragma mark ZYCollectionVIewDataSource
- (NSInteger)collectionView:(ZYCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return ((NSArray *)_categoryArr[section][@"tags"]).count;
}
- (NSInteger)numberOfSectionsInCollectionView:(ZYCollectionView *)collectionView
{
    return _categoryArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(ZYCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELL" forIndexPath:indexPath];
    cell.textLabel.text = ((NSArray *)_categoryArr[indexPath.section][@"tags"])[indexPath.row];
    return cell;
}

- (nullable NSString *)collectionView:(ZYCollectionView *)collectionView titleForHeaderInSection
                                     :(NSInteger)section
{
    return _categoryArr[section][@"title"];
}
- (nullable UIImage  *)collectionView:(ZYCollectionView *)collectionView imageForHeaderInSection:(NSInteger)section
{
    return nil;
}
- (void)collectionView:(ZYCollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (Equals(_from, @"songlist")) {
        
        NSMutableArray *songlistCategoryArr = [[NSMutableArray alloc] init];
        NSMutableArray *newArr = [[userdefault objectForKey:@"newSonglistCategory"] mutableCopy];
        [songlistCategoryArr addObjectsFromArray:newArr];
        [songlistCategoryArr insertObject:((NSArray *)_categoryArr[indexPath.section][@"tags"])[indexPath.row] atIndex:0];
        [userdefault setObject:songlistCategoryArr forKey:@"newSonglistCategory"];
        [userdefault synchronize];
        
        MioCategorySonglistListVC *vc = [[MioCategorySonglistListVC alloc] init];
        vc.tag = ((NSArray *)_categoryArr[indexPath.section][@"tags"])[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        MioCategoryVC *vc = [[MioCategoryVC alloc] init];
        vc.tag = ((NSArray *)_categoryArr[indexPath.section][@"tags"])[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
