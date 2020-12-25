//
//  MioDownloadMusicVC.m
//  573music
//
//  Created by Mimio on 2020/12/24.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioDownloadMusicVC.h"
#import "SODownloader+MusicDownloader.h"
#import "SOSimulateDB.h"

static void * kDownloaderCompleteArrayKVOContext = &kDownloaderCompleteArrayKVOContext;

@interface MioDownloadMusicVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *musicTable;
@property (copy, nonatomic) NSArray *dataArray;

@end

@implementation MioDownloadMusicVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bgImg.hidden = YES;
    self.view.backgroundColor = appClearColor;
    
    _musicTable = [UITableView creatTable:frame(0, 48, KSW, KSH - NavH - 48 - 48 - TabH) inView:self.view vc:self];
    
    
//    [[SODownloader musicDownloader] addObserver:self forKeyPath:SODownloaderCompleteArrayObserveKeyPath options:NSKeyValueObservingOptionNew context:kDownloaderCompleteArrayKVOContext];
    self.dataArray = [SODownloader musicDownloader].completeArray;
    
    NSLog(@"%@",[SOSimulateDB complatedMusicArrayInDB]); 
}

-(void)reload{
    self.dataArray = [SODownloader musicDownloader].completeArray;
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = ((MioMusicModel *)(self.dataArray[indexPath.row])).title;
    return cell;
}

- (void)dealloc {
    // 移除对"已下载"列表的观察
//    [[SODownloader musicDownloader]removeObserver:self forKeyPath:SODownloaderCompleteArrayObserveKeyPath];
}
@end
