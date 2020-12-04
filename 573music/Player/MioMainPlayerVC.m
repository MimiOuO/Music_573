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

@interface MioMainPlayerVC ()<MioPlayerDelegate,UITableViewDelegate,UITableViewDataSource,GKSliderViewDelegate>
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UIButton *preBtn;
@property (nonatomic, strong) UIButton *nextBtn;
@property (nonatomic, strong) UIButton *playListBtn;
@property (nonatomic, strong) UIButton *playOrderBtn;
@property (nonatomic, strong) UITableView *playList;
@property (nonatomic, strong) UILabel *duration;
@property (nonatomic, strong) GKSliderView *slider;
@property (nonatomic, assign) BOOL isDraging;
@end

@implementation MioMainPlayerVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = mainColor;
    [self.navView.leftButton setImage:backArrowIcon forState:UIControlStateNormal];
    WEAKSELF;
    self.navView.leftButtonBlock = ^{
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
    
    [self creatUI];
    
    mioPlayer.delegate = self;
    
    
    
    [mioPlayList xw_addObserverBlockForKeyPath:@"playListArr" block:^(id  _Nonnull obj, id  _Nonnull oldVal, id  _Nonnull newVal) {
        NSLog(@"播放列表变化");
    }];
//
    [mioPlayList xw_addObserverBlockForKeyPath:@"currentPlayIndex" block:^(id  _Nonnull obj, id  _Nonnull oldVal, id  _Nonnull newVal) {
        [weakSelf.playList reloadData];
    }];
    
    [mioPlayer xw_addObserverBlockForKeyPath:@"currentMusicDuration" block:^(id  _Nonnull obj, id  _Nonnull oldVal, id  _Nonnull newVal) {
        weakSelf.duration.text = [NSDate stringDuartion:mioPlayer.currentMusicDuration];
    }];
    
    [mioPlayer xw_addObserverBlockForKeyPath:@"bufferProgress" block:^(id  _Nonnull obj, id  _Nonnull oldVal, id  _Nonnull newVal) {
        NSLog(@"___!!!%f",mioPlayer.bufferProgress);
        _slider.bufferValue = mioPlayer.bufferProgress;
        [self.slider layoutIfNeeded];
    }];
    
    [mioPlayer xw_addObserverBlockForKeyPath:@"currentTime" block:^(id  _Nonnull obj, id  _Nonnull oldVal, id  _Nonnull newVal) {
        NSLog(@"___%f",mioPlayer.currentTime / mioPlayer.currentMusicDuration);
        if (!self.isDraging) {
            _slider.value = mioPlayer.currentTime / mioPlayer.currentMusicDuration;
            [self.slider layoutIfNeeded];
        }
    }];
}

-(void)creatUI{
    WEAKSELF;
    _playOrderBtn = [UIButton creatBtn:frame(20, 700, 50, 50) inView:self.view bgImage:@"up_icon" action:^{
        [weakSelf switchPlayOrder];
    }];
    
    _preBtn = [UIButton creatBtn:frame(20, 700, 50, 50) inView:self.view bgImage:@"up_icon" action:^{
        [weakSelf preBtnClick];
    }];
    
    _playBtn = [UIButton creatBtn:frame(20, 700, 50, 50) inView:self.view bgImage:@"up_icon" action:^{
        [weakSelf playClick];
    }];
    
    _nextBtn = [UIButton creatBtn:frame(20, 700, 50, 50) inView:self.view bgImage:@"up_icon" action:^{
        [weakSelf nextBtnClick];
    }];
    
    _playListBtn = [UIButton creatBtn:frame(20, 700, 50, 50) inView:self.view bgImage:@"up_icon" action:^{
        [weakSelf playListClick];
    }];
    _duration = [UILabel creatLabel:frame(0, 760, KSW, 20) inView:self.view text:@"00:00" color:appBlackColor size:14 alignment:NSTextAlignmentCenter];

    _slider = [[GKSliderView alloc] initWithFrame:frame(50, 790, KSW - 100, 20)];
    [_slider setBackgroundImage:[UIImage imageNamed:@"cm2_fm_playbar_btn"] forState:UIControlStateNormal];
    [_slider setThumbImage:[UIImage imageNamed:@"cm2_fm_playbar_btn_dot"] forState:UIControlStateNormal];
    _slider.maximumTrackImage = [UIImage imageNamed:@"cm2_fm_playbar_bg"];
    _slider.minimumTrackImage = [UIImage imageNamed:@"cm2_fm_playbar_curr"];
    _slider.bufferTrackImage  = [UIImage imageNamed:@"cm2_fm_playbar_ready"];
    _slider.delegate = self;
    _slider.sliderHeight = 2;
    self.isDraging = NO;
    [self.view addSubview:_slider];
    
    
    _playOrderBtn.centerX = KSW/6;
    _preBtn.centerX = 2* KSW/6;
    _playBtn.centerX = 3* KSW/6;
    _nextBtn.centerX = 4* KSW/6;
    _playListBtn.centerX = 5* KSW/6;

    _playList = [[UITableView alloc] initWithFrame:CGRectMake(0, NavH, KSW, 550)];
    _playList.dataSource = self;
    _playList.delegate = self;
    [self.view addSubview:_playList];

}

-(void)switchPlayOrder{
    if (Equals(currentPlayOrder, MioPlayOrderCycle)) {
        setPlayOrder(MioPlayOrderSingle);
        [userdefault synchronize];
        return;
    }
    if (Equals(currentPlayOrder, MioPlayOrderSingle)) {
        setPlayOrder(MioPlayOrderRandom);
        [userdefault synchronize];
        return;
    }
    if (Equals(currentPlayOrder, MioPlayOrderRandom)) {
        setPlayOrder(MioPlayOrderCycle);
        [userdefault synchronize];
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
    [mioPlayList clearPlayList];
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return mioPlayList.playListArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = mioPlayList.playListArr[indexPath.row].name;
    if (mioPlayList.currentPlayIndex == indexPath.row) {
        cell.backgroundColor = redTextColor;
    }else{
        cell.backgroundColor = appWhiteColor;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [mioPlayer playIndex:indexPath.row];
}


@end
