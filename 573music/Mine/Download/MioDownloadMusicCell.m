//
//  MioDownloadMusicCell.m
//  573music
//
//  Created by Mimio on 2021/2/8.
//  Copyright © 2021 Mimio. All rights reserved.
//

#import "MioDownloadMusicCell.h"
#import <SJM3U8DownloadListController.h>
@interface MioDownloadMusicCell()
@property (nonatomic, strong) UIImageView *cover;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *singer;
@property (nonatomic, strong) UILabel *speed;
@property (nonatomic, strong) UILabel *size;
@property (nonatomic, strong) UIProgressView *progress;
@property (nonatomic, strong) UILabel *stateLab;
@property (nonatomic, strong) UIButton *deleteBtn;
@end

@implementation MioDownloadMusicCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = appClearColor;
        _cover = [UIImageView creatImgView:frame(Mar, 0, 60, 60) inView:self.contentView image:@"" radius:4];
        _title = [UILabel creatLabel:frame(84, 0, KSW - 84 - 40, 22) inView:self.contentView text:@"" color:color_text_one size:16 alignment:NSTextAlignmentLeft];
        _singer = [UILabel creatLabel:frame(84, 21, KSW - 84 - 40, 17) inView:self.contentView text:@"" color:color_text_two size:12 alignment:NSTextAlignmentLeft];
        
        _stateLab = [UILabel creatLabel:frame(KSW_Mar - 100, 27, 100, 14) inView:self.contentView text:@"" color:color_text_two size:10 alignment:NSTextAlignmentRight];
        
        _deleteBtn = [UIButton creatBtn:frame(KSW_Mar - 16, 0, 16, 16) inView:self.contentView bgImage:@"denlu_guanbi" action:nil];
        
        _speed = [UILabel creatLabel:frame(84, 46, 100, 14) inView:self.contentView text:@"" color:color_text_two size:10 alignment:NSTextAlignmentLeft];
        
        _size = [UILabel creatLabel:frame(KSW_Mar - 100, 46, 100, 14) inView:self.contentView text:@"" color:color_text_two size:10 alignment:NSTextAlignmentLeft];
        
        _progress = [[UIProgressView alloc] initWithFrame:frame(84, 43, KSW_Mar - 84, 2)];
        _progress.progressTintColor= color_main;
        [self.contentView addSubview:_progress];
    }
    return self;
}

- (void)setItem:(SJM3U8DownloadListItem *)item{
    MioMusicModel *music = [MioMusicModel mj_objectWithKeyValues:item.musicJson];
    [_cover sd_setImageWithURL:music.cover_image_path.mj_url placeholderImage:image(@"qxt_gequ")];
    _title.text = music.title;
    _singer.text = music.singer_name;
    _speed.text = [NSString stringWithFormat:@"%.0fkb/s",item.speed*1024.0];
    _progress.progress = item.progress;
    
    if (item.state == SJDownloadStateRunning) {
        _stateLab.text = @"下载中";
        _speed.hidden = NO;
    }
    if (item.state == SJDownloadStateWaiting) {
        _stateLab.text = @"等待中";
        _speed.hidden = YES;
    }
    if (item.state == SJDownloadStateSuspended) {
        _stateLab.text = @"已暂停";
        _speed.hidden = YES;
    }
    if (item.state == SJDownloadStateFailed) {
        _stateLab.text = @"失败";
        _speed.hidden = YES;
    }
    
    [_deleteBtn whenTapped:^{
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *downloadPath = [NSString stringWithFormat:@"%@/sj.download.files",
                               NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]];
        [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%lu",downloadPath,[[item.url mj_url] hash]] error:nil];
        [SJM3U8DownloadListController.shared deleteItemForUrl:item.url];
        [SJM3U8DownloadListController.shared updateContentsForItemByUrl:item.url];
    }];
}

@end
