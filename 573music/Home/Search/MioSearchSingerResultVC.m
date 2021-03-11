//
//  MioSearchSingerResultVC.m
//  573music
//
//  Created by Mimio on 2020/12/31.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioSearchSingerResultVC.h"
#import "MioSingerModel.h"
#import "MioSingerTableCell.h"
#import "MioSingerVC.h"

@interface MioSearchSingerResultVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray<MioSingerModel *> *dataArr;
@end

@implementation MioSearchSingerResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bgImg.hidden = YES;
    self.view.backgroundColor = appClearColor;
    
    _dataArr = [[NSMutableArray alloc] init];
    _page = 1;
    
    _table = [UITableView creatTable:frame(0, 0, KSW, KSH - NavH - 40 - TabH) inView:self.view vc:self];
    _table.autoHideMjFooter = YES;
    _table.ly_emptyView = [MioEmpty noDataEmpty];
    _table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page = _page + 1;
        [self requestData];
    }];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    RecieveNotice(@"search", requestNewKeyData);
    [self requestData];
}

//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}

-(void)requestNewKeyData{
    _page = 1;
    [self requestData];
}

-(void)requestData{
    if (_searchKey.length == 0 ) {
        return;
    }
    [UIWindow showLoading];
    [MioGetReq(api_singers, (@{@"s":_searchKey,@"page":Str(_page)})) success:^(NSDictionary *result){
        NSArray *data = [result objectForKey:@"data"];
        [_table.mj_footer endRefreshing];
        if (_page == 1) {
            [_dataArr removeAllObjects];
        }
        if (Equals(result[@"links"][@"next"], @"<null>")) {
            [_table.mj_footer endRefreshingWithNoMoreData];
        }
        
        [_dataArr addObjectsFromArray:[MioSingerModel mj_objectArrayWithKeyValuesArray:data]];
        [_table reloadData];
        [UIWindow hiddenLoading];
    } failure:^(NSString *errorInfo) {
        [UIWindow hiddenLoading];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
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
    cell.model = _dataArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MioSingerVC *vc = [[MioSingerVC alloc] init];
    vc.singerId = _dataArr[indexPath.row].singer_id;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
