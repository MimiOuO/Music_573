//
//  MioSingerVC.m
//  573music
//
//  Created by Mimio on 2020/12/29.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioSingerVC.h"
#import <WMPageController.h>
#import "MioSingerSongsVC.h"
#import "MioSingerAlbumVC.h"
#import "MioSingerMVVC.h"
#import "MioMainPlayerVC.h"
#import "MioBottomPlayView.h"

/****进入置顶通知****/
#define kHomeGoTopNotification               @"Home_Go_Top"
/****离开置顶通知****/
#define kHomeLeaveTopNotification            @"Home_Leave_Top"
@interface MioSingerVC()<UIScrollViewDelegate,UIGestureRecognizerDelegate,WMPageControllerDelegate,WMPageControllerDataSource>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIScrollView *pageScoll;
@property (nonatomic, strong) NSArray *myChildViewControllers;

/** 是否悬浮 */
@property (nonatomic, assign) BOOL canScroll;
@property (nonatomic, assign) CGFloat topHeiget;

@property (nonatomic, strong) MioSingerModel *model;

@property (nonatomic, strong) UIImageView *backgroundImg;
@property (nonatomic, strong) UILabel *navLab;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *fansLab;
@property (nonatomic, strong) UIButton *likeBtn;

@property (nonatomic, strong) WMPageController *pageController;
@end


@implementation MioSingerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:kHomeLeaveTopNotification object:nil];
    _canScroll = YES;
    
    [self creatUI];
    
    [self.navView.leftButton setImage:backArrowWhiteIcon forState:UIControlStateNormal];
    self.navView.bgImg.hidden = YES;
    self.navView.mainView.backgroundColor = rgba(0, 0, 0, 0);

    if ([self.navigationController.viewControllers[0] isKindOfClass:[MioMainPlayerVC class]]) {
        MioBottomPlayView *bottomPlayer = [[MioBottomPlayView alloc] initWithFrame:frame(0, KSH - 50 - SafeBotH, KSW, 50 + SafeBotH)];
        [self.view addSubview:bottomPlayer];
        [bottomPlayer whenTapped:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIWindow showLoading];
    });

    [self requestData];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle =  UIStatusBarStyleLightContent;
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.view.frame = frame(0, 0, KSW, KSH);
}

-(void)requestData{
    [MioGetReq(api_singerDetail(_singerId), @{@"k":@"v"}) success:^(NSDictionary *result){
        NSDictionary *data = [result objectForKey:@"data"];
        _model = [MioSingerModel mj_objectWithKeyValues:data];
        [self updateUI];
        [_pageController reloadData];
        [UIWindow hiddenLoading];
    } failure:^(NSString *errorInfo) {
        [UIWindow hiddenLoading];
    }];
    
}

-(void)creatUI{
    
    
    _scrollView = [[MioScrollView alloc] initWithFrame:CGRectMake(0, 0, KSW, KSH)];
    _scrollView.delegate = self;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    _scrollView.contentSize = CGSizeMake(KSW, 30000);
    _scrollView.bounces = NO;
    _scrollView.backgroundColor = appClearColor;
    [self.view addSubview:_scrollView];
    
    _backgroundImg = [UIImageView creatImgView:frame(0, 0, KSW, 300) inView:_scrollView image:@"geshou_qst" radius:0];
    UIView *maskView = [UIView creatView:frame(0, 0, KSW, 300) inView:_scrollView bgColor:rgba(0, 0, 0, 0.3) radius:0];
    
    _navLab = [UILabel creatLabel:frame(60, StatusH , KSW - 120, 44) inView:self.view text:@"" color:appWhiteColor boldSize:20 alignment:NSTextAlignmentCenter];
    _navLab.alpha = 0;
    
    
    _nameLab = [UILabel creatLabel:frame(Mar, 191, KSW_Mar2, 28) inView:_scrollView text:@"" color:appWhiteColor boldSize:20 alignment:NSTextAlignmentLeft];
    _fansLab = [UILabel creatLabel:frame(Mar, 223, 100, 20) inView:_scrollView text:@"" color:appWhiteColor size:14 alignment:NSTextAlignmentLeft];
    _likeBtn = [UIButton creatBtn:frame(KSW_Mar - 68, 214, 68, 28) inView:_scrollView bgImage:@"xihuan" action:^{
        [self likeClick];
    }];
    [_likeBtn setBackgroundImage:image(@"yixihuan") forState:UIControlStateSelected];
    
    //======================================================================//
    //                                page
    //======================================================================//
    UIView *contentView = [[UIView alloc] initWithFrame:frame(0, 260, KSW, KSH - NavH )];
    contentView.backgroundColor = appClearColor;
    [_scrollView addSubview:contentView];


    _pageController = [[WMPageController alloc] init];
    [self addChildViewController:_pageController];
    _pageController.delegate           = self;
    _pageController.dataSource         = self;
    _pageController.menuViewStyle      = WMMenuViewStyleLine;
    _pageController.automaticallyCalculatesItemWidths = YES;
    _pageController.itemMargin         = 25;
    _pageController.menuBGColor        = appClearColor;
    _pageController.menuHeight         = 44;
    _pageController.progressWidth      = 32;
    _pageController.progressHeight     = 3;
    _pageController.titleSizeNormal    = 15;
    _pageController.titleSizeSelected  = 15;
    _pageController.titleFontName      = @"PingFang-SC-Medium";
    _pageController.titleColorNormal   = color_text_one;
    _pageController.titleColorSelected = color_main;
    _pageController.progressColor      = color_main;
    _pageController.progressViewCornerRadius = 1.5;
    _pageController.viewFrame          = CGRectMake(0, 0, KSW, KSH - NavH);
    [contentView addSubview:_pageController.view];
    [_pageController.menuView addRoundedCorners:UIRectCornerTopRight|UIRectCornerTopLeft withRadii:CGSizeMake(16, 16)];
    MioImageView *menuBg = [MioImageView creatImgView:frame(0, 0, KSW, 44) inView:_pageController.menuView skin:SkinName image:@"picture_li" radius:0];
    [_pageController.menuView sendSubviewToBack:menuBg];
}

