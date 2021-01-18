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
#import "MioMoreFuncView.h"
#import "MioChooseQuantityView.h"

@interface MioMainPlayerVC ()<GKSliderViewDelegate,LyricViewDelegate>

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
    [self downLoadLrc];
    [self registKVO];

    RecieveNotice(switchMusic, changeMusic);
    RecieveNotice(@"clearPlaylist", clearMusic);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    statusBarLight;
}

-(void)changeMusic{
    [self updateUI];
    [self downLoadLrc];
    _currentLyricIndex = 0;
}

-(void)clearMusic{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
        
    });
}

#pragma mark - UI

-(void)creatUI{
    
    
    WEAKSELF;
    MioMusicModel *music = mioM3U8Player.currentMusic;
    _backgroundImg = [UIImageView creatImgView:frame(-KSW/2, -KSH/2, 2*KSW, 2*KSH) inView:self.view image:@"gequ_zhanweitu" radius:0];
    [_backgroundImg sd_setImageWithURL:music.cover_image_path.mj_url placeholderImage:image(@"gequ_zhanweitu")];
    
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
    
    _nameLab = [UILabel creatLabel:frame(60, StatusH + 10, KSW - 120, 25) inView:self.view text:@"" color:appWhiteColor boldSize:18 alignment:NSTextAlignmentCenter];
    _nameLab.alpha = 0.5;
    _nameLab.text = music.title;
    
    _singerLab = [UILabel creatLabel:frame(60, StatusH + 35, KSW - 120, 17) inView:self.view text:@"" color:rgba(255, 255, 255, 0.7) boldSize:12 alignment:NSTextAlignmentCenter];
    _singerLab.text = music.singer_name;
    
    _qualityBtn = [UIButton creatBtn:frame(KSW2 - 26 - 7, StatusH + 62, 26, 14) inView:self.view bgImage:@"standard_player_player" action:^{
        MioChooseQuantityView *chooseView = [[MioChooseQuantityView alloc] init];
        chooseView.model = mioM3U8Player.currentMusic;
        [chooseView show];
    }];
    
    _mvButton = [UIButton creatBtn:frame(KSW2 + 7, StatusH + 62, 26, 14) inView:self.view bgImage:@"mv_player_player" action:^{
        
    }];
    
    if (music.hasMV) {
        _mvButton.hidden = NO;
        _qualityBtn.left = KSW2 - 26 - 7;
    }else{
        _mvButton.hidden = YES;
        _qualityBtn.left = KSW2 - 13;
    }

    _scrollView = [UIScrollView creatScroll:frame(0, StatusH + 86, KSW, 5 + KSW-56 + (KSH - StatusH - 91 - (KSW - 56) - SafeBotH)/2) inView:self.view contentSize:CGSizeMake(KSW*2, KSH - NavH - 50 - 300)];
    _scrollView.bounces = NO;
    _scrollView.pagingEnabled = YES;
    UIImageView *coverShadow = [UIImageView creatImgView:frame(0, -8, KSW, 400*KSW/375) inView:_scrollView image:@"shadow" radius:0];
    _coverImg = [UIImageView creatImgView:frame(28, 5, KSW - 56, KSW - 56) inView:_scrollView image:@"gequ_zhanweitu" radius:12];
    [_coverImg sd_setImageWithURL:music.cover_image_path.mj_url placeholderImage:image(@"gequ_zhanweitu")];
    float divHeight = (_scrollView.height - 5 - (KSW - 56))/10;
    
    _singleLrcLab = [UILabel creatLabel:frame(28, 0, KSW - 56, 22) inView:_scrollView text:@"" color:appWhiteColor size:16 alignment:NSTextAlignmentCenter];
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

    
    _likeBtn = [UIButton creatBtn:frame(73, _scrollView.bottom + divHeight*6 + 12, 24, 24) inView:self.view bgImage:@"like_ordinary_player" action:^{
        
    }];
    [_likeBtn setBackgroundImage:image(@"like_player") forState:UIControlStateSelected];
    if (music.is_like) {
        _likeBtn.selected = YES;
    }else{
        _likeBtn.selected = NO;
    }
//    _downloadBtn = [UIButton creatBtn:frame(28 + (KSW - 56)/3 - 12, _scrollView.bottom + divHeight*6 + 12, 24, 24) inView:self.view bgImage:@"download_player" action:^{
//
//    }];
    _cmtBtn = [UIButton creatBtn:frame(KSW2 - 12, _scrollView.bottom + divHeight*6 + 12, 24, 24) inView:self.view bgImage:@"group_digital_player" action:^{
        MioMusicCmtVC *vc = [[MioMusicCmtVC alloc] init];
        vc.musicId = @"1";
        [self.navigationController pushViewController:vc animated:YES];
    }];
    _moreBtn = [UIButton creatBtn:frame(KSW - 24 - 73, _scrollView.bottom + divHeight*6 + 12, 24, 24) inView:self.view bgImage:@"group_genduo" action:^{

        MioMoreFuncView *view = [[MioMoreFuncView alloc] init];
        view.model = mioM3U8Player.currentMusic;
        view.fatherVC = self;
        view.lrcView = _lrcView;
        [view show];
        
    }];
    _cmtCountLab = [UILabel creatLabel:frame(16.5, -5, 30, 17) inView:_cmtBtn text:music.comment_num color:appWhiteColor size:12 alignment:NSTextAlignmentLeft];

}

