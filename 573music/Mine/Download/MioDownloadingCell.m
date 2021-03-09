//
//  MioDownloadingCell.m
//  573music
//
//  Created by Mimio on 2020/12/25.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioDownloadingCell.h"

static void * kStateContext = &kStateContext;
static void * kProgressContext = &kProgressContext;
static void * kSpeedContext = &kSpeedContext;

@interface MioDownloadingCell()
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *progress;
@property (nonatomic, strong) UILabel *size;
@property (nonatomic, strong) UILabel *speed;
@property (nonatomic, strong) UILabel *status;

@end

@implementation MioDownloadingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _title = [UILabel creatLabel:frame(20, 0, KSW, 20) inView:self.contentView text:@"" color:color_text_one size:14 alignment:NSTextAlignmentLeft];
        _progress = [UILabel creatLabel:frame(20, 20, KSW, 20) inView:self.contentView text:@"" color:color_text_one size:14 alignment:NSTextAlignmentLeft];
        _size = [UILabel creatLabel:frame(120, 20, KSW, 20) inView:self.contentView text:@"" color:color_text_one size:14 alignment:NSTextAlignmentLeft];
        _speed = [UILabel creatLabel:frame(220, 20, KSW, 20) inView:self.contentView text:@"" color:color_text_one size:14 alignment:NSTextAlignmentLeft];
        _status = [UILabel creatLabel:frame(320, 20, KSW, 20) inView:self.contentView text:@"" color:color_text_one size:14 alignment:NSTextAlignmentLeft];
    }
    return self;
}

//- (void)setMusic:(MioMusicModel *)music{
//    if (_music) {
//        [_music removeObserver:self forKeyPath:SODownloadItemStateObserveKeyPath];
//        [_music removeObserver:self forKeyPath:SODownloadItemProgressObserveKeyPath];
//        [_music removeObserver:self forKeyPath:SODownloadItemSpeedObserveKeyPath];
//    }
//    _music = music;
//    _title.text = _music.title;
//    [self updateState:_music.so_downloadState];
//    _size.text = [NSString stringWithFormat:@"%lld",_music.so_downloadProgress.totalUnitCount];
//    if (_music) {
//        [_music addObserver:self forKeyPath:SODownloadItemStateObserveKeyPath options:NSKeyValueObservingOptionNew context:kStateContext];
//        [_music addObserver:self forKeyPath:SODownloadItemProgressObserveKeyPath options:NSKeyValueObservingOptionNew context:kProgressContext];
//        [_music addObserver:self forKeyPath:SODownloadItemSpeedObserveKeyPath options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:kSpeedContext];
//    }
//}
//
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
//    if (context == kStateContext) {
//
//        SODownloadState newState = [change[NSKeyValueChangeNewKey]integerValue];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self updateState:newState];
//        });
//    } else if (context == kProgressContext) {
//        NSNumber *newProgressNum = change[NSKeyValueChangeNewKey];
//        if (![newProgressNum isKindOfClass:[NSNumber class]]) {
//            NSLog(@"Progress Class: %@", NSStringFromClass([newProgressNum class]));
//            // 这里 newProgressNum 可能是 NSNull，向 NSNull 对象发送 doubleValue 会导致异常。
//            return;
//        }
//        double newProgress = [newProgressNum doubleValue];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            _progress.text = [NSString stringWithFormat:@"%f",newProgress];
//            _size.text = [NSString stringWithFormat:@"%lld",_music.so_downloadProgress.totalUnitCount];
//        });
//    } else if (context == kSpeedContext) {
//        NSNumber *value = change[NSKeyValueChangeNewKey];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if ((NSNull *)value == [NSNull null]) {
//                _speed.text = @"0 Byte/s";
//            } else {
//                NSInteger speed = [value integerValue];
//                if (speed < 1024) {
//                    _speed.text = [NSString stringWithFormat:@"%li Byte/s", speed];
//                } else if (speed < 1024 * 1024) {
//                    _speed.text = [NSString stringWithFormat:@"%li kb/s", speed / 1024];
//                } else {
//                    _speed.text = [NSString stringWithFormat:@"%.1f mb/s", speed / 1024 / 1024.0];
//                }
//            }
//        });
//    } else {
//        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
//    }
//}
//
//- (void)updateState:(SODownloadState)state {
//    switch (state) {
//        case SODownloadStateWait:
//            _status.text = @"等待中";
//            _speed.hidden = YES;
//            break;
//        case SODownloadStatePaused:
//            _status.text = @"已暂停";
//            _speed.hidden = YES;
//            break;
//        case SODownloadStateError:
//            _status.text = @"失败";
//            _speed.hidden = YES;
//            break;
//        case SODownloadStateLoading:
//            _status.text = @"下载中";
//            _speed.hidden = NO;
//            break;
//        case SODownloadStateProcess:
//            _status.text = @"下载中";
//            _speed.hidden = NO;
//            break;
//        case SODownloadStateComplete:
//            _status.text = @"已下载";
//            _speed.hidden = YES;
//            break;
//        default:
//            _status.text = @"未下载";
//            _speed.hidden = YES;
//            break;
//    }
//}
@end
