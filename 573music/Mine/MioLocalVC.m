//
//  MioLocalVC.m
//  573music
//
//  Created by Mimio on 2021/1/21.
//  Copyright © 2021 Mimio. All rights reserved.
//

#import "MioLocalVC.h"

#import "MioMusicTableCell.h"

@interface MioLocalVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSMutableArray *localArr;
@end

@implementation MioLocalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navView.leftButton setImage:backArrowIcon forState:UIControlStateNormal];
    [self.navView.centerButton setTitle:@"本地歌曲" forState:UIControlStateNormal];
    _localArr = [[NSMutableArray alloc] init];
    [self getItunesMusic];
    
    _table = [UITableView creatTable:frame(0, NavH, KSW, KSH - NavH - TabH) inView:self.view vc:self];
    UIView *sectionHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KSW, 48)];

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _localArr.count;
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
    cell.model = _localArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [UIWindow showInfo:@"还未对接"];
}




- (void)getItunesMusic {
    
    // 创建媒体选择队列
    MPMediaQuery *query = [[MPMediaQuery alloc] init];
    // 创建读取条件
    MPMediaPropertyPredicate *albumNamePredicate = [MPMediaPropertyPredicate predicateWithValue:[NSNumber numberWithInt:MPMediaTypeMusic] forProperty:MPMediaItemPropertyMediaType];
    // 给队列添加读取条件
    [query addFilterPredicate:albumNamePredicate];
    // 从队列中获取条件的数组集合
    NSArray *itemsFromGenericQuery = [query items];
    // 遍历解析数据
    for (MPMediaItem *music in itemsFromGenericQuery) {
        [self resolverMediaItem:music];
    }
    
}

- (void)resolverMediaItem:(MPMediaItem *)music {
    
    // 歌名
    NSString *name = [music valueForProperty:MPMediaItemPropertyTitle];
    // 歌曲路径
    NSURL *fileURL = [music valueForProperty:MPMediaItemPropertyAssetURL];
    // 歌手名字
    NSString *singer = [music valueForProperty:MPMediaItemPropertyArtist];
    if(singer == nil)
    {
        singer = @"未知歌手";
    }
    // 歌曲时长（单位：秒）
    NSTimeInterval duration = [[music valueForProperty:MPMediaItemPropertyPlaybackDuration] doubleValue];
    NSString *time = @"";
    if((int)duration % 60 < 10) {
        time = [NSString stringWithFormat:@"%d:0%d",(int)duration / 60,(int)duration % 60];
    }else {
        time = [NSString stringWithFormat:@"%d:%d",(int)duration / 60,(int)duration % 60];
    }
    // 歌曲插图（没有就返回 nil）
    MPMediaItemArtwork *artwork = [music valueForProperty:MPMediaItemPropertyArtwork];
    UIImage *image;
    if (artwork) {
        image = [artwork imageWithSize:CGSizeMake(72, 72)];
    }else {
//        image = [UIImage imageNamed:@"qxt_gequ"];
    }
    
    MioMusicModel *model  = [[MioMusicModel alloc] init];
    model.title = name;
    model.audioFileURL = fileURL;
    model.singer_name = singer;
//    model.cover_image_path = image;
    
//    [_localArr addObject:@{@"name": name,
//                          @"fileURL": fileURL,
//                          @"singer": singer,
//                          @"time": time,
//                          @"image": image,
//                          }];
    [_localArr addObject:model];
    NSLog(@"%@",_localArr);
}

@end
