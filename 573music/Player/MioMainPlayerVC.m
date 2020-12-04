//
//  MioMainPlayerVC.m
//  573music
//
//  Created by Mimio on 2020/12/1.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioMainPlayerVC.h"
#import "NSObject+XWAdd.h"

@interface MioMainPlayerVC ()<MioPlayerDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UIButton *preBtn;
@property (nonatomic, strong) UIButton *nextBtn;
@property (nonatomic, strong) UIButton *playListBtn;
@property (nonatomic, strong) UIButton *playOrderBtn;
@property (nonatomic, strong) UITableView *playList;
@property (nonatomic, strong) UILabel *duration;
@end

@implementation MioMainPlayerVC

- (void)viewDidLoad {
    [super viewDidLoad];

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

- (void)dealloc
{
    NSLog(@"播放器被释放了");
}

@end
