//
//  KVAudioPlayerController.m
//  KVAudioStreamer
//
//  Created by kevin on 2018/2/27.
//  Copyright © 2018年 kv. All rights reserved.
//

#import "KVAudioPlayerController.h"
#import "KVAudioStreamer.h"
#import "Masonry.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "AppDelegate.h"

@interface KVAudioPlayerController () <KVAudioStreamerDelegate>

@property (nonatomic, strong) KVAudioStreamer * streamer;
@property (nonatomic, strong) UIButton * playBtn;
@property (nonatomic, strong) UIButton * preBtn;
@property (nonatomic, strong) UIButton * nextBtn;
@property (nonatomic, strong) UIView * indiBackView;
@property (nonatomic, strong) UISlider * slider;
@property (nonatomic, strong) UISlider * volumeSlider;
@property (nonatomic, assign) BOOL sliderDown;
@property (nonatomic, assign) BOOL volumeSliderDown;

@property (nonatomic, strong) NSDictionary * currentInfo;
@property (nonatomic, strong) NSMutableArray * preArr;
@property (nonatomic, strong) NSMutableArray * nextArr;

@end

@implementation KVAudioPlayerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    UIButton * playRateBtn = [UIButton new];
    [playRateBtn setTitle:@"播放速率" forState:UIControlStateNormal];
    [playRateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    playRateBtn.layer.borderColor = [UIColor blackColor].CGColor;
    playRateBtn.layer.borderWidth = 1;
    playRateBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [playRateBtn addTarget:self action:@selector(playRate) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playRateBtn];
    [playRateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 40));
        make.top.equalTo(self.view).offset(30 + 64);
        make.right.equalTo(self.view).offset(-15);
    }];
    
    UILabel * label = [UILabel new];
    label.text = @"音量";
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor blackColor];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.equalTo(playRateBtn);
    }];
    UISlider * volumeSlider = [UISlider new];
    volumeSlider.maximumValue = 1.0;
    [volumeSlider addTarget:self action:@selector(volumeChange:) forControlEvents:UIControlEventValueChanged];
    [volumeSlider addTarget:self action:@selector(volumeTouchup) forControlEvents:UIControlEventTouchUpInside];
    [volumeSlider addTarget:self action:@selector(volumeTouchup) forControlEvents:UIControlEventTouchUpOutside];
    [volumeSlider addTarget:self action:@selector(volumeTouchdown) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:volumeSlider];
    [volumeSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.left.equalTo(label.mas_right).offset(15);
        make.right.equalTo(playRateBtn.mas_left).offset(-15);
        make.centerY.equalTo(playRateBtn);
    }];
    self.volumeSlider = volumeSlider;
    
    UIButton * playBtn = [UIButton new];
    [playBtn setTitle:@"播放" forState:UIControlStateNormal];
    [playBtn setTitle:@"暂停" forState:UIControlStateSelected];
    [playBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    playBtn.layer.borderColor = [UIColor blackColor].CGColor;
    playBtn.layer.borderWidth = 1;
    playBtn.layer.cornerRadius = 40;
    playBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [playBtn addTarget:self action:@selector(playBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playBtn];
    [playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 80));
        make.center.equalTo(self.view);
    }];
    self.playBtn = playBtn;
    
    self.indiBackView = [UIView new];
    self.indiBackView.backgroundColor = [UIColor orangeColor];
    self.indiBackView.layer.cornerRadius = 40;
    self.indiBackView.layer.borderColor = [UIColor blackColor].CGColor;
    self.indiBackView.layer.borderWidth = 1;
    [playBtn addSubview:self.indiBackView];
    [self.indiBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 80));
        make.center.equalTo(playBtn);
    }];
    self.indiBackView.hidden = YES;
    UIActivityIndicatorView * indiView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [indiView startAnimating];
    [self.indiBackView addSubview:indiView];
    [indiView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.indiBackView);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    UIButton * stopBtn = [UIButton new];
    [stopBtn setTitle:@"停止" forState:UIControlStateNormal];
    [stopBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    stopBtn.layer.borderColor = [UIColor blackColor].CGColor;
    stopBtn.layer.borderWidth = 1;
    stopBtn.layer.cornerRadius = 30;
    stopBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [stopBtn addTarget:self action:@selector(stop) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stopBtn];
    [stopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.top.equalTo(playBtn.mas_bottom).offset(20);
        make.centerX.equalTo(playBtn);
    }];
    
    self.slider = [UISlider new];
    self.slider.enabled = NO;   //先置为NO，如果已经提前知道了音频的时长，那么可以直接设置maximumValue，就不需要禁止了
    //self.slider.maximumValue = 100;
    [self.slider addTarget:self action:@selector(touchup:) forControlEvents:UIControlEventTouchUpInside];
    [self.slider addTarget:self action:@selector(touchup:) forControlEvents:UIControlEventTouchUpOutside];
    [self.slider addTarget:self action:@selector(touchdown:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:self.slider];
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-15);
        make.left.mas_equalTo(30);
        make.right.equalTo(self.view).offset(-30);
        make.height.mas_equalTo(30);
    }];
    
    self.streamer = [[KVAudioStreamer alloc] init];
    self.streamer.delegate = self;
    self.streamer.cacheEnable = YES;    //开启缓存功能
    //设置httpheader，音乐资源在阿里云OSS开启了防盗链，需要在这里设置referer，如果没有防盗链，那么不需要设置
    self.streamer.httpHeaders = @{@"Referer" : @"kevinrefer"};
    
