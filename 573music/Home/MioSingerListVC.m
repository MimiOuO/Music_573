//
//  MioSingerListVC.m
//  573music
//
//  Created by Mimio on 2020/12/31.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioSingerListVC.h"
#import "CYSectionIndexView.h"
#import "MioSingerTableCell.h"
#import "MioSingerVC.h"
@interface MioSingerListVC ()<UITableViewDelegate,UITableViewDataSource,CYSectionIndexViewDelegate,CYSectionIndexViewDataSource,UIScrollViewDelegate>
@property (nonatomic, strong) UITableView *table;
@property (retain, nonatomic) NSMutableArray *sections;
@property (retain, nonatomic) NSMutableDictionary *sectionDic;
@property (nonatomic, strong) CYSectionIndexView * sectionIndexView;
@property (nonatomic, strong) NSArray *categoryArr;
@property (nonatomic,copy) NSString * areaKey;
@property (nonatomic,copy) NSString * genderKey;
@end

@implementation MioSingerListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navView.leftButton setImage:backArrowIcon forState:UIControlStateNormal];
    [self.navView.centerButton setTitle:@"热门歌手" forState:UIControlStateNormal];
    
    _categoryArr = [userdefault objectForKey:@"category"];
    
    [self creatCategory];
    [self createData];
    [self creatUI];
}

-(void)creatCategory{
    
    NSMutableArray *areaArr = [((NSArray *)_categoryArr[0][@"tags"]) mutableCopy];
    [areaArr insertObject:@"全部" atIndex:0];
    UIScrollView *areaScroll = [UIScrollView creatScroll:frame(0, NavH + 16, KSW, 28) inView:self.view contentSize:CGSizeMake(areaArr.count * 64 + 24, 28)];

    for (int i = 0;i < areaArr.count; i++) {
        
        __block UIButton *titleBtn = [UIButton creatBtn:frame(16 + i*64, 0, 56, 28) inView:areaScroll bgColor:color_card title:areaArr[i] titleColor:color_text_one font:14 radius:14 action:^{
            for (int j = 0;j < areaArr.count; j++) {
                UIButton *btn = (UIButton *)[self.view viewWithTag:100 + j];
                btn.selected = NO;
            }
            titleBtn.selected = YES;
            [self requestData];
        }];
        [titleBtn setBackgroundColor:color_main forState:UIControlStateSelected];
        [titleBtn setTitleColor:color_text_white forState:UIControlStateSelected];
        titleBtn.tag = 100 + i;
        if (i == 0) titleBtn.selected = YES;
    }
    
    NSMutableArray *genderArr = [((NSArray *)_categoryArr[1][@"tags"]) mutableCopy];
    [genderArr insertObject:@"全部" atIndex:0];
    UIScrollView *genderScroll = [UIScrollView creatScroll:frame(0, NavH + 52, KSW, 28) inView:self.view contentSize:CGSizeMake(genderArr.count * 64 + 24, 28)];

    for (int i = 0;i < genderArr.count; i++) {
        
        __block UIButton *titleBtn = [UIButton creatBtn:frame(16 + i*64, 0, 56, 28) inView:genderScroll bgColor:color_card title:genderArr[i] titleColor:color_text_one font:14 radius:14 action:^{
            for (int j = 0;j < genderArr.count; j++) {
                UIButton *btn = (UIButton *)[self.view viewWithTag:200 + j];
                btn.selected = NO;
            }
            titleBtn.selected = YES;
            [self requestData];
        }];
        [titleBtn setBackgroundColor:color_main forState:UIControlStateSelected];
        [titleBtn setTitleColor:color_text_white forState:UIControlStateSelected];
        titleBtn.tag = 200 + i;
        if (i == 0) titleBtn.selected = YES;
    }
    
}

-(void)requestData{
    
}


