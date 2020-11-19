//
//  JJCardSliderView.m
//  CardSliderDome
//
//  Created by  张礼栋 on 2019/12/10.
//  Copyright © 2019 mobile. All rights reserved.
//

#import "JJCardSliderView.h"
#import "JJCardSliderFlowLayout.h"
#import "JJCardSliderCell.h"
#import "JJPageControllerView.h"

static const int groupCount = 51;//最好奇数（定位到中间）  如：3，5，11~51，101
static const float timerInterval = 3.0f;
@interface JJCardSliderView()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>
//@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) JJPageControllerView *pageControlView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation JJCardSliderView
{
    NSInteger _selectedIndex;
    NSInteger _isReloadPage;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)dealloc
{
    [self cancelTimer];
}

- (void)configUI
{
//    [self addSubview:self.titleLabel];
//    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self).offset(12);
//        make.top.equalTo(self).offset(35);
//    }];
    
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0);
        make.left.equalTo(self).offset(12);
        make.right.equalTo(self).offset(-12);
        make.bottom.equalTo(self).offset(-44);
//        make.height.equalTo(@(150*[[UIScreen mainScreen] bounds].size.width/375));
    }];
    
    [self addSubview:self.pageControlView];
    [self.pageControlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionView.mas_bottom).offset(18);
        make.centerX.equalTo(self);
        make.height.equalTo(@5);
    }];
}

- (void)cancelTimer {
    if (!self.timer) {
        return;
    }
    
    [self.timer invalidate];
    self.timer = nil;
}

- (void)startTimer {
    if (self.timer) {
        return;
    }
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:timerInterval target:self selector:@selector(cardInfiniteScrolling) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)addTimer
{
    _isReloadPage = YES;
    if (!self.dataSource || self.dataSource.count <= 0) {
        return;
    }
    [self cancelTimer];
    NSInteger centerIndex = (groupCount/2)*self.dataSource.count;
    [self.collectionView setContentOffset:CGPointMake(centerIndex * self.collectionView.bounds.size.width, 0) animated:NO];
    
    _selectedIndex = centerIndex;
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:timerInterval target:self selector:@selector(cardInfiniteScrolling) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)cardInfiniteScrolling
{
    _selectedIndex++;
    [self.collectionView setContentOffset:CGPointMake(_selectedIndex * self.collectionView.bounds.size.width, 0) animated:YES];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count*groupCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JJCardSliderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JJCardSliderCell class]) forIndexPath:indexPath];
    if (indexPath.row < self.dataSource.count*groupCount) {
        [cell setCellData:self.dataSource[indexPath.row%self.dataSource.count]];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= self.dataSource.count*groupCount) {
        return;
    }
//    NSLog(@"----------%d",indexPath.row);
//    NSLog(@"----------%d",(indexPath.row%self.dataSource.count));//选中数组下标
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self cancelTimer];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    [self startTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _selectedIndex = (scrollView.contentOffset.x + 20)/self.collectionView.bounds.size.width;
    if (_selectedIndex >= (self.dataSource.count*groupCount-1-visibleItemsCount) || _selectedIndex == 0) {
        NSInteger centerIndex = (groupCount/2)*self.dataSource.count;
        [self.collectionView setContentOffset:CGPointMake(centerIndex * self.collectionView.bounds.size.width, 0) animated:NO];
        _selectedIndex = centerIndex;
    }
    
    if (self.dataSource && self.dataSource.count > 0 && _selectedIndex%self.dataSource.count < self.pageControlView.pageControlArray.count) {
        [self.pageControlView setIndex:_selectedIndex%self.dataSource.count];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    _selectedIndex = (scrollView.contentOffset.x + 20)/self.collectionView.bounds.size.width;
    if (_selectedIndex >= (self.dataSource.count*groupCount-1-visibleItemsCount) || _selectedIndex == 0) {
        NSInteger centerIndex = (groupCount/2)*self.dataSource.count;
        [self.collectionView setContentOffset:CGPointMake(centerIndex * self.collectionView.bounds.size.width, 0) animated:NO];
        _selectedIndex = centerIndex;
    }
    if (self.dataSource && self.dataSource.count > 0 && _selectedIndex%self.dataSource.count < self.pageControlView.pageControlArray.count) {
        [self.pageControlView setIndex:_selectedIndex%self.dataSource.count];
    }
}

#pragma mark - Get & Set
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        JJCardSliderFlowLayout *flowLayout = [[JJCardSliderFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.clipsToBounds = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        [_collectionView registerClass:[JJCardSliderCell class] forCellWithReuseIdentifier:NSStringFromClass([JJCardSliderCell class])];
    }
    return _collectionView;
}

//- (UILabel *)titleLabel
//{
//    if (!_titleLabel) {
//        _titleLabel = [[UILabel alloc] init];
//        _titleLabel.font = [UIFont boldSystemFontOfSize:17];
//        _titleLabel.textColor = [UIColor blackColor];
//    }
//    return _titleLabel;
//}

- (JJPageControllerView *)pageControlView
{
    if (!_pageControlView) {
        _pageControlView = [[JJPageControllerView alloc] init];
    }
    return _pageControlView;
}

- (void)setCardListData:(NSArray *)cardList{
    if (cardList && cardList.count > 0) {
        self.dataSource = cardList;
//        self.titleLabel.text = @"锦江酒店App特惠";
        self.pageControlView.hidden = NO;
    }else{
//        self.titleLabel.text = @"";
        self.pageControlView.hidden = YES;
        self.dataSource = [[NSArray alloc] init];
    }
    
    [self.collectionView reloadData];
    [self.collectionView.collectionViewLayout invalidateLayout];
    [self.pageControlView setAllCount:self.dataSource.count];
    
    if (_isReloadPage) {
        [self addTimer];
    }
}

- (CGFloat)getViewHeight {
    if (self.dataSource && self.dataSource.count > 0) {
        return (265+150*[[UIScreen mainScreen] bounds].size.width/375+40);
    }
    return 0;
}

- (void)willMoveToWindow:(UIWindow *)newWindow {
    [super willMoveToWindow:newWindow];
    if (newWindow) {
        [self startTimer];
    } else {
        [self cancelTimer];
    }
}
@end
