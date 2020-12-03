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
    }
    return self;
}


#pragma mark - 各种形式播放
- (void)playWithMusicList:(NSArray<MioMusicModel *> *)musicList andIndex:(NSInteger)index{
    [mioPlayList updatePlayList:musicList];
    [self playWithMusic:musicList[index]];
}


- (void)playIndex:(NSInteger)index{
    [self playWithMusic:mioPlayList.playListArr[index]];
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


- (void)playWithMusic:(MioMusicModel *)music{
    if (![self isCurrentPlay:music]) {
        self.currentMusic = music;
        [self resetAudioURL:music];
        [self updateCurrentIndex];
        [mioPlayList saveCurrentPlayList:mioPlayList.playListArr currentIndex:self.currentPlayIndex];
    }
    [self play];
}

- (NSInteger)currentPlayIndex{
    _currentPlayIndex = [mioPlayList.playListArr indexOfObject:self.currentMusic];
    return _currentPlayIndex;
}


-(void)updateCurrentIndex{
    self.currentPlayIndex = [mioPlayList.playListArr indexOfObject:self.currentMusic];
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

- (void)resetAudioURL:(MioMusicModel *)music{
    [self _cancelStreamer];

          _streamer = [DOUAudioStreamer streamerWithAudioFile:music];
          [_streamer addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:kStatusKVOKey];
          [_streamer addObserver:self forKeyPath:@"duration" options:NSKeyValueObservingOptionNew context:kDurationKVOKey];
          [_streamer addObserver:self forKeyPath:@"bufferingRatio" options:NSKeyValueObservingOptionNew context:kBufferingRatioKVOKey];
          
          [_streamer play];
          
//          [self _updateBufferingStatus];
          [self _setupHintForStreamer];
    
      
}
//缓存下一首
- (void)_setupHintForStreamer
{
  NSUInteger nextIndex = self.currentPlayIndex + 1;

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

- (void)seekToTime:(long)location{
//    [_streamer setCurrentTime:[_streamer duration] * [_progressSlider value]];
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
//    [_progressSlider setValue:0.0f animated:NO];
  }
  else {
      self.currentMusicDuration = [_streamer duration];
//    [_progressSlider setValue:[_streamer currentTime] / [_streamer duration] animated:YES];
  }
}

//缓存进度
- (void)_updateBufferingStatus
{
//  [_miscLabel setText:[NSString stringWithFormat:@"Received %.2f/%.2f MB (%.2f %%), Speed %.2f MB/s", (double)[_streamer receivedLength] / 1024 / 1024, (double)[_streamer expectedLength] / 1024 / 1024, [_streamer bufferingRatio] * 100.0, (double)[_streamer downloadSpeed] / 1024 / 1024]];

  if ([_streamer bufferingRatio] >= 1.0) {
    NSLog(@"sha256: %@", [_streamer sha256]);
  }
}
//播放状态改变
- (void)_updateStatus
{
    self.status = [_streamer status];
    switch ([_streamer status]) {
        case DOUAudioStreamerPlaying:
            NSLog(@"playing");
        break;

        case DOUAudioStreamerPaused:
            NSLog(@"paused");
            break;

        case DOUAudioStreamerIdle:
            NSLog(@"idle");
            break;

        case DOUAudioStreamerFinished:
            NSLog(@"finished");
            break;

        case DOUAudioStreamerBuffering:
            NSLog(@"buffering");
            break;

        case DOUAudioStreamerError:
            NSLog(@"error");
            break;
    }
}


//缓存文件成功

#pragma mark - 播放列表代理

@end
