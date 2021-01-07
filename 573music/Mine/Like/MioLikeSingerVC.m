//
//  MioLikeSingerVC.m
//  573music
//
//  Created by Mimio on 2021/1/6.
//  Copyright © 2021 Mimio. All rights reserved.
//

#import "MioLikeSingerVC.h"
#import "MioSingerModel.h"
#import "MioSingerTableCell.h"
#import "MioSingerVC.h"

@interface MioLikeSingerVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation MioLikeSingerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bgImg.hidden = YES;
    self.view.backgroundColor = appClearColor;
    
    _dataArr = [[NSMutableArray alloc] init];
    _page = 1;
    
    _table = [UITableView creatTable:frame(0, 0, KSW, KSH - NavH - 40 - TabH) inView:self.view vc:self];
    _table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page = _page + 1;
        [self requestData];
    }];
    [self requestData];
}


-(void)requestData{

    
    [MioGetReq(api_likeSinger, (@{@"page":Str(_page)})) success:^(NSDictionary *result){
        NSArray *data = [result objectForKey:@"data"];
        [_table.mj_footer endRefreshing];
        if (_page == 1) {
            [_dataArr removeAllObjects];
        }
        if (data.count < 10) {
            [_table.mj_footer endRefreshingWithNoMoreData];
        }
        
        [_dataArr addObjectsFromArray:[MioSingerModel mj_objectArrayWithKeyValuesArray:data]];
        [_table reloadData];
    } failure:^(NSString *errorInfo) {
        NSLog(@"%@",errorInfo);
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
    vc.model = _dataArr[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
