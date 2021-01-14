//
//  MioMusicModel.m
//  573music
//
//  Created by Mimio on 2020/11/30.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioMusicModel.h"
#import "SOSimulateDB.h"
@implementation MioMusicModel
@synthesize so_downloadProgress, so_downloadState = _so_downloadState, so_downloadError, so_downloadSpeed = _so_downloadSpeed;



- (NSURL *)audioFileURL{
    return [NSURL URLWithString:[Str(_standard[@"url"]) stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

- (BOOL)hasFlac{
    if (((NSString *)_lossless[@"url"]).length > 0) {
        return YES;
    }else{
        return NO;
    }
}

- (BOOL)hasMV{
    if ([_mv_id intValue] > 0) {
        return YES;
    }else{
        return NO;
    }
}



- (void)setSavetype:(NSString *)savetype{
    _savetype = savetype;
}

- (NSURL *)so_downloadURL {
    return [_standard[@"url"] mj_url];
}

- (NSString *)savePath {
    
    return [[[[self class] musicDownloadFolder] stringByAppendingPathComponent:_song_id] stringByAppendingPathExtension:@"mp3"];
}

+ (NSString *)musicDownloadFolder {
    NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *downloadFolder = [documents stringByAppendingPathComponent:@"musics"];
    [self handleDownloadFolder:downloadFolder];
    return downloadFolder;
}

+ (void)handleDownloadFolder:(NSString *)folder {
    BOOL isDir = NO;
    BOOL folderExist = [[NSFileManager defaultManager]fileExistsAtPath:folder isDirectory:&isDir];
    if (!folderExist || !isDir) {
        [[NSFileManager defaultManager]createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:nil];
        NSURL *fileURL = [NSURL fileURLWithPath:folder];
        [fileURL setResourceValue:@YES forKey:NSURLIsExcludedFromBackupKey error:nil];
    }
}

-(void)changeSo_downloadState:(SODownloadState)so_downloadState {
    self.so_downloadState = so_downloadState;
    [SOSimulateDB save:self];
}

- (void)setSo_downloadState:(SODownloadState)so_downloadState {
    _so_downloadState = so_downloadState;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
//        self.index = [coder decodeIntegerForKey:NSStringFromSelector(@selector(index))];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
//    [aCoder encodeInteger:self.index forKey:NSStringFromSelector(@selector(index))];
}

+(NSString *)whc_SqliteVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];

    // app build版本

    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];

    return [app_Version stringByAppendingString:app_build];
}

@end
