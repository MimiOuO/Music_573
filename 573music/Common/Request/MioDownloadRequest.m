//
//  MioDownloadRequest.m
//  573music
//
//  Created by Mimio on 2020/12/8.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioDownloadRequest.h"


@implementation MioDownloadRequest{

}
- (instancetype)initWinthUrl:(NSString *)url fileName:(NSString *)name{
    if (self = [super init]) {
        _url = url;
        _lrcName = name;
        NSString *libPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        _cachePath = [libPath stringByAppendingPathComponent:@"lrcDownload"];
        
        NSError *error;
        NSFileManager *m = [NSFileManager defaultManager];
        BOOL suc = [m createDirectoryAtPath:_cachePath withIntermediateDirectories:YES attributes:nil error:&error];
        NSLog(@"创建缓存文件夹成功了吗：%@ 沙盒路径：%@", @(suc), _cachePath);
    }
    return self;
}

- (NSString *)requestUrl {
    return _url;
}
- (NSString *)resumableDownloadPath {

    NSString *filePath = [_cachePath stringByAppendingPathComponent:_lrcName];
    return filePath;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

@end
