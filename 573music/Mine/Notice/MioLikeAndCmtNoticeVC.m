//
//  MioIikeAndCmtNoticeVC.m
//  573music
//
//  Created by Mimio on 2021/1/20.
//  Copyright © 2021 Mimio. All rights reserved.
//

#import "MioLikeAndCmtNoticeVC.h"
#import "MioLikeAndCmtNoticeCell.h"
@interface MioLikeAndCmtNoticeVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) UITableView *table;
@end

@implementation MioLikeAndCmtNoticeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bgImg.hidden = YES;
    self.view.backgroundColor = appClearColor;
    _dataArr = [[NSMutableArray alloc] init];
    _page = 1;
    _table = [UITableView creatTable:frame(Mar, 0, KSW_Mar2, KSH-NavH-TabH) inView:self.view vc:self];
    _table.contentInset = UIEdgeInsetsMake(Mar, 0, Mar, 0);
    _table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page = _page + 1;
        [self requestData];
    }];
    [self requestData];
    
}

-(void)requestData{
    [MioGetReq(api_notifications, (@{@"type":@"like_or_comment",@"page":Str(_page)})) success:^(NSDictionary *result){
        NSArray *data = [result objectForKey:@"data"];
        [_table.mj_footer endRefreshing];
        if (data.count < 10) {
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
    NSString *action = Equals(dic[@"data"][@"action"], @"reply")?@"回复":(Equals(dic[@"data"][@"model"], @"comment")?@"赞":@"喜欢");
    NSString *type = Equals(dic[@"data"][@"model"], @"comment")?@"评论":@"歌单";
    float height = 94;
    if (Equals(type, @"歌单")) {
        height = 94;
    }else if (Equals(action, @"赞")){
        height = 94 + 13 + [dic[@"data"][@"extra"][@"my_content"] heightForFont:Font(14) width:(KSW - 76 -47)];
    }else{
        height = 94 + 13 + 2 + [dic[@"data"][@"extra"][@"my_content"] heightForFont:Font(14) width:(KSW - 76 -47)] + [[NSString stringWithFormat:@"我的评论：%@",dic[@"data"][@"extra"][@"my_content"]] heightForFont:Font(12) width:(KSW - 76 -47)];
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    MioLikeAndCmtNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MioLikeAndCmtNoticeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
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