-(void)updateUI{
    _nameLab.text = _model.singer_name;
    _navLab.text = _model.singer_name;
    _fansLab.text = [NSString stringWithFormat:@"%@粉丝",_model.like_num];
    [_backgroundImg sd_setImageWithURL:_model.cover_image_path.mj_url placeholderImage:image(@"geshou_qst")];
    if (_model.is_like) {
        _likeBtn.selected = YES;
    }
    if (_model.singer_intro.length > 2) {
        UILabel *introLab = [UILabel creatLabel:frame(KSW_Mar - 50, StatusH , 50, 44) inView:self.navView.mainView text:@"简介" color:appWhiteColor size:14 alignment:NSTextAlignmentRight];
        [introLab whenTapped:^{
            [UIWindow showMessage:_model.singer_intro withTitle:_model.singer_name];
        }];
    }
}

-(void)likeClick{
    goLogin;
    [UIWindow showMaskLoading:@"请稍后"];
    [MioPostReq(api_likes, (@{@"model_name":@"singer",@"model_ids":@[_singerId]})) success:^(NSDictionary *result){
        NSDictionary *data = [result objectForKey:@"data"];
        _likeBtn.selected = !_likeBtn.selected;
        if (_likeBtn.selected) {
            [UIWindow showSuccess:@"已收藏到我的喜欢"];
            _fansLab.text = [NSString stringWithFormat:@"%d粉丝",[_fansLab.text substringToIndex:([_fansLab.text length]-2)].intValue + 1];
        }else{
            _fansLab.text = [NSString stringWithFormat:@"%d粉丝",[_fansLab.text substringToIndex:([_fansLab.text length]-2)].intValue - 1];
            [UIWindow showSuccess:@"已取消收藏"];
        }
    } failure:^(NSString *errorInfo) {
        [UIWindow showInfo:errorInfo];
    }];
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController{
    return 3;
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index{

    if (index == 0) {
        MioSingerSongsVC *vc = [[MioSingerSongsVC alloc] init];
        vc.singerId = _singerId;
        vc.songsCount = _model.songs_num?_model.songs_num:@"0";
        return vc;
    }
    else if (index == 1) {
        MioSingerAlbumVC *vc = [[MioSingerAlbumVC alloc] init];
        vc.singerId = _singerId;
        return vc;
    }
    else {
        MioSingerMVVC *vc = [[MioSingerMVVC alloc] init];
        vc.singerId = _singerId;
        return vc;
    }


}
- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index{

    if (index == 0) {
        return [NSString stringWithFormat:@"歌曲 %d",_model.songs_num.intValue];
    }
    else if (index == 1) {
        return [NSString stringWithFormat:@"专辑 %d",_model.albums_num.intValue];
    }
    else {
        return [NSString stringWithFormat:@"视频 %d",_model.mvs_num.intValue];
    }
}

#pragma mark - notification

-(void)acceptMsg : (NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    NSString *canScroll = userInfo[@"canScroll"];
    if ([canScroll isEqualToString:@"1"]) {
        _canScroll = YES;
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {

    CGFloat maxOffsetY = 260 - NavH;
    CGFloat offsetY = scrollView.contentOffset.y;

    if (offsetY < 100) {
        [UIView animateWithDuration:0.3 animations:^{
            _nameLab.alpha = 1;
            _fansLab.alpha = 1;
            _likeBtn.alpha = 1;
            _navLab.alpha = 0;
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            _nameLab.alpha = 0;
            _fansLab.alpha = 0;
            _likeBtn.alpha = 0;
            _navLab.alpha = 1;
        }];
    }
    
    if (offsetY >= maxOffsetY) {
        scrollView.contentOffset = CGPointMake(0, maxOffsetY);
//        NSLog(@"滑动到顶端");
        [[NSNotificationCenter defaultCenter] postNotificationName:kHomeGoTopNotification object:nil userInfo:@{@"canScroll":@"1"}];
        _canScroll = NO;
    } else {
        //NSLog(@"离开顶端");
        if (!_canScroll) {
            scrollView.contentOffset = CGPointMake(0, maxOffsetY);
        }
    }
}



@end
