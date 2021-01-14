//
//  MioAddToSonglistVC.m
//  573music
//
//  Created by Mimio on 2021/1/12.
//  Copyright © 2021 Mimio. All rights reserved.
//

#import "MioAddToSonglistVC.h"
#import "MioSonglistTableCell.h"
#import "MioCreatSonglistVC.h"

@interface MioAddToSonglistVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSArray<MioSongListModel *> *dataArr;
@end

@implementation MioAddToSonglistVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navView.leftButton setImage:backArrowIcon forState:UIControlStateNormal];
    [self.navView.centerButton setTitle:@"添加到" forState:UIControlStateNormal];
    _table = [UITableView creatTable:frame(0, NavH, KSW, KSH - NavH) inView:self.view vc:self];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self request];
}

-(void)request{
    [MioGetReq(api_mySongLists, @{@"k":@"v"}) success:^(NSDictionary *result){
        _dataArr = [MioSongListModel mj_objectArrayWithKeyValuesArray:[result objectForKey:@"data"]];
        [_table reloadData];
    } failure:^(NSString *errorInfo) {}];
}

#pragma mark - tableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count + 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 72;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = appClearColor;
        UIView *iconBg = [UIView creatView:frame(Mar, 6, 60, 60) inView:cell bgColor:color_card radius:4];
        UIImageView *icon = [UIImageView creatImgView:frame(20, 20, 20, 20) inView:iconBg image:@"gedan_xinjian" radius:0];
        UILabel *title = [UILabel creatLabel:frame(84, 6, 100, 60) inView:cell text:@"新建歌单" color:color_text_one size:16 alignment:NSTextAlignmentLeft];
        return cell;
    }
    else if (indexPath.row == 1) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = appClearColor;
        UIView *iconBg = [UIView creatView:frame(Mar, 6, 60, 60) inView:cell bgColor:color_card radius:4];
        UIImageView *icon = [UIImageView creatImgView:frame(20, 20, 20, 20) inView:iconBg image:@"gedan_xihuan" radius:0];
        UILabel *title = [UILabel creatLabel:frame(84, 6, 100, 60) inView:cell text:@"我的喜欢" color:color_text_one size:16 alignment:NSTextAlignmentLeft];
        return cell;
    }else{
        static NSString *identifier = @"cell";
        MioSonglistTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MioSonglistTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = _dataArr[indexPath.row - 2];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *musicIdArr = [[NSMutableArray alloc] init];
    for (int i = 0;i < _musicArr.count; i++) {
        [musicIdArr addObject:_musicArr[i].song_id];
    }
    
    if (indexPath.row == 0) {
        MioCreatSonglistVC *vc = [[MioCreatSonglistVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row == 1) {
        [MioPostReq(api_likes, (@{@"model_name":@"song",@"model_ids":musicIdArr})) success:^(NSDictionary *result){
            [UIWindow showSuccess:@"添加成功"];
            [self dismissViewControllerAnimated:YES completion:nil];
            
        } failure:^(NSString *errorInfo) {
            [UIWindow showInfo:errorInfo];
        }];
    }else{
        [MioPostReq(api_addToSonglist(_dataArr[indexPath.row - 2].song_list_id), @{@"ids":musicIdArr}) success:^(NSDictionary *result){
            [UIWindow showSuccess:@"添加成功"];
            [self dismissViewControllerAnimated:YES completion:nil];
        } failure:^(NSString *errorInfo) {
            [UIWindow showInfo:errorInfo];
        }];
    }
}


@end
