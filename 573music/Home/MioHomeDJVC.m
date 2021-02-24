//
//  MioHomeDJVC.m
//  573music
//
//  Created by Mimio on 2021/2/20.
//  Copyright © 2021 Mimio. All rights reserved.
//

#import "MioHomeDJVC.h"
#import "MioDJMusicTableCell.h"

@interface MioHomeDJVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *tagArr;
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic,copy) NSString * key;
@property (nonatomic, strong) NSMutableArray *taskArr;
@property (nonatomic,copy) NSString * lock;
@end

@implementation MioHomeDJVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bgImg.hidden = YES;
    self.view.backgroundColor = appClearColor;
    
    _dataArr = [[NSMutableArray alloc] init];
    _taskArr = [[NSMutableArray alloc] init];
    _page = 1;
    _key = @"最热";
    _lock = @"";
    
    [self creatUI];
    [self requestData];
}

-(void)requestData{
    
    if (Equals(_key, @"最热") || Equals(_key, @"最新")) {
        [_taskArr addObject:MioGetCacheReq(api_rankDetail(Equals(_key, @"最热")?@"27":@"26"), (@{@"page":Str(_page)}))];
        MioRequest *req = MioGetCacheReq(api_rankDetail(Equals(_key, @"最热")?@"27":@"26"), (@{@"page":Str(_page)}));
        [req success:^(NSDictionary *result){

            NSArray *data = result[@"data"][@"data_paginate"][@"data"];
            [_table.mj_header endRefreshing];
            [_table.mj_footer endRefreshing];
            if (!Equals(_key, _lock)) {
                _lock = _key;
                if (_page == 1) {
                    [_dataArr removeAllObjects];
                }
                if (Equals(result[@"data"][@"data_paginate"][@"next_page_url"], @"<null>")) {
                    [_table.mj_footer endRefreshingWithNoMoreData];
                }
                [_dataArr addObjectsFromArray:[MioMusicModel mj_objectArrayWithKeyValuesArray:data]];
                [_table reloadData];
                [UIWindow hiddenLoading];
            }

        } failure:^(NSString *errorInfo) {
            [_table.mj_header endRefreshing];
            [_table.mj_footer endRefreshing];
            [UIWindow hiddenLoading];
            [UIWindow showInfo:errorInfo];
        }];
    }else{
    
        [_taskArr addObject:MioGetCacheReq(api_songs, (@{@"columns":@[@"tag s"],@"s":_key,@"page":Str(_page)}))];
        MioRequest *req = MioGetCacheReq(api_songs, (@{@"columns":@[@"tags"],@"s":_key,@"page":Str(_page)}));
        [req success:^(NSDictionary *result){
            

            NSArray *data = [result objectForKey:@"data"];
            [_table.mj_header endRefreshing];
            [_table.mj_footer endRefreshing];
            if (!Equals(_key, _lock)) {
                _lock = _key;
                if (_page == 1) {
                    [_dataArr removeAllObjects];
                }
                if (Equals(result[@"links"][@"next"], @"<null>")) {
                    [_table.mj_footer endRefreshingWithNoMoreData];
                }

                [_dataArr addObjectsFromArray:[MioMusicModel mj_objectArrayWithKeyValuesArray:data]];
                [_table reloadData];
                [UIWindow hiddenLoading];
            }
        } failure:^(NSString *errorInfo) {
            [_table.mj_header endRefreshing];
            [_table.mj_footer endRefreshing];
            [UIWindow hiddenLoading];
            [UIWindow showInfo:errorInfo];
        }];
    }
}


-(void)creatUI{
    _tagArr = [NSMutableArray arrayWithArray:@[@"最热",@"最新"]];
    [_tagArr addObjectsFromArray:[userdefault objectForKey:@"djtabs"]];
    UIScrollView *areaScroll = [UIScrollView creatScroll:frame(0, 54, KSW, 28) inView:self.view contentSize:CGSizeMake(_tagArr.count * 64 + 24, 28)];

    for (int i = 0;i < _tagArr.count; i++) {
        
        __block UIButton *titleBtn = [UIButton creatBtn:frame(16 + i*64, 0, 56, 28) inView:areaScroll bgColor:color_card title:_tagArr[i] titleColor:color_text_one font:14 radius:14 action:^{
            for (int j = 0;j < _tagArr.count; j++) {
                UIButton *btn = (UIButton *)[self.view viewWithTag:100 + j];
                btn.selected = NO;
            }
            titleBtn.selected = YES;
            _key = _tagArr[i];
//            [UIWindow showLoading:@"加载中"];
        
            
            for (MioRequest * task in _taskArr) {
                [task stop];
            }
            
            _page = 1;
            [self requestData];
        }];
        [titleBtn setBackgroundColor:color_main forState:UIControlStateSelected];
        [titleBtn setTitleColor:color_text_white forState:UIControlStateSelected];
        titleBtn.tag = 100 + i;
        if (i == 0) titleBtn.selected = YES;
    }
    
    _table = [UITableView creatTable:frame(0,94, KSW, KSH - 92  - 94 - 50 - TabH) inView:self.view vc:self];
    _table.autoHideMjFooter = YES;
    _table.ly_emptyView = [MioEmpty noDataEmpty];
    _table.mj_header = [MioRefreshHeader headerWithRefreshingBlock:^{
        _page = 1;
        _lock = @"";
        [self requestData];
    }];
    _table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page = _page + 1;
        _lock = @"";
        [self requestData];
    }];
    
}

-(void)updateUI{
    

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 72;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    MioDJMusicTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MioDJMusicTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = _dataArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [mioM3U8Player playWithMusicList:_dataArr andIndex:indexPath.row];
}

@end
