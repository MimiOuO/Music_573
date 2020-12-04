//
//  MioPlayer.h
//  573music
//
//  Created by Mimio on 2020/11/30.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DOUAudioStreamer.h"
#import "MioPlayList.h"

NS_ASSUME_NONNULL_BEGIN

@class MioPlayer;
@protocol MioPlayerDelegate <NSObject>
@optional

@end

@interface MioPlayer : NSObject
+(MioPlayer *)shareInstance;


@property (nonatomic, weak) id <MioPlayerDelegate> delegate;

@property (nonatomic, strong) DOUAudioStreamer *streamer;

/**
 当前播放状态
 */
@property (atomic, assign) DOUAudioStreamerStatus status;


/**
 当前播放的模型
 */
@property (nonatomic, strong) MioMusicModel * currentMusic;


/**
 当前播放的时长
 */
@property (nonatomic, assign) float currentMusicDuration;

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
- (void)seekToTime:(long)location;

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
