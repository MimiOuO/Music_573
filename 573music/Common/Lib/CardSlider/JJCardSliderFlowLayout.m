//
//  JJCardSliderFlowLayout.m
//  CardSliderDome
//
//  Created by  张礼栋 on 2019/12/10.
//  Copyright © 2019 mobile. All rights reserved.
//

#import "JJCardSliderFlowLayout.h"
#import "JJCardSliderView.h"

static const float minScale = 0.8;
static const float spacing = 11;
@interface JJCardSliderFlowLayout()
@property (nonatomic) CGSize topItemSize;
@property (nonatomic) NSInteger itemsCount;
@property (nonatomic) CGSize collectionBounds;
@property (nonatomic) CGPoint contentOffset;
@property (nonatomic) NSInteger currentPage;
@property (nonatomic) CGSize collectionViewContentSize;
@end

@implementation JJCardSliderFlowLayout
{
    BOOL didInitialSetup;
}
- (void)prepareLayout
{
    [super prepareLayout];
    
    CGFloat width = self.collectionBounds.width - (visibleItemsCount - 1)*spacing;
    CGFloat height = self.collectionBounds.height;
    self.topItemSize = CGSizeMake(width, height);
    
    if (didInitialSetup) {
        return;
    }
    didInitialSetup = YES;
    
/* 当首页上拉滑动到轮播器在可见区时再添加定时器，也就是到可见时prepareLayout才执行（在JJCardSliderView布局约束不要立刻[self.collectionView layoutIfNeeded]，否则prepareLayout会立刻被调用）
*/
    JJCardSliderView *view = (JJCardSliderView *)self.collectionView.superview;
    if (view) {
        [view addTimer];
    }
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSInteger itemsCount = [self.collectionView numberOfItemsInSection:0];
    if (itemsCount <= 0) {
        return nil;
    }
    
    NSInteger minVisibleIndex = MAX(self.currentPage, 0);
    NSInteger contentOffset = (int)self.contentOffset.x;
    NSInteger collectionBounds = (int)self.collectionBounds.width;
    CGFloat offset = contentOffset % collectionBounds;
    CGFloat offsetProgress = offset / self.collectionBounds.width*1.0f;
    NSInteger maxVisibleIndex = MAX(MIN(itemsCount - 1, self.currentPage + visibleItemsCount), minVisibleIndex);
    
    NSMutableArray *mArr = [[NSMutableArray alloc] init];
    for (NSInteger i = minVisibleIndex; i<=maxVisibleIndex; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
         UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForIndexPath:indexPath currentPage:self.currentPage offset:offset offsetProgress:offsetProgress];
        [mArr addObject:attributes];
    }
    return mArr;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForIndexPath:(NSIndexPath *)indexPath
                         currentPage:(NSInteger)currentPage
                              offset:(CGFloat)offset
                      offsetProgress:(CGFloat)offsetProgress
{
    UICollectionViewLayoutAttributes *attributes = [[self layoutAttributesForItemAtIndexPath:indexPath] copy];
    NSInteger visibleIndex = MAX(indexPath.item - currentPage + 1, 0);
    attributes.size = self.topItemSize;
    CGFloat topCardMidX = self.contentOffset.x + self.topItemSize.width / 2;
    attributes.center = CGPointMake(topCardMidX + spacing * (visibleIndex - 1), self.collectionBounds.height/2);
    attributes.zIndex = 1000 - visibleIndex;
    CGFloat scale = [self parallaxProgressForVisibleIndex:visibleIndex offsetProgress:offsetProgress minScale:minScale];
    attributes.transform = CGAffineTransformMakeScale(scale, scale);
    
//    WHCardSliderCell *cell = (WHCardSliderCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    switch (visibleIndex) {
        case 1:
            if (self.contentOffset.x >= 0) {
                attributes.center = CGPointMake(attributes.center.x - offset, attributes.center.y);
            }else{
                attributes.center = CGPointMake(attributes.center.x + attributes.size.width * (1 - scale)/2 - spacing * offsetProgress, attributes.center.y);
            }
            break;
        case visibleItemsCount+1:
        attributes.center = CGPointMake(attributes.center.x + attributes.size.width * (1 - scale)/2 - spacing, attributes.center.y);
        break;
        default:
            attributes.center = CGPointMake(attributes.center.x + attributes.size.width * (1 - scale)/2 - spacing * offsetProgress, attributes.center.y);
            break;
    }
    return attributes;
}

- (CGFloat)parallaxProgressForVisibleIndex:(NSInteger)visibleIndex
                         offsetProgress:(CGFloat)offsetProgress
                               minScale:(CGFloat)minScale
{
    CGFloat step = (1.0 - minScale) / (visibleItemsCount-1)*1.0;
    return (1.0 - (visibleIndex - 1) * step + step * offsetProgress);
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

- (NSInteger)itemsCount
{
    return [self.collectionView numberOfItemsInSection:0];
}

- (CGSize)collectionBounds
{
    return self.collectionView.bounds.size;
}

- (CGPoint)contentOffset
{
    return self.collectionView.contentOffset;
}

- (NSInteger)currentPage
{
    return MAX(floor(self.contentOffset.x / self.collectionBounds.width), 0);
}

- (CGSize)collectionViewContentSize
{
    return CGSizeMake(self.collectionBounds.width * self.itemsCount, self.collectionBounds.height);
}
@end