-(void)updateUI{
    MioMusicModel *music = mioM3U8Player.currentMusic;
    [_backgroundImg sd_setImageWithURL:music.cover_image_path.mj_url placeholderImage:image(@"gequ_zhanweitu")];
    [_coverImg sd_setImageWithURL:music.cover_image_path.mj_url placeholderImage:image(@"gequ_zhanweitu")];
    _nameLab.text = music.title;
    _singerLab.text = music.singer_name;
    if (music.hasMV) {
        _mvButton.hidden = NO;
        _qualityBtn.left = KSW2 - 26 - 7;
    }else{
        _mvButton.hidden = YES;
        _qualityBtn.left = KSW2 - 13;
    }
    if (music.is_like) {
        _likeBtn.selected = YES;
    }else{
        _likeBtn.selected = NO;
    }
    _cmtCountLab.text = music.comment_num;
    _singleLrcLab.text = @"";
}

#pragma mark - KVO
-(void)registKVO{
    WEAKSELF;
    [mioM3U8Player xw_addObserverBlockForKeyPath:@"status" block:^(id  _Nonnull obj, id  _Nonnull oldVal, id  _Nonnull newVal) {
        [weakSelf playerStatusChanged];
    }];
    

    
    [mioM3U8Player xw_addObserverBlockForKeyPath:@"currentMusicDuration" block:^(id  _Nonnull obj, id  _Nonnull oldVal, id  _Nonnull newVal) {
        weakSelf.durationLab.text = [NSDate stringDuartion:mioM3U8Player.currentMusicDuration];
    }];
    
    [mioM3U8Player xw_addObserverBlockForKeyPath:@"bufferProgress" block:^(id  _Nonnull obj, id  _Nonnull oldVal, id  _Nonnull newVal) {
//        NSLog(@"___!!!%f",mioM3U8Player.bufferProgress);
        if (isnan(mioM3U8Player.bufferProgress)) {
            NSLog(@"nananannanananan");
        }else{
            _slider.bufferValue = mioM3U8Player.bufferProgress;
            [self.slider layoutIfNeeded];
        }

    }];
    
    [mioM3U8Player xw_addObserverBlockForKeyPath:@"currentTime" block:^(id  _Nonnull obj, id  _Nonnull oldVal, id  _Nonnull newVal) {
        if (isnan(mioM3U8Player.currentTime / mioM3U8Player.currentMusicDuration)) {
            NSLog(@"nananannanananan");
        }else{
            [_lrcView updateLrc];
            if (!self.isDraging) {
                _currentTimeLab.text = [NSDate stringDuartion:mioM3U8Player.currentTime];
                _slider.value = mioM3U8Player.currentTime / mioM3U8Player.currentMusicDuration;
                [self.slider layoutIfNeeded];
                
                _singleLrcLab.text = _lrcView.lyrics[_lrcView.currentLyricIndex].content;
                if (Equals(_singleLrcLab.text, @"暂无歌词")) {
                    _singleLrcLab.text = @"";
                }
            }
        }
    }];
}

