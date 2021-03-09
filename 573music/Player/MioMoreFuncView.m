//
//  MioMoreFuncView.m
//  573music
//
//  Created by Mimio on 2021/1/15.
//  Copyright © 2021 Mimio. All rights reserved.
//

#import "MioMoreFuncView.h"
#import "MioFeedBackVC.h"
#import "UIViewController+MioExtension.h"
#import "MioSingerVC.h"
#import "MioAlbumVC.h"
#import "MioSongListVC.h"
#import "MioCategoryVC.h"
#import "MioMusicRankVC.h"
#import "MioLikeVC.h"
#import "MioLocalVC.h"
#import "MioRecentVC.h"
#import "MioDownloadVC.h"

@interface MioMoreFuncView()
@property (nonatomic, strong) UIView *bgView;
@end

@implementation MioMoreFuncView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = appClearColor;

        self.frame = frame(0, KSH, KSW, KSH);
        UIView *closeView = [UIView creatView:frame(0, 0, KSW, KSH - 210 - SafeBotH) inView:self bgColor:appClearColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenView)];
        [closeView addGestureRecognizer:tap];
        
        _bgView = [UIView creatView:frame(0, KSH - 210 - SafeBotH, KSW, 210 + SafeBotH) inView:self bgColor:appWhiteColor];
        MioImageView *bgImg = [MioImageView creatImgView:frame(0, 0, KSW, KSH) inView:_bgView skin:SkinName image:@"picture" radius:0];
        [_bgView addRoundedCorners:UIRectCornerTopRight|UIRectCornerTopLeft withRadii:CGSizeMake(16, 16)];
        
        UILabel *titleLab = [UILabel creatLabel:frame(0, 0, KSW, 50) inView:_bgView text:@"更多功能" color:color_text_one size:16];
        titleLab.textAlignment = NSTextAlignmentCenter;
        UIView *splitView = [UIView creatView:frame(0, 51, KSW, 0.5) inView:_bgView bgColor:color_split];
        
        UIButton *closeBtn = [UIButton creatBtn:frame(0, 160, KSW, 50 + SafeBotH) inView:_bgView bgColor:appClearColor title:@"关闭" titleColor:color_text_one font:14 radius:0 action:^{
            [self hiddenView];
        }];
        RecieveNotice(switchMusic, hiddenView);
    }
    return self;
}

- (void)show{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [self creatUI];
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, 0, KSW, KSH);
    }];
}

