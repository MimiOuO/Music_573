//
//  MioSearchSonglistResultVC.m
//  573music
//
//  Created by Mimio on 2020/12/31.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioSearchSonglistResultVC.h"
#import "MioSongListModel.h"
#import "MioSonglistTableCell.h"
#import "MioSongListVC.h"
@interface MioSearchSonglistResultVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation MioSearchSonglistResultVC

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

-(void)requestNewKeyData{
    _page = 1;
    [self requestData];
}

-(void)requestData{
    if (_searchKey.length == 0 ) {
        return;
    }
    [UIWindow showLoading];
    [MioGetReq(api_songLists, (@{@"s":_searchKey,@"page":Str(_page)})) success:^(NSDictionary *result){
        NSArray *data = [result objectForKey:@"data"];
        [_table.mj_footer endRefreshing];
        if (_page == 1) {
            [_dataArr removeAllObjects];
        }
        if (Equals(result[@"links"][@"next"], @"<null>")) {
            [_table.mj_footer endRefreshingWithNoMoreData];
        }
        
        [_dataArr addObjectsFromArray:[MioSongListModel mj_objectArrayWithKeyValuesArray:data]];
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
    return 72;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    MioSonglistTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MioSonglistTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = _dataArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MioSongListVC *vc = [[MioSongListVC alloc] init];
    vc.songlistId = ((MioSongListModel *)_dataArr[indexPath.row]).song_list_id;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
