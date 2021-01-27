//
//  MioHomeVC.m
//  ifixMerchat
//
//  Created by Mimio on 2020/4/10.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioHomeVC.h"
#import <WMPageController.h>
#import "MioHomeMusicHallVC.h"
#import "MioHomeRecommendVC.h"
#import "PYSearch.h"
#import "MioSearchResultVC.h"

#import "MioFeedBackVC.h"
#import "MioLabel.h"
#import "MioPlayListVC.h"
#import "CountdownTimer.h"

@interface MioHomeVC ()<WMPageControllerDelegate,WMPageControllerDataSource>
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) WMPageController *pageController;
@property (nonatomic, strong) UIView *countDownView;
@property (nonatomic, strong) MioLabel *minuteLab;
@property (nonatomic, strong) MioLabel *secondLab;
@end

@implementation MioHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    RecieveChangeSkin;
    
    _contentView = [[UIView alloc] initWithFrame:frame(0, 0, KSW, KSH - TabH)];
    _contentView.backgroundColor = appClearColor;
    [self.view addSubview:_contentView];
    

    _pageController = [[WMPageController alloc] init];
    [self addChildViewController:_pageController];
    _pageController.delegate           = self;
    _pageController.dataSource         = self;
    _pageController.menuViewStyle      = WMMenuViewStyleLine;
    _pageController.menuViewLayoutMode = WMMenuViewLayoutModeLeft;
    _pageController.automaticallyCalculatesItemWidths = YES;
    _pageController.itemMargin         = 16;
    _pageController.menuHeight         = 48;
    _pageController.titleFontName      = @"PingFangSC-Medium";
    _pageController.titleSizeNormal    = 16;
    _pageController.titleSizeSelected  = 20;
    _pageController.menuBGColor        = appClearColor;
    _pageController.titleColorNormal   = color_text_one;
    _pageController.titleColorSelected = color_main;
    _pageController.progressWidth      = 16;
    _pageController.progressHeight     = 3;
    _pageController.progressViewCornerRadius = 1.5;
    _pageController.progressViewBottomSpace = 4;
    _pageController.viewFrame = CGRectMake(0, StatusH , KSW , KSH - StatusH - 44 - TabH);
    _pageController.selectIndex = 1;
    [_contentView addSubview:self.pageController.view];
    
    MioView *searchView = [MioView creatView:frame(Mar, NavH +  8, KSW_Mar2, 34) inView:self.view bgColorName:name_search radius:17];;
    UIImageView *searchIcon = [UIImageView creatImgView:frame(12, 10, 14, 14) inView:searchView image:@"sosuo" radius:0];
    MioLabel *searchTip = [MioLabel creatLabel:frame(30, 0, 100, 34) inView:searchView text:@"请输入关键词搜索" colorName:name_text_two size:12 alignment:NSTextAlignmentLeft];
    [searchView whenTapped:^{
        [self searchClick];
    }];
   
    _countDownView = [UIView creatView:frame(KSW_Mar - 54, StatusH + 13, 54, 24) inView:self.view bgColor:appClearColor radius:0];
    UIImageView *bgImg = [UIImageView creatImgView:frame(0, 0, 54, 24) inView:_countDownView image:@"daojishi_bg" radius:0];
    _minuteLab = [MioLabel creatLabel:frame(2, 0, 20, 28) inView:_countDownView text:@"" colorName:name_main size:14 alignment:NSTextAlignmentCenter];
    _secondLab = [MioLabel creatLabel:frame(31, 0, 20, 28) inView:_countDownView text:@"" colorName:name_main size:14 alignment:NSTextAlignmentCenter];
    _minuteLab.font = [UIFont fontWithName:@"DIN Condensed" size:16];
    _secondLab.font = [UIFont fontWithName:@"DIN Condensed" size:16];
    UIImageView *bgImg2 = [UIImageView creatImgView:frame(2, 12, 20, 0.5) inView:_countDownView image:@"daojishi_xian" radius:0];
    UIImageView *bgImg3 = [UIImageView creatImgView:frame(31, 12, 20, 0.5) inView:_countDownView image:@"daojishi_xian" radius:0];
    [self startCutDown];
    [_countDownView whenTapped:^{
        [UIWindow showMessage:@"积分说明11111at积分说明11111at积分说明11111at积分说明11111at积分说明11111at积分说明11111at积分说明11111at" withTitle:@"积分说明"];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (Equals([userdefault objectForKey:@"showJifen"], @"1")) {
        _countDownView.hidden = NO;
    }else{
        _countDownView.hidden = YES;
    }
}

-(void)startCutDown{
    [CountdownTimer startTimerWithKey:cutdown count:300*1000 callBack:^(NSInteger count, BOOL isFinished) {
        NSInteger time = count%300;
        _minuteLab.text = [NSString stringWithFormat:@"%02ld",time/60];
        _secondLab.text = [NSString stringWithFormat:@"%02ld",time%60];
        if (time == 0) {
            [UIWindow showSuccess:@"积分添加成功"];
            [self addJifen];
        }
    }];
}

-(void)addJifen{
    
    
    
}

-(void)changeSkin{
    _pageController.titleColorNormal   = color_text_one;
    _pageController.titleColorSelected = color_main;
    [_pageController reloadData];
    CGFloat r = (CGFloat) [(colorDic[@"main"][@"r"]) intValue]/255.0;
    CGFloat g = (CGFloat) [(colorDic[@"main"][@"g"]) intValue]/255.0;
    CGFloat b = (CGFloat) [(colorDic[@"main"][@"b"]) intValue]/255.0;
    CGFloat a = (CGFloat) 1/1.0;
    CGFloat components[4] = {r,g,b,a};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

    CGColorRef color = CGColorCreate(colorSpace, components);
    CGColorSpaceRelease(colorSpace);
    
    _pageController.menuView.progressView.color =  color;
    [_pageController.menuView.progressView setNeedsDisplay];
    
}

#pragma mark - 搜索
-(void)searchClick{
        NSArray *hotSeaches = @[@"Java", @"Python", @"Objective-C", @"Swift", @"C", @"C++", @"PHP", @"C#", @"Perl", @"Go", @"JavaScript", @"R", @"Ruby", @"MATLAB"];
        PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:@"搜索品类、ID、昵称"];
        searchViewController.searchResultShowMode = PYSearchResultShowModeEmbed;
        MioSearchResultVC *resultVC = [[MioSearchResultVC alloc] init];
        searchViewController.searchResultController = resultVC;
        searchViewController.delegate = resultVC;
        searchViewController.searchBarBackgroundColor = rgb(246, 247, 249);
        searchViewController.searchHistoryStyle = PYSearchHistoryStyleNormalTag;
        searchViewController.hotSearchStyle = PYHotSearchStyleNormalTag;

        CATransition* transition = [CATransition animation];
        transition.type = kCATransitionMoveIn;//可更改为其他方式
        transition.subtype = kCATransitionFromTop;//可更改为其他方式
        [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];

        [self.navigationController pushViewController:searchViewController animated:NO];
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController{
    
    return 2;
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index{
    
    if (index == 0) {
        
        return [[MioHomeRecommendVC alloc] init];
    }else{
        return [[MioHomeMusicHallVC alloc] init];
    }
    
    
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index{
    
    if (index == 0) {
        return @"推荐";
    }else{
        return @"音乐馆";
    }
    
}

-(void)upScroll{
    WEAKSELF;
    [UIView animateWithDuration:0.3 animations:^{
//        weakSelf.publichBtn.top =  KSH - 56 - 23 - TabH;
    }];
}

-(void)downScroll{
    WEAKSELF;
    [UIView animateWithDuration:0.3 animations:^{
//        weakSelf.publichBtn.top = KSH - TabH;
    }];
}

@end
