//
//  MioM3U8Player.m
//  573music
//
//  Created by Mimio on 2021/1/11.
//  Copyright © 2021 Mimio. All rights reserved.
//

#import "MioM3U8Player.h"
#import <WHC_ModelSqlite.h>
#import <SJM3U8Downloader.h>
#import <SJM3U8DownloadListController.h>
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

        [userdefault setObject:@"1" forKey:@"firstPlay"];//第一次点击play
        
        mioPlayList.delegate = self;
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(_timerAction:) userInfo:nil repeats:YES];
        
        if (mioPlayList.currentPlayIndex >= 0) {
            self.currentMusic = mioPlayList.playListArr[mioPlayList.currentPlayIndex];
        }
        
        
        ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];

        playerManager.shouldAutoPlay = YES;
        
        self.player = [ZFPlayerController playerWithPlayerManager:playerManager containerView:nil];
        self.player.allowOrentitaionRotation = NO;
        self.player.pauseWhenAppResignActive = NO;
        WEAKSELF;
        self.player.currentPlayerManager.playerPlayStateChanged = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset, ZFPlayerPlaybackState playState) {
            [weakSelf updateState:playState];
        };
        self.player.currentPlayerManager.playerLoadStateChanged = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset, ZFPlayerLoadState loadState) {

        };
        self.player.currentPlayerManager.playerDidToEnd = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset) {
            NSLog(@"自动播放完成");
            [MioPostReq(api_addCoin, @{@"action":@"listen_song"}) success:^(NSDictionary *result){} failure:^(NSString *errorInfo) {}];
            [weakSelf autoPlayNext];
        };
        if (self.currentMusic) {
            self.player.assetURLs = @[self.currentMusic.audioFileURL];
        }
        
        [self setupLockScreenControlInfo];
        
        // 插拔耳机
        RecieveNotice(AVAudioSessionRouteChangeNotification, audioSessionRouteChange:);
        RecieveNotice(AVAudioSessionInterruptionNotification, audioSessionInterruption:)
    }
    return self;
}


#pragma mark - 各种形式播放
- (void)playWithMusicList:(NSArray<MioMusicModel *> *)musicList andIndex:(NSInteger)index{
    [self playWithMusic:musicList[index] withMusicList:musicList];
    PostNotice(@"showPlaylistIcon");
    [userdefault setObject:@"0" forKey:@"isRadio"];
    [userdefault synchronize];
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
    if (Equals([userdefault objectForKey:@"openNewtwork"], @"0")) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [UIWindow showMessage:@"当前网络模式为“仅WIFI可用”,不能访问网络" withTitle:@"提示"];
        });
        return;
    }
    
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
        if (!music.local) {//本地歌曲 不是下载歌曲
            //添加到最近播放
            [WHCSqlite delete:[MioMusicModel class] where:[NSString stringWithFormat:@"savetype = 'recentMusic' AND song_id = '%@'",music.song_id]];
            
            music.savetype = @"recentMusic";
            [WHCSqlite insert:music];
        }
        
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
    NSArray<MioMusicModel *> *dataArr = [WHCSqlite query:[MioMusicModel class]  where:@"savetype = 'downloaded'"];
    NSMutableArray *musicIdArr = [[NSMutableArray alloc] init];
    for (int i = 0;i < dataArr.count; i++) {
        [musicIdArr addObject:dataArr[i].song_id];
    }
    
    NSString *downloadPath = [NSString stringWithFormat:@"%@/sj.download.files",
                           NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([musicIdArr containsObject:music.song_id] && [fileManager fileExistsAtPath:[NSString stringWithFormat:@"%@/%lu",downloadPath,[music.audioFileURL hash]]] ) {
        self.player.assetURLs = @[[SJM3U8DownloadListController.shared localPlayUrlByUrl:[NSString stringWithFormat:@"%@",music.audioFileURL]].mj_url];
        [self.player playTheIndex:0];
    }else{
        if (music.local) {//是本地歌曲 不是下载歌曲
            self.player.assetURLs = @[music.localUrl];
            [self.player playTheIndex:0];
        }else{
            self.player.assetURLs = @[music.audioFileURL];
            [self.player playTheIndex:0];
        }
    }
    
    if (!music.local) {
        //添加播放量
        [MioPostReq(api_addPlayCount, (@{@"model_name":@"song",@"columns":@"hits_all",@"model_id":music.song_id})) success:^(NSDictionary *result){} failure:^(NSString *errorInfo) {}];
    }
}

