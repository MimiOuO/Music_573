//
//  MioMainPlayerVC.m
//  573music
//
//  Created by Mimio on 2020/12/1.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioMainPlayerVC.h"
#import "NSObject+XWAdd.h"
#import "GKSliderView.h"
#import "MioPlayListVC.h"
#import "MioLrcView.h"
#import "LyricParser.h"
#import "MusicLyric.h"
#import "UIButton+MioExtension.h"
#import "MioSongListVC.h"
#import "MioMusicCmtVC.h"

@interface MioMainPlayerVC ()<MioPlayerDelegate,UITableViewDelegate,UITableViewDataSource,GKSliderViewDelegate,LyricViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) MioLrcView *lrcView;
//当前歌词索引
@property(assign,nonatomic) NSInteger currentLyricIndex;

@property (nonatomic, strong) UIImageView *backgroundImg;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *singerLab;
@property (nonatomic, strong) UIButton *qualityBtn;
@property (nonatomic, strong) UIButton *mvButton;
@property (nonatomic, strong) UIImageView *coverImg;

@property (nonatomic, strong) UILabel *singleLrcLab;
@property (nonatomic, strong) GKSliderView *slider;

@property (nonatomic, strong) UILabel *currentTimeLab;
@property (nonatomic, strong) UILabel *durationLab;

@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UIImageView *bufferImg;
@property (nonatomic, strong) UIButton *preBtn;
@property (nonatomic, strong) UIButton *nextBtn;
@property (nonatomic, strong) UIButton *playListBtn;
@property (nonatomic, strong) UIButton *playOrderBtn;

@property (nonatomic, strong) UIButton *likeBtn;
@property (nonatomic, strong) UIButton *downloadBtn;
@property (nonatomic, strong) UIButton *cmtBtn;
@property (nonatomic, strong) UILabel *cmtCountLab;
@property (nonatomic, strong) UIButton *moreBtn;

@property (nonatomic, assign) BOOL isDraging;

@end

@implementation MioMainPlayerVC

- (void)viewDidLoad {
    [super viewDidLoad];

    
    
    [self creatUI];
    [self registKVO];
    
    mioPlayer.delegate = self;

    RecieveNotice(switchMusic, changeMusic);

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    statusBarLight;
}

#pragma mark - UI

