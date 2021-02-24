//
//  ZYTableView.m
//  ZYTableView
//
//  Created by 雨张 on 2018/4/3.
//  Copyright © 2018年 雨张. All rights reserved.
//

#import "ZYCollectionView.h"
#import "CustomCell.h"
#import "HeaderView.h"
#define IS_CONTEXT_TABLE if(tableView == _contextTable)

#define MAX_CATEGORYCELL_HEIGHT 100
#define MIN_CATEGORYCELL_HEIGHT 40
#define DEFAULT_SECTIONHEADER_HEIGHT 10
#define DEFAULT_SECTIONFOOTER_HEIGHT 0
#define FIT_FLOAT(X,MIN,MAX) (X < MIN ? MIN:(X > MAX ? MAX : X))
@implementation ZYCategoryCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _titleLab = [UILabel creatLabel:frame(0, 0, 83, 52) inView:self.contentView text:@"" color:color_text_two size:12 alignment:NSTextAlignmentCenter];
        [_titleLab addRoundedCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft withRadii:CGSizeMake(6, 6)];
        _lineView = [UIView creatView:frame(2, 19, 3, 14) inView:self.contentView bgColor:color_main radius:1.5];
    }
    return self;
}

-(void)setSelected:(BOOL)selected
{
    self.titleLab.textColor = selected ? color_main : color_text_two;
    self.titleLab.font = selected ? BoldFont(12) : Font(12);
    self.titleLab.backgroundColor = selected ? color_card : appClearColor;
    self.lineView.hidden = selected ? NO : YES;
}

@end
/*  -------------------------------------------------------------------------------------*/
@interface ZYCollectionView()<UITableViewDelegate,UITableViewDataSource, UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic,readonly) UITableView      *categoryTable;
@property(nonatomic,readonly) UICollectionView *contextCollection;
@end