//        [self.streamer resetAudioURL:@"http://kevinfile.oss-cn-shenzhen.aliyuncs.com/%E9%99%88%E5%A5%95%E8%BF%85%20-%20%E6%97%A0%E4%BA%BA%E4%B9%8B%E5%A2%83.mp3"];
    
    [self.streamer resetAudioURL:@"https://mp3.aw998.com/%E6%9D%8E%E5%85%8B%E5%8B%A4/%E6%97%A7%E6%AC%A2%E5%A6%82%E6%A2%A6.flac"];
    
    //放开下面的注释，调整音频时不会出现系统音频提醒视图
//    [self.streamer setVolumeSuperView:self.view];
    
    if (self.filepaths) {
        //播放列表设置
        [self.nextArr addObjectsFromArray:self.filepaths];
        NSDictionary * info = self.filepaths.firstObject;
        self.title = info[@"name"];
        [self.streamer resetAudioURL:@"http://kevinfile.oss-cn-shenzhen.aliyuncs.com/%E9%99%88%E5%A5%95%E8%BF%85%20-%20%E6%97%A0%E4%BA%BA%E4%B9%8B%E5%A2%83.mp3"];
        self.currentInfo = info;
        [self.nextArr removeObject:info];
        
        UIButton * preBtn = [UIButton new];
        preBtn.enabled = NO;
        [preBtn setTitle:@"上一首" forState:UIControlStateNormal];
        [preBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [preBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        preBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [preBtn addTarget:self action:@selector(preBtnClick) forControlEvents:UIControlEventTouchUpInside];
        preBtn.layer.borderColor = [UIColor blackColor].CGColor;
        preBtn.layer.borderWidth = 1;
        [self.view addSubview:preBtn];
        [preBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(80, 40));
            make.centerY.equalTo(playBtn);
            make.right.equalTo(playBtn.mas_left).offset(-10);
        }];
        self.preBtn = preBtn;
        
        UIButton * nextBtn = [UIButton new];
        [nextBtn setTitle:@"下一首" forState:UIControlStateNormal];
        [nextBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [nextBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        nextBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
        nextBtn.layer.borderColor = [UIColor blackColor].CGColor;
        nextBtn.layer.borderWidth = 1;
        [self.view addSubview:nextBtn];
        [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(80, 40));
            make.centerY.equalTo(playBtn);
            make.left.equalTo(playBtn.mas_right).offset(10);
        }];
        self.nextBtn = nextBtn;
    }
    
    volumeSlider.value = self.streamer.volume;
    //监听音量变化
    [[AVAudioSession sharedInstance] addObserver:self forKeyPath:@"outputVolume" options:NSKeyValueObservingOptionNew context:nil];
    
    //开启锁屏控制监听
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    //设置锁屏控制通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(remotePlay) name:kNotifyRemoteControlPlay object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(remotePause) name:kNotifyRemoteControlPause object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(remotePre) name:kNotifyRemoteControlPrevious object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(remoteNext) name:kNotifyRemoteControlNext object:nil];
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    //设置成后台播放，还需要在项目设置Capabilities的Backgroud Modes里面勾选Audio,AirPlay...选项
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    //不知道什么原因，如果不首先设置一下锁屏封面，第一次播放的时候，设置锁屏封面无效
    [self pausePlaybackInfoWithTitle:self.title arttist:@"未知歌手" image:[UIImage imageNamed:@"chenyixun"] duration:0 currentDuration:0];
}

- (void)touchdown:(UISlider*)slider {
    self.sliderDown = YES;
}

- (void)touchup:(UISlider*)slider {
    self.sliderDown = NO;
    [self.streamer seekToTime:slider.value];
}

