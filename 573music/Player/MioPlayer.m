//
//  MioPlayer.m
//  573music
//
//  Created by Mimio on 2020/11/30.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioPlayer.h"

@interface MioPlayer()<KVAudioStreamerDelegate,MioPlayListDelegate>

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
        self.streamer = [[KVAudioStreamer alloc] init];
        self.streamer.delegate = self;
        self.streamer.cacheEnable = YES;    //开启缓存功能
        
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
    
}

- (void)playNext{
    
}

-(void)autoPlayNext{
    
}

#pragma mark - MioPlayer基础操作
-(NSInteger)getPreIndex{
    if (!Equals(currentPlayOrder, MioPlayOrderRandom)) {
        NSLog(@"%ld",(long)self.curretnPlayIndex);
        return 0;
    }else{
        return 0;
    }
}

-(void)getNextIndex{
    
}

- (void)playWithMusic:(MioMusicModel *)music{
    if (![self isCurrentPlay:music]) {
        self.currentMusic = music;
        [self resetAudioURL:music.audiourl];
        [self updateCurrentIndex];
        [mioPlayList saveCurrentPlayList:mioPlayList.playListArr currentIndex:self.curretnPlayIndex];
    }
    [self play];
}

- (NSInteger)curretnPlayIndex{
    return [mioPlayList.playListArr indexOfObject:self.currentMusic];
}

-(void)updateCurrentIndex{
    self.curretnPlayIndex = [mioPlayList.playListArr indexOfObject:self.currentMusic];
}

#pragma mark - 基础判断方法


-(BOOL)isCurrentPlay:(MioMusicModel *)music{
    if (Equals(music.id, mioPlayer.currentMusic.id)) {
        return YES;
    }else{
        return NO;
    }
}

#pragma mark - 播放器基础操作

- (BOOL)resetAudioURL:(NSString*)audiourl{
    return [self.streamer resetAudioURL:audiourl];
}



- (void)play{
    
    
    [self.streamer play];
}


- (void)playAtTime:(long)location{
    [self.streamer playAtTime:location];
}


- (void)seekToTime:(long)location{
    [self.streamer seekToTime:location];
}

- (void)pause{
    [self.streamer pause];
}

- (void)stop{
    [self.streamer stop];
}

#pragma mark - 播放器代理
- (void)audioStreamer:(KVAudioStreamer *)streamer playAtTime:(long)location{
    if ([self.delegate respondsToSelector:@selector(player:playAtTime:)]) {
        [self.delegate player:self playAtTime:self.status];
    }
}

- (void)audioStreamer:(KVAudioStreamer *)streamer loadNetworkDataInRange:(NSRange)range fileSize:(UInt64)filesize{
    if ([self.delegate respondsToSelector:@selector(player:loadNetworkDataInRange:fileSize:)]) {
        [self.delegate player:self loadNetworkDataInRange:(NSRange)range fileSize:(UInt64)filesize];
    }
}

- (void)audioStreamer:(KVAudioStreamer *)streamer playStatusChange:(KVAudioStreamerPlayStatus)status{
    switch (status) {
        case KVAudioStreamerPlayStatusBuffering:
            NSLog(@"缓冲中");

            break;
        case KVAudioStreamerPlayStatusStop:
        {
            NSLog(@"播放停止");

        }
            break;
        case KVAudioStreamerPlayStatusPause:
        {
            NSLog(@"播放暂停");

            if (self.streamer.currentAudioFile.duration) {
//                [self pausePlaybackInfoWithTitle:self.title arttist:@"未知歌手" image:[UIImage imageNamed:@"chenyixun"] duration:self.streamer.currentAudioFile.duration currentDuration:self.streamer.currentAudioFile.currentPlayDuration];
            }else {
//                [self pausePlaybackInfoWithTitle:self.title arttist:@"未知歌手" image:[UIImage imageNamed:@"chenyixun"] duration:self.streamer.currentAudioFile.estimateDuration currentDuration:self.streamer.currentAudioFile.currentPlayDuration];
            }
        }
            break;
        case KVAudioStreamerPlayStatusFinish:
        {
            NSLog(@"播放结束");

//            [self nextBtnClick];
        }
            break;
        case KVAudioStreamerPlayStatusPlaying:
        {
            NSLog(@"播放中");

//            if (self.streamer.currentAudioFile.duration) {
//                [self updatePlaybackInfoWithTitle:self.title arttist:@"未知歌手" image:[UIImage imageNamed:@"chenyixun"] duration:self.streamer.currentAudioFile.duration currentDuration:self.streamer.currentAudioFile.currentPlayDuration playRate:self.streamer.playRate];
//            }else {
//                [self updatePlaybackInfoWithTitle:self.title arttist:@"未知歌手" image:[UIImage imageNamed:@"chenyixun"] duration:self.streamer.currentAudioFile.estimateDuration currentDuration:self.streamer.currentAudioFile.currentPlayDuration playRate:self.streamer.playRate];
//            }
        }
            break;
        case KVAudioStreamerPlayStatusIdle:
        {
            NSLog(@"闲置状态");

        }
            break;
        default:
            break;
    }
}

- (BOOL)audioStreamer:(KVAudioStreamer *)streamer cacheCompleteWithRelativePath:(NSString *)relativePath cachepath:(NSString *)cachepath {
    NSLog(@"缓存文件成功%@", cachepath);
    return YES;
}

#pragma mark - 播放列表代理

@end
