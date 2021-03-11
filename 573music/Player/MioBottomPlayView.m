//
//  MioPlayerView.m
//  573music
//
//  Created by Mimio on 2020/11/24.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioBottomPlayView.h"
#import "MioPlayListVC.h"
//#import <JhtMarquee/JhtHorizontalMarquee.h>
//#import "STRAutoScrollLabel.h"
@interface MioBottomPlayView()
@property (nonatomic, strong) UIImageView *coverImg;
//@property (nonatomic, strong) JhtHorizontalMarquee *marquee;
//@property (nonatomic, strong) STRAutoScrollLabel *titleLab;
@property (nonatomic, strong) MioLabel *songNameLab;
@property (nonatomic, strong) MioLabel *singerLab;
@property (nonatomic, strong) MioButton *playListBtn;
@property (nonatomic, strong) MioButton *playBtn;
@property (nonatomic, strong) MioButton *playNextBtn;
@end

@implementation MioBottomPlayView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        RecieveNotice(switchMusic, changeMusic);
        RecieveNotice(@"clearPlaylist", changeMusic);
        RecieveNotice(@"hiddenPlaylistIcon", hiddenPlaylistIcon);
        RecieveNotice(@"showPlaylistIcon", showPlaylistIcon);
        RecieveChangeSkin;
        WEAKSELF;
        [mioM3U8Player xw_addObserverBlockForKeyPath:@"status" block:^(id  _Nonnull obj, id  _Nonnull oldVal, id  _Nonnull newVal) {
            [weakSelf playerStatusChanged];
        }];
        
        MioImageView *bottomImg = [MioImageView creatImgView:frame(0, 0, KSW, 50 + SafeBotH) inView:self skin:SkinName image:@"picture_bfq" radius:0];
        bottomImg.userInteractionEnabled = YES;
        UIImageView *bgImg = [UIImageView creatImgView:frame(11, -11, 60, 60) inView:self image:@"dfq_yy" radius:0];
        _coverImg = [UIImageView creatImgView:frame(Mar, -9, 50, 50) inView:self image:@"qxt_logo" radius:4];
        [_coverImg whenTapped:^{
            NSLog(@"YES");
        }];

        
//        _titleLab = [[STRAutoScrollLabel alloc] initWithFrame:CGRectMake(74, 6, ([(@"573音乐") widthForFont:BoldFont(14)] > (KSW - 120 - 80))?(KSW - 120 - 80):[(@"573音乐") widthForFont:BoldFont(14)], 20)];
//        _titleLab.text = @"573音乐";
//        _titleLab.textFont = BoldFont(14);
//        _titleLab.labelBetweenGap = 10;
//        _titleLab.textColor = color_text_one;
//        [self addSubview:_titleLab];
//        _titleLab.width = [_titleLab.text widthForFont:BoldFont(14)];
        
        _songNameLab = [MioLabel creatLabel:frame(74, 6, KSW - 120 - 75, 20) inView:self text:@"573音乐" colorName:name_text_one boldSize:14 alignment:NSTextAlignmentLeft];
        _singerLab = [MioLabel creatLabel:frame(74, 26, KSW - 120 - 75, 14) inView:self text:@"欢迎来到573音乐" colorName:name_text_two size:14 alignment:NSTextAlignmentLeft];
        
        _playListBtn = [MioButton creatBtn:frame(KSW - 102 - 17, 14.5, 17, 17) inView:self bgImage:@"bfq_bflb" bgTintColorName:name_main action:^{
            MioPlayListVC * vc = [[MioPlayListVC alloc]init];
            vc.beforeVC = [self getCurrentViewController];
            [[self getCurrentViewController] presentViewController:vc animated:YES completion:nil];
        }];
        _playBtn = [MioButton creatBtn:frame(KSW - 56 - 26, 11, 26, 26) inView:self bgImage:@"play_dibu" bgTintColorName:name_main action:^{
            if (mioM3U8Player.status == ZFPlayerPlayStatePlaying) {
                [mioM3U8Player pause];
            }else{
                [mioM3U8Player play];
            }
        }];
        _playNextBtn = [MioButton creatBtn:frame(KSW - 20 - 17, 14.5, 17, 17) inView:self bgImage:@"bfq_xys" bgTintColorName:name_main action:^{
            [mioM3U8Player playNext];
        }];
        
        if (Equals([userdefault objectForKey:@"isRadio"], @"1")) {
            _playListBtn.hidden = YES;
        }
        
        [self updateUI];
    }
    return self;
}