-(void)downLoadLrc{
    if (mioM3U8Player.currentMusic.lrc_url.length > 0) {
        NSString *dirPath = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"lrcDownload"];

        NSString *lrcName=[NSString stringWithFormat:@"%@.lrc",mioM3U8Player.currentMusic.song_id];
        NSString *lrcPath = [NSString stringWithFormat:@"%@/%@",dirPath,lrcName];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:lrcPath]) {//歌词已存在
            NSArray *lrcArr = [LyricParser parserLyricWithFileName:lrcPath];
            _lrcView.lyrics = lrcArr;
        } else{//歌词不存在
            MioDownloadRequest *req = [[MioDownloadRequest alloc] initWinthUrl:[NSString stringWithFormat:@"%@",mioM3U8Player.currentMusic.lrc_url.mj_url] fileName:[NSString stringWithFormat:@"%@.lrc",mioM3U8Player.currentMusic.song_id]];
            [req success:^(NSDictionary * _Nonnull result) {
                NSLog(@"歌词下载成功");
                NSArray *lrcArr = [LyricParser parserLyricWithFileName:lrcPath];
                _lrcView.lyrics = lrcArr;
            } failure:^(NSString * _Nonnull errorInfo) {
                NSLog(@"歌词下载失败");
            }];
        };
    }else{//没有歌词
        MusicLyric *lyric = [[MusicLyric alloc]init];
        lyric.content = @"暂无歌词";
        lyric.time = 0;
        _lrcView.lyrics = @[lyric];
    }
}


-(void)playerStatusChanged{
    switch (mioM3U8Player.status) {
        case MioPlayerStatePlaying:
            NSLog(@"播放中");
            [_playBtn setBackgroundImage:image(@"suspended_player") forState:UIControlStateNormal];
            break;
            
        case MioPlayerStatePaused:
            NSLog(@"暂停");
            [_playBtn setBackgroundImage:image(@"play_player") forState:UIControlStateNormal];
            break;
            
        case MioPlayerStatePlayStopped:
            NSLog(@"结束");
            [_playBtn setBackgroundImage:image(@"play_player") forState:UIControlStateNormal];
            break;
            
        case MioPlayerStatePlayEnded:
            NSLog(@"播放完成");
            break;
            
        case MioPlayerStatePlayFailed:
            NSLog(@"错误");
            break;
            
        case MioPlayerStateUnknown:
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
    [mioM3U8Player playPre];
}

-(void)nextBtnClick{
    [mioM3U8Player playNext];
}

-(void)playClick{
    if (mioM3U8Player.status == ZFPlayerPlayStatePlaying) {
        [mioM3U8Player pause];
    }else{
        [mioM3U8Player play];
    }
}

-(void)playListClick{
    
    MioPlayListVC * vc = [[MioPlayListVC alloc]init];
    vc.beforeVC = self;
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
    NSInteger seekTime = (int)(mioM3U8Player.currentMusicDuration * value);
    [mioM3U8Player seekToTime:seekTime];
}
- (void)sliderTapped:(float)value{//点击进度条
    NSInteger seekTime = (int)(mioM3U8Player.currentMusicDuration * value);
    [mioM3U8Player seekToTime:seekTime];
}

- (void)lyricView:(MioLrcView *)lyricView withProgress:(CGFloat)progress{
    NSLog(@"%f",progress);
}

@end
