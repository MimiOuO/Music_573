//
//  MioNoticeCenterVC.m
//  573music
//
//  Created by Mimio on 2021/1/20.
//  Copyright © 2021 Mimio. All rights reserved.
//

#import "MioNoticeCenterVC.h"
#import <WMPageController.h>
#import "MioLikeAndCmtNoticeVC.h"
#import "MioSystemNoticeVC.h"
@interface MioNoticeCenterVC ()<WMPageControllerDelegate,WMPageControllerDataSource>
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) WMPageController *pageController;
@property (nonatomic, strong) UIView *reddot;
@property (nonatomic, strong) UILabel *unredLab;

@property (nonatomic, strong) UIView *reddot2;
@property (nonatomic, strong) UILabel *unredLab2;
@end

@implementation MioNoticeCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navView.leftButton setImage:backArrowIcon forState:UIControlStateNormal];
    [self.navView.centerButton setTitle:@"" forState:UIControlStateNormal];
//    self.navView.mainView.backgroundColor = appClearColor;
    
    _contentView = [[UIView alloc] initWithFrame:frame(0, 0, KSW, KSH - TabH)];
    _contentView.backgroundColor = appClearColor;
    [self.view addSubview:_contentView];
    
    
    _pageController = [[WMPageController alloc] init];
    [self addChildViewController:_pageController];
    _pageController.delegate           = self;
    _pageController.dataSource         = self;
    _pageController.menuViewStyle      = WMMenuViewStyleLine;
    _pageController.menuViewLayoutMode = WMMenuViewLayoutModeCenter;
    _pageController.automaticallyCalculatesItemWidths = YES;
    _pageController.itemMargin         = 16;
    _pageController.menuHeight         = 44;
    _pageController.titleFontName      = @"PingFangSC-Medium";
    _pageController.titleSizeNormal    = 14;
    _pageController.titleSizeSelected  = 14;
    _pageController.menuBGColor        = appClearColor;
    _pageController.titleColorNormal   = color_text_one;
    _pageController.titleColorSelected = color_main;
    _pageController.progressWidth      = 16;
    _pageController.progressHeight     = 3;
    _pageController.progressViewCornerRadius = 1.5;
    _pageController.progressViewBottomSpace = 4;
    _pageController.viewFrame = CGRectMake(0, StatusH , KSW , KSH - StatusH  - TabH);
    [_contentView addSubview:self.pageController.view];
    
    UIButton *backBtn = [UIButton creatBtn:frame(0, StatusH, 50, 44) inView:self.view bgColor:appClearColor title:@"" titleColor:appClearColor font:10 radius:0  action:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    _reddot = [UIView creatView:frame(KSW2 - 5,StatusH + 8, 14, 14) inView:_contentView bgColor:redTextColor radius:7];
    _reddot.hidden = YES;
    _unredLab = [UILabel creatLabel:frame(0, 0, 14, 14) inView:_reddot text:@"" color:appWhiteColor size:8 alignment:NSTextAlignmentCenter];
    
    
    _reddot2 = [UIView creatView:frame(KSW2 + 66,StatusH + 8, 14, 14) inView:_contentView bgColor:redTextColor radius:7];
    _reddot2.hidden = YES;
    _unredLab2 = [UILabel creatLabel:frame(0, 0, 14, 14) inView:_reddot2 text:@"" color:appWhiteColor size:8 alignment:NSTextAlignmentCenter];
    
    [MioGetReq(api_unread, @{@"k":@"v"}) success:^(NSDictionary *result){
        NSDictionary *count = [result objectForKey:@"data"][@"count"];
        
        if ([count[@"like_or_comment"] intValue] != 0) {
            _reddot.hidden = NO;
            _unredLab.text = [NSString stringWithFormat:@"%d", [count[@"like_or_comment"] intValue]];
        }
        
        if ([count[@"from_system"] intValue] != 0) {
            _reddot2.hidden = NO;
            _unredLab2.text = [NSString stringWithFormat:@"%d", [count[@"from_system"] intValue]];
        }

    } failure:^(NSString *errorInfo) {}];
}


-(NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController{
    return 2;
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index{
    if (index == 0) {
        return [[MioLikeAndCmtNoticeVC alloc] init];
    }else{
        return [[MioSystemNoticeVC alloc] init];
    }
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index{
    
    if (index == 0) {
        return @"喜欢和评论";
    }else{
        return @"系统通知";
    }
    
}

@end
