//
//  MiomvVC.m
//  jgsschool
//
//  Created by Mimio on 2020/9/16.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioMvVC.h"
#import "AppDelegate.h"
#import "ZFPlayer.h"
#import "ZFAVPlayerManager.h"
#import "ZFIJKPlayerManager.h"
#import "ZFPlayerControlView.h"
#import <WMPageController.h>
#import "MioMvIntroVC.h"
#import "MioMvCmtVC.h"
#import "MioMvModel.h"
#import <WHC_ModelSqlite.h>
#import <SJVideoPlayer/SJVideoPlayer.h>

@interface MioMvVC ()<WMPageControllerDelegate,WMPageControllerDataSource,ChangeMVDelegate>
@property (nonatomic, strong) MioMvModel *mv;

//@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) UIImageView *containerView;
@property (nonatomic, strong) ZFPlayerControlView *controlView;
@property (nonatomic, strong) UIButton *playBtn;

@property (nonatomic, strong) WMPageController *pageController;
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) MioMvIntroVC *info;
@property (nonatomic, strong) MioMvCmtVC *cmtVC;

@property (nonatomic, strong) SJVideoPlayer *player;
@end

@implementation MioMvVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self request];
    [self creatView];
    
    [mioM3U8Player pause];
    
    RecieveNotice(@"playerBackClick", popVC);
    RecieveNotice(@"mvCmtSuccess", refreshCmtCount);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_player vc_viewDidAppear];
    [UIApplication sharedApplication].statusBarStyle =  UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_player vc_viewWillDisappear];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [_player vc_viewDidDisappear];
}

-(void)popVC{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)request{

    [MioGetReq(api_mvrDetail(_mvId), @{@"k":@"v"}) success:^(NSDictionary *result){
        NSDictionary *data = [result objectForKey:@"data"];
        _mv = [MioMvModel mj_objectWithKeyValues:data];
        
        [WHCSqlite delete:[MioMvModel class] where:[NSString stringWithFormat:@"savetype = 'recentMV' AND mv_id = '%@'",_mv.mv_id]];
        _mv.savetype = @"recentMV";
        [WHCSqlite insert:_mv];
        
        
        [_pageController updateTitle:[NSString stringWithFormat:@"评论(%@)",_mv.comment_num] atIndex:1];
        _pageController.titles = @[@"简介",[NSString stringWithFormat:@"评论(%@)",_mv.comment_num]];
        _info.mv = _mv;

        SJVideoPlayerURLAsset *asset = [SJVideoPlayerURLAsset.alloc initWithURL:_mv.mv_path.mj_url startPosition:0];
        _player.URLAsset = asset;
    } failure:^(NSString *errorInfo) {}];
}

-(void)creatView{
    
    
    //======================================================================//
    //                              播放器
    //======================================================================//
    UIView *statusView = [UIView creatView:frame(0, 0, KSW, NavH) inView:self.view bgColor:[UIColor blackColor] radius:0];
    

    
    WEAKSELF;
    _player = SJVideoPlayer.player;
    _player.view.frame = frame(0, StatusH, KSW, KSW * 9.0/16);
    if (@available(iOS 14.0, *)) {
        _player.defaultEdgeControlLayer.automaticallyShowsPictureInPictureItem = NO;
    }
    _player.defaultEdgeControlLayer.showsMoreItem = NO;
    [self.view addSubview:_player.view];
    _player.playbackObserver.playbackDidFinishExeBlock = ^(__kindof SJBaseVideoPlayer * _Nonnull player) {
        if (weakSelf. info.relatedMVArr.count > 0) {
            [weakSelf changeMV:weakSelf.info.relatedMVArr[0].mv_id];
        }
    };


    
    _contentView = [[UIView alloc] initWithFrame:frame(0,StatusH + KSW * 9/16, KSW, KSH - StatusH - TabH)];
    [self.view addSubview:_contentView];
    
    _pageController = [[WMPageController alloc] init];
    [self addChildViewController:_pageController];
    _pageController.delegate           = self;
    _pageController.dataSource         = self;
    _pageController.menuViewStyle      = WMMenuViewStyleLine;
    _pageController.automaticallyCalculatesItemWidths = YES;
    _pageController.progressViewIsNaughty = YES;
    _pageController.itemMargin         = 25;
    _pageController.menuHeight         = 44;
    _pageController.menuItemWidth      = 60;
    _pageController.progressWidth      = 20;
    _pageController.titleFontName      = @"PingFangSC-Medium";
    _pageController.titleSizeNormal    = 16;
    _pageController.menuBGColor        = appWhiteColor;
    _pageController.titleColorNormal   = color_text_one;
    _pageController.titleColorSelected = color_main;
    _pageController.progressWidth      = 32;
    _pageController.progressHeight     = 2;
    _pageController.progressViewCornerRadius = 2;
    _pageController.progressViewBottomSpace = 0;
    _pageController.viewFrame = CGRectMake(0, 0, KSW, KSH-StatusH - TabH);
    [_contentView addSubview:self.pageController.view];

    
    MioImageView *menuBg = [MioImageView creatImgView:frame(0, 0, KSW, 44) inView:_pageController.menuView skin:SkinName image:@"picture_li" radius:0];
    [_pageController.menuView sendSubviewToBack:menuBg];
    
}


#pragma mark - WMPageDelegate

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController{
  
    return 2;
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index{
    
    if (index == 0) {
        _info = [[MioMvIntroVC alloc] init];
        _info.delegate = self;
        return _info;
    }
    if (index == 1) {
        _cmtVC = [[MioMvCmtVC alloc] init];
        _cmtVC.mvId = _mvId;
        return _cmtVC;
    }
    return [[UIViewController alloc] init];
    
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index{
    
    if (index == 0) {
        return @"简介";
    }
    else if (index == 1) {
        if (_mv) {
            return [NSString stringWithFormat:@"评论(%@)",_mv.comment_num];
        }else{
            return @"评论(0)";
        }
        
    }
    return @"";
}

- (BOOL)shouldAutorotate {
    return NO;
}

//- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    return UIInterfaceOrientationMaskPortrait;
//}

- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [ZFPlayerControlView new];
        _controlView.fastViewAnimated = YES;
        _controlView.autoHiddenTimeInterval = 6;
        _controlView.autoFadeTimeInterval = 0.5;
        _controlView.prepareShowLoading = YES;
        _controlView.prepareShowControlView = NO;
    }
    return _controlView;
}

- (void)changeMV:(NSString *)mvId{
    _mvId = mvId;
    _cmtVC.mvId = mvId;
    [_cmtVC refreshCmt];
    [self request];
}

-(void)refreshCmtCount{
    NSString *str = [_pageController.titles[1] substringFromIndex:3];
    NSString *str2 =  [str substringToIndex:str.length - 1];
    [_pageController updateTitle:[NSString stringWithFormat:@"评论(%d)",[str2 intValue] + 1] atIndex:1];
    _pageController.titles = @[@"简介",[NSString stringWithFormat:@"评论(%d)",[str2 intValue] + 1]];
}

- (void)dealloc
{
    NSLog(@"1111");
}

@end
