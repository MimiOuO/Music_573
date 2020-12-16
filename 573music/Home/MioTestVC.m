//
//  MioTestVC.m
//  573music
//
//  Created by Mimio on 2020/11/20.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioTestVC.h"
#import "CocoaDownloader.h"
@interface MioTestVC ()<DownloadTaskDelegate>
@property (nonatomic, strong) DownloadManager *downloadManger;
@property (nonatomic, strong) DownloadInfo *downloadInfo;
@end

@implementation MioTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.navView.leftButton setImage:backArrowIcon forState:UIControlStateNormal];
//    [self.navView.centerButton setTitle:@"测试" forState:UIControlStateNormal];
    
    self.downloadManger = [DownloadManager sharedInstance];
    
    //save path
    NSString *documentPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path=[documentPath stringByAppendingPathComponent:@"Skin/bai.zip"];

    NSLog(@"ixuea download save path:%@",path);

    //Create download info.
    self.downloadInfo=[[DownloadInfo alloc] init];
//    self.downloadInfo

    //Set download save path.
    [self.downloadInfo setPath:path];

    //Set download url.
    [self.downloadInfo setUri:@"http://file.duoduo.apphw.com/test/bai.zip"];

    //Set download info id.
    [self.downloadInfo setId:@"8"];

    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];

    NSTimeInterval currentTimeMillis=[date timeIntervalSince1970];

    //Set download create time.
    [self.downloadInfo setCreatedAt:currentTimeMillis];

    //Set download callcabk.
    [self.downloadInfo setDownloadBlock:^(DownloadInfo * _Nonnull downloadInfo) {
        //TODO Progress, status changes are callbacks.
    }];

    //Start download.
    [self.downloadManger download:self.downloadInfo];
    
    [self.downloadInfo setDownloadBlock:^(DownloadInfo * _Nonnull downloadInfo) {
        NSLog(@"___%ld",downloadInfo.progress);
        NSLog(@"___%ld",downloadInfo.size);
        NSLog(@"___%@",downloadInfo.path);
        if (downloadInfo.path.length > 0) {
            
        }
    }];
    
    
}


@end
