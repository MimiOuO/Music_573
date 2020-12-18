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

@interface MioMvVC ()<WMPageControllerDelegate,WMPageControllerDataSource,ChangeCollectionDelegate>
@property (nonatomic, strong) MioMvModel *mv;

@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) UIImageView *containerView;
@property (nonatomic, strong) ZFPlayerControlView *controlView;
@property (nonatomic, strong) UIButton *playBtn;

@property (nonatomic, strong) WMPageController *pageController;
@property (nonatomic, strong) UIView *contentView;
@end

@implementation MioMvVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self request];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popVC) name:@"playerBackClick" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.player.viewControllerDisappear = NO;
    [UIApplication sharedApplication].statusBarStyle =  UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.player.viewControllerDisappear = YES;
}

-(void)popVC{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)request{
    [MioGetReq(api_base, @{@"k":@"v"}) success:^(NSDictionary *result){
        NSDictionary *data = [result objectForKey:@"data"];
        _mv = [MioMvModel mj_objectWithKeyValues:data];
        [self creatView];
    } failure:^(NSString *errorInfo) {}];
}

-(void)creatView{
    //======================================================================//
    //                              播放器
    //======================================================================//
    UIView *statusView = [UIView creatView:frame(0, 0, KSW, NavH) inView:self.view bgColor:[UIColor blackColor] radius:0];
    
    _containerView = [[UIImageView alloc] initWithFrame:frame(0, StatusH, KSW, KSW * 9/16)];
    _containerView.image = [UIImage hx_imageWithColor:[UIColor blackColor] havingSize:CGSizeMake(1, 1)];
    [self.view addSubview:_containerView];
    
    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];

    playerManager.shouldAutoPlay = YES;
    
    /// 播放器相关
    self.player = [ZFPlayerController playerWithPlayerManager:playerManager containerView:self.containerView];
    self.player.controlView = self.controlView;
    /// 设置退到后台继续播放
    self.player.pauseWhenAppResignActive = NO;
//    self.player.resumePlayRecord = YES;
    
    @zf_weakify(self)
    self.player.orientationWillChange = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
        ((AppDelegate*)[[UIApplication sharedApplication] delegate]).allowOrentitaionRotation = isFullScreen;
    };
    
    /// 播放完成
    self.player.playerDidToEnd = ^(id  _Nonnull asset) {
//        @zf_strongify(self)
//        if (!self.player.isLastAssetURL) {
//            [self.player playTheNext];
//            NSString *title = [NSString stringWithFormat:@"视频标题%zd",self.player.currentPlayIndex];
//            [self.controlView showTitle:title coverURLString:kVideoCover fullScreenMode:ZFFullScreenModeLandscape];
//        } else {
//            [self.player stop];
//        }
    };
    
    self.player.assetURLs = @[[NSURL URLWithString:@"https://www.apple.com/105/media/us/iphone-x/2017/01df5b43-28e4-4848-bf20-490c34a926a7/films/feature/iphone-x-feature-tpl-cc-us-20170912_1280x720h.mp4"],[NSURL URLWithString:@"https://www.apple.com/105/media/cn/mac/family/2018/46c4b917_abfd_45a3_9b51_4e3054191797/films/bruce/mac-bruce-tpl-cn-2018_1280x720h.mp4"],];
    [self.player playTheIndex:0];
    [self.controlView showTitle:@"" coverURLString:@"https://upload-images.jianshu.io/upload_images/635942-14593722fe3f0695.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240" fullScreenMode:ZFFullScreenModeAutomatic];
    
//    [self.navView.leftButton setImage:backArrowWhiteIcon forState:UIControlStateNormal];
//    self.navView.mainView.backgroundColor = appClearColor;
    
    
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
    _pageController.menuHeight         = 48;
    _pageController.menuItemWidth      = 60;
    _pageController.progressWidth      = 20;
    _pageController.titleFontName      = @"PingFangSC-Medium";
    _pageController.titleSizeNormal    = 16;
    _pageController.menuBGColor        = appWhiteColor;
    _pageController.titleColorNormal   = subColor;
    _pageController.titleColorSelected = color_main;
    _pageController.progressWidth      = 32;
    _pageController.progressHeight     = 2;
    _pageController.progressViewCornerRadius = 2;
    _pageController.progressViewBottomSpace = 0;
    _pageController.viewFrame = CGRectMake(0, 0, KSW, KSH-StatusH - TabH);
    [_contentView addSubview:self.pageController.view];
    
    UIView *split = [UIView creatView:frame(0, 48, KSW, 0.5) inView:_contentView bgColor:botLineColor radius:0];
}

-(void)changeCollection:(int)index{
    [self.player playTheIndex:index];
}


#pragma mark - WMPageDelegate

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController{
  
    return 2;
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index{
    
    if (index == 0) {
        MioMvIntroVC *info = [[MioMvIntroVC alloc] init];
        info.mv = _mv;
        info.delegate = self;
        return info;
    }
    if (index == 1) {
        return [[MioMvCmtVC alloc] init];
    }
    return [[UIViewController alloc] init];
    
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index{
    
    if (index == 0) {
        return @"简介";
    }
    else if (index == 1) {
        return @"评论(1)";
    }
    return @"";
}



- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

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


@end
