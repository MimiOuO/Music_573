//
//  MioM3U8Player.m
//  573music
//
//  Created by Mimio on 2021/1/11.
//  Copyright © 2021 Mimio. All rights reserved.
//

#import "MioM3U8Player.h"
#import <WHC_ModelSqlite.h>
static void *kStatusKVOKey = &kStatusKVOKey;
static void *kDurationKVOKey = &kDurationKVOKey;
static void *kBufferingRatioKVOKey = &kBufferingRatioKVOKey;

@interface MioM3U8Player()<MioPlayListDelegate>
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) ZFPlayerController *player;
@end


@implementation MioM3U8Player
#pragma mark - 初始化
+(MioM3U8Player *)shareInstance{
    static MioM3U8Player *player = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        player = [[MioM3U8Player alloc]init];
    });
    return player;
}

- (instancetype)init
{
    self = [super init];
    if (self) {

        mioPlayList.delegate = self;
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(_timerAction:) userInfo:nil repeats:YES];
        
        self.currentMusic = mioPlayList.playListArr[mioPlayList.currentPlayIndex];
        
        ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];

        playerManager.shouldAutoPlay = YES;
        
        self.player = [ZFPlayerController playerWithPlayerManager:playerManager containerView:nil];
        self.player.pauseWhenAppResignActive = NO;
        WEAKSELF;
        self.player.currentPlayerManager.playerPlayStateChanged = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset, ZFPlayerPlaybackState playState) {
            [weakSelf updateState:playState];
        };
        self.player.currentPlayerManager.playerLoadStateChanged = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset, ZFPlayerLoadState loadState) {

        };
        self.player.currentPlayerManager.playerDidToEnd = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset) {
            NSLog(@"自动播放完成");
            [weakSelf autoPlayNext];
        };
        if (self.currentMusic) {
            self.player.assetURLs = @[self.currentMusic.audioFileURL];
        }
        
        
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
    [self playIndex:[mioPlayList getAutoPlayIndex]];
    
}

-(void)switchQuailty{
    [self resetAudiostreamer:self.currentMusic];
    [self seekToTime:self.currentTime];
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
        //添加到最近播放
        [WHCSqlite delete:[MioMusicModel class] where:[NSString stringWithFormat:@"savetype = 'recentMusic' AND song_id = '%@'",music.song_id]];
        
        music.savetype = @"recentMusic";
        [WHCSqlite insert:music];
        //通知更新UI
        PostNotice(switchMusic);
        
    }
    [self play];
}



#pragma mark - 基础判断方法


-(BOOL)isCurrentPlay:(MioMusicModel *)music{
    if (Equals(music, mioM3U8Player.currentMusic)) {
        return YES;
    }else{
        return NO;
    }
}

#pragma mark - 播放器基础操作
- (void)_cancelStreamer
{
  if (self.player != nil) {
    [self.player.currentPlayerManager pause];
    [self.player removeObserver:self forKeyPath:@"status"];
   
    self.player = nil;
  }
}

- (void)resetAudiostreamer:(MioMusicModel *)music{
//    [self _cancelStreamer];
    self.player.assetURLs = @[music.audioFileURL];
    [self.player playTheIndex:0];

}

- (void)play{
    static dispatch_once_t onceToken;
    if (onceToken >= 0) {//第一次调用
        dispatch_once(&onceToken, ^{
            [self.player playTheIndex:0];
        });
    }else{
        [self.player.currentPlayerManager play];
    }
}

- (void)pause{
    [self.player.currentPlayerManager pause];
}

- (void)stop{
    [self.player.currentPlayerManager stop];
}

- (void)seekToTime:(NSInteger)location{
    [self.player seekToTime:location completionHandler:^(BOOL finished) {
        
    }];
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
//    NSLog(@"---------");
//    NSLog(@"%f",self.player.currentTime);
//    NSLog(@"%f",self.player.bufferTime);
//
//    NSLog(@"---------");
    
    self.currentMusicDuration = self.player.totalTime;
    self.currentTime = self.player.currentTime;
    self.bufferProgress = self.player.bufferProgress;
    
}

//缓存进度
- (void)_updateBufferingStatus
{
//    if (!isnan([_streamer bufferingRatio])) {
//        self.bufferProgress = [_streamer bufferingRatio];
//    }
}
//播放状态改变
- (void)updateState:(ZFPlayerPlaybackState)state
{
//    self.status = self.player.playbackState;
    switch (state) {
        case ZFPlayerPlayStatePlaying:
//            NSLog(@"播放中");
            self.status = MioPlayerStatePlaying;
            break;

        case ZFPlayerPlayStatePaused:
//            NSLog(@"暂停");
            self.status = MioPlayerStatePaused;
            break;

        case ZFPlayerPlayStatePlayStopped:
            self.status = MioPlayerStatePlayStopped;
//            NSLog(@"%ld___%ld",(long)self.player.currentTime,(long)self.player.totalTime);
//            if ((self.player.totalTime) > 0 && (self.player.totalTime - self.player.currentTime < 1)) {
//                self.status = MioPlayerStatePlayEnded;
                
//                NSLog(@"%ld___%ld",(long)self.player.currentTime,(long)self.player.totalTime);
//            }else{
//                self.status = MioPlayerStatePlayStopped;
//            }
                
            break;

        case ZFPlayerPlayStateUnknown:
//            NSLog(@"缓冲中");
            self.status = MioPlayerStateUnknown;
            break;

        case ZFPlayerPlayStatePlayFailed:
//            NSLog(@"错误");
            self.status = MioPlayerStatePlayFailed;
            break;
    }
}


//缓存文件成功

#pragma mark - 播放列表代理

@end
