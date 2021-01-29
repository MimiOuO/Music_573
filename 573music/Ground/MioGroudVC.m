//
//  MioGroudVC.m
//  jgsschool
//
//  Created by Mimio on 2020/9/14.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioGroudVC.h"
#import <WMPageController.h>
#import "MioRecommendMVVC.h"
#import "MioCategoryMVVC.h"
#import "PYSearch.h"
#import "MioSearchResultVC.h"
@interface MioGroudVC ()<WMPageControllerDelegate,WMPageControllerDataSource>
@property (nonatomic, strong) WMPageController *pageController;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) NSArray *tabsArr;
@end

@implementation MioGroudVC

- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    RecieveChangeSkin;
    
    _tabsArr = [userdefault objectForKey:@"mvtabs"];
    
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
    [_contentView addSubview:self.pageController.view];
    
    MioView *searchView = [MioView creatView:frame(Mar, NavH +  8, KSW_Mar2, 34) inView:self.view bgColorName:name_search radius:17];;
    UIImageView *searchIcon = [UIImageView creatImgView:frame(12, 10, 14, 14) inView:searchView image:@"sosuo" radius:0];
    MioLabel *searchTip = [MioLabel creatLabel:frame(30, 0, 100, 34) inView:searchView text:@"请输入关键词搜索" colorName:name_text_two size:12 alignment:NSTextAlignmentLeft];
    [searchView whenTapped:^{
        [self searchClick];
    }];
    
}

#pragma mark - 搜索
-(void)searchClick{
    NSArray *hotSeaches = [userdefault objectForKey:@"hotsearch"];
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

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController{
    
    return _tabsArr.count + 1;
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index{
    
    if (index == 0) {
        
        return [[MioRecommendMVVC alloc] init];
    }else{
        MioCategoryMVVC *vc = [[MioCategoryMVVC alloc] init];
        vc.tagStr = _tabsArr[index - 1];
        return vc;
    }
    
    
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index{
    
    if (index == 0) {
        return @"推荐";
    }else{
        return _tabsArr[index - 1];
    }
    
}


@end