- (void)volumeTouchup {
    self.volumeSliderDown = NO;
}

- (void)volumeTouchdown {
    self.volumeSliderDown = YES;
}

- (void)volumeChange:(UISlider*)slider {
    self.streamer.volume = slider.value;
}

- (void)playRate {
    UIAlertController * ac = [UIAlertController alertControllerWithTitle:@"播放速率" message:@"修改播放速率" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"0.5" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.streamer.playRate = 0.5;
        //需要更新一下锁屏封面
        if (self.streamer.currentAudioFile.duration) {
            [self updatePlaybackInfoWithTitle:self.title arttist:@"未知歌手" image:[UIImage imageNamed:@"chenyixun"] duration:self.streamer.currentAudioFile.duration currentDuration:self.streamer.currentAudioFile.currentPlayDuration playRate:self.streamer.playRate];
        }else {
            [self updatePlaybackInfoWithTitle:self.title arttist:@"未知歌手" image:[UIImage imageNamed:@"chenyixun"] duration:self.streamer.currentAudioFile.estimateDuration currentDuration:self.streamer.currentAudioFile.currentPlayDuration playRate:self.streamer.playRate];
        }
    }];
    [ac addAction:action];
    UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"1.0" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.streamer.playRate = 1.0;
        if (self.streamer.currentAudioFile.duration) {
            [self updatePlaybackInfoWithTitle:self.title arttist:@"未知歌手" image:[UIImage imageNamed:@"chenyixun"] duration:self.streamer.currentAudioFile.duration currentDuration:self.streamer.currentAudioFile.currentPlayDuration playRate:self.streamer.playRate];
        }else {
            [self updatePlaybackInfoWithTitle:self.title arttist:@"未知歌手" image:[UIImage imageNamed:@"chenyixun"] duration:self.streamer.currentAudioFile.estimateDuration currentDuration:self.streamer.currentAudioFile.currentPlayDuration playRate:self.streamer.playRate];
        }
    }];
    [ac addAction:action1];
    UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"1.5" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.streamer.playRate = 1.5;
        if (self.streamer.currentAudioFile.duration) {
            [self updatePlaybackInfoWithTitle:self.title arttist:@"未知歌手" image:[UIImage imageNamed:@"chenyixun"] duration:self.streamer.currentAudioFile.duration currentDuration:self.streamer.currentAudioFile.currentPlayDuration playRate:self.streamer.playRate];
        }else {
            [self updatePlaybackInfoWithTitle:self.title arttist:@"未知歌手" image:[UIImage imageNamed:@"chenyixun"] duration:self.streamer.currentAudioFile.estimateDuration currentDuration:self.streamer.currentAudioFile.currentPlayDuration playRate:self.streamer.playRate];
        }
    }];
    [ac addAction:action2];
    UIAlertAction * action3 = [UIAlertAction actionWithTitle:@"2.0" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.streamer.playRate = 2.0;
        if (self.streamer.currentAudioFile.duration) {
            [self updatePlaybackInfoWithTitle:self.title arttist:@"未知歌手" image:[UIImage imageNamed:@"chenyixun"] duration:self.streamer.currentAudioFile.duration currentDuration:self.streamer.currentAudioFile.currentPlayDuration playRate:self.streamer.playRate];
        }else {
            [self updatePlaybackInfoWithTitle:self.title arttist:@"未知歌手" image:[UIImage imageNamed:@"chenyixun"] duration:self.streamer.currentAudioFile.estimateDuration currentDuration:self.streamer.currentAudioFile.currentPlayDuration playRate:self.streamer.playRate];
        }
    }];
    [ac addAction:action3];
    UIAlertAction * action_cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [ac addAction:action_cancle];
    [self presentViewController:ac animated:YES completion:nil];
}

- (void)playBtn:(UIButton*)btn {
    if (btn.selected) {
        [self.streamer pause];
    }else {
        [self.streamer play];
//        [self.streamer playAtTime:60];   //定点播放
    }
}

- (void)stop {
    [self.streamer stop];
    [self canclePlaybackInfo];
}

- (void)preBtnClick {
    if (self.preArr.count > 0) {
        [self.nextArr insertObject:self.currentInfo atIndex:0];
        NSDictionary * info = self.preArr.lastObject;
        [self.streamer resetAudioURL:info[@"path"]];
        self.title = info[@"name"];
        self.currentInfo = info;
        [self.preArr removeObject:info];
        self.playBtn.selected = NO;
        [self playBtn:self.playBtn];
        self.nextBtn.enabled = YES;
        if (!self.preArr.count) {
            self.preBtn.enabled = NO;
        }
    }else {
        self.preBtn.enabled = NO;
    }
}

