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

@property (nonatomic, strong) UILabel *navLab;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *fansLab;
@property (nonatomic, strong) UIButton *likeBtn;
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

    

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle =  UIStatusBarStyleLightContent;
//    [self request];
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
    
    UIImageView *bgImg = [UIImageView creatImgView:frame(0, 0, KSW, 300) inView:_scrollView image:@"" radius:0];
    [bgImg sd_setImageWithURL:_model.cover_image_path.mj_url placeholderImage:image(@"geshou_qst")];
    UIView *maskView = [UIView creatView:frame(0, 0, KSW, 300) inView:_scrollView bgColor:rgba(0, 0, 0, 0.3) radius:0];
    
    _navLab = [UILabel creatLabel:frame(60, StatusH , KSW - 120, 44) inView:self.view text:_model.singer_name color:appWhiteColor boldSize:20 alignment:NSTextAlignmentCenter];
    _navLab.alpha = 0;
    
    if (_model.singer_intro.length > 2) {
        UILabel *introLab = [UILabel creatLabel:frame(KSW_Mar - 50, StatusH , 50, 44) inView:self.navView.mainView text:@"简介" color:appWhiteColor size:14 alignment:NSTextAlignmentRight];
        [introLab whenTapped:^{
            [UIWindow showMessage:_model.singer_intro withTitle:_model.singer_name];
        }];
    }

    
    _nameLab = [UILabel creatLabel:frame(Mar, 191, KSW_Mar2, 28) inView:_scrollView text:_model.singer_name color:appWhiteColor boldSize:20 alignment:NSTextAlignmentLeft];
    _fansLab = [UILabel creatLabel:frame(Mar, 223, 100, 20) inView:_scrollView text:[NSString stringWithFormat:@"%@粉丝",_model.like_num] color:appWhiteColor size:14 alignment:NSTextAlignmentLeft];
    _likeBtn = [UIButton creatBtn:frame(KSW_Mar - 50, 222, 50, 22) inView:_scrollView bgImage:@"xihuan" action:^{
        _likeBtn.selected = !_likeBtn.selected;
    }];
    [_likeBtn setBackgroundImage:image(@"geshou_yixihuan") forState:UIControlStateSelected];
    
    //======================================================================//
    //                                page
    //======================================================================//
    UIView *contentView = [[UIView alloc] initWithFrame:frame(0, 260, KSW, KSH - NavH )];
    contentView.backgroundColor = appClearColor;
    [_scrollView addSubview:contentView];


    WMPageController *_pageController = [[WMPageController alloc] init];
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


- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController{
    return 3;
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index{

    if (index == 0) {
        MioSingerSongsVC *vc = [[MioSingerSongsVC alloc] init];
        vc.singerId = _model.singer_id;
        return vc;
    }
    else if (index == 1) {
        MioSingerAlbumVC *vc = [[MioSingerAlbumVC alloc] init];
        vc.singerId = _model.singer_id;
        return vc;
    }
    else {
        MioSingerMVVC *vc = [[MioSingerMVVC alloc] init];
        vc.singerId = _model.singer_id;
        return vc;
    }


}
- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index{

    if (index == 0) {
        return @"歌曲";
    }
    else if (index == 1) {
        return @"专辑";
    }
    else {
        return @"视频";
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