-(void)creatUI{

    _table = [[UITableView alloc] initWithFrame:frame(0, NavH + 94, KSW, KSH - NavH - 94 - TabH) style:UITableViewStyleGrouped];
    _table.backgroundColor = appClearColor;
    _table.delegate = self;
    _table.dataSource = self;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    _table.showsVerticalScrollIndicator = NO;

    [self.view addSubview:_table];
    
    self.sectionIndexView = [[CYSectionIndexView alloc] initWithFrame:frame(KSW - 20 - 6, _table.top + 50, 20 , _table.height - 100)];
    [self.sectionIndexView registerClass:[MioSingerTableCell class] forSectionIndexCellReuseIdentifier:@"cell"];
    self.sectionIndexView.delegate = self;
    self.sectionIndexView.dataSource = self;
    //     self.sectionIndexView.isShowCallout = NO;
    self.sectionIndexView.calloutType = 1;
    [self.view addSubview:self.sectionIndexView];
}

#pragma mark- TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *bgView = [UIView creatView:frame(0, 0, KSW, 32) inView:nil bgColor:appClearColor radius:0];
    UILabel *titleLab = [UILabel creatLabel:frame(Mar, 0, 100, 32) inView:bgView text:self.sections[section] color:color_text_one boldSize:14 alignment:NSTextAlignmentLeft];
    return bgView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 32;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((NSArray *)[self.sectionDic objectForKey:self.sections[section]]).count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 68;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    MioSingerTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MioSingerTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = [MioSingerModel mj_objectWithKeyValues:((NSArray *)[self.sectionDic objectForKey:self.sections[indexPath.section]])[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MioSingerVC *vc = [[MioSingerVC alloc] init];
    vc.model = [MioSingerModel mj_objectWithKeyValues:((NSArray *)[self.sectionDic objectForKey:self.sections[indexPath.section]])[indexPath.row]];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark- CYSectionIndexViewDelegate,CYSectionIndexViewDataSource
-(NSInteger)numberOfItemViewForSectionIndexView:(CYSectionIndexView *)sectionIndexView{
     return self.sections.count;
}
- (NSString *)sectionIndexView:(CYSectionIndexView *)sectionIndexView
               titleForSection:(NSInteger)section{
     return [self.sections objectAtIndex:section];
}
-(CYSectionIndexViewCell *)sectionIndexView:(CYSectionIndexView *)sectionIndexView itemViewForSection:(NSInteger)section{
    MioSingerTableCell * cell = [sectionIndexView dequeueSectionIndexCellWithReuseIdentifier:@"cell"];
//     cell.indexLabel.text = self.sections[section];
     return cell;
}
- (UIView *)sectionIndexView:(CYSectionIndexView *)sectionIndexView calloutViewForSection:(NSInteger)section
{
     UILabel *label = [[UILabel alloc] init];
     label.frame = CGRectMake(0, 0, 80, 80);
     label.backgroundColor = [UIColor clearColor];
     label.textColor = [UIColor redColor];
     label.font = [UIFont boldSystemFontOfSize:36];
     label.text = [self.sections objectAtIndex:section];
     label.textAlignment = NSTextAlignmentCenter;
     
     [label.layer setCornerRadius:label.frame.size.width/2];
     [label.layer setBorderColor:[UIColor lightGrayColor].CGColor];
     [label.layer setBorderWidth:3.0f];
     [label.layer setShadowColor:[UIColor blackColor].CGColor];
     [label.layer setShadowOpacity:0.8];
     [label.layer setShadowRadius:5.0];
     [label.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
     return label;
}
-(void)sectionIndexView:(CYSectionIndexView *)sectionIndexView didSelectSection:(NSInteger)section{
     [_table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}
#pragma mark-
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
     if (scrollView == _table && !self.sectionIndexView.isTouch) {
          NSArray <MioSingerTableCell *> *cellArray = [_table  visibleCells];
          //cell的section的最小值
          long cellSectionMINCount = LONG_MAX;
          for (int i = 0; i < cellArray.count; i++) {
              MioSingerTableCell *cell = cellArray[i];
               long cellSection = [_table indexPathForCell:cell].section;
               if (cellSection < cellSectionMINCount) {
                    cellSectionMINCount = cellSection;
               }
          }
          if (cellSectionMINCount < self.sections.count) {
               [self.sectionIndexView uploadSectionIndexStatusWithCurrentIndex:cellSectionMINCount];
          }
     }
}

- (void)createData
{
    self.sectionDic = [userdefault objectForKey:@"singerGroup"];
    NSArray *temArr = [[self.sectionDic allKeys] mutableCopy];
    self.sections = [[temArr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }] mutableCopy];
}

@end
