//
//  MioDownloadingVC.m
//  573music
//
//  Created by Mimio on 2020/12/24.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioDownloadingVC.h"
#import <SJM3U8Download.h>
#import <SJM3U8DownloadListController.h>
#import <SJM3U8DownloadListControllerDefines.h>
#import "MioDownloadMusicCell.h"
#import <WHC_ModelSqlite.h>

//static void * kDownloaderCompleteArrayKVOContext = &kDownloaderCompleteArrayKVOContext;
//static void * kDownloaderKVOContext = &kDownloaderKVOContext;
@interface MioDownloadingVC ()<UITableViewDelegate,UITableViewDataSource,SJM3U8DownloadListControllerDelegate, SJM3U8DownloadListItemDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (copy, nonatomic) NSArray *dataArray;
@end

@implementation MioDownloadingVC

- (void)viewDidLoad {

    [super viewDidLoad];
    self.bgImg.hidden = YES;
    self.view.backgroundColor = appClearColor;
    
    SJM3U8DownloadListController.shared.delegate = self;
    
    _tableView = [UITableView creatTable:frame(0, 0, KSW, KSH - NavH - 48 - 0 - TabH) inView:self.view vc:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    for ( id<SJM3U8DownloadListItem> item in SJM3U8DownloadListController.shared.items ) {
        item.delegate = self;
    }
}

- (void)listController:(id<SJM3U8DownloadListController>)controller itemsDidChange:(NSArray<id<SJM3U8DownloadListItem>> *)items {
    [self.tableView reloadData];
}

- (void)downloadItemProgressDidChange:(id<SJM3U8DownloadListItem>)item {
    NSInteger idx = [SJM3U8DownloadListController.shared indexOfItemByUrl:item.url];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
    [self _updateContentForCell:[self.tableView cellForRowAtIndexPath:indexPath] forRowAtIndexPath:indexPath];
}

- (void)downloadItemStateDidChange:(id<SJM3U8DownloadListItem>)item {
    NSInteger idx = [SJM3U8DownloadListController.shared indexOfItemByUrl:item.url];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
    [self _updateContentForCell:[self.tableView cellForRowAtIndexPath:indexPath] forRowAtIndexPath:indexPath];
}

#pragma mark -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"%ld",(long)SJM3U8DownloadListController.shared.count);
    return SJM3U8DownloadListController.shared.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    MioDownloadMusicCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MioDownloadMusicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    id<SJM3U8DownloadListItem> item = [SJM3U8DownloadListController.shared itemAtIndex:indexPath.row];
    cell.item = item;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 72;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(MioDownloadMusicCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self _updateContentForCell:cell forRowAtIndexPath:indexPath];
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [SJM3U8DownloadListController.shared deleteItemAtIndex:indexPath.row];
    }];
    return @[action];
}

#pragma mark -

- (void)_updateContentForCell:(MioDownloadMusicCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    id<SJM3U8DownloadListItem> item = [SJM3U8DownloadListController.shared itemAtIndex:indexPath.row];
    cell.item = item;

    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id<SJM3U8DownloadListItem> item = [SJM3U8DownloadListController.shared itemAtIndex:indexPath.row];
    switch ( item.state ) {
        case SJDownloadStateWaiting:
        case SJDownloadStateRunning: {
            [SJM3U8DownloadListController.shared suspendItemAtIndex:indexPath.row];
        }
            break;
        case SJDownloadStateSuspended:
        case SJDownloadStateFailed: {
            [SJM3U8DownloadListController.shared resumeItemAtIndex:indexPath.row];
        }
            break;
        case SJDownloadStateCancelled:
        case SJDownloadStateFinished:
            break;
    }
}
@end

