//
//  MioRecentMusicVC.m
//  573music
//
//  Created by Mimio on 2021/1/12.
//  Copyright © 2021 Mimio. All rights reserved.
//

#import "MioRecentMusicVC.h"
#import <WHC_ModelSqlite.h>
#import "MioMusicTableCell.h"
#import "MioMutipleVC.h"

@interface MioRecentMusicVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSArray *dataArr;
@end

@implementation MioRecentMusicVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bgImg.hidden = YES;
    self.view.backgroundColor = appClearColor;
    
    _dataArr = [[[WHCSqlite query:[MioMusicModel class] where:@"savetype = 'recentMusic'"] reverseObjectEnumerator] allObjects];
    
    _table = [UITableView creatTable:frame(0, 0, KSW, KSH - NavH - 40 - TabH) inView:self.view vc:self];
    _table.ly_emptyView = [MioEmpty noDataEmpty];
    UIView *sectionHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KSW, 48)];
    
    UIButton *playAllBtn = [UIButton creatBtn:frame(0, 0, 150, 48) inView:sectionHeader bgImage:@"" action:^{
        if (_dataArr.count > 0) {
            [mioM3U8Player playWithMusicList:_dataArr andIndex:0];
        }
    }];
    MioImageView *playAllIcon = [MioImageView creatImgView:frame(Mar, 14, 20, 20) inView:sectionHeader image:@"exclude_play" bgTintColorName:name_main radius:0];
    UILabel *playAllLab = [UILabel creatLabel:frame(40, 13, 80, 22) inView:sectionHeader text:@"播放全部" color:color_text_one size:16 alignment:NSTextAlignmentLeft];
    UIButton *multipleBtn = [UIButton creatBtn:frame(KSW - 100, 0, 100, 48) inView:sectionHeader bgImage:@"" action:^{
        if (_dataArr.count > 0) {
            MioMutipleVC *vc = [[MioMutipleVC alloc] init];
            vc.musicArr = _dataArr;
            vc.type = MioMutipleTypeSongList;
            MioNavVC *nav = [[MioNavVC alloc] initWithRootViewController:vc];
            nav.modalPresentationStyle = 0;
            [self presentViewController:nav animated:YES completion:nil];
        }
    }];
    MioImageView *multipleIcon = [MioImageView creatImgView:frame(KSW - 24 -  18, 15, 18, 18) inView:sectionHeader image:@"liebiao_duoxuan" bgTintColorName:name_icon_one radius:0];
    _table.tableHeaderView = sectionHeader;
//    _table = [[UITableView  alloc] initWithFrame:frame(0, 0, KSW, KSH - NavH - 40 - TabH) style:UITableViewStyleGrouped];

}

-(void)clearData{
    _dataArr = @[];
    [_table reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 72;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    MioMusicTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MioMusicTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = _dataArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [mioM3U8Player playWithMusicList:_dataArr andIndex:indexPath.row];
}

@end
