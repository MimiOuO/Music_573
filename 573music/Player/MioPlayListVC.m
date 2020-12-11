//
//  MioPlayListVC.m
//  573music
//
//  Created by Mimio on 2020/12/7.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioPlayListVC.h"
#import "BTCoverVerticalTransition.h"
#import "MioMutipleVC.h"

@interface MioPlayListVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) BTCoverVerticalTransition *aniamtion;
@property (nonatomic, strong) UITableView *playList;
@end

@implementation MioPlayListVC
- (instancetype)init{
    self = [super init];
    if (self) {
        _aniamtion = [[BTCoverVerticalTransition alloc]initPresentViewController:self withRragDismissEnabal:YES];
        self.transitioningDelegate = _aniamtion;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = appClearColor;
    
    UIVisualEffectView *effect = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    effect.frame = frame(0, 0, KSW, 400 + SafeBotH);
    effect.alpha = 1;
    [self.view addSubview:effect];
    UIVisualEffectView *effect2 = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    effect2.frame = frame(0, 0, KSW, 400 + SafeBotH);
    effect2.alpha = 1;
    [self.view addSubview:effect2];
    
    self.preferredContentSize = CGSizeMake(self.view.bounds.size.width,400 + SafeBotH);
    WEAKSELF;

    _playList = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, KSW, 300)];
    _playList.dataSource = self;
    _playList.delegate = self;
    _playList.backgroundColor = appClearColor;
    [self.view addSubview:_playList];
    
    UIButton *mutiBtn = [UIButton creatBtn:frame(0, 0, 50, 50) inView:self.view bgImage:@"icon" action:^{

        MioMutipleVC *vc = [[MioMutipleVC alloc] init];
        vc.musicArr = mioPlayList.playListArr;
        vc.type = MioMutipleTypePlayList;
        MioNavVC *nav = [[MioNavVC alloc] initWithRootViewController:vc];
        nav.modalPresentationStyle = 0;
        [self presentViewController:nav animated:YES completion:nil];
        
        
    }];
    
    [mioPlayList xw_addObserverBlockForKeyPath:@"playListArr" block:^(id  _Nonnull obj, id  _Nonnull oldVal, id  _Nonnull newVal) {
        NSLog(@"播放列表变化");
    }];
//
    [mioPlayList xw_addObserverBlockForKeyPath:@"currentPlayIndex" block:^(id  _Nonnull obj, id  _Nonnull oldVal, id  _Nonnull newVal) {
        [weakSelf.playList reloadData];
    }];
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
        cell.backgroundColor = appClearColor;
    }else{
        cell.backgroundColor = appClearColor;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [mioPlayer playIndex:indexPath.row];
}

@end
