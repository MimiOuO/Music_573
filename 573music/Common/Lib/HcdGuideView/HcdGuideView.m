//
//  HcdGuideViewManager.m
//  HcdGuideViewDemo
//
//  Created by polesapp-hcd on 16/7/12.
//  Copyright © 2016年 Polesapp. All rights reserved.
//

#import "HcdGuideView.h"
#import "HcdGuideViewCell.h"
#import "Lottie.h"
#import "AppDelegate.h"
#import "AppDelegate+MioInitalData.h"

@interface HcdGuideView()<UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate>


@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIColor *buttonBgColor;
@property (nonatomic, strong) UIColor *buttonBorderColor;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, copy  ) NSString *buttonTitle;

@end

@implementation HcdGuideView

+ (instancetype)sharedInstance {
    static HcdGuideView *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [HcdGuideView new];
    });
    return instance;
}

/**
 *  引导页界面
 *
 *  @return 引导页界面
 */
- (UICollectionView *)view {
    if (!_view) {
        
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.itemSize = kHcdGuideViewBounds.size;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _view = [[UICollectionView alloc] initWithFrame:kHcdGuideViewBounds collectionViewLayout:layout];
        _view.bounces = NO;
        _view.backgroundColor = [UIColor whiteColor];
        _view.showsHorizontalScrollIndicator = NO;
        _view.showsVerticalScrollIndicator = NO;
        _view.pagingEnabled = YES;
        _view.dataSource = self;
        _view.delegate = self;
        _view.alpha = 1;
        [_view registerClass:[HcdGuideViewCell class] forCellWithReuseIdentifier:kCellIdentifier_HcdGuideViewCell];
    }
    return _view;
}

/**
 *  初始化pageControl
 *
 *  @return pageControl
 */
- (UIPageControl *)pageControl {
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.frame = CGRectMake(0, 0, kHcdGuideViewBounds.size.width, 44.0f);
        _pageControl.center = CGPointMake(kHcdGuideViewBounds.size.width / 2, kHcdGuideViewBounds.size.height - 60);
    }
    return _pageControl;
}

- (void)showGuideViewWithImages:(NSArray *)images
                 andButtonTitle:(NSString *)title
            andButtonTitleColor:(UIColor *)titleColor
               andButtonBGColor:(UIColor *)bgColor
           andButtonBorderColor:(UIColor *)borderColor {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *version = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    //根据版本号来判断是否需要显示引导页，一般来说每更新一个版本引导页都会有相应的修改
    BOOL show = [userDefaults boolForKey:[NSString stringWithFormat:@"version_%@", version]];
    
    if (!show) {
        self.images = images;
        self.buttonBorderColor = borderColor;
        self.buttonBgColor = bgColor;
        self.buttonTitle = title;
        self.titleColor = titleColor;
        self.pageControl.numberOfPages = images.count;
        
        if (nil == self.window) {
            self.window = [UIApplication sharedApplication].keyWindow;
        }
        
        [self.window addSubview:self.view];
//        [self.window addSubview:self.pageControl];
        
        [userDefaults setBool:YES forKey:[NSString stringWithFormat:@"version_%@", version]];
        [userDefaults synchronize];
    }
}

#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.images count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HcdGuideViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier_HcdGuideViewCell forIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        LOTAnimationView *hud1 = [LOTAnimationView animationNamed:@"tingge"];
        hud1.frame = frame(KSW2 - 150, KSH * 0.2, 300, 300);
        hud1.loopAnimation = YES;
        [cell addSubview:hud1];
        [hud1 play];
        UIImageView *img1 = [UIImageView creatImgView:frame(KSW2 - 375/2, KSH - SafeBotH - 254, 375, 254) inView:cell image:@"ydy_qk" radius:0];
    }
    
    if (indexPath.row == 1) {
        LOTAnimationView *hud1 = [LOTAnimationView animationNamed:@"jifen"];
        hud1.frame = frame(KSW2 - 150, KSH * 0.2, 300, 300);
        hud1.loopAnimation = YES;
        [cell addSubview:hud1];
        [hud1 play];
        UIImageView *img1 = [UIImageView creatImgView:frame(KSW2 - 375/2, KSH - SafeBotH - 254, 375, 254) inView:cell image:@"ydy_jf" radius:0];
    }
    if (indexPath.row == 2) {
        LOTAnimationView *hud1 = [LOTAnimationView animationNamed:@"zhuti"];
        hud1.frame = frame(KSW2 - 150, KSH * 0.2, 300, 300);
        hud1.loopAnimation = YES;
        [cell addSubview:hud1];
        [hud1 play];
        UIImageView *img1 = [UIImageView creatImgView:frame(KSW2 - 375/2, KSH - SafeBotH - 254, 375, 254) inView:cell image:@"ydy_zt" radius:0];
        [img1 whenTapped:^{
            [self nextButtonHandler];
        }];
    }
    

    
    return cell;
}

/**
 *  计算自适应的图片
 *
 *  @param is 需要适应的尺寸
 *  @param cs 适应到的尺寸
 *
 *  @return 适应后的尺寸
 */
- (CGSize)adapterSizeImageSize:(CGSize)is compareSize:(CGSize)cs
{
    CGFloat w = cs.width;
    CGFloat h = cs.width / is.width * is.height;
    
    if (h < cs.height) {
        w = cs.height / h * w;
        h = cs.height;
    }
    return CGSizeMake(w, h);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    self.pageControl.currentPage = (scrollView.contentOffset.x / kHcdGuideViewBounds.size.width);
    if (self.pageControl.currentPage == 1) {//防止授权之前没有网络
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [delegate initalData];
        PostNotice(@"firstLaunch");
    }
}

/**
 *  点击立即体验按钮响应事件
 *
 *  @param sender sender
 */
- (void)nextButtonHandler {
    
    [UIView animateWithDuration: 1.0 delay: 0.0 options: nil  animations: ^{
        self.view.alpha = 0;
    } completion: ^(BOOL finished) {
        [self.pageControl removeFromSuperview];
        [self.view removeFromSuperview];
        [self setWindow:nil];
        [self setView:nil];
        [self setPageControl:nil];
    }];

    

    
    if ([self.delegate respondsToSelector:@selector(guideBtnClick)]) {
        [self.delegate guideBtnClick];
    }
}

@end
