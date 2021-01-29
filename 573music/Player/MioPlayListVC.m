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
#import "MioMusicPlaylistCell.h"

@interface MioPlayListVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) BTCoverVerticalTransition *aniamtion;
@property (nonatomic, strong) UITableView *playList;
@property (nonatomic, assign) MioBottomType beforeBottomType;
@property (nonatomic, strong) MioButton *mutiBtn;
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
    [self.view addRoundedCorners:UIRectCornerTopLeft|UIRectCornerTopRight withRadii:CGSizeMake(16, 16)];

    MioImageView *bgImg = [MioImageView creatImgView:frame(0, 0, KSW, KSH) inView:self.view skin:SkinName image:@"picture" radius:0];
    
    self.preferredContentSize = CGSizeMake(self.view.bounds.size.width,450 + SafeBotH);
    WEAKSELF;

    _playList = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, KSW, 350)];
    _playList.dataSource = self;
    _playList.delegate = self;
    _playList.backgroundColor = appClearColor;
    _playList.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_playList];
//    MioImageView *bgImg1 = [MioImageView creatImgView:frame(0, 0, KSW, 50) inView:self.view skin:SkinName image:@"picture_li" radius:0];
    MioView *split1 = [MioView creatView:frame(0, 50, KSW, 0.5) inView:self.view bgColorName:name_split radius:0];
    MioLabel *title = [MioLabel creatLabel:frame(Mar, 0, KSW, 50) inView:self.view text:@"当前播放" colorName:name_text_one boldSize:14 alignment:NSTextAlignmentLeft];
    _mutiBtn = [MioButton creatBtn:frame(KSW - 52 - 16, 16, 16, 16) inView:self.view bgImage:@"liebiao_add" bgTintColorName:name_icon_one action:^{
        if (mioPlayList.playListArr.count > 0) {
            MioMutipleVC *vc = [[MioMutipleVC alloc] init];
            vc.musicArr = mioPlayList.playListArr;
            vc.type = MioMutipleTypePlayList;
            MioNavVC *nav = [[MioNavVC alloc] initWithRootViewController:vc];
            nav.modalPresentationStyle = 0;
            [self presentViewController:nav animated:YES completion:nil];
        }
    }];
    MioButton *clearbtn = [MioButton creatBtn:frame(KSW -16 -16, 16, 16, 16) inView:self.view bgImage:@"liebiao_shanchu" bgTintColorName:name_icon_one action:^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确定清空播放队列？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"我再想想" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {

            [mioPlayList clearPlayList];
            [self dismissViewControllerAnimated:YES completion:nil];


        }];
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        alertController.modalPresentationStyle = 0;
        [self presentViewController:alertController animated:YES completion:nil];
        

    }];

//    MioImageView *bgImg2 = [MioImageView creatImgView:frame(0, 400, KSW, 50 + SafeBotH) inView:self.view skin:SkinName image:@"picture_li" radius:0];
    MioView *split2 = [MioView creatView:frame(0, 400, KSW, 0.5) inView:self.view bgColorName:name_split radius:0];
    UIButton *closeBtn = [UIButton creatBtn:frame(0, 400, KSW, 50 + SafeBotH) inView:self.view bgColor:appClearColor title:@"关闭" titleColor:color_text_one font:14 radius:0 action:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [mioPlayList xw_addObserverBlockForKeyPath:@"playListArr" block:^(id  _Nonnull obj, id  _Nonnull oldVal, id  _Nonnull newVal) {
        NSLog(@"播放列表变化");
    }];
//
    [mioPlayList xw_addObserverBlockForKeyPath:@"currentPlayIndex" block:^(id  _Nonnull obj, id  _Nonnull oldVal, id  _Nonnull newVal) {
        [weakSelf.playList reloadData];
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _beforeBottomType =  [MioVCConfig getBottomType:_beforeVC];
    if (_beforeBottomType == MioBottomAll) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MioBottomAll" object:nil];
    }
    if (_beforeBottomType == MioBottomHalf) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MioBottomHalf" object:nil];
    }
    if (_beforeBottomType == MioBottomNone) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MioBottomNone" object:nil];;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return mioPlayList.playListArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    MioMusicPlaylistCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MioMusicPlaylistCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = mioPlayList.playListArr[indexPath.row];
    if (mioPlayList.currentPlayIndex == indexPath.row) {
        cell.isplaying = YES;
    }else{
        cell.isplaying = NO;
    }
    if (mioPlayList.playListArr[indexPath.row].local) {
        _mutiBtn.hidden = YES;
    }else{
        _mutiBtn.hidden = NO;
    }
    
    cell.deleteBlock = ^(MioMusicPlaylistCell * cell) {
        if (mioPlayList.playListArr.count == 1) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确定清空播放队列？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"我再想想" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {

                [mioPlayList clearPlayList];
                [self dismissViewControllerAnimated:YES completion:nil];

            }];
            [alertController addAction:cancelAction];
            [alertController addAction:okAction];
            alertController.modalPresentationStyle = 0;
            [self presentViewController:alertController animated:YES completion:nil];
        }else{
            NSLog(@"%ld",(long)indexPath.row);
            [mioPlayList deletePlayListAtIndex:indexPath.row];
            [_playList deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [_playList reloadData];
        }
    };
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [mioM3U8Player playIndex:indexPath.row];
}

@end
