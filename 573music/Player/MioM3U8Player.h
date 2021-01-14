//
//  MioM3U8Player.h
//  573music
//
//  Created by Mimio on 2021/1/11.
//  Copyright © 2021 Mimio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MioPlayList.h"
#import "ZFPlayer.h"
#import "ZFAVPlayerManager.h"
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MioPlayerState) {
    MioPlayerStateUnknown,
    MioPlayerStatePlaying,
    MioPlayerStatePaused,
    MioPlayerStatePlayFailed,
    MioPlayerStatePlayStopped,
    MioPlayerStatePlayEnded
};

@interface MioM3U8Player : NSObject
+(MioM3U8Player *)shareInstance;


/**
 当前播放状态
 */
@property (atomic, assign) MioPlayerState status;


/**
 当前播放的模型
 */
@property (nonatomic, strong) MioMusicModel * currentMusic;


/**
 当前播放的时长
 */
@property (nonatomic, assign) float currentMusicDuration;

/**
 当前缓冲进度
 */
@property (nonatomic, assign) float bufferProgress;

/**
 当前播放时间
 */
@property (nonatomic, assign) NSInteger currentTime;


#pragma mark - 音频播放相关


/**
 播放音频列表
 */
- (void)playWithMusicList:(NSArray<MioMusicModel *> *)musicList andIndex:(NSInteger)index;

/**
 播放列表中的某个歌曲
 */
- (void)playIndex:(NSInteger)index;

/**
 播放列表中下一首
 */
- (void)playNext;
/**
 自动播放下一首
 */
-(void)autoPlayNext;

/**
 播放列表中上一首
 */
- (void)playPre;

/**
 播放音频，如果当前为暂停状态，那么会继续播放
 */
- (void)play;

/**
 seek到某个位置进行播放

 @param location 目标位置，以秒为单位
 */
- (void)seekToTime:(NSInteger)location;

/**
 暂停播放
 */
- (void)pause;

/**
 停止播放
 */
- (void)stop;

@end


NS_ASSUME_NONNULL_END
