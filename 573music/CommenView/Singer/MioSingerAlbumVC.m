//
//  MioSingerAlbumVC.m
//  573music
//
//  Created by Mimio on 2020/12/29.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioSingerAlbumVC.h"
#import "MioAlbumTableCell.h"
/****进入置顶通知****/
#define kHomeGoTopNotification               @"Home_Go_Top"
/****离开置顶通知****/
#define kHomeLeaveTopNotification            @"Home_Leave_Top"

@interface MioSingerAlbumVC ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property (nonatomic, assign) BOOL canScroll;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation MioSingerAlbumVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = appClearColor;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:kHomeGoTopNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:kHomeLeaveTopNotification object:nil];//其中一个TAB离开顶部的时候，如果其他几个偏移量不为0的时候，要把他们都置为0
    
    _dataArr = [[NSMutableArray alloc] init];
    _page = 1;
    
    _tableView = [UITableView creatTable:frame(0, 0, KSW, KSH - NavH - TabH - 44) inView:self.view vc:self];
    _tableView.backgroundColor = appClearColor;
    _tableView.autoHideMjFooter = YES;
    _tableView.ly_emptyView = [MioEmpty noDataEmpty];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page = _page + 1;
        [self requestData];
    }];
    [self requestData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle =  UIStatusBarStyleLightContent;
}

-(void)requestData{
    [MioGetReq(api_singerAlbums(_singerId), @{@"page":Str(_page)}) success:^(NSDictionary *result){
        NSArray *data = [result objectForKey:@"data"];
        [self.tableView.mj_footer endRefreshing];
        if (Equals(result[@"links"][@"next"], @"<null>")) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        [_dataArr addObjectsFromArray:[MioAlbumModel mj_objectArrayWithKeyValuesArray:data]];
        [_tableView reloadData];
    } failure:^(NSString *errorInfo) {}];
}

#pragma mark - notification

-(void)acceptMsg:(NSNotification *)notification {
    NSString *notificationName = notification.name;
    if ([notificationName isEqualToString:kHomeGoTopNotification]) {
        NSDictionary *userInfo = notification.userInfo;
        NSString *canScroll = userInfo[@"canScroll"];
        if ([canScroll isEqualToString:@"1"]) {
            self.canScroll = YES;
            //            self.tableView.showsVerticalScrollIndicator = YES;
        }
    }else if([notificationName isEqualToString:kHomeLeaveTopNotification]){
        _tableView.contentOffset = CGPointZero;
        self.canScroll = NO;
        //        self.tableView.showsVerticalScrollIndicator = NO;
    }
}


#pragma mark - UIScrollViewDelegate


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (!self.canScroll) {
        [scrollView setContentOffset:CGPointZero];
    }
    CGFloat offsetY = scrollView.contentOffset.y;
//    NSLog(@"%f",offsetY);
    if (offsetY < 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kHomeLeaveTopNotification object:nil userInfo:@{@"canScroll":@"1"}];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 72;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    MioAlbumTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MioAlbumTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = _dataArr[indexPath.row];
    return cell;
}

@end
