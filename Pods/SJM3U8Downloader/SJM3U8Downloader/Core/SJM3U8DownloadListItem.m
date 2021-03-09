//
//  SJM3U8DownloadListItem.m
//  SJM3u8Downloader
//
//  Created by BlueDancer on 2019/12/18.
//  Copyright © 2019 SanJiang. All rights reserved.
//

#import "SJM3U8DownloadListItem.h"
#if __has_include(<YYModel/YYModel.h>)
#import <YYModel/NSObject+YYModel.h>
#elif __has_include(<YYKit/YYKit.h>)
#import <YYKit/YYKit.h>
#endif

NS_ASSUME_NONNULL_BEGIN
@interface SJM3U8DownloadListItem ()
@property (nonatomic) NSInteger id;
@property (nonatomic, copy) NSString *url;
@end

@implementation SJM3U8DownloadListItem
+ (nullable NSString *)sql_primaryKey {
    return @"id";
}

+ (nullable NSArray<NSString *> *)sql_autoincrementlist {
    return @[@"id"];
}

+ (nullable NSArray<NSString *> *)sql_blacklist {
    return @[@"operation", @"speed", @"delegate"];
}

- (instancetype)initWithUrl:(NSString *)url folderName:(nullable NSString *)name withMusic:(NSDictionary *)musicJson{
    self = [super init];
    if ( self ) {
        _url = url;
        _folderName = name;
        _musicJson = musicJson;
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:musicJson options:NSJSONWritingPrettyPrinted error:nil];
        NSString * jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        _musicJsonString = jsonStr;
    }
    return self;
}

- (void)setProgress:(float)progress {
    _progress = progress;
    if ( [self.delegate respondsToSelector:@selector(downloadItemProgressDidChange:)] ) {
        [self.delegate downloadItemProgressDidChange:self];
    }
}

- (void)setState:(SJDownloadState)state {
    _state = state;
    if (_state == SJDownloadStateFinished) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"downLoadFinish" object:self.musicJson];
    }
    if ( [self.delegate respondsToSelector:@selector(downloadItemStateDidChange:)] ) {
        [self.delegate downloadItemStateDidChange:self];
        
    }
}

- (NSDictionary *)musicJson{
    if (_musicJson) {
        return _musicJson;
    }else{
        if (_musicJsonString) {
            NSData * getJsonData = [_musicJsonString dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary * getDict = [NSJSONSerialization JSONObjectWithData:getJsonData options:NSJSONReadingMutableContainers error:nil];
            return getDict;
        }
    }
}
@end
NS_ASSUME_NONNULL_END