-(void)changeSkin{
//    _titleLab.textColor = color_text_one;
}

-(void)changeMusic{
    [self updateUI];
}

-(void)hiddenPlaylistIcon{
    _playListBtn.hidden = YES;
}

-(void)showPlaylistIcon{
    _playListBtn.hidden = NO;
}

-(void)updateUI{
    MioMusicModel *music = mioM3U8Player.currentMusic;
    [_coverImg sd_setImageWithURL:music.cover_image_path.mj_url placeholderImage:image(@"qxt_logo")];
    _songNameLab.text = music?music.title:@"573音乐";

    
//    [_titleLab removeFromSuperview];
//    _titleLab = [[STRAutoScrollLabel alloc] initWithFrame:CGRectMake(74, 6, ([(music?music.title:@"573音乐") widthForFont:BoldFont(14)] > (KSW - 120 - 80))?(KSW - 120 - 80):[(music?music.title:@"573音乐") widthForFont:BoldFont(14)], 20)];
//    _titleLab.text = music?music.title:@"573音乐";
//    _titleLab.labelBetweenGap = 10;
//    _titleLab.textFont = BoldFont(14);
//    _titleLab.textColor = color_text_one;
//    _titleLab.width = ([(music?music.title:@"573音乐") widthForFont:BoldFont(14)] > (KSW - 120 - 80))?(KSW - 120 - 80):[(music?music.title:@"573音乐") widthForFont:BoldFont(14)];
//    NSLog(@"%f",([(music?music.title:@"573音乐") widthForFont:BoldFont(14)] > (KSW - 120 - 80))?(KSW - 120 - 80):[(music?music.title:@"573音乐") widthForFont:BoldFont(14)]);
//    [self addSubview:_titleLab];
    
    _singerLab.text = music?music.singer_name:@"欢迎来到573音乐";
    if (music) {
        _playListBtn.enabled = YES;
        _playBtn.enabled = YES;
        _playNextBtn.enabled = YES;
    }else{
        _playListBtn.enabled = NO;
        _playBtn.enabled = NO;
        _playNextBtn.enabled = NO;
    }
}


-(void)playerStatusChanged{
    switch (mioM3U8Player.status) {
        case MioPlayerStatePlaying:
//            NSLog(@"播放中");
            [_playBtn setBackgroundImage:[image(@"suspended_dibu") imageWithRenderingMode:(UIImageRenderingModeAlwaysTemplate)] forState:UIControlStateNormal];
            break;
            
        case MioPlayerStatePaused:
//            NSLog(@"暂停");
            [_playBtn setBackgroundImage:[image(@"play_dibu") imageWithRenderingMode:(UIImageRenderingModeAlwaysTemplate)] forState:UIControlStateNormal];
            break;
            
        case MioPlayerStatePlayStopped:
//            NSLog(@"结束");
            [_playBtn setBackgroundImage:[image(@"play_dibu") imageWithRenderingMode:(UIImageRenderingModeAlwaysTemplate)] forState:UIControlStateNormal];
            break;
            
        case MioPlayerStatePlayEnded:
//            NSLog(@"播放完成");
            break;
            
        case MioPlayerStatePlayFailed:
//            NSLog(@"错误");
            break;
            
        case MioPlayerStateUnknown:
            break;
    }
}

-(UIViewController *)getCurrentViewController{
    UIResponder *next = [self nextResponder];
    do {if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next !=nil);
    return nil;
}

@end
