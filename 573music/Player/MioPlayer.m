//
//  MioPlayer.m
//  573music
//
//  Created by Mimio on 2020/11/30.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioPlayer.h"

static void *kStatusKVOKey = &kStatusKVOKey;
static void *kDurationKVOKey = &kDurationKVOKey;
static void *kBufferingRatioKVOKey = &kBufferingRatioKVOKey;

@interface MioPlayer()<MioPlayListDelegate>
@property (nonatomic, strong) NSTimer *timer;
@end


@implementation MioPlayer
#pragma mark - 初始化
+(MioPlayer *)shareInstance{
    static MioPlayer *player = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        player = [[MioPlayer alloc]init];
    });
    return player;
}

- (instancetype)init
{
    self = [super init];
    if (self) {

        mioPlayList.delegate = self;
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(_timerAction:) userInfo:nil repeats:YES];
    }
    return self;
}


#pragma mark - 各种形式播放
- (void)playWithMusicList:(NSArray<MioMusicModel *> *)musicList andIndex:(NSInteger)index{
    [self playWithMusic:musicList[index] withMusicList:musicList];
}


- (void)playIndex:(NSInteger)index{
    [self playWithMusic:mioPlayList.playListArr[index] withMusicList:nil];
}

- (void)playPre{
    [self playIndex:[mioPlayList getPreIndex]];
}

- (void)playNext{
    [self playIndex:[mioPlayList getNextIndex]];
}

-(void)autoPlayNext{
    
}

#pragma mark - MioPlayer基础操作

//统一播放方法
- (void)playWithMusic:(MioMusicModel *)music withMusicList:(NSArray<MioMusicModel *> *)musicList{
    if (![self isCurrentPlay:music]) {//不是当前歌曲
        //重设Mioplayer模型
        self.currentMusic = music;
        //重设MioplayList
        if (musicList) {
            [mioPlayList updatePlayList:musicList];
        }
        //重设currentIndex
        [mioPlayList updateCurrentIndex:music];
        //重设currentIndex
        self.currentTime = 0;
        //重设streamer
        [self resetAudiostreamer:music];
        //通知更新UI
        PostNotice(switchMusic);
        
    }
    [self play];
}



#pragma mark - 基础判断方法


-(BOOL)isCurrentPlay:(MioMusicModel *)music{
    if (Equals(music, mioPlayer.currentMusic)) {
        return YES;
    }else{
        return NO;
    }
}

#pragma mark - 播放器基础操作
- (void)_cancelStreamer
{
  if (_streamer != nil) {
    [_streamer pause];
    [_streamer removeObserver:self forKeyPath:@"status"];
    [_streamer removeObserver:self forKeyPath:@"duration"];
    [_streamer removeObserver:self forKeyPath:@"bufferingRatio"];
    _streamer = nil;
  }
}

- (void)resetAudiostreamer:(MioMusicModel *)music{
    [self _cancelStreamer];

    _streamer = [DOUAudioStreamer streamerWithAudioFile:music];
    [_streamer addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:kStatusKVOKey];
    [_streamer addObserver:self forKeyPath:@"duration" options:NSKeyValueObservingOptionNew context:kDurationKVOKey];
    [_streamer addObserver:self forKeyPath:@"bufferingRatio" options:NSKeyValueObservingOptionNew context:kBufferingRatioKVOKey];

    

    //          [self _updateBufferingStatus];
    
    //缓存下一首
    [DOUAudioStreamer setHintWithAudioFile:[mioPlayList.playListArr objectAtIndex:[mioPlayList getNextIndex]]];
      
}


- (void)play{
    [self.streamer play];
}

- (void)pause{
    [self.streamer pause];
}

- (void)stop{
    [self.streamer stop];
}

- (void)seekToTime:(NSInteger)location{
    [self.streamer setCurrentTime:location];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
  if (context == kStatusKVOKey) {
    [self performSelector:@selector(_updateStatus)
                 onThread:[NSThread mainThread]
               withObject:nil
            waitUntilDone:NO];
  }
  else if (context == kDurationKVOKey) {
    [self performSelector:@selector(_timerAction:)
                 onThread:[NSThread mainThread]
               withObject:nil
            waitUntilDone:NO];
  }
  else if (context == kBufferingRatioKVOKey) {
    [self performSelector:@selector(_updateBufferingStatus)
                 onThread:[NSThread mainThread]
               withObject:nil
            waitUntilDone:NO];
  }
  else {
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
  }
}

//播放进度
- (void)_timerAction:(id)timer
{
    if ([_streamer duration] == 0.0) {
        self.currentMusicDuration = 0.0;
    }
    else {
        self.currentMusicDuration = [_streamer duration];
        self.currentTime = [_streamer currentTime];
    }
}

//缓存进度
- (void)_updateBufferingStatus
{
    if (!isnan([_streamer bufferingRatio])) {
        self.bufferProgress = [_streamer bufferingRatio];
    }
}
//播放状态改变
- (void)_updateStatus
{
    self.status = [_streamer status];
    switch ([_streamer status]) {
        case DOUAudioStreamerPlaying:
            NSLog(@"播放中");
            break;

        case DOUAudioStreamerPaused:
            NSLog(@"暂停");
            break;

        case DOUAudioStreamerIdle:
            NSLog(@"空闲");
            break;

        case DOUAudioStreamerFinished:
            NSLog(@"结束");
            break;

        case DOUAudioStreamerBuffering:
            NSLog(@"缓冲中");
            break;

        case DOUAudioStreamerError:
            NSLog(@"错误");
            break;
    }
}


//缓存文件成功

#pragma mark - 播放列表代理

@end