- (void)hiddenView {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, KSH, KSW, KSH);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)creatUI{
    NSMutableArray *imgArr =[[NSMutableArray alloc] init];
    NSMutableArray *titleArr = [[NSMutableArray alloc] init];
    if ([_model.singer_id intValue] > 0) {
        [imgArr addObject:@"more_singer"];
        [titleArr addObject:@"歌手"];
    }
    if ([_model.album_id intValue] > 0 ) {
        [imgArr addObject:@"more_album"];
        [titleArr addObject:@"专辑"];
    }
    if (_model.fromModel != MioFromUnkown) {
        [imgArr addObject:@"lj"];
        [titleArr addObject:@"播放来源"];
    }
    if (_model.lrc_url.length > 0) {
        [imgArr addObject:@"more_forward"];
        [imgArr addObject:@"more_back"];
        [titleArr addObject:@"歌词快退"];
        [titleArr addObject:@"歌词快进"];
    }
    [imgArr addObject:@"more_feedback"];
    [titleArr addObject:@"反馈"];
    
    UIScrollView *scroll = [UIScrollView creatScroll:frame( (titleArr.count*64 + 16) > KSW? 0 : KSW/2 - (titleArr.count*64 + 16)/2, 0, KSW, 160) inView:_bgView contentSize:CGSizeMake(titleArr.count*64 + 16, 160)];
    
    for (int i = 0;i < titleArr.count; i++) {

        UIView *bgView = [UIView creatView:frame(16 + i * 64 , 73, 48, 48) inView:scroll bgColor:color_sup_four radius:6];
        MioImageView *icon = [MioImageView creatImgView:frame(13, 13, 22, 22) inView:bgView image:imgArr[i] bgTintColorName:name_icon_one radius:0];
        MioLabel *title = [MioLabel creatLabel:frame(bgView.left - 5, 123, 58, 17) inView:scroll text:titleArr[i] colorName:name_text_one size:12 alignment:NSTextAlignmentCenter];
        [bgView whenTapped:^{
            if (Equals(titleArr[i], @"歌手")) {
                [self hiddenView];
                MioSingerVC *vc = [[MioSingerVC alloc] init];
                vc.singerId = _model.singer_id;
                [_fatherVC.currentTabbarSelectedNavigationController pushViewController:vc animated:YES];
            }
            if (Equals(titleArr[i], @"专辑")) {
                [self hiddenView];
                MioAlbumVC *vc = [[MioAlbumVC alloc] init];
                vc.album_id = _model.album_id;
                [_fatherVC.currentTabbarSelectedNavigationController pushViewController:vc animated:YES];
            }
            if (Equals(titleArr[i], @"歌词快退")) {
                _lrcView.adjustLrcSec = _lrcView.adjustLrcSec - 1;
                [self showTip];
            }
            if (Equals(titleArr[i], @"歌词快进")) {
                _lrcView.adjustLrcSec = _lrcView.adjustLrcSec + 1;
                [self showTip];
            }
            if (Equals(titleArr[i], @"反馈")) {
                [self hiddenView];
                MioFeedBackVC *vc = [[MioFeedBackVC alloc] init];
                [_fatherVC.navigationController pushViewController:vc animated:YES];
            }
            if (Equals(titleArr[i], @"播放来源")) {
                [self hiddenView];
                [_fatherVC dismissViewControllerAnimated:YES completion:^{
                    if (_model.fromModel == MioFromSonglist) {
                        MioSongListVC *vc = [[MioSongListVC alloc] init];
                        vc.songlistId = _model.fromId;
                        [_fatherVC.currentTabbarSelectedNavigationController pushViewController:vc animated:YES];
                    }
                    if (_model.fromModel == MioFromAlbum) {
                        MioAlbumVC *vc = [[MioAlbumVC alloc] init];
                        vc.album_id = _model.fromId;
                        [_fatherVC.currentTabbarSelectedNavigationController pushViewController:vc animated:YES];
                    }
                    if (_model.fromModel == MioFromSinger) {
                        MioSingerVC *vc = [[MioSingerVC alloc] init];
                        vc.singerId = _model.fromId;
                        [_fatherVC.currentTabbarSelectedNavigationController pushViewController:vc animated:YES];
                    }
                    if (_model.fromModel == MioFromCategory) {
                        MioCategoryVC *vc = [[MioCategoryVC alloc] init];
                        vc.tag = _model.fromId;
                        [_fatherVC.currentTabbarSelectedNavigationController pushViewController:vc animated:YES];
                    }
                    if (_model.fromModel == MioFromRank) {
                        MioMusicRankVC *vc = [[MioMusicRankVC alloc] init];
                        vc.rankId = _model.fromId;
                        [_fatherVC.currentTabbarSelectedNavigationController pushViewController:vc animated:YES];
                    }
                    if (_model.fromModel == MioFromMyLike) {
                        MioLikeVC *vc = [[MioLikeVC alloc] init];
                        [_fatherVC.currentTabbarSelectedNavigationController pushViewController:vc animated:YES];
                    }
                    if (_model.fromModel == MioFromLocal) {
                        MioLocalVC *vc = [[MioLocalVC alloc] init];
                        [_fatherVC.currentTabbarSelectedNavigationController pushViewController:vc animated:YES];
                    }
                    if (_model.fromModel == MioFromRecent) {
                        MioRecentVC *vc = [[MioRecentVC alloc] init];
                        [_fatherVC.currentTabbarSelectedNavigationController pushViewController:vc animated:YES];
                    }
                    if (_model.fromModel == MioFromDownload) {
                        MioDownloadVC *vc = [[MioDownloadVC alloc] init];
                        [_fatherVC.currentTabbarSelectedNavigationController pushViewController:vc animated:YES];
                    }
                    
                    
                }];

            }
        }];
    }
    
    
}

-(void)showTip{
    if (_lrcView.adjustLrcSec == 0) {
        [UIWindow showInfo:@"歌词还原"];
    }else if(_lrcView.adjustLrcSec < 0) {
        [UIWindow showInfo:[NSString stringWithFormat:@"歌词延后%ld秒",-(long)_lrcView.adjustLrcSec]];
    }else{
        [UIWindow showInfo:[NSString stringWithFormat:@"歌词提前%ld秒",(long)_lrcView.adjustLrcSec]];
    }
}

@end
