//
//  MioMusicModel.m
//  573music
//
//  Created by Mimio on 2020/11/30.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioMusicModel.h"
#import <WHC_ModelSqlite.h>
@implementation MioMusicModel
//@synthesize so_downloadProgress, so_downloadState = _so_downloadState, so_downloadError, so_downloadSpeed = _so_downloadSpeed;


- (NSURL *)audioFileURL{
    NSString *quailty = self.defaultQuailty;
    if (Equals(quailty, @"标准")) {
        if (self.hasSQ) {
            return Str(_standard[@"url"]).mj_url;
        }else if(self.hasHQ){
            return Str(_high[@"url"]).mj_url;
        }else{
            return Str(_lossless[@"url"]).mj_url;
        }
    }
    if (Equals(quailty, @"超品")) {
        if (self.hasHQ) {
            return Str(_high[@"url"]).mj_url;
        }else if(self.hasSQ){
            return Str(_standard[@"url"]).mj_url;
        }else{
            return Str(_lossless[@"url"]).mj_url;
        }
    }
    if (Equals(quailty, @"无损")) {
        if (self.hasFlac) {
            return Str(_lossless[@"url"]).mj_url;
        }else if(self.hasHQ){
            return Str(_high[@"url"]).mj_url;
        }else{
            return Str(_standard[@"url"]).mj_url;
        }
    }
    return @"".mj_url;
}


- (NSString *)defaultQuailty{
    NSString * quailty = [userdefault objectForKey:@"defaultQuailty"];
    if ([userdefault objectForKey:_song_id]) {
        quailty = [userdefault objectForKey:_song_id];
    }
    if (Equals(quailty, @"标准")) {
        if (self.hasSQ) {
            return @"标准";
        }else if(self.hasHQ){
            return @"超品";
        }else{
            return @"无损";
        }
    }
    if (Equals(quailty, @"超品")) {
        if (self.hasHQ) {
            return @"超品";
        }else if(self.hasSQ){
            return @"标准";
        }else{
            return @"无损";
        }
    }
    if (Equals(quailty, @"无损")) {
        if (self.hasFlac) {
            return @"无损";
        }else if(self.hasHQ){
            return @"超品";
        }else{
            return @"标准";
        }
    }
    return @"";
}

- (BOOL)hasSQ{
    if (((NSString *)_standard[@"url"]).length > 0) {
        return YES;
    }else{
        return NO;
    }
}

- (BOOL)hasHQ{
    if (((NSString *)_high[@"url"]).length > 0) {
        return YES;
    }else{
        return NO;
    }
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

//- (NSURL *)so_downloadURL {
//    return [_standard[@"url"] mj_url];
//}



//+ (NSString *)musicDownloadFolder {
//    NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
//    NSString *downloadFolder = [documents stringByAppendingPathComponent:@"musics"];
//    [self handleDownloadFolder:downloadFolder];
//    return downloadFolder;
//}
//
//+ (void)handleDownloadFolder:(NSString *)folder {
//    BOOL isDir = NO;
//    BOOL folderExist = [[NSFileManager defaultManager]fileExistsAtPath:folder isDirectory:&isDir];
//    if (!folderExist || !isDir) {
//        [[NSFileManager defaultManager]createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:nil];
//        NSURL *fileURL = [NSURL fileURLWithPath:folder];
//        [fileURL setResourceValue:@YES forKey:NSURLIsExcludedFromBackupKey error:nil];
//    }
//}

//-(void)changeSo_downloadState:(SODownloadState)so_downloadState {
//    self.so_downloadState = so_downloadState;
//    [SOSimulateDB save:self];
//}
//
//- (void)setSo_downloadState:(SODownloadState)so_downloadState {
//    _so_downloadState = so_downloadState;
//}

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

- (NSString *)hits_all{
    if ([_hits_all intValue] > 10000) {
        return [NSString stringWithFormat:@"%.1fw",[_hits_all intValue]/10000.0];
    }else if ([_hits_all intValue] > 1000) {
        return [NSString stringWithFormat:@"%.1fk",[_hits_all intValue]/1000.0];
    }else{
        return _hits_all;
    }
}


@end