- (void)nextBtnClick {
    if (self.nextArr.count > 0) {
        [self.preArr addObject:self.currentInfo];
        NSDictionary * info = self.nextArr.firstObject;
        [self.streamer resetAudioURL:info[@"path"]];
        self.title = info[@"name"];
        self.currentInfo = info;
        [self.nextArr removeObject:info];
        self.playBtn.selected = NO;
        [self playBtn:self.playBtn];
        self.preBtn.enabled = YES;
        if (!self.nextArr.count) {
            self.nextBtn.enabled = NO;
        }
    }else {
        self.nextBtn.enabled = NO;
    }
}

#pragma mark - 代理
- (void)audioStreamer:(KVAudioStreamer *)streamer playStatusChange:(KVAudioStreamerPlayStatus)status {
    switch (status) {
        case KVAudioStreamerPlayStatusBuffering:
            NSLog(@"缓冲中");
            self.indiBackView.hidden = NO;
            break;
        case KVAudioStreamerPlayStatusStop:
        {
            NSLog(@"播放停止");
            self.indiBackView.hidden = YES;
            self.playBtn.selected = NO;
        }
            break;
        case KVAudioStreamerPlayStatusPause:
        {
            NSLog(@"播放暂停");
            self.indiBackView.hidden = YES;
            self.playBtn.selected = NO;
            if (self.streamer.currentAudioFile.duration) {
                [self pausePlaybackInfoWithTitle:self.title arttist:@"未知歌手" image:[UIImage imageNamed:@"chenyixun"] duration:self.streamer.currentAudioFile.duration currentDuration:self.streamer.currentAudioFile.currentPlayDuration];
            }else {
                [self pausePlaybackInfoWithTitle:self.title arttist:@"未知歌手" image:[UIImage imageNamed:@"chenyixun"] duration:self.streamer.currentAudioFile.estimateDuration currentDuration:self.streamer.currentAudioFile.currentPlayDuration];
            }
        }
            break;
        case KVAudioStreamerPlayStatusFinish:
        {
            NSLog(@"播放结束");
            self.indiBackView.hidden = YES;
            self.playBtn.selected = NO;
            [self nextBtnClick];
        }
            break;
        case KVAudioStreamerPlayStatusPlaying:
        {
            NSLog(@"播放中");
            self.indiBackView.hidden = YES;
            self.playBtn.selected = YES;
            if (self.streamer.currentAudioFile.duration) {
                [self updatePlaybackInfoWithTitle:self.title arttist:@"未知歌手" image:[UIImage imageNamed:@"chenyixun"] duration:self.streamer.currentAudioFile.duration currentDuration:self.streamer.currentAudioFile.currentPlayDuration playRate:self.streamer.playRate];
            }else {
                [self updatePlaybackInfoWithTitle:self.title arttist:@"未知歌手" image:[UIImage imageNamed:@"chenyixun"] duration:self.streamer.currentAudioFile.estimateDuration currentDuration:self.streamer.currentAudioFile.currentPlayDuration playRate:self.streamer.playRate];
            }
        }
            break;
        case KVAudioStreamerPlayStatusIdle:
        {
            NSLog(@"闲置状态");
            self.indiBackView.hidden = YES;
            self.playBtn.selected = NO;
        }
            break;
        default:
            break;
    }
}

- (void)audioStreamer:(KVAudioStreamer *)streamer durationChange:(float)duration {
    self.slider.enabled = YES;
    self.slider.maximumValue = duration;
    if (self.streamer.status == KVAudioStreamerPlayStatusPlaying) {
        [self updatePlaybackInfoWithTitle:self.title arttist:@"未知歌手" image:[UIImage imageNamed:@"chenyixun"] duration:duration currentDuration:self.streamer.currentAudioFile.currentPlayDuration playRate:self.streamer.playRate];
    }
}

- (void)audioStreamer:(KVAudioStreamer *)streamer estimateDurationChange:(float)estimateDuration {
    self.slider.enabled = YES;
    if (!self.sliderDown) {
        self.slider.maximumValue = estimateDuration;
    }
    if (self.streamer.status == KVAudioStreamerPlayStatusPlaying) {
        [self updatePlaybackInfoWithTitle:self.title arttist:@"未知歌手" image:[UIImage imageNamed:@"chenyixun"] duration:estimateDuration currentDuration:self.streamer.currentAudioFile.currentPlayDuration playRate:self.streamer.playRate];
    }
}