-(void)creatUI{
    WEAKSELF;
    
    _backgroundImg = [UIImageView creatImgView:frame(-KSW/2, -KSH/2, 2*KSW, 2*KSH) inView:self.view image:@"WX20201210-181259" radius:0];

    UIVisualEffectView *effect = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    effect.frame = frame(KSW/2, KSH/2, KSW, KSH);
    effect.alpha = 1;
    [_backgroundImg addSubview:effect];
    UIVisualEffectView *effect2 = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    effect2.frame = frame(KSW/2, KSH/2, KSW, KSH);
    effect2.alpha = 0.5;
    [_backgroundImg addSubview:effect2];

    
    [self.navView.leftButton setImage:image(@"right_player") forState:UIControlStateNormal];
    self.navView.leftButton.left = 13;
    self.navView.mainView.backgroundColor = appClearColor;
    self.navView.bgImg.image = [UIImage imageNamed:@""];
    
    self.navView.leftButtonBlock = ^{
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
    
    _nameLab = [UILabel creatLabel:frame(60, StatusH + 10, KSW - 120, 25) inView:self.view text:@"光年之外" color:appWhiteColor boldSize:18 alignment:NSTextAlignmentCenter];
    _nameLab.alpha = 0.5;
    _singerLab = [UILabel creatLabel:frame(60, StatusH + 35, KSW - 120, 17) inView:self.view text:@"光年之外" color:rgba(255, 255, 255, 0.7) boldSize:12 alignment:NSTextAlignmentCenter];
    _qualityBtn = [UIButton creatBtn:frame(KSW2 - 26 - 7, StatusH + 62, 26, 14) inView:self.view bgImage:@"standard_player_player" action:^{
        
    }];
    _mvButton = [UIButton creatBtn:frame(KSW2 + 7, StatusH + 62, 26, 14) inView:self.view bgImage:@"mv_player_player" action:^{
        
    }];

    _scrollView = [UIScrollView creatScroll:frame(0, StatusH + 86, KSW, 5 + KSW-56 + (KSH - StatusH - 91 - (KSW - 56) - SafeBotH)/2) inView:self.view contentSize:CGSizeMake(KSW*2, KSH - NavH - 50 - 300)];
    _scrollView.bounces = NO;
    _scrollView.pagingEnabled = YES;
    UIImageView *coverShadow = [UIImageView creatImgView:frame(0, -8, KSW, 400*KSW/375) inView:_scrollView image:@"shadow" radius:0];
    _coverImg = [UIImageView creatImgView:frame(28, 5, KSW - 56, KSW - 56) inView:_scrollView image:@"2041607506147_.pic_hd" radius:12];
    
    float divHeight = (_scrollView.height - 5 - (KSW - 56))/10;
    
    _singleLrcLab = [UILabel creatLabel:frame(28, 0, KSW - 56, 22) inView:_scrollView text:@"如果世间万物能相爱" color:appWhiteColor size:16 alignment:NSTextAlignmentCenter];
    _singleLrcLab.centerY = 5 + (KSW - 56) + divHeight*3;

    _slider = [[GKSliderView alloc] initWithFrame:frame(28, 5 + (KSW - 56) + divHeight * 6 - 4.5, KSW - 56, 20)];
    [_slider setBackgroundImage:[UIImage imageNamed:@"progress_point_player"] forState:UIControlStateNormal];
//    [_slider setThumbImage:[UIImage imageNamed:@"cm2_fm_playbar_btn_dot"] forState:UIControlStateNormal];
    _slider.maximumTrackImage = [UIImage imageNamed:@"progress_bg_player"];
    _slider.minimumTrackImage = [UIImage imageNamed:@"progress_play_player"];
    _slider.bufferTrackImage  = [UIImage imageNamed:@"progress_loading_player"];
    _slider.delegate = self;
    _slider.sliderHeight = 3;
    self.isDraging = NO;
    [_scrollView addSubview:_slider];
    
    _currentTimeLab = [UILabel creatLabel:frame(28, 5 + (KSW - 56) + divHeight * 6 + 12, 50, 17) inView:_scrollView text:@"00:00" color:rgba(255, 255, 255, 0.7) boldSize:14 alignment:NSTextAlignmentLeft];
    _durationLab = [UILabel creatLabel:frame(KSW - 28 - 50, 5 + (KSW - 56) + divHeight * 6 + 12, 50, 17) inView:_scrollView text:@"00:00" color:rgba(255, 255, 255, 0.7) boldSize:14 alignment:NSTextAlignmentRight];
 
    _lrcView = [[MioLrcView alloc] initWithFrame:CGRectMake(KSW + 28 , 0, KSW - 56, _scrollView.height)];
    _lrcView.delegate = self;
    [_scrollView addSubview:_lrcView];
    
    
    _playOrderBtn = [UIButton creatBtn:frame(28, 0, 24, 24) inView:self.view bgImage:@"" action:^{
        [weakSelf switchPlayOrder];
    }];
    if (Equals(currentPlayOrder, MioPlayOrderCycle)) {
        [_playOrderBtn setBackgroundImage:image(@"cycle_player") forState:UIControlStateNormal];
    }
    if (Equals(currentPlayOrder, MioPlayOrderSingle)) {
        [_playOrderBtn setBackgroundImage:image(@"single_player") forState:UIControlStateNormal];
    }
    if (Equals(currentPlayOrder, MioPlayOrderRandom)) {
        [_playOrderBtn setBackgroundImage:image(@"random_player") forState:UIControlStateNormal];
    }

    
    _preBtn = [UIButton creatBtn:frame(28 + (KSW2 - 28 - 30)/2, 0, 30, 30) inView:self.view bgImage:@"forward_player" action:^{
        [weakSelf preBtnClick];
    }];

    
    _playBtn = [UIButton creatBtn:frame(KSW2 - 30, 0, 60, 60) inView:self.view bgImage:@"play_player" action:^{
        [weakSelf playClick];
    }];
    
    _bufferImg = [UIImageView creatImgView:frame(KSW2 - 30, 0, 60, 60) inView:self.view  image:@"loading_player" radius:0];
    _bufferImg.hidden = YES;
    
    _nextBtn = [UIButton creatBtn:frame(KSW2 + (KSW2 - 28 - 30)/2, 0, 30, 30) inView:self.view bgImage:@"back_player" action:^{
        [weakSelf nextBtnClick];
    }];
    
    _playListBtn = [UIButton creatBtn:frame(KSW - 28  - 24, 0, 24, 24) inView:self.view bgImage:@"list_player" action:^{
        [weakSelf playListClick];
    }];

    _playOrderBtn.centerY = _scrollView.bottom + divHeight*2;
    _preBtn.centerY = _scrollView.bottom + divHeight*2;
    _playBtn.centerY = _scrollView.bottom + divHeight*2;
    _bufferImg.centerY = _scrollView.bottom + divHeight*2;
    _nextBtn.centerY = _scrollView.bottom + divHeight*2;
    _playListBtn.centerY = _scrollView.bottom + divHeight*2;

    
    _likeBtn = [UIButton creatBtn:frame(28, _scrollView.bottom + divHeight*6 + 12, 24, 24) inView:self.view bgImage:@"like_ordinary_player" action:^{
        
    }];
    _downloadBtn = [UIButton creatBtn:frame(28 + (KSW - 56)/3 - 12, _scrollView.bottom + divHeight*6 + 12, 24, 24) inView:self.view bgImage:@"download_player" action:^{
        
    }];
    _cmtBtn = [UIButton creatBtn:frame(28 + (KSW - 56)*2/3 - 12, _scrollView.bottom + divHeight*6 + 12, 24, 24) inView:self.view bgImage:@"group_digital_player" action:^{
        MioMusicCmtVC *vc = [[MioMusicCmtVC alloc] init];
        vc.musicId = @"1";
        [self.navigationController pushViewController:vc animated:YES];
    }];
    _moreBtn = [UIButton creatBtn:frame(KSW - 24 -28, _scrollView.bottom + divHeight*6 + 12, 24, 24) inView:self.view bgImage:@"group_genduo" action:^{
        
        goLogin
        
//        MioSongListVC *vc = [[MioSongListVC alloc] init];
//        vc.view.height = KSH;
//        [self.navigationController pushViewController:vc animated:YES];
        
//        MioNavVC *nav = [[MioNavVC alloc] initWithRootViewController:vc];
//        nav.modalPresentationStyle = 0;
//        [self presentViewController:nav animated:YES completion:nil];
    }];
    _cmtCountLab = [UILabel creatLabel:frame(16.5, -5, 30, 17) inView:_cmtBtn text:@"0" color:appWhiteColor size:12 alignment:NSTextAlignmentLeft];

}

-(void)updateUI{
    
}

#pragma mark - KVO
-(void)registKVO{
    WEAKSELF;
    [mioPlayer xw_addObserverBlockForKeyPath:@"status" block:^(id  _Nonnull obj, id  _Nonnull oldVal, id  _Nonnull newVal) {
        [weakSelf playerStatusChanged];
    }];
    

    
    [mioPlayer xw_addObserverBlockForKeyPath:@"currentMusicDuration" block:^(id  _Nonnull obj, id  _Nonnull oldVal, id  _Nonnull newVal) {
        weakSelf.durationLab.text = [NSDate stringDuartion:mioPlayer.currentMusicDuration];
    }];
    
    [mioPlayer xw_addObserverBlockForKeyPath:@"bufferProgress" block:^(id  _Nonnull obj, id  _Nonnull oldVal, id  _Nonnull newVal) {
        NSLog(@"___!!!%f",mioPlayer.bufferProgress);
        _slider.bufferValue = mioPlayer.bufferProgress;
        [self.slider layoutIfNeeded];
    }];
    
    [mioPlayer xw_addObserverBlockForKeyPath:@"currentTime" block:^(id  _Nonnull obj, id  _Nonnull oldVal, id  _Nonnull newVal) {
        NSLog(@"___%f",mioPlayer.currentTime / mioPlayer.currentMusicDuration);
        if (isnan(mioPlayer.currentTime / mioPlayer.currentMusicDuration)) {
            NSLog(@"nananannanananan");
        }else{
            [_lrcView updateLrc];
            if (!self.isDraging) {
                _currentTimeLab.text = [NSDate stringDuartion:mioPlayer.currentTime];
                _slider.value = mioPlayer.currentTime / mioPlayer.currentMusicDuration;
                [self.slider layoutIfNeeded];
            }
        }

    }];
}

-(void)changeMusic{
    [self downLoadLrc];
    _currentLyricIndex = 0;
}

-(void)downLoadLrc{

//    MioDownloadRequest *req = [[MioDownloadRequest alloc] initWinthUrl:mioPlayer.currentMusic.lrc_url fileName:[NSString stringWithFormat:@"%@.lrc",mioPlayer.currentMusic.id]];
//    [req startWithCompletionBlockWithSuccess:^(__kindof MioDownloadRequest * _Nonnull request) {
//        NSLog(@"%s res:%@", __func__, request.lrcName);
//        if ([request.lrcName containsString:mioPlayer.currentMusic.id]) {
//            NSArray *lyrics = [LyricParser parserLyricWithFileName:[NSString stringWithFormat:@"%@/%@.lrc",LRCDownloadDir,mioPlayer.currentMusic.id]];
//            _lrcView.lyrics = lyrics;
//        }
//    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
//
//    }];

}


-(void)playerStatusChanged{
    switch (mioPlayer.status) {
        case DOUAudioStreamerPlaying:
            NSLog(@"播放中");
            [_playBtn setBackgroundImage:image(@"suspended_player") forState:UIControlStateNormal];
            _bufferImg.hidden = YES;
            break;

        case DOUAudioStreamerPaused:
            NSLog(@"暂停");
            [_playBtn setBackgroundImage:image(@"play_player") forState:UIControlStateNormal];
            _bufferImg.hidden = YES;
            break;

        case DOUAudioStreamerIdle:
            NSLog(@"空闲");
            break;

        case DOUAudioStreamerFinished:
            NSLog(@"结束");
            [_playBtn setBackgroundImage:image(@"play_player") forState:UIControlStateNormal];
            _bufferImg.hidden = YES;
            break;

        case DOUAudioStreamerBuffering:
            NSLog(@"缓冲中");
            _bufferImg.hidden = NO;
            break;

        case DOUAudioStreamerError:
            NSLog(@"错误");
            _bufferImg.hidden = YES;
            break;
    }
}

-(void)switchPlayOrder{
    if (Equals(currentPlayOrder, MioPlayOrderCycle)) {
        setPlayOrder(MioPlayOrderSingle);
        [userdefault synchronize];
        [_playOrderBtn setBackgroundImage:image(@"single_player") forState:UIControlStateNormal];
        return;
    }
    if (Equals(currentPlayOrder, MioPlayOrderSingle)) {
        setPlayOrder(MioPlayOrderRandom);
        [userdefault synchronize];
        [_playOrderBtn setBackgroundImage:image(@"random_player") forState:UIControlStateNormal];
        return;
    }
    if (Equals(currentPlayOrder, MioPlayOrderRandom)) {
        setPlayOrder(MioPlayOrderCycle);
        [userdefault synchronize];
        [_playOrderBtn setBackgroundImage:image(@"cycle_player") forState:UIControlStateNormal];
        return;
    }
}

-(void)preBtnClick{
    [mioPlayer playPre];
}

-(void)nextBtnClick{
    [mioPlayer playNext];
}

-(void)playClick{
    if (mioPlayer.status == DOUAudioStreamerPlaying) {
        [mioPlayer pause];
    }else{
        [mioPlayer play];
    }
}



-(void)playListClick{
    
    MioPlayListVC * vc = [[MioPlayListVC alloc]init];
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - slider代理
- (void)sliderTouchBegin:(float)value{//拖拽开始
    self.isDraging = YES;
}

- (void)sliderValueChanged:(float)value{//正在拖拽，改变当前时间
    
    
}
- (void)sliderTouchEnded:(float)value{//拖拽结束
    self.isDraging = NO;
    NSInteger seekTime = (int)(mioPlayer.currentMusicDuration * value);
    [mioPlayer seekToTime:seekTime];
}
- (void)sliderTapped:(float)value{//点击进度条
    NSInteger seekTime = (int)(mioPlayer.currentMusicDuration * value);
    [mioPlayer seekToTime:seekTime];
}

- (void)lyricView:(MioLrcView *)lyricView withProgress:(CGFloat)progress{
    NSLog(@"%f",progress);
}



@end
