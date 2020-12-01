//
//  MioPlayer.h
//  573music
//
//  Created by Mimio on 2020/11/30.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KVAudioStreamer.h"
#import "MioPlayList.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, MioPlayStatus) {
    MioPlayStatusIdle,  //闲置状态
    MioPlayStatusBuffering, //缓冲中
    MioPlayStatusPlaying,   //播放
    MioPlayStatusPause, //暂停
    MioPlayStatusFinish,  //完成播放
    MioPlayStatusStop  //停止
};
@class MioPlayer;
@protocol MioPlayerDelegate <NSObject>
@optional
/**
 播放进度通知

 @param player 流媒体
 @param location 当前播放位置，以秒为单位
 */
- (void)player:(MioPlayer *)player playAtTime:(long)location;

/**
 网络请求数据加载区间

 @param player 流媒体
 @param range 数据区间，如果是没有seek操作的，那么是从0开始的，如果使用了seek操作，那么会从seek的文件位置开始，如果开发者需要在进度条中显示加载进度，需要自行处理（可以通过原文件大小跟数据区间的length比值来显示进度）
 @param filesize 原文件大小
 */
- (void)player:(MioPlayer *)player loadNetworkDataInRange:(NSRange)range fileSize:(UInt64)filesize;
@end

@interface MioPlayer : NSObject
+(MioPlayer *)shareInstance;


@property (nonatomic, weak) id <MioPlayerDelegate> delegate;

@property (nonatomic, strong) KVAudioStreamer *streamer;

/**
 当前播放状态
 */
@property (atomic, assign) MioPlayStatus status;

/**
 当前播放的音频路径
 */
@property (nonatomic, copy) NSString * currentAudioUrl;

/**
 当前播放的模型
 */
@property (nonatomic, strong) MioMusicModel * currentMusic;

/**
 当前播放的模型
 */
@property (nonatomic, assign) NSInteger curretnPlayIndex;

#pragma mark - 音频播放相关
/**
 重设音频地址
 注意：重设音频地址将会停止播放上一个音频
 
 @param audiourl 音频地址，如果为本地音频文件，需要添加file://前缀，如果为网络文件，必须以http（https）开头，支持https
 @return 成功返回YES
 */
- (BOOL)resetAudioURL:(NSString*)audiourl;

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
 在某个位置进行播放

 @param location 播放位置，以秒为单位
 */
- (void)playAtTime:(long)location;

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
