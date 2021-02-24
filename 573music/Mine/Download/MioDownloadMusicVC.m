//
//  MioDownloadMusicVC.m
//  573music
//
//  Created by Mimio on 2020/12/24.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioDownloadMusicVC.h"
#import <SJM3U8Download.h>
#import <SJM3U8DownloadListController.h>
#import "MioDownloadedMusicTableCell.h"
#import <WHC_ModelSqlite.h>
#import "MioMutipleVC.h"

static void * kDownloaderCompleteArrayKVOContext = &kDownloaderCompleteArrayKVOContext;

@interface MioDownloadMusicVC ()<UITableViewDelegate,UITableViewDataSource,MutipleDeleteDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (copy, nonatomic) NSMutableArray *dataArr;

@end

@implementation MioDownloadMusicVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bgImg.hidden = YES;
    self.view.backgroundColor = appClearColor;
    
    RecieveNotice(@"downloadCountChange", reloadCount);
    
    _tableView = [UITableView creatTable:frame(0, 0, KSW, KSH - NavH - 48  - TabH) inView:self.view vc:self];
    
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
            vc.delegate = self;
            vc.musicArr = _dataArr;
            vc.type = MioMutipleTypeDownloadList;
            MioNavVC *nav = [[MioNavVC alloc] initWithRootViewController:vc];
            nav.modalPresentationStyle = 0;
            [self presentViewController:nav animated:YES completion:nil];
        }
    }];
    MioImageView *multipleIcon = [MioImageView creatImgView:frame(KSW - 24 -  18, 15, 18, 18) inView:sectionHeader image:@"liebiao_duoxuan" bgTintColorName:name_icon_one radius:0];
    _tableView.tableHeaderView = sectionHeader;
    

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _dataArr = [[WHCSqlite query:[MioMusicModel class]  where:@"savetype = 'downloaded'"] mutableCopy];
    [_tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 72;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    MioDownloadedMusicTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MioDownloadedMusicTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = _dataArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [mioM3U8Player playWithMusicList:_dataArr andIndex:indexPath.row];
}

-(void)reloadCount{
    _dataArr = [[WHCSqlite query:[MioMusicModel class]  where:@"savetype = 'downloaded'"] mutableCopy];
    [_tableView reloadData];
}

-(void)mutipleDelete:(NSArray<MioMusicModel *> *)selectArr{
//    NSMutableArray *idArr = [[NSMutableArray alloc] init];
//    for (int i = 0;i < selectArr.count; i++) {
//        [idArr addObject:selectArr[i].song_id];
//    }
    NSString *downloadPath = [NSString stringWithFormat:@"%@/sj.download.files",
                           NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    for (int i = 0;i < selectArr.count; i++) {
        //清理已下载同一首歌曲的不同音质
        [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%lu",downloadPath,[[selectArr[i].standard[@"url"] mj_url] hash]] error:nil];
        [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%lu",downloadPath,[[selectArr[i].high[@"url"] mj_url] hash]] error:nil];
        [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%lu",downloadPath,[[selectArr[i].lossless[@"url"] mj_url] hash]] error:nil];
        
        [SJM3U8DownloadListController.shared deleteItemForUrl:[NSString stringWithFormat:@"%@",[selectArr[i].standard[@"url"] mj_url]]];
        [SJM3U8DownloadListController.shared deleteItemForUrl:[NSString stringWithFormat:@"%@",[selectArr[i].high[@"url"] mj_url]]];
        [SJM3U8DownloadListController.shared deleteItemForUrl:[NSString stringWithFormat:@"%@",[selectArr[i].lossless[@"url"] mj_url]]];
        [SJM3U8DownloadListController.shared updateContentsForItemByUrl:[NSString stringWithFormat:@"%@",[selectArr[i].standard[@"url"] mj_url]]];
        [SJM3U8DownloadListController.shared updateContentsForItemByUrl:[NSString stringWithFormat:@"%@",[selectArr[i].high[@"url"] mj_url]]];
        [SJM3U8DownloadListController.shared updateContentsForItemByUrl:[NSString stringWithFormat:@"%@",[selectArr[i].lossless[@"url"] mj_url]]];
        
        [WHCSqlite delete:[MioMusicModel class] where:[NSString stringWithFormat:@"savetype = 'downloaded' AND song_id = '%@'",selectArr[i].song_id]];
        
        if (Equals(selectArr[i].song_id, mioM3U8Player.currentMusic.song_id) && (mioM3U8Player.status == MioPlayerStatePlaying))
        {
            [mioM3U8Player switchQuailty];
        }
//        [mioPlayList deletePlayListById:selectArr[i].song_id];
        
    }
    
    _dataArr = [[WHCSqlite query:[MioMusicModel class]  where:@"savetype = 'downloaded'"] mutableCopy];
    [_tableView reloadData];


}

//- (void)listController:(id<SJM3U8DownloadListController>)controller itemsDidChange:(NSArray<id<SJM3U8DownloadListItem>> *)items {
//
//}

@end