static NSString * CATEGORY_CELL_IDENTIFIER = @"CATEGORY_CELL";
@implementation ZYCollectionView
{
    /*
     *  记录上一次 scrollViewDidScroll 触发时的偏移量
     *  ，以便和这次的偏移量做比较 来确定是上滑 还是 下滑
     */
    float _last_offset_y;
    
    
    /*
     * 用来判断是上滑 还是 下滑  true为上滑
     */
    BOOL _isUpScroll;
    
    /*
     *  用来判断是不是选中 categoryTable中的cell 引起的滚动
     *  如果是 willDisplayHeaderView 和 didEndDisplayingHeaderView 方法直接返回
     */
    BOOL _isSelectedCategoryOperation;
}
-(id)init
{
    if(self = [super init])
    {
        [self initSubview];
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self initSubview];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self selectCategoryRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        });
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    _categoryTable.frame     = CGRectMake(8, 8, 91 - 8, KSH - NavH - TabH - 16);
    _contextCollection.frame = CGRectMake(0, 0, KSW - 91 - 8,KSH - NavH - TabH - 16);
}
#pragma mark private method
-(void)initSubview
{
    _isSelectedCategoryOperation = NO;

    CGRect categoryFrame      = CGRectMake(8, 8, 91 - 8, KSH - NavH - TabH);
    _categoryTable                         = [[UITableView alloc] initWithFrame:categoryFrame style:UITableViewStylePlain];
    _categoryTable.dataSource              = self;
    _categoryTable.delegate                = self;
    _categoryTable.separatorStyle          = UITableViewCellSeparatorStyleNone;
    _categoryTable.backgroundColor         = appClearColor;
    _categoryTable.allowsMultipleSelection = NO;
    _categoryTable.showsVerticalScrollIndicator = NO;
    [self addSubview:_categoryTable];
   
    
    UIView *bgView = [UIView creatView:frame(91, 8, KSW - 91 - 8, KSH - NavH - TabH - 16) inView:self bgColor:appClearColor radius:0];
    [bgView addRoundedCorners:UIRectCornerTopRight|UIRectCornerBottomRight withRadii:CGSizeMake(6, 6)];
    
    CGRect contextFrame = CGRectMake(0, 0, KSW - 91 - 8, KSH - NavH - TabH - 16);
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize                     = CGSizeMake(120, 120);
    flowLayout.minimumInteritemSpacing      = 10;
    flowLayout.minimumLineSpacing           = 15;
    flowLayout.sectionInset                 = UIEdgeInsetsMake(15, 15, 15, 15);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _contextCollection  = [[UICollectionView alloc] initWithFrame:contextFrame collectionViewLayout:flowLayout];
    _contextCollection.backgroundColor = color_card;
    [_contextCollection registerClass:[HeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HEADER"];
    
    _contextCollection.showsVerticalScrollIndicator = NO;
    _contextCollection.bounces = NO;
    _contextCollection.dataSource  = self;
    _contextCollection.delegate    = self;
    
    [bgView addSubview:_contextCollection];
    

    

}
- (void)selectCategoryRowAtIndexPath:(NSIndexPath*)indexPath
{
    /*
     * 选定一个类别
     */
    NSIndexPath * willUnSelecteIndex = [_categoryTable indexPathForSelectedRow];
    
    /*
     * 如果选取了已选取的类别  不执行任何操作
     */
    if([indexPath isEqual:willUnSelecteIndex])
        return;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//        [_contextCollection scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
//        _contextCollection.contentOffset=CGPointMake(0, 0);
//        [_contextCollection scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    });
    
    
    UITableViewCell * cell           = [_categoryTable cellForRowAtIndexPath:indexPath];
    [cell setSelected:YES];
    
    
    UITableViewCell * u_cell         = [_categoryTable cellForRowAtIndexPath:willUnSelecteIndex];
    [u_cell setSelected:NO];
    
    [_categoryTable selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
}
#pragma mark Public method
- (__kindof UICollectionViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;
{
    return [self.contextCollection dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
}
-(void)reloadData
{
    [_contextCollection reloadData];
    [_categoryTable reloadData];
}
- (void)registerClass:(nullable Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier
{
    [self.contextCollection registerClass:cellClass forCellWithReuseIdentifier:identifier];
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_dataSource && [_dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)])
        return [_dataSource numberOfSectionsInCollectionView:self];
    else
        return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZYCategoryCell * cell = [tableView dequeueReusableCellWithIdentifier:CATEGORY_CELL_IDENTIFIER];
    if(cell == nil)
    {
        cell = [[ZYCategoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CATEGORY_CELL_IDENTIFIER];
        cell.selectionStyle          = UITableViewCellSelectionStyleNone;

        cell.backgroundColor = appClearColor;
    }
    
    

        cell.titleLab.text  = [_dataSource collectionView:self titleForHeaderInSection:indexPath.row];
 
    
    return cell;
}
#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

   
    return 52;
}

/*
 * 接下来是 UIScrollviewDelegate 中的方法,在这里实现两个tableView的一些联动
 *
 */
- (nullable NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == _categoryTable)
    {
        _isSelectedCategoryOperation = true;
        [self selectCategoryRowAtIndexPath:indexPath];
        [_contextCollection scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.row] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _isSelectedCategoryOperation = false;
        });
    }
    return indexPath;
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    _isSelectedCategoryOperation = false;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _isUpScroll    = (scrollView.contentOffset.y > _last_offset_y);
    _last_offset_y = scrollView.contentOffset.y;
}
/* -----------------------------------------------------------------------------------*/
#pragma mark UICollectionViewDelegate
/*
 * 将要显示 section title
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.delegate respondsToSelector:@selector(collectionView:didSelectItemAtIndexPath:)])
    {
        [self.delegate collectionView:self didSelectItemAtIndexPath:indexPath];
    }
}
- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0)
{
    if([elementKind isEqualToString:@"UICollectionElementKindSectionHeader"])
    {
        if(_isSelectedCategoryOperation)
            return;
        if( _isUpScroll)
            return;
        [self selectCategoryRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.section inSection:0]];
        static dispatch_once_t onceToken;

    }
}


/*
 *  section title 已经消失
 */
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(UICollectionReusableView *)view forElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    if([elementKind isEqualToString:@"UICollectionElementKindSectionHeader"])
    {
        if(_isSelectedCategoryOperation)
            return;
        if( !_isUpScroll)
            return;
        [self selectCategoryRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.section inSection:0]];
    }
}
#pragma mark UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if(_dataSource && [_dataSource respondsToSelector:@selector( numberOfSectionsInCollectionView:)])
        return [_dataSource numberOfSectionsInCollectionView:self];
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    if(_dataSource && [_dataSource respondsToSelector:@selector( collectionView:numberOfItemsInSection:)])
        return [_dataSource collectionView:self numberOfItemsInSection:section];
    return 0;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(_dataSource && [_dataSource respondsToSelector:@selector(collectionView:cellForItemAtIndexPath:)])
        return [_dataSource collectionView:self cellForItemAtIndexPath:indexPath];
    return nil;
}
-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        HeaderView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"HEADER" forIndexPath:indexPath];
        if(headerView == nil)
        {
            headerView = [[HeaderView alloc] init];
        }
        if(_dataSource && [_dataSource respondsToSelector:@selector(collectionView:titleForHeaderInSection:)])
            headerView.titleLabel.text  = [_dataSource collectionView:self titleForHeaderInSection:indexPath.section];
        else
            headerView.titleLabel.text = [NSString stringWithFormat:@"section%ld",indexPath.section];
        return headerView;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(KSW - 91 - 8, 44);
}


#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{

    return (CGSize){(KSW - 91 - 36 - 8)/3,32};
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 12, 30, 12);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 6.f;
}




@end
