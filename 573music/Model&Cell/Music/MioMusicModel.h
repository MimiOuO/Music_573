//
//  MioMusicModel.h
//  573music
//
//  Created by Mimio on 2020/11/30.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DOUAudioFile.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MioFromType) {
    MioFromSonglist,
    MioFromAlbum,
    MioFromSinger,
    MioFromCategory,
    MioFromRank,
    MioFromMyLike,
    MioFromLocal,
    MioFromRecent,
    MioFromDownload,
    MioFromUnkown
};

@interface MioMusicModel : NSObject <DOUAudioFile,NSCopying>

@property (nonatomic, copy) NSString * song_id;
@property (nonatomic, copy) NSString * singer_id;
@property (nonatomic, copy) NSString * singer_name;
@property (nonatomic, copy) NSString * album_id;
@property (nonatomic, copy) NSString * album_name;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * cover_image_path;
@property (nonatomic, copy) NSString * lrc_url;

@property (nonatomic, copy) NSString * defaultQuailty;
@property (nonatomic, strong) NSDictionary * standard;
@property (nonatomic, strong) NSDictionary * high;
@property (nonatomic, strong) NSDictionary * lossless;

@property (nonatomic, copy) NSString * mv_id;
@property (nonatomic, copy) NSString * like_num;
@property (nonatomic, copy) NSString * comment_num;
@property (nonatomic, copy) NSString * hits_all;
@property (nonatomic, assign) BOOL is_like;

@property (nonatomic, assign) BOOL hasSQ;//标清
@property (nonatomic, assign) BOOL hasHQ;//高清
@property (nonatomic, assign) BOOL hasFlac;//无损
@property (nonatomic, assign) BOOL hasMV;

@property (nonatomic, strong) NSURL * audioFileURL;

@property (nonatomic, assign) BOOL local;//本地 非下载
@property (nonatomic, strong) NSString * localUrl;//本地 非下载
@property (nonatomic, copy) NSString * savetype;

@property (nonatomic, assign) MioFromType fromModel;
@property (nonatomic, copy) NSString * fromId;

@end

NS_ASSUME_NONNULL_END
