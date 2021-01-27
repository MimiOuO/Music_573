//
//  MioSystemNoticeVC.m
//  573music
//
//  Created by Mimio on 2021/1/20.
//  Copyright © 2021 Mimio. All rights reserved.
//

#import "MioSystemNoticeVC.h"
#import "MioSystemNoticeCell.h"
@interface MioSystemNoticeVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) UITableView *table;
@end

@implementation MioSystemNoticeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bgImg.hidden = YES;
    self.view.backgroundColor = appClearColor;
    _dataArr = [[NSMutableArray alloc] init];
    _page = 1;
    _table = [UITableView creatTable:frame(Mar, 0, KSW_Mar2, KSH-NavH-TabH) inView:self.view vc:self];
    _table.contentInset = UIEdgeInsetsMake(Mar, 0, Mar, 0);
    _table.autoHideMjFooter = YES;
    _table.ly_emptyView = [MioEmpty noDataEmpty];
    _table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page = _page + 1;
        [self requestData];
    }];
    [self requestData];
    
}

-(void)requestData{
    [MioGetReq(api_notifications, (@{@"type":@"from_system",@"page":Str(_page)})) success:^(NSDictionary *result){
        NSArray *data = [result objectForKey:@"data"];
        [_table.mj_footer endRefreshing];
        if (Equals(result[@"links"][@"next"], @"<null>")) {
            [_table.mj_footer endRefreshingWithNoMoreData];
        }
        [_dataArr addObjectsFromArray:data];
        [_table reloadData];
    } failure:^(NSString *errorInfo) {}];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = _dataArr[indexPath.row];
    return 56 + [dic[@"data"][@"content"] heightForFont:Font(14) width:(KSW - 86 -28)];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    MioSystemNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MioSystemNoticeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.dic = _dataArr[indexPath.row];
    if (_dataArr.count == 1) {
        ViewRadius(cell.bgView, 8);
    }else{
        if (indexPath.row == 0) {

            [cell.bgView addRoundedCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight withRadii:CGSizeMake(0, 0)];
            [cell.bgView addRoundedCorners:UIRectCornerTopLeft|UIRectCornerTopRight withRadii:CGSizeMake(8, 8)];
        }else if (indexPath.row == _dataArr.count - 1){
            [cell.bgView addRoundedCorners:UIRectCornerTopLeft|UIRectCornerTopRight withRadii:CGSizeMake(0, 0)];
            [cell.bgView addRoundedCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight withRadii:CGSizeMake(8, 8)];
        }else{
            [cell.bgView addRoundedCorners:UIRectCornerTopLeft|UIRectCornerTopRight withRadii:CGSizeMake(0, 0)];
            [cell.bgView addRoundedCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight withRadii:CGSizeMake(0, 0)];
        }
    }

    return cell;
}


@end
