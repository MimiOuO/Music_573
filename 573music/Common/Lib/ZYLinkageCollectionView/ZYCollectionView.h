//
//  ZYTableView.h
//  ZYTableView
//
//  Created by 雨张 on 2018/4/3.
//  Copyright © 2018年 雨张. All rights reserved.
//

/*
 *  美团外卖订单页面的效果，左侧是类别tableView 右侧是内容tableView,因为左侧tableView的数据其实就是右侧
 *  tableView 的section title，因此这里将两个tableView封装到一起，通过一套代理来实现数据获得
 */
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@class ZYCollectionView;
@protocol ZYCollectionViewDataSource<NSObject>
@required
- (NSInteger)collectionView:(ZYCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
- (NSInteger)numberOfSectionsInCollectionView:(ZYCollectionView *)collectionView;

- (__kindof UICollectionViewCell *)collectionView:(ZYCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
/*
 * 返回不同section 的 title,此title 是右侧列表的 section title,同时将作为左侧列表cell 的文本内容
 */
- (nullable NSString *)collectionView:(ZYCollectionView *)collectionView titleForHeaderInSection
                                   :(NSInteger)section;

/*
 * 返回section 的 image ,这个image 将显示在左侧列表的对应cell中
 */
- (nullable UIImage  *)collectionView:(ZYCollectionView *)collectionView imageForHeaderInSection
                                   :(NSInteger)section;

@end
@protocol ZYCollectionViewDelegate<NSObject>
@optional
- (void)collectionView:(ZYCollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface ZYCategoryCell:UITableViewCell
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIView *lineView;
@end


@interface ZYCollectionView : UIView
/*
 *  dataSource为 _contextTable提供内容, _categoryTable的内容依托于_contexTable
 *  所以我们没有必要提供两个dataSource
 */

/*
 *  左侧类别 view 占 整个 view 的比例，默认被设置为0.3
 */
@property (nonatomic,assign) float                     categoryWidthProportion;
@property (nonatomic,assign) id<ZYCollectionViewDataSource> dataSource;
@property (nonatomic,assign) id<ZYCollectionViewDelegate>   delegate;
- (void)reloadData;
- (void)registerClass:(nullable Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier;
- (__kindof UICollectionViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;
@end