- (void)audioStreamer:(KVAudioStreamer *)streamer playAtTime:(long)location {
    if (!self.sliderDown) {
        self.slider.value = location;
    }
}

- (void)audioStreamer:(KVAudioStreamer *)streamer loadNetworkDataInRange:(NSRange)range fileSize:(UInt64)filesize {
    NSLog(@"加载数据%@ 文件大小%lld", NSStringFromRange(range), filesize);
}

- (BOOL)audioStreamer:(KVAudioStreamer *)streamer cacheCompleteWithRelativePath:(NSString *)relativePath cachepath:(NSString *)cachepath {
    NSLog(@"缓存文件成功%@", cachepath);
    return YES;
}

- (void)audioStreamer:(KVAudioStreamer *)streamer didFailWithErrorType:(KVAudioStreamerErrorType)errorType msg:(NSString *)msg error:(NSError *)error {
    NSLog(@"%@", msg);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"outputVolume"] && !self.volumeSliderDown) {
        float outputVolume = [change[@"new"] floatValue];
        self.volumeSlider.value = outputVolume;
    }
}

#pragma mark - 设置锁屏界面
- (void)updatePlaybackInfoWithTitle:(NSString*)title arttist:(NSString*)arttist image:(UIImage*)image duration:(float)duration currentDuration:(float)currentDuration playRate:(double)playRate {
//    MPNowPlayingInfoCenter * playingCenter = [MPNowPlayingInfoCenter defaultCenter];
//    NSMutableDictionary * playinginfo = [NSMutableDictionary dictionary];
//    playinginfo[MPMediaItemPropertyTitle] = title;
//    playinginfo[MPMediaItemPropertyArtist] = arttist;
//    MPMediaItemArtwork * artwork = [[MPMediaItemArtwork alloc] initWithImage:image];
//    playinginfo[MPMediaItemPropertyArtwork] = artwork;
//    playinginfo[MPMediaItemPropertyPlaybackDuration] = @(duration);
//    playinginfo[MPNowPlayingInfoPropertyPlaybackRate] = @(playRate);
//#ifdef __IPHONE_8_0
//    playinginfo[MPNowPlayingInfoPropertyDefaultPlaybackRate] = @1;
//#endif
//    playinginfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = @(currentDuration);
//    playingCenter.nowPlayingInfo = playinginfo;
}

- (void)pausePlaybackInfoWithTitle:(NSString*)title arttist:(NSString*)arttist image:(UIImage*)image duration:(float)duration currentDuration:(float)currentDuration {
//    MPNowPlayingInfoCenter * playingCenter = [MPNowPlayingInfoCenter defaultCenter];
//    NSMutableDictionary * playinginfo = [NSMutableDictionary dictionary];
//    playinginfo[MPMediaItemPropertyTitle] = title;
//    playinginfo[MPMediaItemPropertyArtist] = arttist;
//    MPMediaItemArtwork * artwork = [[MPMediaItemArtwork alloc] initWithImage:image];
//    playinginfo[MPMediaItemPropertyArtwork] = artwork;
//    playinginfo[MPMediaItemPropertyPlaybackDuration] = @(duration);
//    playinginfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = @(currentDuration);
//    playinginfo[MPNowPlayingInfoPropertyPlaybackRate] = @(0);
//#ifdef __IPHONE_8_0
//    playinginfo[MPNowPlayingInfoPropertyDefaultPlaybackRate] = @1;
//#endif
//    playingCenter.nowPlayingInfo = playinginfo;
}

- (void)canclePlaybackInfo {
    MPNowPlayingInfoCenter * playingCenter = [MPNowPlayingInfoCenter defaultCenter];
    playingCenter.nowPlayingInfo = nil;
}

#pragma mark - 锁屏控制
- (void)remotePlay {
    [self playBtn:self.playBtn];
}

- (void)remotePause {
    [self playBtn:self.playBtn];
}

- (void)remotePre {
    [self preBtnClick];
}

- (void)remoteNext {
    [self nextBtnClick];
}

#pragma mark - getter
- (NSMutableArray*)preArr {
    if (!_preArr) {
        _preArr = [NSMutableArray array];
    }
    return _preArr;
}

- (NSMutableArray*)nextArr {
    if (!_nextArr) {
        _nextArr = [NSMutableArray array];
    }
    return _nextArr;
}

- (void)dealloc {
    [[AVAudioSession sharedInstance] removeObserver:self forKeyPath:@"outputVolume"];
    //停止锁屏控制监听
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.streamer releaseStreamer];    //释放流媒体
    self.streamer = nil;
    [self canclePlaybackInfo];
}

@end