- (void)play{
    [MPRemoteCommandCenter sharedCommandCenter].playCommand.enabled = YES;

    if (Equals([userdefault objectForKey:@"firstPlay"], @"1")) {
        [userdefault setObject:@"0" forKey:@"firstPlay"];
        [self resetAudiostreamer:self.currentMusic];
        [self playIndex:mioPlayList.currentPlayIndex];
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
//    [self performSelector:@selector(_updateStatus)
//                 onThread:[NSThread mainThread]
//               withObject:nil
//            waitUntilDone:NO];
  }
  else if (context == kDurationKVOKey) {
    [self performSelector:@selector(_timerAction:)
                 onThread:[NSThread mainThread]
               withObject:nil
            waitUntilDone:NO];
  }
  else if (context == kBufferingRatioKVOKey) {
//    [self performSelector:@selector(_updateBufferingStatus)
//                 onThread:[NSThread mainThread]
//               withObject:nil
//            waitUntilDone:NO];
  }
  else {
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
  }
}

//播放进度
- (void)_timerAction:(id)timer
{
    
    self.currentMusicDuration = self.player.totalTime;
    self.currentTime = self.player.currentTime;
    self.bufferProgress = self.player.bufferProgress;
    
    if (mioM3U8Player.currentMusic) {
        //锁屏界面
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView sd_setImageWithURL:mioM3U8Player.currentMusic.cover_image_path.mj_url placeholderImage:image(@"qxt_logo")];


        MPMediaItemArtwork *artWork = [[MPMediaItemArtwork alloc] initWithImage:imageView.image];
        NSDictionary *dic = @{
            MPMediaItemPropertyTitle:mioM3U8Player.currentMusic.title,
            MPMediaItemPropertyArtist:mioM3U8Player.currentMusic.singer_name,
            MPMediaItemPropertyArtwork:artWork,
            MPNowPlayingInfoPropertyElapsedPlaybackTime:[NSNumber numberWithInteger:mioM3U8Player.currentTime],
            MPMediaItemPropertyPlaybackDuration:[NSNumber numberWithFloat:mioM3U8Player.currentMusicDuration],
                 };
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dic];
    }
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


- (void)setupLockScreenControlInfo {
    MPRemoteCommandCenter *commandCenter = [MPRemoteCommandCenter sharedCommandCenter];
    // 锁屏播放
    [commandCenter.playCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        NSLog(@"锁屏暂停后点击播放");
        [self play];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    // 锁屏暂停
    [commandCenter.pauseCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        NSLog(@"锁屏正在播放点击后暂停");
        [self pause];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    

    
    // 播放和暂停按钮（耳机控制）
    MPRemoteCommand *playPauseCommand = commandCenter.togglePlayPauseCommand;
    playPauseCommand.enabled = YES;
    [playPauseCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        
        if (self.status == MioPlayerStatePlaying) {
            [self pause];
        }else {
            [self play];
        }
        
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    // 上一曲
    MPRemoteCommand *previousCommand = commandCenter.previousTrackCommand;
    [previousCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        
        [self playPre];
        
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    // 下一曲
    MPRemoteCommand *nextCommand = commandCenter.nextTrackCommand;
    nextCommand.enabled = YES;
    [nextCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        
        [self playNext];
        
        return MPRemoteCommandHandlerStatusSuccess;
    }];
}

- (void)audioSessionRouteChange:(NSNotification *)notify {
    NSDictionary *interuptionDict = notify.userInfo;
    
    NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    switch (routeChangeReason) {
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
            NSLog(@"耳机插入");
            // 继续播放音频，什么也不用做
            break;
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
        {
            NSLog(@"耳机拔出");
            
            if (self.status == MioPlayerStatePlaying) {
                [self pause];
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)audioSessionInterruption:(NSNotification *)notify {
    NSDictionary *interuptionDict = notify.userInfo;
    
    NSInteger interruptionType = [interuptionDict[AVAudioSessionInterruptionTypeKey] integerValue];
    NSInteger interruptionOption = [interuptionDict[AVAudioSessionInterruptionOptionKey] integerValue];
    
    if (interruptionType == AVAudioSessionInterruptionTypeBegan) {
        // 收到播放中断的通知，暂停播放
        if (self.status == MioPlayerStatePlaying) {
            [self pause];
        }
    }else if (interruptionType == AVAudioSessionInterruptionTypeEnded){
        
    }
}


@end
