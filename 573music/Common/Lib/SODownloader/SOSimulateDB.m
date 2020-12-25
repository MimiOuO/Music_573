//
//  SOSimulateDB.m
//  SODownloader_Example
//
//  Created by 张豪 on 2017/11/5.
//  Copyright © 2017年 scfhao. All rights reserved.
//

#import "SOSimulateDB.h"
#import "MioMusicModel.h"
#import <WHC_ModelSqlite.h>

@interface SOSimulateDB ()


@property (strong, nonatomic) NSMutableArray *downloadingArray;
@property (strong, nonatomic) NSMutableArray *pausedArray;
@property (strong, nonatomic) NSMutableArray *complatedArray;

@end

@implementation SOSimulateDB

+ (instancetype)sharedDB {
    static SOSimulateDB *_db = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _db = [[SOSimulateDB alloc] init];
    });
    return _db;
}

//+ (NSString *)dbFile {
//    NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    return [documents stringByAppendingPathComponent:@"simulate.db"];
//}
//
- (instancetype)init {
    self = [super init];
    if (self) {

        _downloadingArray = [[NSMutableArray alloc]init];
        _pausedArray = [[NSMutableArray alloc]init];
        _complatedArray = [[NSMutableArray alloc]init];
        
        _downloadingArray = [[WHCSqlite query:[MioMusicModel class] where:@"savetype = 'downloading'"] mutableCopy];
        _pausedArray = [[WHCSqlite query:[MioMusicModel class] where:@"savetype = 'pause'"] mutableCopy];
        _complatedArray = [[WHCSqlite query:[MioMusicModel class] where:@"savetype = 'complate'"] mutableCopy];
    }
    return self;
}


// 这个方法用于保存
+ (void)save:(MioMusicModel *)music {
    [[SOSimulateDB sharedDB] save:music];
}

- (void)save:(MioMusicModel *)music {
    
    switch (music.so_downloadState) {
        case SODownloadStateWait:
        case SODownloadStateLoading:

            if (![self.downloadingArray containsObject:music]) {
                [self.downloadingArray addObject:music];
            }
            [self.pausedArray removeObject:music];
            [self.complatedArray removeObject:music];
            break;
        case SODownloadStatePaused:

            if (![self.pausedArray containsObject:music]) {
                 [self.pausedArray addObject:music];
            }
            [self.downloadingArray removeObject:music];
            [self.complatedArray removeObject:music];
            break;
        case SODownloadStateComplete:

            if (![self.complatedArray containsObject:music]) {
                [self.complatedArray addObject:music];
            }
            [self.downloadingArray removeObject:music];
            [self.pausedArray removeObject:music];
            break;
        case SODownloadStateNormal:

            [self.downloadingArray removeObject:music];
            [self.pausedArray removeObject:music];
            [self.complatedArray removeObject:music];
        default:
            break;
    }
    

    [WHCSqlite delete:[MioMusicModel class] where:@"savetype = 'downloading'"];
    [WHCSqlite delete:[MioMusicModel class] where:@"savetype = 'pause'"];
    [WHCSqlite delete:[MioMusicModel class] where:@"savetype = 'complate'"];
    
    if (self.downloadingArray.count > 0) {
        for (MioMusicModel *music in self.downloadingArray) {
            music.savetype = @"downloading";
        }
        [WHCSqlite inserts:self.downloadingArray];
    }
    
    

    if (self.pausedArray.count > 0) {
        for (MioMusicModel *music in self.pausedArray) {
            music.savetype = @"pause";
        }
        [WHCSqlite inserts:self.pausedArray];
    }
    

    if (self.complatedArray.count > 0) {
        for (MioMusicModel *music in self.complatedArray) {
            music.savetype = @"complate";
        }
        [WHCSqlite inserts:self.complatedArray];
    }
}

/// 获取出于下载中状态的音乐
+ (NSArray *)downloadingMusicArrayInDB {
    SOSimulateDB *db = [self sharedDB];
    return [db.downloadingArray copy];
}

+ (NSArray *)pausedMusicArrayInDB {
    SOSimulateDB *db = [self sharedDB];
    return [db.pausedArray copy];
}

+ (NSArray *)complatedMusicArrayInDB {
    SOSimulateDB *db = [self sharedDB];
    return [db.complatedArray copy];
}

@end
