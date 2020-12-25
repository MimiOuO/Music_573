//
//  MioDownloadingVC.m
//  573music
//
//  Created by Mimio on 2020/12/24.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioDownloadingVC.h"
#import "SODownloader+MusicDownloader.h"
#import "SOSimulateDB.h"
#import "MioDownloadingCell.h"

//static void * kDownloaderCompleteArrayKVOContext = &kDownloaderCompleteArrayKVOContext;
//static void * kDownloaderKVOContext = &kDownloaderKVOContext;
@interface MioDownloadingVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *musicTable;
@property (copy, nonatomic) NSArray *dataArray;
@end

@implementation MioDownloadingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bgImg.hidden = YES;
    self.view.backgroundColor = appClearColor;
    
    _musicTable = [UITableView creatTable:frame(0, 48, KSW, KSH - NavH - 48 - 48 - TabH) inView:self.view vc:self];
    

//    [[SODownloader musicDownloader]addObserver:self forKeyPath:SODownloaderCompleteArrayObserveKeyPath options:NSKeyValueObservingOptionNew context:kDownloaderKVOContext];
    
    self.dataArray = [SODownloader musicDownloader].downloadArray;
   
}

-(void)reload{
    self.dataArray = [SODownloader musicDownloader].downloadArray;
    [_musicTable reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    MioDownloadingCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MioDownloadingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.music = ((MioMusicModel *)(self.dataArray[indexPath.row]));
    
    return cell;
}
/// 实现这个代理方法是为了当一个cell在界面消失时，移除cell对music模型的kvo。
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    MioDownloadingCell *musicCell = (MioDownloadingCell *)cell;
    [musicCell setMusic:nil];
}

@end
