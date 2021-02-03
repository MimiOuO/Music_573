//
//  MioIntegralVC.m
//  573music
//
//  Created by Mimio on 2021/1/22.
//  Copyright © 2021 Mimio. All rights reserved.
//

#import "MioIntegralVC.h"

@interface MioIntegralVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) UILabel *intergralLab;
@property (nonatomic, strong) UILabel *levelLab;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation MioIntegralVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navView.leftButton setImage:backArrowIcon forState:UIControlStateNormal];
    [self.navView.centerButton setTitle:@"我的积分" forState:UIControlStateNormal];
    
    _dataArr = [[NSMutableArray alloc] init];
    _page = 1;
    
    [self requestUserInfo];
    [self requestCoinData];
    
    _table = [UITableView creatTable:frame(0, NavH, KSW, KSH - NavH - TabH) inView:self.view vc:self];
    _table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page = _page + 1;
        [self requestCoinData];
    }];
    UIView *headerView = [UIView creatView:frame(0, 0, KSW, 202) inView:nil bgColor:appClearColor radius:0];
    _table.tableHeaderView = headerView;
    UIView *integralView = [UIView creatView:frame(Mar, 12, KSW_Mar2, 130) inView:headerView bgColor:color_main radius:8];
    UIImageView *bgImg = [UIImageView creatImgView:frame(KSW_Mar2 - 199, 0, 199, 130) inView:integralView image:@"jf_bg" radius:0];
    _intergralLab = [UILabel creatLabel:frame(0, 18, KSW_Mar2, 44) inView:integralView text:@"0" color:appWhiteColor size:36 alignment:NSTextAlignmentCenter];
    UILabel *tipLab = [UILabel creatLabel:frame(0, 72, KSW_Mar2, 20) inView:integralView text:@"我的积分" color:rgba(255, 255, 255, 0.8) size:14 alignment:NSTextAlignmentCenter];
    UIView *levelView = [UIView creatView:frame(KSW_Mar2/2 - 21, 96, 42, 19) inView:integralView bgColor:rgba(0, 0, 0, 0.06) radius:9.5];
    _levelLab = [UILabel creatLabel:frame(KSW_Mar2/2 - 21, 96, 42, 19) inView:integralView text:@"Lv.0>" color:appWhiteColor size:12 alignment:NSTextAlignmentCenter];
    [levelView whenTapped:^{
        NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[[userdefault objectForKey:@"levelTip"] dataUsingEncoding:NSUnicodeStringEncoding]options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType}documentAttributes:nil error:nil];
        [UIWindow showMessage:[attrStr string] withTitle:@"等级说明"];
    }];
    UIImageView *tipView = [UIImageView creatImgView:frame(KSW_Mar2 - 8 - 14, 8, 14, 14) inView:integralView image:@"bangzhu" radius:0];
    [tipView whenTapped:^{
        NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[[userdefault objectForKey:@"jifenTip"] dataUsingEncoding:NSUnicodeStringEncoding]options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType}documentAttributes:nil error:nil];
        [UIWindow showMessage:[attrStr string] withTitle:@"积分说明"];
    }];
    _titleView = [UIView creatView:frame(Mar, 158, KSW_Mar2, 44) inView:headerView bgColor:color_card radius:0];
    [_titleView addRoundedCorners:UIRectCornerTopLeft|UIRectCornerTopRight withRadii:CGSizeMake(8, 8)];
    UILabel *title = [UILabel creatLabel:frame(Mar, 0, 100, 44) inView:_titleView text:@"积分记录" color:color_text_one boldSize:14 alignment:NSTextAlignmentLeft];
    UIView *split = [UIView creatView:frame(0, 0, KSW_Mar2, 0.5) inView:_titleView bgColor:color_split radius:0];
}

-(void)requestUserInfo{
    [MioGetReq(api_otherUserinfo(currentUserId), @{@"k":@"v"}) success:^(NSDictionary *result){
        NSDictionary *data = [result objectForKey:@"data"];
        MioUserInfo *user = [MioUserInfo mj_objectWithKeyValues:data];
        _intergralLab.text = user.coin;
        _levelLab.text = [NSString stringWithFormat:@"Lv.%@",user.level];
    } failure:^(NSString *errorInfo) {}];
}

-(void)requestCoinData{
    [MioGetReq(api_CoinLog, @{@"page":Str(_page)}) success:^(NSDictionary *result){
        NSArray *data = [result objectForKey:@"data"];
        [_table.mj_footer endRefreshing];
        if (Equals(result[@"links"][@"next"], @"<null>") ) {
            [_table.mj_footer endRefreshingWithNoMoreData];
        }
        [_dataArr addObjectsFromArray:data];
        
        [_table reloadData];
    } failure:^(NSString *errorInfo) {}];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_dataArr.count == 0) {
        _titleView.hidden = YES;
    }else{
        _titleView.hidden = NO;
    }
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = appClearColor;
    [cell removeAllSubviews];
    UIView *bgView = [UIView creatView:frame(Mar, 0, KSW_Mar2, 44) inView:cell bgColor:color_card radius:0];
    if (_dataArr.count - 1 == indexPath.row) {
        [bgView addRoundedCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight withRadii:CGSizeMake(8, 8)];
    }
    UILabel *titleLab = [UILabel creatLabel:frame(Mar, 0, KSW_Mar2 - Mar2, 44) inView:bgView text:_dataArr[indexPath.row][@"action_zh"] color:color_text_one size:14 alignment:NSTextAlignmentLeft];
    UILabel *timeLab = [UILabel creatLabel:frame(Mar, 0, KSW_Mar2 - Mar2, 44) inView:bgView text:_dataArr[indexPath.row][@"created_at"] color:color_text_one size:14 alignment:NSTextAlignmentCenter];
    UILabel *numLab = [UILabel creatLabel:frame(Mar, 0, KSW_Mar2 - Mar2, 44) inView:bgView text:[NSString stringWithFormat:@"+%@",_dataArr[indexPath.row][@"num"]] color:color_text_one size:14 alignment:NSTextAlignmentRight];
    return cell;
}

@end
