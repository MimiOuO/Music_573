//
//  MioHomeVC.m
//  ifixMerchat
//
//  Created by Mimio on 2020/4/10.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioHomeVC.h"
#import "MioFeedBackVC.h"
#import "MioTestVC.h"
#import "MioTest2VC.h"
#import "MioLabel.h"
#import "KVAudioStreamer.h"
#import "KVAudioPlayerController.h"
@interface MioHomeVC ()<KVAudioStreamerDelegate>
@property (nonatomic, strong) KVAudioStreamer *streamer;
@end

@implementation MioHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = appWhiteColor;
    
    UIButton *sdfsd = [UIButton creatBtn:frame(100, 100, 100, 100) inView:self.view bgColor:mainColor title:@"111" titleColor:appWhiteColor font:14 radius:5 action:^{
        if (Equals([userdefault objectForKey:@"skin"], @"bai") ) {
            [userdefault setObject:@"hei" forKey:@"skin"];
        }else{
            [userdefault setObject:@"bai" forKey:@"skin"];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeSkin" object:nil];
//        MioFeedBackVC *vc = [[MioFeedBackVC alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
    }];
    UIButton *sdfsdws = [UIButton creatBtn:frame(100, 220, 100, 100) inView:self.view bgColor:mainColor title:@"111" titleColor:appWhiteColor font:14 radius:5 action:^{
//        [mioPlayer resetAudioURL:@"http://kevinfile.oss-cn-shenzhen.aliyuncs.com/%E9%99%88%E5%A5%95%E8%BF%85%20-%20%E6%97%A0%E4%BA%BA%E4%B9%8B%E5%A2%83.mp3"];
        [mioPlayer play];
        return;
        MioTestVC *vc = [[MioTestVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    UIButton *sdfsdw21s = [UIButton creatBtn:frame(100, 340, 100, 100) inView:self.view bgColor:mainColor title:@"222" titleColor:appWhiteColor font:14 radius:5 action:^{
        [mioPlayer pause];
        return;
        MioTest2VC *vc = [[MioTest2VC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
//    UIImageView *avatar = [UIImageView creatImginView:self.view image:@"avatar_bai" radius:0];
    UIImageView *avatar = [UIImageView creatImgView:frame(100, 460, 100, 100) inView:self.view image:@"" radius:5];
    
    NSString *path = [NSString stringWithFormat:@"%@/Skin/bai/icon_bai.jpg",
                     NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]];
    avatar.image = [UIImage imageWithContentsOfFile:path];
//    UIImage *_image = [UIImage imageWithContentsOfFile:fullPathToFile];
    
    
    MioLabel *testlab = [[MioLabel alloc] init];
    testlab.frame = frame( 0, 580, KSW, 23);
    testlab.text = @"sdlfskjfsldjf234dsfsdfsf";
    testlab.textColor = subColor;
    [self.view addSubview:testlab];
    
    
    
    [MioGetCacheReq(@"https://test.aw998.com/api/dance/all_listen_dance", @{@"token":@"8bafb112da1c444cba40578884196350"}) success:^(NSDictionary *result){
        NSArray *data = [result objectForKey:@"list"];
        NSMutableArray *musicArr = [[NSMutableArray alloc] init];
        for (int i = 0;i < data.count; i++) {
            [musicArr addObject:[MioMusicModel mj_objectWithKeyValues:data[i]]];
            [musicArr addObject:[MioMusicModel mj_objectWithKeyValues:data[i]]];
        }
        [mioPlayer playWithMusicList:musicArr andIndex:0];
        NSLog(@"cacheYES__%@",data);
    } failure:^(NSString *errorInfo) {
        NSLog(@"%@",errorInfo);
    }];
    
    NSArray *arr = @[@"111",@"111",@"111",@"111"];
    [mioPlayList updatePlayList:arr];
    
    
//    self.streamer = [[KVAudioStreamer alloc] init];
//    self.streamer.delegate = self;
//    self.streamer.cacheEnable = YES;    //开启缓存功能
//    [self.streamer resetAudioURL:@"http://kevinfile.oss-cn-shenzhen.aliyuncs.com/%E9%99%88%E5%A5%95%E8%BF%85%20-%20%E6%97%A0%E4%BA%BA%E4%B9%8B%E5%A2%83.mp3"];
//    self.streamer.httpHeaders = @{@"Referer" : @"kevinrefer"};
//    [self.streamer play];
    
}
//- (BOOL)audioStreamer:(KVAudioStreamer *)streamer cacheCompleteWithRelativePath:(NSString *)relativePath cachepath:(NSString *)cachepath {
//    NSLog(@"缓存文件成功%@", cachepath);
//    return YES;
//}


@end
